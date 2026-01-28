package plugins

import (
	"archive/zip"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"os"
	"path/filepath"
	"runtime"
	"strings"

	"github.com/FerzDevZ/fpawn/internal/core"
)

// GitHubRelease represents a GitHub release
type GitHubRelease struct {
	TagName string  `json:"tag_name"`
	Assets  []Asset `json:"assets"`
}

// Asset represents a release asset
type Asset struct {
	Name        string `json:"name"`
	DownloadURL string `json:"browser_download_url"`
	Size        int64  `json:"size"`
}

// InstallPlugin downloads and installs a plugin
func InstallPlugin(name string) error {
	plugin := GetPluginByName(name)
	if plugin == nil {
		return fmt.Errorf("plugin '%s' not found in database", name)
	}

	fmt.Printf("\n %s Installing: %s\n", core.LBlue("📦"), core.Bold(name))
	fmt.Println(" ──────────────────────────────────────────────────")

	// Create directories
	os.MkdirAll("plugins", 0755)
	os.MkdirAll("include", 0755)

	// Pillar VIII: THE ALCHEMIST (Smart Dependency Resolution)
	if len(plugin.Deps) > 0 {
		fmt.Printf(" %s The Alchemist: Resolving %d dependencies...\n", core.Magenta("🧪"), len(plugin.Deps))
		for _, depName := range plugin.Deps {
			// Check if already installed
			if !isPluginInstalled(depName) {
				fmt.Printf("   ➜ Auto-installing missing dependency: %s\n", core.Bold(depName))
				if err := InstallPlugin(depName); err != nil {
					fmt.Printf("   %s Failed to resolve dependency '%s': %v\n", core.Yellow("[Warn]"), depName, err)
				}
			}
		}
	}

	// Get latest release from GitHub
	repoPath := extractRepoPath(plugin.URL)
	if repoPath == "" {
		return fmt.Errorf("invalid GitHub URL")
	}

	fmt.Printf(" %s Fetching latest release...\n", core.Cyan("[GitHub]"))

	release, err := getLatestRelease(repoPath)
	if err != nil {
		return err
	}

	fmt.Printf(" %s Version: %s\n", core.Green("[Found]"), release.TagName)

	// Find appropriate asset for current OS
	asset := findAsset(release.Assets)
	if asset == nil {
		fmt.Printf(" %s No binary found, trying to download include files...\n", core.Yellow("[Warn]"))
		return downloadIncludes(plugin)
	}

	fmt.Printf(" %s Downloading: %s (%d KB)\n", core.Blue("[Download]"), asset.Name, asset.Size/1024)

	// Download asset
	tempFile := filepath.Join(os.TempDir(), asset.Name)
	if err := downloadFile(asset.DownloadURL, tempFile); err != nil {
		return err
	}
	defer os.Remove(tempFile)

	// Extract if it's an archive
	if strings.HasSuffix(asset.Name, ".zip") {
		if err := extractZip(tempFile, "."); err != nil {
			return err
		}
	} else if strings.HasSuffix(asset.Name, ".so") || strings.HasSuffix(asset.Name, ".dll") {
		// Direct plugin file
		destPath := filepath.Join("plugins", asset.Name)
		if err := copyFile(tempFile, destPath); err != nil {
			return err
		}
		os.Chmod(destPath, 0755)
	}

	// Update server.cfg
	updateServerCfg(name)

	fmt.Printf(" %s %s installed successfully!\n", core.Green("✓"), name)
	return nil
}

func extractRepoPath(url string) string {
	url = strings.TrimSuffix(url, ".git")
	url = strings.TrimPrefix(url, "https://github.com/")
	url = strings.TrimPrefix(url, "http://github.com/")
	if strings.Contains(url, "/") {
		return url
	}
	return ""
}

func getLatestRelease(repoPath string) (*GitHubRelease, error) {
	url := fmt.Sprintf("https://api.github.com/repos/%s/releases/latest", repoPath)

	resp, err := http.Get(url)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	if resp.StatusCode != 200 {
		return nil, fmt.Errorf("GitHub API returned status %d", resp.StatusCode)
	}

	var release GitHubRelease
	if err := json.NewDecoder(resp.Body).Decode(&release); err != nil {
		return nil, err
	}

	return &release, nil
}

func findAsset(assets []Asset) *Asset {
	osName := runtime.GOOS
	keywords := []string{}

	switch osName {
	case "linux":
		keywords = []string{".so", "linux", "ubuntu"}
	case "windows":
		keywords = []string{".dll", "windows", "win32", "win64"}
	case "darwin":
		keywords = []string{".dylib", "macos", "darwin"}
	}

	for _, asset := range assets {
		name := strings.ToLower(asset.Name)
		for _, kw := range keywords {
			if strings.Contains(name, kw) {
				return &asset
			}
		}
	}

	// Try to find any archive
	for _, asset := range assets {
		if strings.HasSuffix(asset.Name, ".zip") || strings.HasSuffix(asset.Name, ".tar.gz") {
			return &asset
		}
	}

	return nil
}

func downloadFile(url, dest string) error {
	resp, err := http.Get(url)
	if err != nil {
		return err
	}
	defer resp.Body.Close()

	out, err := os.Create(dest)
	if err != nil {
		return err
	}
	defer out.Close()

	_, err = io.Copy(out, resp.Body)
	return err
}

func extractZip(zipPath, destDir string) error {
	r, err := zip.OpenReader(zipPath)
	if err != nil {
		return err
	}
	defer r.Close()

	for _, f := range r.File {
		fpath := filepath.Join(destDir, f.Name)

		// Check for zip slip
		if !strings.HasPrefix(fpath, filepath.Clean(destDir)+string(os.PathSeparator)) {
			continue
		}

		if f.FileInfo().IsDir() {
			os.MkdirAll(fpath, os.ModePerm)
			continue
		}

		if err := os.MkdirAll(filepath.Dir(fpath), os.ModePerm); err != nil {
			return err
		}

		outFile, err := os.OpenFile(fpath, os.O_WRONLY|os.O_CREATE|os.O_TRUNC, f.Mode())
		if err != nil {
			return err
		}

		rc, err := f.Open()
		if err != nil {
			outFile.Close()
			return err
		}

		_, err = io.Copy(outFile, rc)
		outFile.Close()
		rc.Close()

		if err != nil {
			return err
		}
	}
	return nil
}

func copyFile(src, dst string) error {
	in, err := os.Open(src)
	if err != nil {
		return err
	}
	defer in.Close()

	out, err := os.Create(dst)
	if err != nil {
		return err
	}
	defer out.Close()

	_, err = io.Copy(out, in)
	return err
}

func downloadIncludes(plugin *Plugin) error {
	// Try to download raw include file from main branch
	repoPath := extractRepoPath(plugin.URL)
	urls := []string{
		fmt.Sprintf("https://raw.githubusercontent.com/%s/master/%s.inc", repoPath, plugin.Name),
		fmt.Sprintf("https://raw.githubusercontent.com/%s/main/%s.inc", repoPath, plugin.Name),
		fmt.Sprintf("https://raw.githubusercontent.com/%s/master/include/%s.inc", repoPath, plugin.Name),
	}

	for _, url := range urls {
		resp, err := http.Get(url)
		if err != nil {
			continue
		}
		defer resp.Body.Close()

		if resp.StatusCode == 200 {
			incPath := filepath.Join("include", plugin.Name+".inc")
			out, err := os.Create(incPath)
			if err != nil {
				return err
			}
			defer out.Close()
			io.Copy(out, resp.Body)
			fmt.Printf(" %s Include file installed: %s\n", core.Green("✓"), incPath)
			return nil
		}
	}

	return fmt.Errorf("could not find include files")
}

func updateServerCfg(pluginName string) {
	cfgPath := "server.cfg"
	data, err := os.ReadFile(cfgPath)
	if err != nil {
		return
	}

	content := string(data)
	if strings.Contains(content, pluginName) {
		return // Already added
	}

	lines := strings.Split(content, "\n")
	for i, line := range lines {
		if strings.HasPrefix(line, "plugins") {
			lines[i] = line + " " + pluginName
			break
		}
	}

	os.WriteFile(cfgPath, []byte(strings.Join(lines, "\n")), 0644)
	fmt.Printf(" %s Added to server.cfg\n", core.Blue("[Config]"))
}

// ListPlugins displays all available plugins
func ListPlugins() {
	fmt.Printf("\n %s %s\n", core.LBlue("📚"), core.Bold("Plugin Database"))
	fmt.Println(" ──────────────────────────────────────────────────")

	categories := GetCategories()
	for _, cat := range categories {
		plugins := GetPluginsByCategory(cat)
		fmt.Printf("\n %s [%d]\n", core.Bold(cat), len(plugins))
		for _, p := range plugins {
			compat := core.Green(p.Compat)
			if p.Compat == "Legacy" {
				compat = core.Yellow(p.Compat)
			}
			fmt.Printf("   • %-20s %s - %s\n", p.Name, compat, p.Description)
		}
	}

	fmt.Printf("\n %s Total: %d plugins\n", core.Cyan("[Info]"), len(PluginDatabase))
}

// SearchPlugins searches for plugins by name or description
func SearchPlugins(query string) []Plugin {
	query = strings.ToLower(query)
	var results []Plugin

	for _, p := range PluginDatabase {
		if strings.Contains(strings.ToLower(p.Name), query) ||
			strings.Contains(strings.ToLower(p.Description), query) {
			results = append(results, p)
		}
	}

	return results
}

func isPluginInstalled(name string) bool {
paths := []string{
filepath.Join("plugins", name+".so"),
filepath.Join("plugins", name+".dll"),
filepath.Join("include", name+".inc"),
}
for _, p := range paths {
if _, err := os.Stat(p); err == nil {
return true
}
}
return false
}

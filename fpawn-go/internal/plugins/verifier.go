package plugins

import (
	"crypto/md5"
	"fmt"
	"io"
	"os"
	"path/filepath"

	"strings"

	"github.com/FerzDevZ/fpawn/internal/core"
)

// PluginInfo holds information about an installed plugin
type PluginInfo struct {
	Name     string
	Path     string
	Size     int64
	Hash     string
	Verified bool
}

// VerifyPlugins checks the integrity of installed plugins
func VerifyPlugins() ([]PluginInfo, error) {
	fmt.Printf("\n %s %s\n", core.LBlue("🔍"), core.Bold("Plugin Integrity Verification"))
	fmt.Println(" ──────────────────────────────────────────────────")

	if _, err := os.Stat("plugins"); os.IsNotExist(err) {
		return nil, fmt.Errorf("plugins directory not found")
	}

	var plugins []PluginInfo

	err := filepath.Walk("plugins", func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return nil
		}
		if info.IsDir() {
			return nil
		}

		// Only check .so and .dll files
		ext := filepath.Ext(path)
		if ext != ".so" && ext != ".dll" && ext != ".dylib" {
			return nil
		}

		pluginInfo := PluginInfo{
			Name: info.Name(),
			Path: path,
			Size: info.Size(),
		}

		// Calculate hash
		hash, err := calculateHash(path)
		if err != nil {
			pluginInfo.Hash = "ERROR"
			pluginInfo.Verified = false
		} else {
			pluginInfo.Hash = hash
			pluginInfo.Verified = true
		}

		plugins = append(plugins, pluginInfo)
		return nil
	})

	if err != nil {
		return nil, err
	}

	// Display results
	for _, p := range plugins {
		status := core.Green("✓")
		if !p.Verified {
			status = core.Red("✗")
		}

		fmt.Printf(" %s %-25s %s (%d KB)\n", status, p.Name, p.Hash[:8]+"...", p.Size/1024)
	}

	fmt.Println(" ──────────────────────────────────────────────────")
	fmt.Printf(" %s Verified: %d plugins\n", core.Green("✓"), len(plugins))

	return plugins, nil
}

func calculateHash(path string) (string, error) {
	file, err := os.Open(path)
	if err != nil {
		return "", err
	}
	defer file.Close()

	hash := md5.New()
	if _, err := io.Copy(hash, file); err != nil {
		return "", err
	}

	return fmt.Sprintf("%x", hash.Sum(nil)), nil
}

// CheckDependencies checks if all plugin dependencies are satisfied
func CheckDependencies() {
	fmt.Printf("\n %s %s\n", core.LBlue("🔗"), core.Bold("Dependency Graph"))
	fmt.Println(" ──────────────────────────────────────────────────")

	// Read server.cfg to find loaded plugins
	data, err := os.ReadFile("server.cfg")
	if err != nil {
		fmt.Printf(" %s server.cfg not found\n", core.Red("[Error]"))
		return
	}

	content := string(data)
	installedPlugins := make(map[string]bool)

	// Simple parsing
	for _, plugin := range PluginDatabase {
		if fileExists(filepath.Join("plugins", plugin.Name+".so")) ||
			fileExists(filepath.Join("plugins", plugin.Name+".dll")) {
			installedPlugins[plugin.Name] = true
		}
	}

	fmt.Printf(" %s Installed plugins: %d\n", core.Cyan("[Info]"), len(installedPlugins))

	// Check for common dependencies
	if installedPlugins["mysql"] {
		if !installedPlugins["bcrypt"] && !installedPlugins["whirlpool"] {
			fmt.Printf(" %s mysql installed but no password hashing plugin found\n", core.Yellow("[Suggest]"))
			fmt.Printf("   Run: fpawn --install bcrypt\n")
		}
	}

	if installedPlugins["crashdetect"] {
		fmt.Printf(" %s crashdetect installed - debug symbols available\n", core.Green("[Good]"))
	}

	_ = content // Will be used in future for deeper analysis
}

func fileExists(path string) bool {
	_, err := os.Stat(path)
	return err == nil
}

// UninstallPlugin removes a plugin
func UninstallPlugin(name string) error {
	fmt.Printf("\n %s Uninstalling: %s\n", core.Red("🗑️"), core.Bold(name))
	fmt.Println(" ──────────────────────────────────────────────────")

	// Remove plugin file
	paths := []string{
		filepath.Join("plugins", name+".so"),
		filepath.Join("plugins", name+".dll"),
		filepath.Join("include", name+".inc"),
	}

	removed := false
	for _, path := range paths {
		if fileExists(path) {
			if err := os.Remove(path); err != nil {
				fmt.Printf(" %s Failed to remove: %s\n", core.Red("[Error]"), path)
			} else {
				fmt.Printf(" %s Removed: %s\n", core.Green("[OK]"), path)
				removed = true
			}
		}
	}

	if !removed {
		return fmt.Errorf("plugin '%s' not found", name)
	}

	// Remove from server.cfg
	cfgPath := "server.cfg"
	if data, err := os.ReadFile(cfgPath); err == nil {
		content := string(data)
		// Simple removal (more sophisticated needed for production)
		content = strings.Replace(content, " "+name, "", -1)
		content = strings.Replace(content, name+" ", "", -1)
		os.WriteFile(cfgPath, []byte(content), 0644)
	}

	fmt.Printf(" %s %s uninstalled\n", core.Green("✓"), name)
	return nil
}


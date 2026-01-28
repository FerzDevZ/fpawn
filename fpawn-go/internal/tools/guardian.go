package tools

import (
	"crypto/rand"
	"encoding/hex"
	"fmt"
	"io"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"time"

	"github.com/FerzDevZ/fpawn/internal/compiler"
	"github.com/FerzDevZ/fpawn/internal/core"
)

// CodeGuardian protects source code with DRM and vaulting
func CodeGuardian(target string) error {
	if target == "" {
		target = compiler.FindEntryPoint()
	}

	fmt.Printf("\n %s %s\n", core.Red("🔒"), core.Bold(core.Msg("grd_title")))
	fmt.Println(" ──────────────────────────────────────────────────")

	if target == "" {
		return fmt.Errorf(core.Msg("entry_err"))
	}

	// Read original file
	originalData, err := os.ReadFile(target)
	if err != nil {
		return err
	}

	// Ask for IP lock
	fmt.Printf(" %s ", core.Msg("grd_enter_ip"))
	var lockIP string
	fmt.Scanln(&lockIP)

	// Create guarded copy
	guardedPath := "guarded_" + filepath.Base(target)
	guardedData := string(originalData)

	// Inject DRM if IP provided
	if lockIP != "" {
		drmCode := fmt.Sprintf(`
// === FPAWN CODE GUARDIAN DRM ===
#if !defined _FPAWN_DRM_
#define _FPAWN_DRM_

public OnGameModeInit()
{
    new ip[16];
    GetServerVarAsString("bind", ip, sizeof(ip));
    if(strcmp(ip, "%s", true) != 0 && strcmp(ip, "0.0.0.0", true) != 0)
    {
        print("[DRM] Unauthorized server IP detected!");
        print("[DRM] This build is locked to: %s");
        SendRconCommand("exit");
        return 0;
    }
    #if defined _DRM_OnGameModeInit
        return _DRM_OnGameModeInit();
    #else
        return 1;
    #endif
}
#if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit _DRM_OnGameModeInit
#if defined _DRM_OnGameModeInit
    forward _DRM_OnGameModeInit();
#endif
#endif
// === END DRM ===

`, lockIP, lockIP)

		guardedData = drmCode + guardedData
		fmt.Printf(" %s DRM injected for IP: %s\n", core.Green("[Guard]"), lockIP)
	}

	// Minify - remove comments
	guardedData = removeComments(guardedData)

	// Write guarded file
	if err := os.WriteFile(guardedPath, []byte(guardedData), 0644); err != nil {
		return err
	}

	// Compile
	fmt.Printf(" %s Compiling secured script...\n", core.Blue("[Compiler]"))
	result := compiler.Compile(guardedPath, compiler.ProfileAuto)

	if !result.Success {
		os.Remove(guardedPath)
		return fmt.Errorf("compilation failed")
	}

	// Move AMX to original location
	originalAMX := strings.TrimSuffix(target, ".pwn") + ".amx"
	os.Rename(result.AMXPath, originalAMX)
	os.Remove(guardedPath)

	fmt.Printf(" %s %s\n", core.Green("[Success]"), core.Msg("grd_success"))

	// Ask about vaulting
	fmt.Printf(" %s [y/N] ", core.Msg("grd_vault_ask"))
	var answer string
	fmt.Scanln(&answer)

	if strings.ToLower(answer) == "y" {
		if err := vaultSource(target); err != nil {
			return err
		}
	}

	return nil
}

func removeComments(content string) string {
	// Remove single-line comments
	lines := strings.Split(content, "\n")
	var result []string

	inBlockComment := false
	for _, line := range lines {
		// Skip block comments
		if strings.Contains(line, "/*") {
			inBlockComment = true
		}
		if strings.Contains(line, "*/") {
			inBlockComment = false
			continue
		}
		if inBlockComment {
			continue
		}

		// Remove single-line comments
		if idx := strings.Index(line, "//"); idx != -1 {
			line = line[:idx]
		}

		// Skip empty lines
		trimmed := strings.TrimSpace(line)
		if trimmed != "" {
			result = append(result, line)
		}
	}

	return strings.Join(result, "\n")
}

func vaultSource(target string) error {
	homeDir, _ := os.UserHomeDir()
	vaultDir := filepath.Join(homeDir, ".ferzdevz", "vault", time.Now().Format("20060102"))
	os.MkdirAll(vaultDir, 0755)

	// Generate random password
	passwordBytes := make([]byte, 8)
	rand.Read(passwordBytes)
	password := hex.EncodeToString(passwordBytes)

	zipPath := filepath.Join(vaultDir, strings.TrimSuffix(filepath.Base(target), ".pwn")+".encrypted.zip")

	// Use system zip command if available
	if _, err := exec.LookPath("zip"); err == nil {
		cmd := exec.Command("zip", "-P", password, "-j", zipPath, target)
		if err := cmd.Run(); err != nil {
			return fmt.Errorf("failed to create encrypted zip: %v", err)
		}
	} else {
		// Fallback to move if zip not found
		destPath := filepath.Join(vaultDir, filepath.Base(target))
		if err := copyFile(target, destPath); err != nil {
			return err
		}
		core_warning("zip not found. Source moved unencrypted to: " + vaultDir)
	}

	// Delete original
	os.Remove(target)

	fmt.Printf(" %s Source locked in: %s\n", core.Green("[Vault]"), zipPath)
	fmt.Printf(" %s Unlock Password: %s %s\n", core.Yellow("[Key]"), core.Bold(password), core.Red("(SAVE THIS!)"))
	fmt.Printf(" %s Original source deleted from workspace.\n", core.Red("[!]"))

	return nil
}

func core_warning(msg string) {
	fmt.Printf(" %s %s\n", core.Yellow("[Warn]"), msg)
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

// ProjectBundler creates a distributable archive of the project
func ProjectBundler() error {
	projectName := filepath.Base(".")
	if cwd, err := os.Getwd(); err == nil {
		projectName = filepath.Base(cwd)
	}

	bundleName := fmt.Sprintf("%s_bundle_%s.tar.gz", projectName, time.Now().Format("20060102_1504"))

	fmt.Printf("\n %s %s\n", core.LBlue("📦"), core.Bold("Project Bundler"))
	fmt.Println(" ──────────────────────────────────────────────────")

	// List of directories/files to include
	includes := []string{
		"gamemodes",
		"filterscripts",
		"plugins",
		"scriptfiles",
		"npcmodes",
		"include",
		"server.cfg",
		"pawn.json",
		"config.json",
	}

	var included []string
	for _, item := range includes {
		if _, err := os.Stat(item); err == nil {
			included = append(included, item)
			fmt.Printf(" %s Including: %s\n", core.Cyan("+"), item)
		}
	}

	if len(included) == 0 {
		return fmt.Errorf("no project files found to bundle")
	}

	// Note: For proper tar.gz, you'd use archive/tar and compress/gzip
	// This is a simplified version
	fmt.Printf("\n %s Bundle would be created as: %s\n", core.Green("[Info]"), bundleName)
	fmt.Printf(" %s Use 'tar -czf %s %s' to create the bundle\n",
		core.Cyan("[Tip]"), bundleName, strings.Join(included, " "))

	return nil
}

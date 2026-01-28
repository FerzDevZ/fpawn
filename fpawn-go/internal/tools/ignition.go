package tools

import (
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"strings"

	"github.com/FerzDevZ/fpawn/internal/core"
)

// DeploymentConfig holds SSH details
type DeploymentConfig struct {
	Host     string
	User     string
	Path     string
	Password string // Optional, SSH keys preferred
}

// IgnitionPro handles remote server deployment
func IgnitionPro(target string) {
	fmt.Printf("\n %s %s\n", core.LBlue("🚀"), core.Bold("Ignition Pro: Deep Deployment"))
	fmt.Println(" ──────────────────────────────────────────────────")

	// Check if target is a .amx
	if filepath.Ext(target) != ".amx" {
		target = strings.Replace(target, ".pwn", ".amx", 1)
	}

	if _, err := os.Stat(target); err != nil {
		fmt.Printf(" %s Build artifact not found: %s\n", core.Red("[Error]"), target)
		return
	}

	// Mock or Read Config
	config := loadDeploymentConfig()
	if config.Host == "" {
		fmt.Printf(" %s Deployment not configured. Please set SSH details in fpawn.json\n", core.Yellow("[Notice]"))
		return
	}

	fmt.Printf(" %s Target:  %s\n", core.Cyan("[Info]"), target)
	fmt.Printf(" %s Remote:  %s@%s:%s\n", core.Cyan("[Info]"), config.User, config.Host, config.Path)

	// Step 1: SCP Upload
	fmt.Printf("\n %s Uploading to production...\n", core.Blue("➜"))
	err := runCommand("scp", target, fmt.Sprintf("%s@%s:%s", config.User, config.Host, config.Path))
	if err != nil {
		fmt.Printf(" %s Upload failed: %v\n", core.Red("[Fail]"), err)
		return
	}
	fmt.Printf(" %s Upload Successful!\n", core.Green("✓"))

	// Step 2: RCON Hot-Reload
	fmt.Printf(" %s Triggering Remote Hot-Reload...\n", core.Blue("➜"))
	// Simulating SSH command to trigger reload
	reloadCmd := fmt.Sprintf("echo 'reloadfs %s' > /tmp/rcon_relay", filepath.Base(target))
	err = runCommand("ssh", fmt.Sprintf("%s@%s", config.User, config.Host), reloadCmd)
	if err != nil {
		fmt.Printf(" %s Hot-Reload trigger failed (Is RCON relay setup?): %v\n", core.Yellow("[Warn]"), err)
	} else {
		fmt.Printf(" %s Hot-Reload Command Sent!\n", core.Green("✓"))
	}

	fmt.Println("\n ──────────────────────────────────────────────────")
	fmt.Printf(" %s Deployment Cycle Complete!\n", core.Green("SUCCESS"))
}

func loadDeploymentConfig() DeploymentConfig {
	// For production, this would read from a config file
	// Returning empty for now to prompt user
	return DeploymentConfig{}
}

func runCommand(name string, args ...string) error {
	cmd := exec.Command(name, args...)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	return cmd.Run()
}

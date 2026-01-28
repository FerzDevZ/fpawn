package core

import (
	"fmt"
	"os"
	"path/filepath"
	"strings"
)

// Config holds the application configuration
type Config struct {
	RepoOwner   string
	RepoName    string
	Lang        string
	AutoIgnite  bool
	BaseDir     string
	ConfigFile  string
	CacheDir    string
	BuildFlags  string
	Theme       string
	Sensitivity int
	SshHost     string
	SshUser        string
	SshPath        string
	LogLevel       string
	GitSync        bool
	Optimization   int
	DiscordWebhook string
	WatchDelay     int
}

var AppConfig *Config

// Initialize loads or creates the configuration
func Initialize() error {
	homeDir, err := os.UserHomeDir()
	if err != nil {
		return err
	}

	configDir := filepath.Join(homeDir, ".ferzdevz", "fpawn")
	configFile := filepath.Join(configDir, "config")
	cacheDir := filepath.Join(configDir, "cache")

	// Create directories
	if err := os.MkdirAll(configDir, 0755); err != nil {
		return err
	}
	if err := os.MkdirAll(cacheDir, 0755); err != nil {
		return err
	}

	AppConfig = &Config{
		RepoOwner:   "FerzDevZ",
		RepoName:    "fpawn",
		Lang:        "id",
		AutoIgnite:  false,
		ConfigFile:  configFile,
		CacheDir:    cacheDir,
		BuildFlags:     "-d3",
		Theme:          "Satoru",
		Sensitivity:    5,
		LogLevel:       "Normal",
		GitSync:        false,
		Optimization:   1,
		DiscordWebhook: "",
		WatchDelay:     1500,
	}

	// Detect base directory (where fpawn binary is located)
	execPath, err := os.Executable()
	if err == nil {
		AppConfig.BaseDir = filepath.Dir(execPath)
	}

	// Load existing config if present
	if _, err := os.Stat(configFile); err == nil {
		data, err := os.ReadFile(configFile)
		if err == nil {
			parseConfig(string(data))
		}
	} else {
		// Create default config
		SaveConfig()
	}

	return nil
}

func parseConfig(data string) {
	lines := strings.Split(data, "\n")
	for _, line := range lines {
		line = strings.TrimSpace(line)
		if line == "" || strings.HasPrefix(line, "#") {
			continue
		}
		parts := strings.SplitN(line, "=", 2)
		if len(parts) != 2 {
			continue
		}
		key := strings.TrimSpace(parts[0])
		value := strings.Trim(strings.TrimSpace(parts[1]), "\"")

		switch key {
		case "REPO_OWNER":
			AppConfig.RepoOwner = value
		case "REPO_NAME":
			AppConfig.RepoName = value
		case "LANG":
			AppConfig.Lang = value
		case "AUTO_IGNITE":
			AppConfig.AutoIgnite = strings.ToUpper(value) == "ON"
		case "BUILD_FLAGS":
			AppConfig.BuildFlags = value
		case "THEME":
			AppConfig.Theme = value
		case "SENSITIVITY":
			fmt.Sscanf(value, "%d", &AppConfig.Sensitivity)
		case "SSH_HOST":
			AppConfig.SshHost = value
		case "SSH_USER":
			AppConfig.SshUser = value
		case "SSH_PATH":
			AppConfig.SshPath = value
		case "LOG_LEVEL":
			AppConfig.LogLevel = value
		case "GIT_SYNC":
			AppConfig.GitSync = strings.ToUpper(value) == "ON"
		case "OPTIMIZATION":
			fmt.Sscanf(value, "%d", &AppConfig.Optimization)
		case "WEBHOOK":
			AppConfig.DiscordWebhook = value
		case "WATCH_DELAY":
			fmt.Sscanf(value, "%d", &AppConfig.WatchDelay)
		}
	}
}

// SaveConfig writes configuration to disk
func SaveConfig() error {
	ignite := "OFF"
	if AppConfig.AutoIgnite {
		ignite = "ON"
	}
	git := "OFF"
	if AppConfig.GitSync {
		git = "ON"
	}

	content := fmt.Sprintf(`REPO_OWNER="%s"
REPO_NAME="%s"
LANG="%s"
AUTO_IGNITE="%s"
BUILD_FLAGS="%s"
THEME="%s"
SENSITIVITY="%d"
SSH_HOST="%s"
SSH_USER="%s"
SSH_PATH="%s"
LOG_LEVEL="%s"
GIT_SYNC="%s"
OPTIMIZATION="%d"
WEBHOOK="%s"
WATCH_DELAY="%d"
`, AppConfig.RepoOwner, AppConfig.RepoName, AppConfig.Lang, ignite,
		AppConfig.BuildFlags, AppConfig.Theme, AppConfig.Sensitivity,
		AppConfig.SshHost, AppConfig.SshUser, AppConfig.SshPath,
		AppConfig.LogLevel, git, AppConfig.Optimization,
		AppConfig.DiscordWebhook, AppConfig.WatchDelay)

	return os.WriteFile(AppConfig.ConfigFile, []byte(content), 0644)
}

// SetLang updates the language setting
func SetLang(lang string) {
	AppConfig.Lang = lang
	SaveConfig()
}

// ToggleAutoIgnite toggles the auto-ignite feature
func ToggleAutoIgnite() {
	AppConfig.AutoIgnite = !AppConfig.AutoIgnite
	SaveConfig()
}

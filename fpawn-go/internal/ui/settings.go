package ui

import (
	"fmt"

	"github.com/FerzDevZ/fpawn/internal/core"
)

// ShowMasterSettings provides a deep configuration interface
func ShowMasterSettings() {
	for {
		clearScreen()
		themeColor := core.GetThemeANSI()
		fmt.Printf("\n %s %s\n", core.Satoru("⚙️"), core.Bold(themeColor+"MASTER SETTINGS - CENTRAL CONTROL"+core.ColorReset))
		fmt.Println(" ──────────────────────────────────────────────────")

		fmt.Println(" [1] 🛠️  Compiler & Build Engine")
		fmt.Println(" [2] 🎨  UI & Aesthetic Vision")
		fmt.Println(" [3] ☁️  Cloud & Remote Deployment")
		fmt.Println(" [4] 🤖  Automation & Intelligence")
		fmt.Println(" [S] 📑  Sync & Save All")
		fmt.Println(" [0] 🔙  Return to Dashboard")
		fmt.Println(" ──────────────────────────────────────────────────")

		choice := readInput("Select Category (or 0):")

		switch choice {
		case "0":
			return
		case "1":
			compilerSettings()
		case "2":
			uiSettings()
		case "3":
			cloudSettings()
		case "4":
			automationSettings()
		case "S", "s":
			core.SaveConfig()
			fmt.Printf("\n %s All settings synced to persistent core.\n", core.Green("✓"))
			waitEnter()
		}
	}
}

func compilerSettings() {
	for {
		clearScreen()
		fmt.Printf("\n %s %s\n", core.Satoru("🛠️"), core.Bold("COMPILER & BUILD ENGINE"))
		fmt.Println(" ──────────────────────────────────────────────────")
		fmt.Printf(" [1] Build Flags      : %s\n", core.Yellow(core.AppConfig.BuildFlags))
		fmt.Printf(" [2] Optimization Lvl: %s\n", core.Cyan(fmt.Sprintf("%d", core.AppConfig.Optimization)))
		fmt.Printf(" [3] Log Level        : %s\n", core.Sky(core.AppConfig.LogLevel))
		fmt.Println(" [0] Back")
		fmt.Println(" ──────────────────────────────────────────────────")

		choice := readInput("Index:")
		switch choice {
		case "0": return
		case "1": core.AppConfig.BuildFlags = readInput("Flags:")
		case "2": fmt.Sscanf(readInput("Level (0-3):"), "%d", &core.AppConfig.Optimization)
		case "3": core.AppConfig.LogLevel = readInput("Level (Quiet/Normal/Verbose):")
		}
		core.SaveConfig()
	}
}

func uiSettings() {
	for {
		clearScreen()
		fmt.Printf("\n %s %s\n", core.Satoru("🎨"), core.Bold("UI & AESTHETIC VISION"))
		fmt.Println(" ──────────────────────────────────────────────────")
		fmt.Printf(" [1] TUI Theme        : %s\n", core.Satoru(core.AppConfig.Theme))
		fmt.Printf(" [2] Language         : %s\n", core.Sky(core.AppConfig.Lang))
		fmt.Println(" [0] Back")
		fmt.Println(" ──────────────────────────────────────────────────")

		choice := readInput("Index:")
		switch choice {
		case "0": return
		case "1": themeMenu()
		case "2": 
			lang := readInput("Lang (id/en):")
			if lang != "" { core.AppConfig.Lang = lang }
		}
		core.SaveConfig()
	}
}

func cloudSettings() {
	for {
		clearScreen()
		fmt.Printf("\n %s %s\n", core.Satoru("☁️"), core.Bold("CLOUD & REMOTE DEPLOYMENT"))
		fmt.Println(" ──────────────────────────────────────────────────")
		fmt.Printf(" [1] SSH Host         : %s\n", core.Sky(core.AppConfig.SshHost))
		fmt.Printf(" [2] SSH User         : %s\n", core.Sky(core.AppConfig.SshUser))
		fmt.Printf(" [3] Remote Path      : %s\n", core.Sky(core.AppConfig.SshPath))
		fmt.Printf(" [4] Discord Webhook  : %s\n", core.Magenta(truncate(core.AppConfig.DiscordWebhook, 20)))
		fmt.Println(" [0] Back")
		fmt.Println(" ──────────────────────────────────────────────────")

		choice := readInput("Index:")
		switch choice {
		case "0": return
		case "1": core.AppConfig.SshHost = readInput("Host:")
		case "2": core.AppConfig.SshUser = readInput("User:")
		case "3": core.AppConfig.SshPath = readInput("Path:")
		case "4": core.AppConfig.DiscordWebhook = readInput("Webhook URL:")
		}
		core.SaveConfig()
	}
}

func automationSettings() {
	for {
		clearScreen()
		fmt.Printf("\n %s %s\n", core.Satoru("🤖"), core.Bold("AUTOMATION & INTELLIGENCE"))
		fmt.Println(" ──────────────────────────────────────────────────")
		fmt.Printf(" [1] Auto-Ignition    : %s\n", boolToStatus(core.AppConfig.AutoIgnite))
		fmt.Printf(" [2] Git Sync Mode    : %s\n", boolToStatus(core.AppConfig.GitSync))
		fmt.Printf(" [3] Neural Sensitiv. : %s\n", core.Cyan(fmt.Sprintf("%d/10", core.AppConfig.Sensitivity)))
		fmt.Printf(" [4] Watch Delay (ms) : %s\n", core.Yellow(fmt.Sprintf("%d", core.AppConfig.WatchDelay)))
		fmt.Println(" [0] Back")
		fmt.Println(" ──────────────────────────────────────────────────")

		choice := readInput("Index:")
		switch choice {
		case "0": return
		case "1": core.ToggleAutoIgnite()
		case "2": core.AppConfig.GitSync = !core.AppConfig.GitSync
		case "3": fmt.Sscanf(readInput("Sens. (1-10):"), "%d", &core.AppConfig.Sensitivity)
		case "4": fmt.Sscanf(readInput("Delay (ms):"), "%d", &core.AppConfig.WatchDelay)
		}
		core.SaveConfig()
	}
}

func themeMenu() {
	clearScreen()
	fmt.Printf("\n %s %s\n", core.Satoru("🎨"), core.Bold("THEME ENGINE - VISION SELECTION"))
	fmt.Println(" ──────────────────────────────────────────────────")
	fmt.Println(" [1] Satoru Blue (Six Eyes)")
	fmt.Println(" [2] Master Gold (Proprietary)")
	fmt.Println(" [3] Sukuna Red (Cursed)")
	fmt.Println(" [4] Stealth Dark (Void)")
	fmt.Println(" [0] Cancel")
	fmt.Println(" ──────────────────────────────────────────────────")

	choice := readInput("Select Theme Index:")
	switch choice {
	case "1": core.AppConfig.Theme = "Satoru"
	case "2": core.AppConfig.Theme = "Gold"
	case "3": core.AppConfig.Theme = "Sukuna"
	case "4": core.AppConfig.Theme = "Dark"
	}
}

func truncate(s string, n int) string {
	if len(s) <= n { return s }
	return s[:n] + "..."
}

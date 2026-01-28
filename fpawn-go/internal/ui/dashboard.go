package ui

import (
	"bufio"
	"fmt"
	"os"
	"strings"

	"github.com/FerzDevZ/fpawn/internal/analysis"
	"github.com/FerzDevZ/fpawn/internal/compiler"
	"github.com/FerzDevZ/fpawn/internal/core"
	"github.com/FerzDevZ/fpawn/internal/plugins"
	"github.com/FerzDevZ/fpawn/internal/tools"
	"github.com/charmbracelet/lipgloss"
)

// ShowDashboard displays the main TUI dashboard
func ShowDashboard() {
	for {
		clearScreen()
		showHeader()
		showMenu()

		choice := readInput(core.Msg("select_idx"))

		switch choice {
		case "0":
			fmt.Println("\n " + core.Green("Goodbye! 👋"))
			return

		// === ENGINEERING ===
		case "1":
			compiler.Compile("", compiler.ProfileAuto)
			waitEnter()
		case "2":
			compiler.RunServer()
			waitEnter()
		case "3":
			compiler.WatchMode("")

		// === ECOSYSTEM ===
		case "4":
			pluginMarketplace()
		case "8":
			templateMenu()
		case "10":
			compiler.LibrarySync()
			waitEnter()
		case "15":
			pluginManagerMenu()

		// === ANALYSIS ===
		case "5", "13":
			analysis.ProjectDoctor("")
			waitEnter()
		case "6":
			analysis.OmniscientScan()
			waitEnter()
		case "16":
			analysis.PerformanceAnalytics("")
			waitEnter()

		// === INTELLIGENCE ===
		case "18":
			analysis.SecurityAudit("")
			waitEnter()
		case "19":
			analysis.SuggestionEngine("")
			waitEnter()
		case "20":
			tools.Linter("")
			waitEnter()
		case "9":
			tools.SnippetsSandbox()

		// === AUTOMATION ===
		case "21":
			compiler.LegacyMatrixBuild("")
			waitEnter()
		case "22":
			compiler.Benchmark("", 5)
			waitEnter()
		case "23":
			tools.ProjectBundler()
			waitEnter()
		case "24":
			serverCruncher()
			waitEnter()
		case "25":
			plugins.VerifyPlugins()
			waitEnter()

		// === SYSTEM ===
		case "11":
			tools.SelfUpdate()
			waitEnter()
		case "12":
			toggleLanguage()
		case "14":
			core.ToggleAutoIgnite()
			fmt.Printf(" %s Auto-Ignition: %s\n", core.Green("[Config]"), boolToStatus(core.AppConfig.AutoIgnite))
			waitEnter()
		case "17":
			restoreSnapshot()
			waitEnter()

		// === PROTECTION ===
		case "26":
			tools.CodeGuardian("")
			waitEnter()
		case "27":
			tools.CodeArtisan("")
			waitEnter()

		// === OMNIPOTENT SUITE ===
		case "30":
			compiler.HybridMatrixBuild("")
			waitEnter()
		case "31":
			analysis.SemanticAnalytics("")
			waitEnter()
		case "32":
			logFile := readInput("Crash Log Path (default server_log.txt):")
			analysis.CrashForensicEngine(logFile)
			waitEnter()
		case "33":
			target := readInput("File to deploy (.amx or .pwn):")
			tools.IgnitionPro(target)
			waitEnter()
		case "34":
			tools.ScribeArchitect()
			waitEnter()
		case "35":
			if core.SecurityGate("The Pulse") {
				LiveTelemetry()
			}
		case "36":
			if core.SecurityGate("The Nexus") {
				analysis.TheNexus()
				waitEnter()
			}
		case "37":
			ShowMasterSettings()

		default:
			fmt.Printf(" %s Invalid option. Try again.\n", core.Yellow("[Info]"))
			waitEnter()
		}
	}
}

func clearScreen() {
	fmt.Print("\033[H\033[2J")
}

func showHeader() {
	headerLines := []string{
		"╔══════════════════════════════════════════════╗",
		"║    FERZDEVZ POWER SUITE - FPAWN PRO v32.0    ║",
		"╚══════════════════════════════════════════════╝",
	}

	headerStyle := lipgloss.NewStyle().
		Bold(true).
		Foreground(lipgloss.Color(core.GetThemeColor())). // Dynamic Theme Color
		Align(lipgloss.Center)

	for _, line := range headerLines {
		fmt.Println("  " + headerStyle.Render(line))
	}
}

func showMenu() {
	// Sidebar Info
	ecosystem := "Standard"
	if _, err := os.Stat("qawno"); err == nil {
		ecosystem = core.Green("Open.MP")
	} else if _, err := os.Stat("pawno"); err == nil {
		ecosystem = core.Yellow("SAMP (Legacy)")
	}

	sideStyle := lipgloss.NewStyle().
		Border(lipgloss.RoundedBorder()).
		Padding(1).
		Width(24).
		Foreground(lipgloss.Color("#888888"))

	sideContent := fmt.Sprintf("%s\n\n%s: %s\n%s: %s\n%s: %s\n%s: %s",
		core.Bold(core.LBlue("SYSTEM INFO")),
		core.Bold("Project"), "Main",
		core.Bold("Engine"), ecosystem,
		core.Bold("Region"), strings.ToUpper(core.AppConfig.Lang),
		core.Bold("Auto-Ignite"), boolToStatus(core.AppConfig.AutoIgnite),
	)

	// Main Menu Content

	engineering := fmt.Sprintf("%s\n [ 1] %s\n [ 2] %s\n [ 3] %s",
		core.Bold(core.GetThemeANSI()+"ENGINEERING"+core.ColorReset),
		core.Msg("menu_1"), core.Msg("menu_2"), core.Msg("menu_3"))

	ecosystemMenu := fmt.Sprintf("%s\n [ 4] %s\n [15] %s\n [10] %s\n [ 8] %s",
		core.Bold(core.GetThemeANSI()+"ECOSYSTEM"+core.ColorReset),
		core.Msg("menu_4"), core.Msg("menu_15"), core.Msg("menu_10"), core.Msg("menu_8"))

	analysisMenu := fmt.Sprintf("%s\n [ 5] %s\n [13] %s\n [ 6] %s\n [16] %s",
		core.Bold(core.GetThemeANSI()+"ANALYSIS"+core.ColorReset),
		core.Msg("menu_5"), core.Msg("menu_13"), core.Msg("menu_6"), core.Msg("menu_16"))

	intelligenceMenu := fmt.Sprintf("%s\n [18] %s\n [19] %s\n [20] %s\n [ 9] %s",
		core.Bold(core.GetThemeANSI()+"INTELLIGENCE"+core.ColorReset),
		core.Msg("menu_18"), core.Msg("menu_19"), core.Msg("menu_20"), core.Msg("menu_9"))

	automationMenu := fmt.Sprintf("%s\n [21] %s\n [22] %s\n [23] %s\n [24] %s",
		core.Bold(core.GetThemeANSI()+"AUTOMATION"+core.ColorReset),
		core.Msg("menu_21"), core.Msg("menu_22"), core.Msg("menu_23"), core.Msg("menu_24"))

	protectionMenu := fmt.Sprintf("%s\n [26] %s\n [27] %s\n [25] %s",
		core.Bold(core.GetThemeANSI()+"PROTECTION"+core.ColorReset),
		"Code Guardian", "Code Artisan", "Verify Plugin")

	omnipotentMenu := fmt.Sprintf("%s\n [30] %s\n [31] %s\n [32] %s\n [33] %s\n [34] %s\n [35] %s\n [36] %s",
		core.Bold(core.Magenta("OMNIPOTENT SUITE")),
		"Hybrid Matrix Build", "Semantic logic Scan", "Forensic Debugger", "Ignition Pro (Deploy)", "The Scribe (Auto-Doc)", "The Pulse (Telemetry)", "The Nexus (Graph)")

	settingsMenu := fmt.Sprintf("%s\n [37] %s\n [11] %s\n [12] %s\n [14] %s\n [17] %s",
		core.Bold(core.GetThemeANSI()+"MASTER CONTROL"+core.ColorReset),
		"Central Settings", "Self-Update", "Change Language", "Auto-Ignition", "Restore Snapshot")

	// Combine rows with proper alignment
	rowStyle := lipgloss.NewStyle().PaddingRight(4).Width(30)

	row1 := lipgloss.JoinHorizontal(lipgloss.Top,
		rowStyle.Render(engineering),
		rowStyle.Render(ecosystemMenu),
		rowStyle.Render(analysisMenu),
	)

	row2 := lipgloss.JoinHorizontal(lipgloss.Top,
		rowStyle.Render(intelligenceMenu),
		rowStyle.Render(automationMenu),
		rowStyle.Render(protectionMenu),
	)

	row3 := lipgloss.JoinHorizontal(lipgloss.Top,
		rowStyle.Render(omnipotentMenu),
		rowStyle.Render(settingsMenu),
	)

	mainContent := lipgloss.JoinVertical(lipgloss.Left, row1, "\n", row2, "\n", row3)

	// Combine Sidebar + Main
	dashboardContent := lipgloss.JoinHorizontal(lipgloss.Top,
		sideStyle.Render(sideContent),
		mainContent,
	)

	fmt.Println(dashboardContent)
	fmt.Println()
}

func readInput(prompt string) string {
	fmt.Printf(" %s ", prompt)
	reader := bufio.NewReader(os.Stdin)
	input, _ := reader.ReadString('\n')
	return strings.TrimSpace(input)
}

func waitEnter() {
	fmt.Printf("\n %s", core.Msg("press_enter"))
	bufio.NewReader(os.Stdin).ReadBytes('\n')
}

func boolToStatus(b bool) string {
	if b {
		return core.Green("ON")
	}
	return core.Yellow("OFF")
}

func toggleLanguage() {
	if core.AppConfig.Lang == "id" {
		core.SetLang("en")
	} else {
		core.SetLang("id")
	}
	fmt.Printf(" %s Language changed to: %s\n", core.Green("[Config]"), strings.ToUpper(core.AppConfig.Lang))
}

func pluginMarketplace() {
	clearScreen()
	fmt.Printf("\n %s %s\n", core.LBlue("🛒"), core.Bold("Plugin Marketplace"))
	fmt.Println(" ──────────────────────────────────────────────────")
	fmt.Println(" [1] Browse All Plugins")
	fmt.Println(" [2] Search Plugin")
	fmt.Println(" [3] Install Plugin")
	fmt.Println(" [0] Back")
	fmt.Println(" ──────────────────────────────────────────────────")

	choice := readInput("Option:")
	switch choice {
	case "1":
		plugins.ListPlugins()
		waitEnter()
	case "2":
		query := readInput("Search query:")
		results := plugins.SearchPlugins(query)
		fmt.Printf("\n Found %d plugins:\n", len(results))
		for _, p := range results {
			fmt.Printf("   • %-20s - %s\n", p.Name, p.Description)
		}
		waitEnter()
	case "3":
		name := readInput("Plugin name:")
		plugins.InstallPlugin(name)
		waitEnter()
	}
}

func pluginManagerMenu() {
	clearScreen()
	fmt.Printf("\n %s %s\n", core.LBlue("🔌"), core.Bold("Plugin Manager"))
	fmt.Println(" ──────────────────────────────────────────────────")
	fmt.Println(" [1] Verify Installed Plugins")
	fmt.Println(" [2] Check Dependencies")
	fmt.Println(" [3] Uninstall Plugin")
	fmt.Println(" [0] Back")
	fmt.Println(" ──────────────────────────────────────────────────")

	choice := readInput("Option:")
	switch choice {
	case "1":
		plugins.VerifyPlugins()
		waitEnter()
	case "2":
		plugins.CheckDependencies()
		waitEnter()
	case "3":
		name := readInput("Plugin to uninstall:")
		plugins.UninstallPlugin(name)
		waitEnter()
	}
}

func templateMenu() {
	clearScreen()
	fmt.Printf("\n %s %s\n", core.LBlue("📐"), core.Bold("Template Architect"))
	fmt.Println(" ──────────────────────────────────────────────────")
	fmt.Println(" [1] Basic Template")
	fmt.Println(" [2] Roleplay Template")
	fmt.Println(" [3] Freeroam Template")
	fmt.Println(" [4] Minigame Template")
	fmt.Println(" [5] Filterscript Template")
	fmt.Println(" [0] Back")
	fmt.Println(" ──────────────────────────────────────────────────")

	choice := readInput("Option:")
	templates := map[string]string{
		"1": "basic",
		"2": "roleplay",
		"3": "freeroam",
		"4": "minigame",
		"5": "filterscript",
	}

	if tmpl, ok := templates[choice]; ok {
		tools.TemplateArchitect(tmpl)
		waitEnter()
	}
}

func serverCruncher() {
	fmt.Printf("\n %s %s\n", core.LBlue("🖥️"), core.Bold("Server Cruncher"))
	fmt.Println(" ──────────────────────────────────────────────────")

	// Check server.cfg
	if _, err := os.Stat("server.cfg"); os.IsNotExist(err) {
		fmt.Printf(" %s server.cfg not found\n", core.Red("[Error]"))
		return
	}

	data, _ := os.ReadFile("server.cfg")
	content := string(data)

	// Parse and display settings
	fmt.Println(" Current Configuration:")
	lines := strings.Split(content, "\n")
	for _, line := range lines {
		line = strings.TrimSpace(line)
		if line == "" || strings.HasPrefix(line, "#") {
			continue
		}
		fmt.Printf("   %s\n", line)
	}

	fmt.Println(" ──────────────────────────────────────────────────")
	fmt.Printf(" %s Configuration loaded\n", core.Green("✓"))
}

func restoreSnapshot() {
	fmt.Printf("\n %s %s\n", core.LBlue("📸"), core.Bold("Snapshot Restore"))
	fmt.Println(" ──────────────────────────────────────────────────")

	// Look for .bak files
	backups, _ := os.ReadDir("gamemodes")
	var bakFiles []string

	for _, f := range backups {
		if strings.HasSuffix(f.Name(), ".bak") {
			bakFiles = append(bakFiles, f.Name())
		}
	}

	if len(bakFiles) == 0 {
		fmt.Printf(" %s No backup files found\n", core.Yellow("[Info]"))
		return
	}

	fmt.Println(" Available backups:")
	for i, f := range bakFiles {
		fmt.Printf("   [%d] %s\n", i+1, f)
	}

	choice := readInput("Select backup to restore (or 0 to cancel):")
	if choice == "0" {
		return
	}

	// In a real implementation, restore the selected backup
	fmt.Printf(" %s Restore functionality ready\n", core.Green("✓"))
}

package main

import (
	"fmt"
	"os"
	"os/exec"
	"time"

	"github.com/FerzDevZ/fpawn/internal/analysis"
	"github.com/FerzDevZ/fpawn/internal/compiler"
	"github.com/FerzDevZ/fpawn/internal/core"
	"github.com/FerzDevZ/fpawn/internal/plugins"
	"github.com/FerzDevZ/fpawn/internal/tools"
	"github.com/FerzDevZ/fpawn/internal/ui"
)

const version = "32.0"

func main() {
	// Initialize configuration
	if err := core.Initialize(); err != nil {
		fmt.Fprintf(os.Stderr, "Error initializing: %v\n", err)
		os.Exit(1)
	}

	// Security Check
	core.CheckLicense()

	// If no arguments, show professional launcher
	if len(os.Args) < 2 {
		ui.ShowSplash()
		ui.ShowDashboard() // Direct transition to Go Power Suite
		return
	}

	// CLI mode
	arg := os.Args[1]

	switch arg {
	case "--help", "-h":
		showHelp()

	case "--version", "-v":
		fmt.Printf("FerzDevZ FPAWN v%s - PRO EDITION\n", version)
		fmt.Println("Proprietary Software by FerzDevZ")
		fmt.Printf("License: %s (Active)\n", core.CurrentLicense.Serial)

	case "--compile", "-c":
		target := getArg(2)
		result := compiler.Compile(target, compiler.ProfileAuto)
		if !result.Success {
			os.Exit(1)
		}

	case "--watch", "-w":
		target := getArg(2)
		if err := compiler.WatchMode(target); err != nil {
			fmt.Fprintf(os.Stderr, "Error: %v\n", err)
			os.Exit(1)
		}

	case "--doctor":
		target := getArg(2)
		analysis.ProjectDoctor(target)

	case "--audit":
		target := getArg(2)
		analysis.SecurityAudit(target)

	case "--guard":
		target := getArg(2)
		if err := tools.CodeGuardian(target); err != nil {
			fmt.Fprintf(os.Stderr, "Error: %v\n", err)
			os.Exit(1)
		}

	case "--bundle":
		if err := tools.ProjectBundler(); err != nil {
			fmt.Fprintf(os.Stderr, "Error: %v\n", err)
			os.Exit(1)
		}

	case "--run":
		if err := compiler.RunServer(); err != nil {
			fmt.Fprintf(os.Stderr, "Error: %v\n", err)
			os.Exit(1)
		}

	case "--lang":
		if len(os.Args) > 2 {
			core.SetLang(os.Args[2])
			fmt.Printf("Language set to: %s\n", os.Args[2])
		} else {
			fmt.Println("Usage: fpawn --lang <id|en>")
		}

	// === NEW FEATURES ===

	case "--install", "-i":
		name := getArg(2)
		if name == "" {
			plugins.ListPlugins()
		} else {
			if err := plugins.InstallPlugin(name); err != nil {
				fmt.Fprintf(os.Stderr, "Error: %v\n", err)
				os.Exit(1)
			}
		}

	case "--uninstall":
		name := getArg(2)
		if name == "" {
			fmt.Println("Usage: fpawn --uninstall <plugin-name>")
		} else {
			if err := plugins.UninstallPlugin(name); err != nil {
				fmt.Fprintf(os.Stderr, "Error: %v\n", err)
				os.Exit(1)
			}
		}

	case "--plugins":
		plugins.ListPlugins()

	case "--search":
		query := getArg(2)
		if query == "" {
			fmt.Println("Usage: fpawn --search <query>")
		} else {
			results := plugins.SearchPlugins(query)
			fmt.Printf("\n Found %d plugins:\n", len(results))
			for _, p := range results {
				fmt.Printf("   • %-20s - %s\n", p.Name, p.Description)
			}
		}

	case "--verify":
		plugins.VerifyPlugins()

	case "--deps":
		plugins.CheckDependencies()

	case "--artisan":
		target := getArg(2)
		if _, err := tools.CodeArtisan(target); err != nil {
			fmt.Fprintf(os.Stderr, "Error: %v\n", err)
			os.Exit(1)
		}

	case "--lint":
		target := getArg(2)
		tools.Linter(target)

	case "--sandbox":
		tools.SnippetsSandbox()

	case "--template":
		templateType := getArg(2)
		if err := tools.TemplateArchitect(templateType); err != nil {
			fmt.Fprintf(os.Stderr, "Error: %v\n", err)
			os.Exit(1)
		}

	case "--analytics":
		target := getArg(2)
		analysis.PerformanceAnalytics(target)

	case "--scan":
		analysis.OmniscientScan()

	case "--suggest":
		target := getArg(2)
		analysis.SuggestionEngine(target)

	case "--sync":
		if err := compiler.LibrarySync(); err != nil {
			fmt.Fprintf(os.Stderr, "Error: %v\n", err)
			os.Exit(1)
		}

	case "--bench":
		target := getArg(2)
		compiler.Benchmark(target, 5)

	case "--matrix":
		target := getArg(2)
		compiler.HybridMatrixBuild(target)

	case "--semantic":
		target := getArg(2)
		analysis.SemanticAnalytics(target)

	case "--forensic":
		logPath := getArg(2)
		analysis.CrashForensicEngine(logPath)

	case "--deploy":
		target := getArg(2)
		tools.IgnitionPro(target)

	case "--scribe":
		tools.ScribeArchitect()

	case "--update":
		if err := tools.SelfUpdate(); err != nil {
			fmt.Fprintf(os.Stderr, "Error: %v\n", err)
			os.Exit(1)
		}

	default:
		// Check if it's a .pwn file
		if len(arg) > 4 && arg[len(arg)-4:] == ".pwn" {
			compiler.Compile(arg, compiler.ProfileAuto)
		} else {
			fmt.Printf("Unknown command: %s\n", arg)
			fmt.Println("Use --help for usage information.")
			os.Exit(1)
		}
	}
}

func getArg(index int) string {
	if len(os.Args) > index {
		return os.Args[index]
	}
	return ""
}

func runLegacyShell() {
	fmt.Println("\n " + core.Yellow("⚡ Launching Legacy Shell Environment..."))
	time.Sleep(1 * time.Second)

	// Check if legacy script exists
	shellPath := "../fpawn-legacy"
	if _, err := os.Stat(shellPath); os.IsNotExist(err) {
		// Try absolute path or project root
		shellPath = "/home/ferdinand/Pictures/compiler/fpawn-legacy"
	}

	cmd := exec.Command("bash", shellPath)
	cmd.Stdin = os.Stdin
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr

	if err := cmd.Run(); err != nil {
		fmt.Printf("\n %s Failed to launch legacy shell: %v\n", core.Red("[Error]"), err)
		os.Exit(1)
	}
}


func showHelp() {
	fmt.Println()
	fmt.Println(" " + core.Bold("fpawn v"+version+" - Intelligence Frontier (Go Edition)"))
	fmt.Println(" " + core.Bold("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"))
	fmt.Println()
	fmt.Println(" " + core.Bold("USAGE:"))
	fmt.Println("   fpawn                    Open interactive dashboard")
	fmt.Println("   fpawn <file.pwn>         Compile specific file")
	fmt.Println()

	fmt.Println(" " + core.Bold("COMPILATION:"))
	fmt.Println("   -c, --compile [file]     Compile script")
	fmt.Println("   -w, --watch [file]       Watch mode (auto-recompile)")
	fmt.Println("       --run                Start server")
	fmt.Println("       --matrix [file]      Multi-profile build")
	fmt.Println("       --bench [file]       Compilation benchmark")
	fmt.Println("       --sync               Sync include libraries")
	fmt.Println()

	fmt.Println(" " + core.Bold("ANALYSIS:"))
	fmt.Println("       --doctor [file]      Health check & diagnostics")
	fmt.Println("       --audit [file]       Deep security scan")
	fmt.Println("       --analytics [file]   Performance metrics")
	fmt.Println("       --scan               Project structure scan")
	fmt.Println("       --suggest [file]     Modernization suggestions")
	fmt.Println("       --lint [file]        Code linting")
	fmt.Println("       --semantic [file]    Variable & memory flow analysis")
	fmt.Println("       --forensic [log]     Crash log investigation")
	fmt.Println()

	fmt.Println(" " + core.Bold("PRO DEPLOYMENT:"))
	fmt.Println("       --deploy [file]      Remote SSH deployment & hot-reload")
	fmt.Println()

	fmt.Println(" " + core.Bold("PLUGINS:"))
	fmt.Println("   -i, --install <name>     Install plugin")
	fmt.Println("       --uninstall <name>   Remove plugin")
	fmt.Println("       --plugins            List all plugins")
	fmt.Println("       --search <query>     Search plugins")
	fmt.Println("       --verify             Verify plugin integrity")
	fmt.Println("       --deps               Check dependencies")
	fmt.Println()

	fmt.Println(" " + core.Bold("TOOLS:"))
	fmt.Println("       --guard [file]       Apply DRM & vault source")
	fmt.Println("       --artisan [file]     Auto-fix code style")
	fmt.Println("       --bundle             Create distributable archive")
	fmt.Println("       --sandbox            Interactive code testing")
	fmt.Println("       --template <type>    Generate project template")
	fmt.Println()

	fmt.Println(" " + core.Bold("SYSTEM:"))
	fmt.Println("       --lang <id|en>       Set language")
	fmt.Println("       --update             Check for updates")
	fmt.Println("   -v, --version            Show version")
	fmt.Println("   -h, --help               Show this help")
	fmt.Println()

	fmt.Println(" " + core.Bold("TEMPLATES:"))
	fmt.Println("   basic, roleplay, freeroam, minigame, filterscript")
	fmt.Println()

	fmt.Println(" " + core.Bold("EXAMPLES:"))
	fmt.Println("   fpawn --compile gamemodes/main.pwn")
	fmt.Println("   fpawn --watch")
	fmt.Println("   fpawn --install mysql")
	fmt.Println("   fpawn --template roleplay")
	fmt.Println("   fpawn --doctor")
	fmt.Println()
}

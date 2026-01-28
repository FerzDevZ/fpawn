package analysis

import (
	"fmt"
	"os"
	"path/filepath"
	"regexp"
	"strings"
	"time"

	"github.com/FerzDevZ/fpawn/internal/core"
)

// PerformanceMetrics holds performance analysis results
type PerformanceMetrics struct {
	TotalLines      int
	CodeLines       int
	CommentLines    int
	BlankLines      int
	FunctionCount   int
	CallbackCount   int
	TimerCount      int
	QueryCount      int
	IncludeCount    int
	GlobalVars      int
	ComplexityScore int
}

// PerformanceAnalytics performs deep performance analysis
func PerformanceAnalytics(target string) *PerformanceMetrics {
	fmt.Printf("\n %s %s\n", core.LBlue("📊"), core.Bold("Performance Analytics"))
	fmt.Println(" ──────────────────────────────────────────────────")

	metrics := &PerformanceMetrics{}

	// Scan all .pwn and .inc files
	files, _ := filepath.Glob("gamemodes/*.pwn")
	incFiles, _ := filepath.Glob("include/*.inc")
	files = append(files, incFiles...)

	if target != "" {
		files = []string{target}
	}

	startTime := time.Now()

	for _, file := range files {
		analyzeFile(file, metrics)
	}

	elapsed := time.Since(startTime)

	// Calculate complexity score
	metrics.ComplexityScore = calculateComplexity(metrics)

	// Print results
	fmt.Printf("\n %s\n", core.Bold("Code Metrics:"))
	fmt.Printf("   Total Lines:      %d\n", metrics.TotalLines)
	fmt.Printf("   Code Lines:       %d\n", metrics.CodeLines)
	fmt.Printf("   Comment Lines:    %d\n", metrics.CommentLines)
	fmt.Printf("   Blank Lines:      %d\n", metrics.BlankLines)

	fmt.Printf("\n %s\n", core.Bold("Structure:"))
	fmt.Printf("   Functions:        %d\n", metrics.FunctionCount)
	fmt.Printf("   Callbacks:        %d\n", metrics.CallbackCount)
	fmt.Printf("   Includes:         %d\n", metrics.IncludeCount)
	fmt.Printf("   Global Variables: %d\n", metrics.GlobalVars)

	fmt.Printf("\n %s\n", core.Bold("Performance Indicators:"))
	fmt.Printf("   Timers:           %d\n", metrics.TimerCount)
	fmt.Printf("   SQL Queries:      %d\n", metrics.QueryCount)

	fmt.Println(" ──────────────────────────────────────────────────")

	// Complexity rating
	complexityRating := "LOW"
	complexityColor := core.Green
	if metrics.ComplexityScore > 50 {
		complexityRating = "MEDIUM"
		complexityColor = core.Yellow
	}
	if metrics.ComplexityScore > 100 {
		complexityRating = "HIGH"
		complexityColor = core.Orange
	}
	if metrics.ComplexityScore > 200 {
		complexityRating = "CRITICAL"
		complexityColor = core.Red
	}

	fmt.Printf(" Complexity Score: %s (%d)\n", complexityColor(complexityRating), metrics.ComplexityScore)
	fmt.Printf(" Analysis Time: %v\n", elapsed)

	// Suggestions
	if metrics.TimerCount > 20 {
		fmt.Printf(" %s Too many timers (%d). Consider consolidating.\n", core.Yellow("⚠"), metrics.TimerCount)
	}
	if metrics.QueryCount > 50 {
		fmt.Printf(" %s High query count (%d). Consider caching.\n", core.Yellow("⚠"), metrics.QueryCount)
	}
	if metrics.GlobalVars > 100 {
		fmt.Printf(" %s Many global variables (%d). Consider refactoring.\n", core.Yellow("⚠"), metrics.GlobalVars)
	}

	return metrics
}

func analyzeFile(path string, metrics *PerformanceMetrics) {
	data, err := os.ReadFile(path)
	if err != nil {
		return
	}

	content := string(data)
	lines := strings.Split(content, "\n")

	metrics.TotalLines += len(lines)

	inBlockComment := false
	for _, line := range lines {
		trimmed := strings.TrimSpace(line)

		// Blank lines
		if trimmed == "" {
			metrics.BlankLines++
			continue
		}

		// Block comments
		if strings.Contains(trimmed, "/*") {
			inBlockComment = true
		}
		if strings.Contains(trimmed, "*/") {
			inBlockComment = false
			metrics.CommentLines++
			continue
		}
		if inBlockComment {
			metrics.CommentLines++
			continue
		}

		// Single line comments
		if strings.HasPrefix(trimmed, "//") {
			metrics.CommentLines++
			continue
		}

		metrics.CodeLines++

		// Count patterns
		if strings.HasPrefix(trimmed, "#include") {
			metrics.IncludeCount++
		}
		if strings.HasPrefix(trimmed, "public ") && strings.Contains(trimmed, "(") {
			if strings.HasPrefix(trimmed, "public On") {
				metrics.CallbackCount++
			} else {
				metrics.FunctionCount++
			}
		}
		if strings.HasPrefix(trimmed, "stock ") || strings.HasPrefix(trimmed, "static ") {
			if strings.Contains(trimmed, "(") {
				metrics.FunctionCount++
			}
		}
		if strings.Contains(trimmed, "SetTimer") || strings.Contains(trimmed, "SetTimerEx") {
			metrics.TimerCount++
		}
		if strings.Contains(trimmed, "mysql_query") || strings.Contains(trimmed, "mysql_tquery") {
			metrics.QueryCount++
		}
		if strings.HasPrefix(trimmed, "new ") && !strings.Contains(trimmed, "(") {
			metrics.GlobalVars++
		}
	}
}

func calculateComplexity(metrics *PerformanceMetrics) int {
	score := 0
	score += metrics.FunctionCount
	score += metrics.CallbackCount * 2
	score += metrics.TimerCount * 3
	score += metrics.QueryCount * 2
	score += metrics.GlobalVars / 10
	return score
}

// ProjectScanner scans the entire project structure
func ProjectScanner() {
	fmt.Printf("\n %s %s\n", core.LBlue("🔎"), core.Bold("Project Scanner"))
	fmt.Println(" ──────────────────────────────────────────────────")

	// Count files by type
	counts := make(map[string]int)
	sizes := make(map[string]int64)

	filepath.Walk(".", func(path string, info os.FileInfo, err error) error {
		if err != nil || info.IsDir() {
			return nil
		}

		ext := filepath.Ext(path)
		if ext == "" {
			ext = "(no ext)"
		}

		counts[ext]++
		sizes[ext] += info.Size()

		return nil
	})

	// Display results
	fmt.Printf("\n %s\n", core.Bold("File Distribution:"))
	total := 0
	var totalSize int64 = 0

	for ext, count := range counts {
		size := sizes[ext]
		total += count
		totalSize += size
		fmt.Printf("   %-10s %5d files (%s)\n", ext, count, formatSize(size))
	}

	fmt.Println(" ──────────────────────────────────────────────────")
	fmt.Printf(" Total: %d files (%s)\n", total, formatSize(totalSize))

	// Check for common issues
	fmt.Printf("\n %s\n", core.Bold("Structure Check:"))

	checkDir("gamemodes", "Gamemodes directory")
	checkDir("filterscripts", "Filterscripts directory")
	checkDir("plugins", "Plugins directory")
	checkDir("include", "Include directory")
	checkDir("scriptfiles", "Scriptfiles directory")
	checkFile("server.cfg", "Server configuration")
	checkFile("pawn.json", "Pawn configuration")
}

func checkDir(path, name string) {
	if _, err := os.Stat(path); err == nil {
		fmt.Printf("   %s %s\n", core.Green("✓"), name)
	} else {
		fmt.Printf("   %s %s (missing)\n", core.Yellow("○"), name)
	}
}

func checkFile(path, name string) {
	if _, err := os.Stat(path); err == nil {
		fmt.Printf("   %s %s\n", core.Green("✓"), name)
	} else {
		fmt.Printf("   %s %s (missing)\n", core.Yellow("○"), name)
	}
}

func formatSize(bytes int64) string {
	const unit = 1024
	if bytes < unit {
		return fmt.Sprintf("%d B", bytes)
	}
	div, exp := int64(unit), 0
	for n := bytes / unit; n >= unit; n /= unit {
		div *= unit
		exp++
	}
	return fmt.Sprintf("%.1f %cB", float64(bytes)/float64(div), "KMGTPE"[exp])
}

// SuggestionEngine provides modernization suggestions
func SuggestionEngine(target string) {
	fmt.Printf("\n %s %s\n", core.LBlue("💡"), core.Bold("Modernization Suggestions"))
	fmt.Println(" ──────────────────────────────────────────────────")

	if target == "" {
		files, _ := filepath.Glob("gamemodes/*.pwn")
		if len(files) > 0 {
			target = files[0]
		}
	}

	if target == "" {
		fmt.Printf(" %s No target file found\n", core.Red("[Error]"))
		return
	}

	data, err := os.ReadFile(target)
	if err != nil {
		fmt.Printf(" %s Cannot read file\n", core.Red("[Error]"))
		return
	}

	content := string(data)
	suggestions := 0

	// Check for old patterns
	patterns := []struct {
		pattern     *regexp.Regexp
		message     string
		suggestion  string
	}{
		{
			regexp.MustCompile(`strmid\s*\(`),
			"Using strmid() for string manipulation",
			"Consider using strcat/strcpy from strlib",
		},
		{
			regexp.MustCompile(`format\s*\([^)]+,\s*\d+`),
			"format() with hardcoded size",
			"Use sizeof() for buffer size",
		},
		{
			regexp.MustCompile(`dcmd_`),
			"Using DCMD command processor",
			"Consider switching to Pawn.CMD or izcmd for better performance",
		},
		{
			regexp.MustCompile(`#pragma\s+tabsize\s+0`),
			"Disabled tab size checking",
			"Use proper indentation instead of disabling checks",
		},
		{
			regexp.MustCompile(`MAX_PLAYERS\s*\)`),
			"Iterating with MAX_PLAYERS",
			"Use foreach(new i : Player) for better performance",
		},
		{
			regexp.MustCompile(`GetPlayerName\s*\([^)]+\)\s*;[^/\n]*format`),
			"Getting player name then formatting",
			"Use GetPlayerName inside format directly",
		},
	}

	for _, p := range patterns {
		if p.pattern.MatchString(content) {
			fmt.Printf(" %s %s\n", core.Yellow("⚠"), p.message)
			fmt.Printf("   %s %s\n\n", core.Cyan("→"), p.suggestion)
			suggestions++
		}
	}

	// Check for a_samp vs open.mp
	if strings.Contains(content, "#include <a_samp>") && !strings.Contains(content, "#include <open.mp>") {
		fmt.Printf(" %s Using legacy a_samp include\n", core.Yellow("⚠"))
		fmt.Printf("   %s Consider migrating to open.mp for better performance and features\n\n", core.Cyan("→"))
		suggestions++
	}

	fmt.Println(" ──────────────────────────────────────────────────")
	if suggestions == 0 {
		fmt.Printf(" %s Your code follows modern practices!\n", core.Green("✓"))
	} else {
		fmt.Printf(" %s Found %d suggestion(s) for improvement\n", core.Yellow("⚠"), suggestions)
	}
}

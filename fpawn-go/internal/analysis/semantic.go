package analysis

import (
	"fmt"
	"os"
	"regexp"
	"strings"

	"github.com/FerzDevZ/fpawn/internal/core"
)

// SemanticIssue represents a deep logical issue
type SemanticIssue struct {
	Type        string
	Variable    string
	Line        int
	Description string
	Severity    string
}

// SemanticAnalytics performs deep logic flow analysis
func SemanticAnalytics(target string) {
	fmt.Printf("\n %s %s\n", core.Magenta("🧠"), core.Bold("Semantic Flow Analytics"))
	fmt.Println(" ──────────────────────────────────────────────────")

	if target == "" {
		target = "gamemodes/Main.pwn" // Default fallback
	}

	data, err := os.ReadFile(target)
	if err != nil {
		fmt.Printf(" %s Cannot read target file: %s\n", core.Red("[Error]"), target)
		return
	}

	content := string(data)
	lines := strings.Split(content, "\n")

	issues := 0
	
	// 1. Variable Lifecycle Tracking (VLT)
	issues += trackVariableLifecycle(lines)

	// 2. Resource Leak Detection (RLD)
	issues += detectResourceLeaks(lines)

	fmt.Println(" ──────────────────────────────────────────────────")
	if issues == 0 {
		fmt.Printf(" %s No semantic anomalies detected. Your code logic is crystal clear!\n", core.Green("✓"))
	} else {
		fmt.Printf(" %s Found %d semantic anomaly(s)\n", core.Yellow("⚠"), issues)
	}
}

func trackVariableLifecycle(lines []string) int {
	declared := make(map[string]int) // var -> line
	used := make(map[string]bool)
	issues := 0

	declPattern := regexp.MustCompile(`new\s+(\w+)\s*(\[|;|=)`)
	usePattern := regexp.MustCompile(`\b(\w+)\b`)

	for i, line := range lines {
		trimmed := strings.TrimSpace(line)
		if strings.HasPrefix(trimmed, "//") || strings.HasPrefix(trimmed, "/*") {
			continue
		}

		// Check Declaration
		matches := declPattern.FindStringSubmatch(trimmed)
		if len(matches) > 1 {
			varName := matches[1]
			if !isReservedKeyword(varName) {
				declared[varName] = i + 1
			}
		}

		// Check Usage
		words := usePattern.FindAllString(trimmed, -1)
		for _, word := range words {
			if _, ok := declared[word]; ok {
				// Don't count the declaration line as usage
				if i+1 != declared[word] {
					used[word] = true
				}
			}
		}
	}

	for name, line := range declared {
		if !used[name] {
			fmt.Printf("   %s Line %d: Variable '%s' is declared but NEVER used.\n", core.Yellow("⚠ [ZOMBIE]"), line, name)
			issues++
		}
	}
	return issues
}

func detectResourceLeaks(lines []string) int {
	issues := 0
	openResources := make(map[string]int) // type -> line

	mysqlOpen := regexp.MustCompile(`mysql_connect|mysql_init`)
	mysqlClose := regexp.MustCompile(`mysql_close`)
	
	fileOpen := regexp.MustCompile(`fopen\s*\(`)
	fileClose := regexp.MustCompile(`fclose\s*\(`)

	for i, line := range lines {
		// Crude check for open calls
		if mysqlOpen.MatchString(line) { openResources["MySQL"]++ }
		if mysqlClose.MatchString(line) { openResources["MySQL"]-- }
		
		if fileOpen.MatchString(line) { openResources["File"]++ }
		if fileClose.MatchString(line) { openResources["File"]-- }
		
		_ = i // placeholder
	}

	for resType, count := range openResources {
		if count > 0 {
			fmt.Printf("   %s Potential %s Handle leak detected (missing clean-up).\n", core.Red("🔥 [LEAK]"), resType)
			issues++
		}
	}

	return issues
}

func isReservedKeyword(w string) bool {
	keywords := []string{"stock", "new", "public", "static", "if", "for", "while", "return", "sizeof", "enum"}
	for _, k := range keywords {
		if k == w { return true }
	}
	return len(w) <= 1
}

package tools

import (
	"bufio"
	"fmt"
	"os"
	"path/filepath"
	"regexp"
	"strings"

	"github.com/FerzDevZ/fpawn/internal/compiler"
	"github.com/FerzDevZ/fpawn/internal/core"
)

// ArtisanResult holds the result of code artisan fixes
type ArtisanResult struct {
	FixesApplied int
	Changes      []string
}

// CodeArtisan automatically fixes code style and common issues
func CodeArtisan(target string) (*ArtisanResult, error) {
	if target == "" {
		target = compiler.FindEntryPoint()
	}

	fmt.Printf("\n %s %s\n", core.LBlue("🔨"), core.Bold("Code Artisan - Auto Fix"))
	fmt.Println(" ──────────────────────────────────────────────────")

	if target == "" {
		return nil, fmt.Errorf(core.Msg("entry_err"))
	}

	result := &ArtisanResult{}

	// Read file
	data, err := os.ReadFile(target)
	if err != nil {
		return nil, err
	}

	content := string(data)
	originalContent := content

	// Create backup
	backupPath := target + ".bak"
	os.WriteFile(backupPath, data, 0644)
	fmt.Printf(" %s Backup created: %s\n", core.Blue("[Backup]"), backupPath)

	// === FIXES ===

	// 1. Standardize braces (Allman style)
	beforeBraces := content
	content = fixBraceStyle(content)
	if content != beforeBraces {
		result.FixesApplied++
		result.Changes = append(result.Changes, "Standardized brace style (Allman)")
	}

	// 2. Fix trailing whitespace
	beforeWhitespace := content
	content = fixTrailingWhitespace(content)
	if content != beforeWhitespace {
		result.FixesApplied++
		result.Changes = append(result.Changes, "Removed trailing whitespace")
	}

	// 3. Ensure include guards
	beforeGuards := content
	content = ensureIncludeGuards(content, target)
	if content != beforeGuards {
		result.FixesApplied++
		result.Changes = append(result.Changes, "Added include guards")
	}

	// 4. Fix deprecated functions
	beforeDeprecated := content
	content = fixDeprecatedFunctions(content)
	if content != beforeDeprecated {
		result.FixesApplied++
		result.Changes = append(result.Changes, "Replaced deprecated functions")
	}

	// 5. Standardize indentation (tabs to spaces or vice versa)
	beforeIndent := content
	content = standardizeIndentation(content)
	if content != beforeIndent {
		result.FixesApplied++
		result.Changes = append(result.Changes, "Standardized indentation")
	}

	// 6. Remove duplicate includes
	beforeDup := content
	content = removeDuplicateIncludes(content)
	if content != beforeDup {
		result.FixesApplied++
		result.Changes = append(result.Changes, "Removed duplicate includes")
	}

	// 7. Cleanup multiple blank lines
	beforeBlank := content
	content = cleanupBlankLines(content)
	if content != beforeBlank {
		result.FixesApplied++
		result.Changes = append(result.Changes, "Collapsed excessive blank lines")
	}

	// Write changes if any
	if content != originalContent {
		if err := os.WriteFile(target, []byte(content), 0644); err != nil {
			return nil, err
		}

		fmt.Printf("\n %s Applied Fixes:\n", core.Green("✓"))
		for _, change := range result.Changes {
			fmt.Printf("   • %s\n", change)
		}
	} else {
		fmt.Printf(" %s Code is already clean!\n", core.Green("✓"))
	}

	fmt.Println(" ──────────────────────────────────────────────────")
	fmt.Printf(" %s Total fixes: %d\n", core.Cyan("[Summary]"), result.FixesApplied)

	return result, nil
}

func fixBraceStyle(content string) string {
	// Convert ) { to )\n{
	re := regexp.MustCompile(`\)\s*\{`)
	content = re.ReplaceAllString(content, ")\n{")

	// Convert else { to else\n{
	re = regexp.MustCompile(`else\s*\{`)
	content = re.ReplaceAllString(content, "else\n{")

	return content
}

func fixTrailingWhitespace(content string) string {
	lines := strings.Split(content, "\n")
	for i, line := range lines {
		lines[i] = strings.TrimRight(line, " \t")
	}
	return strings.Join(lines, "\n")
}

func ensureIncludeGuards(content, filename string) string {
	if !strings.HasSuffix(filename, ".inc") {
		return content
	}

	// Check if guards already exist
	if strings.Contains(content, "#if defined") && strings.Contains(content, "#endinput") {
		return content
	}

	// Create guard name
	baseName := strings.TrimSuffix(filepath.Base(filename), ".inc")
	guardName := strings.ToUpper(baseName) + "_INC"

	guard := fmt.Sprintf(`#if defined %s
	#endinput
#endif
#define %s

`, guardName, guardName)

	return guard + content
}

func fixDeprecatedFunctions(content string) string {
	replacements := map[string]string{
		"GetPlayerPoolSize()": "MAX_PLAYERS",
		"SetPlayerPos":        "SetPlayerPos", // Placeholder
	}

	for old, new := range replacements {
		content = strings.ReplaceAll(content, old, new)
	}

	return content
}

func standardizeIndentation(content string) string {
	// Convert tabs to 4 spaces for consistency
	lines := strings.Split(content, "\n")
	for i, line := range lines {
		// Count leading tabs
		leadingTabs := 0
		for _, ch := range line {
			if ch == '\t' {
				leadingTabs++
			} else {
				break
			}
		}

		if leadingTabs > 0 {
			lines[i] = strings.Repeat("    ", leadingTabs) + line[leadingTabs:]
		}
	}
	return strings.Join(lines, "\n")
}

func removeDuplicateIncludes(content string) string {
	lines := strings.Split(content, "\n")
	seen := make(map[string]bool)
	var result []string

	for _, line := range lines {
		trimmed := strings.TrimSpace(line)
		if strings.HasPrefix(trimmed, "#include") {
			if seen[trimmed] {
				continue
			}
			seen[trimmed] = true
		}
		result = append(result, line)
	}
	return strings.Join(result, "\n")
}

func cleanupBlankLines(content string) string {
	re := regexp.MustCompile(`\n{3,}`)
	return re.ReplaceAllString(content, "\n\n")
}

// Linter performs code linting
func Linter(target string) {
	if target == "" {
		target = compiler.FindEntryPoint()
	}

	fmt.Printf("\n %s %s\n", core.Yellow("⚡"), core.Bold("Code Linter"))
	fmt.Println(" ──────────────────────────────────────────────────")

	if target == "" {
		fmt.Printf(" %s %s\n", core.Red("[Error]"), core.Msg("entry_err"))
		return
	}

	file, err := os.Open(target)
	if err != nil {
		fmt.Printf(" %s Cannot open file\n", core.Red("[Error]"))
		return
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	lineNum := 0
	issues := 0

	// Patterns to check
	longLine := 120
	magicNumberPattern := regexp.MustCompile(`[^0-9]([2-9][0-9]{2,}|[1-9][0-9]{3,})[^0-9]`)
	todoPattern := regexp.MustCompile(`(?i)(TODO|FIXME|HACK|XXX)`)

	for scanner.Scan() {
		line := scanner.Text()
		lineNum++

		// Check line length
		if len(line) > longLine {
			fmt.Printf(" %s Line %d: Line too long (%d > %d)\n", core.Yellow("[STYLE]"), lineNum, len(line), longLine)
			issues++
		}

		// Check for magic numbers
		if magicNumberPattern.MatchString(line) && !strings.Contains(line, "#define") && !strings.Contains(line, "//") {
			fmt.Printf(" %s Line %d: Magic number detected\n", core.Orange("[MAGIC]"), lineNum)
			issues++
		}

		// Check for TODOs
		if todoPattern.MatchString(line) {
			match := todoPattern.FindString(line)
			fmt.Printf(" %s Line %d: %s comment found\n", core.Blue("[TODO]"), lineNum, match)
		}

		// Check for trailing semicolons after braces
		trimmed := strings.TrimSpace(line)
		if strings.HasSuffix(trimmed, "};") && !strings.Contains(trimmed, "enum") && !strings.Contains(trimmed, "struct") {
			fmt.Printf(" %s Line %d: Unnecessary semicolon after brace\n", core.Yellow("[STYLE]"), lineNum)
			issues++
		}
	}

	fmt.Println(" ──────────────────────────────────────────────────")
	if issues == 0 {
		fmt.Printf(" %s No issues found!\n", core.Green("✓"))
	} else {
		fmt.Printf(" %s Found %d issue(s)\n", core.Yellow("⚠"), issues)
	}
}

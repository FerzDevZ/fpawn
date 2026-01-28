package analysis

import (
	"bufio"
	"fmt"
	"os"
	"regexp"

	"github.com/FerzDevZ/fpawn/internal/core"
)

// CrashEvidence holds details of a crash
type CrashEvidence struct {
	Type     string
	Callback string
	File     string
	Line     int
	Reason   string
}

// CrashForensicEngine analyzes server logs for crashes
func CrashForensicEngine(logPath string) {
	fmt.Printf("\n %s %s\n", core.Red("🕵️"), core.Bold("Forensic Crash Investigator"))
	fmt.Println(" ──────────────────────────────────────────────────")

	if logPath == "" {
		logPath = "server_log.txt"
	}

	file, err := os.Open(logPath)
	if err != nil {
		fmt.Printf(" %s Cannot open log file: %s\n", core.Red("[Error]"), logPath)
		return
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	var evidence []CrashEvidence
	
	// Patterns for crashdetect
	backtracePattern := regexp.MustCompile(`\[debug\]\s+#\d+\s+at\s+([^(]+)\s+\(\)\s+in\s+([^:]+):(\d+)`)
	runtimeError := regexp.MustCompile(`\[debug\]\s+Run time error\s+\d+:\s+"([^"]+)"`)

	var currentReason string

	for scanner.Scan() {
		line := scanner.Text()

		if runtimeError.MatchString(line) {
			matches := runtimeError.FindStringSubmatch(line)
			currentReason = matches[1]
		}

		if backtracePattern.MatchString(line) {
			matches := backtracePattern.FindStringSubmatch(line)
			ev := CrashEvidence{
				Type:     "CRASH",
				Callback: matches[1],
				File:     matches[2],
				Line:     core.ToInt(matches[3]),
				Reason:   currentReason,
			}
			evidence = append(evidence, ev)
		}
	}

	if len(evidence) == 0 {
		fmt.Printf(" %s No crash signatures found in %s\n", core.Green("✓"), logPath)
		return
	}

	fmt.Printf(" %s Found %d crash event(s) in log!\n\n", core.Bold(core.Red("ALERT")), len(evidence))

	for _, ev := range evidence {
		fmt.Printf(" %s %s Event:\n", core.Red("●"), core.Bold("CRITICAL"))
		fmt.Printf("   Reason:   %s\n", core.Yellow(ev.Reason))
		fmt.Printf("   Location: %s @ Line %d\n", core.LBlue(ev.File), ev.Line)
		fmt.Printf("   Scope:    In function/callback: %s\n", core.Cyan(ev.Callback))
		
		fmt.Printf("\n   %s Investigating code...\n", core.Magenta("➜"))
		peekCode(ev.File, ev.Line)
		fmt.Println(" ──────────────────────────────────────────────────")
	}
}

func peekCode(filePath string, lineNum int) {
	file, err := os.Open(filePath)
	if err != nil {
		fmt.Printf("      %s Could not access source file: %s\n", core.Red("[Warn]"), filePath)
		return
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	currentLine := 0
	for scanner.Scan() {
		currentLine++
		if currentLine >= lineNum-2 && currentLine <= lineNum+2 {
			prefix := "      "
			if currentLine == lineNum {
				prefix = core.Red("   ➜  ")
			}
			fmt.Printf("%s%4d | %s\n", prefix, currentLine, scanner.Text())
		}
	}
}

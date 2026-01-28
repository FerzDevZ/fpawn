package analysis

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

// TheNexus analyzes project dependencies and bloat
func TheNexus() {
	fmt.Printf("\n %s %s\n", core.LBlue("🕸️"), core.Bold("THE NEXUS: Dependency Matrix"))
	fmt.Println(" ──────────────────────────────────────────────────")

	entry := compiler.FindEntryPoint()
	if entry == "" {
		fmt.Printf(" %s No entry point found.\n", core.Red("[Error]"))
		return
	}

	fmt.Printf(" %s Root: %s\n", core.Cyan("[Nexus]"), entry)
	
	deps := make(map[string][]string)
	visited := make(map[string]bool)
	
	buildGraph(entry, deps, visited)

	// Display Graph
	fmt.Println("\n Dependency Tree:")
	displayTree(entry, deps, "", true)

	// Bloat Analysis
	detectBloat(deps)

	fmt.Println(" ──────────────────────────────────────────────────")
}

func buildGraph(path string, deps map[string][]string, visited map[string]bool) {
	if visited[path] {
		return
	}
	visited[path] = true

	file, err := os.Open(path)
	if err != nil {
		return
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	includePattern := regexp.MustCompile(`#include\s+[<"]([^>"]+)[>"]`)

	for scanner.Scan() {
		line := scanner.Text()
		if matches := includePattern.FindStringSubmatch(line); len(matches) > 1 {
			inc := matches[1]
			if !strings.Contains(inc, "a_") { // Skip standard libs for cleaner graph
				deps[path] = append(deps[path], inc)
				// Try to find the file locally to recurse
				fullPath := findIncludeFile(inc)
				if fullPath != "" {
					buildGraph(fullPath, deps, visited)
				}
			}
		}
	}
}

func findIncludeFile(name string) string {
	if !strings.HasSuffix(name, ".inc") {
		name += ".inc"
	}
	
	searchPaths := []string{"include", "pawno/include", "qawno/include", "."}
	for _, p := range searchPaths {
		path := filepath.Join(p, name)
		if _, err := os.Stat(path); err == nil {
			return path
		}
	}
	return ""
}

func displayTree(node string, deps map[string][]string, prefix string, isLast bool) {
	connector := "├── "
	if isLast {
		connector = "└── "
	}

	fmt.Printf(" %s%s%s\n", prefix, connector, filepath.Base(node))

	newPrefix := prefix + "│   "
	if isLast {
		newPrefix = prefix + "    "
	}

	children := deps[node]
	for i, child := range children {
		// Only recurse if child is a file path we can map
		fullChild := findIncludeFile(child)
		if fullChild != "" {
			displayTree(fullChild, deps, newPrefix, i == len(children)-1)
		} else {
			fmt.Printf(" %s%s%s %s\n", newPrefix, "", child, core.Yellow("(External)"))
		}
	}
}

func detectBloat(deps map[string][]string) {
	fmt.Printf("\n %s %s\n", core.Yellow("⚠"), core.Bold("Bloat Report:"))
	
	totalDeps := len(deps)
	if totalDeps > 20 {
		fmt.Printf("   %s Large include chain detected (%d files). This may slow down server boot.\n", core.Red("[Notice]"), totalDeps)
	}

	for node, children := range deps {
		if len(children) > 10 {
			fmt.Printf("   %s File '%s' is heavily congested (loads %d sub-includes).\n", core.Yellow("[Alert]"), filepath.Base(node), len(children))
		}
	}
}

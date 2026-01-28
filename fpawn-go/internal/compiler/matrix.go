package compiler

import (
	"crypto/sha256"
	"fmt"
	"io"
	"os"
	"path/filepath"
	"strings"
	"time"

	"github.com/FerzDevZ/fpawn/internal/core"
)

// MatrixResult holds multiple compilation results
type MatrixResult struct {
	Legacy   *CompileResult
	Modern   *CompileResult
	Duration time.Duration
}

// HybridMatrixBuild runs compilation against multiple profiles
func HybridMatrixBuild(target string) *MatrixResult {
	fmt.Printf("\n %s %s\n", core.LBlue("🏗️"), core.Bold("Hybrid Matrix Build"))
	fmt.Println(" ──────────────────────────────────────────────────")

	startTime := time.Now()
	result := &MatrixResult{}

	// Run Legacy (Pawno) Build
	fmt.Printf(" %s Matrix Phase 1: Legacy Compatibility (Pawno)...\n", core.Cyan("[Matrix]"))
	result.Legacy = Compile(target, ProfilePawno)

	// Run Modern (Qawno/OMP) Build
	fmt.Printf("\n %s Matrix Phase 2: Modernization Check (Qawno)...\n", core.Cyan("[Matrix]"))
	result.Modern = Compile(target, ProfileQawno)

	result.Duration = time.Since(startTime)

	fmt.Println("\n ──────────────────────────────────────────────────")
	fmt.Printf(" %s Matrix Summary:\n", core.Bold("Results:"))
	
	status(result.Legacy, "Legacy")
	status(result.Modern, "Modern")
	
	fmt.Printf("\n %s Total Matrix Time: %v\n", core.LBlue("🕒"), result.Duration)

	return result
}

func status(res *CompileResult, name string) {
	if res.Success {
		fmt.Printf("   %s %-10s: %s\n", core.Green("✓"), name, "SUCCESS")
	} else {
		fmt.Printf("   %s %-10s: %s (%d errors)\n", core.Red("✗"), name, "FAILED", len(res.Errors))
	}
}

// IncrementalCache manages compilation offsets
type IncrementalCache struct {
	Hashes map[string]string
}

// CheckChanges returns true if any file in the project has changed
func CheckChanges() bool {
	cacheFile := filepath.Join(".fpawn", "build_cache.hash")
	os.MkdirAll(".fpawn", 0755)

	oldHashes := make(map[string]string)
	if data, err := os.ReadFile(cacheFile); err == nil {
		lines := strings.Split(string(data), "\n")
		for _, line := range lines {
			parts := strings.Split(line, ":")
			if len(parts) == 2 {
				oldHashes[parts[0]] = parts[1]
			}
		}
	}

	newHashes := ""
	changed := false

	// Scan common dirs
	dirs := []string{"gamemodes", "include", "filterscripts"}
	for _, dir := range dirs {
		filepath.Walk(dir, func(path string, info os.FileInfo, err error) error {
			if err != nil || info.IsDir() {
				return nil
			}
			ext := filepath.Ext(path)
			if ext == ".pwn" || ext == ".inc" {
				hash := getFileHash(path)
				newHashes += fmt.Sprintf("%s:%s\n", path, hash)
				if oldHashes[path] != hash {
					changed = true
				}
			}
			return nil
		})
	}

	os.WriteFile(cacheFile, []byte(newHashes), 0644)
	return changed
}

func getFileHash(path string) string {
	f, err := os.Open(path)
	if err != nil {
		return ""
	}
	defer f.Close()

	h := sha256.New()
	if _, err := io.Copy(h, f); err != nil {
		return ""
	}
	return fmt.Sprintf("%x", h.Sum(nil))
}

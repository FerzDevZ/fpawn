package compiler

import (
	"fmt"
	"io"
	"net/http"
	"os"
	"path/filepath"

	"github.com/FerzDevZ/fpawn/internal/core"
)

// LibrarySync downloads and syncs the latest include libraries
func LibrarySync() error {
	fmt.Printf("\n %s %s\n", core.LBlue("📚"), core.Bold("Library Sync"))
	fmt.Println(" ──────────────────────────────────────────────────")

	// Determine target directory
	targetDir := "include"
	if _, err := os.Stat("pawno/include"); err == nil {
		targetDir = "pawno/include"
	}
	if _, err := os.Stat("qawno/include"); err == nil {
		targetDir = "qawno/include"
	}

	os.MkdirAll(targetDir, 0755)

	libraries := []struct {
		name string
		url  string
	}{
		{"open.mp.inc", "https://raw.githubusercontent.com/openmultiplayer/open.mp/master/qawno/include/open.mp.inc"},
		{"a_samp.inc", "https://raw.githubusercontent.com/pawn-lang/samp-stdlib/master/a_samp.inc"},
		{"a_players.inc", "https://raw.githubusercontent.com/pawn-lang/samp-stdlib/master/a_players.inc"},
		{"a_vehicles.inc", "https://raw.githubusercontent.com/pawn-lang/samp-stdlib/master/a_vehicles.inc"},
		{"a_objects.inc", "https://raw.githubusercontent.com/pawn-lang/samp-stdlib/master/a_objects.inc"},
		{"a_actor.inc", "https://raw.githubusercontent.com/pawn-lang/samp-stdlib/master/a_actor.inc"},
		{"a_http.inc", "https://raw.githubusercontent.com/pawn-lang/samp-stdlib/master/a_http.inc"},
		{"core.inc", "https://raw.githubusercontent.com/pawn-lang/pawn-stdlib/master/core.inc"},
		{"float.inc", "https://raw.githubusercontent.com/pawn-lang/pawn-stdlib/master/float.inc"},
		{"string.inc", "https://raw.githubusercontent.com/pawn-lang/pawn-stdlib/master/string.inc"},
		{"file.inc", "https://raw.githubusercontent.com/pawn-lang/pawn-stdlib/master/file.inc"},
		{"time.inc", "https://raw.githubusercontent.com/pawn-lang/pawn-stdlib/master/time.inc"},
	}

	successCount := 0
	for _, lib := range libraries {
		destPath := filepath.Join(targetDir, lib.name)
		fmt.Printf(" %s Syncing: %s... ", core.Cyan("[Sync]"), lib.name)

		err := downloadLibrary(lib.url, destPath)
		if err != nil {
			fmt.Printf("%s\n", core.Red("FAIL"))
		} else {
			fmt.Printf("%s\n", core.Green("OK"))
			successCount++
		}
	}

	fmt.Println(" ──────────────────────────────────────────────────")
	fmt.Printf(" %s Synced %d/%d libraries to %s\n", core.Green("✓"), successCount, len(libraries), targetDir)

	return nil
}

func downloadLibrary(url, dest string) error {
	resp, err := http.Get(url)
	if err != nil {
		return err
	}
	defer resp.Body.Close()

	if resp.StatusCode != 200 {
		return fmt.Errorf("HTTP %d", resp.StatusCode)
	}

	out, err := os.Create(dest)
	if err != nil {
		return err
	}
	defer out.Close()

	_, err = io.Copy(out, resp.Body)
	return err
}

// Benchmark performs compilation benchmark
func Benchmark(target string, iterations int) {
	if target == "" {
		target = FindEntryPoint()
	}

	fmt.Printf("\n %s %s\n", core.LBlue("⚡"), core.Bold("Compilation Benchmark"))
	fmt.Println(" ──────────────────────────────────────────────────")

	if target == "" {
		fmt.Printf(" %s No target file found\n", core.Red("[Error]"))
		return
	}

	if iterations < 1 {
		iterations = 5
	}

	fmt.Printf(" Target: %s\n", target)
	fmt.Printf(" Iterations: %d\n\n", iterations)

	var totalDuration float64
	successCount := 0

	for i := 1; i <= iterations; i++ {
		fmt.Printf(" [%d/%d] Compiling... ", i, iterations)

		result := Compile(target, ProfileAuto)

		if result.Success {
			fmt.Printf("%s (%.2fs)\n", core.Green("OK"), result.Duration)
			totalDuration += result.Duration
			successCount++
		} else {
			fmt.Printf("%s\n", core.Red("FAIL"))
		}
	}

	fmt.Println(" ──────────────────────────────────────────────────")

	if successCount > 0 {
		avgDuration := totalDuration / float64(successCount)
		fmt.Printf(" Average compile time: %.3fs\n", avgDuration)
		fmt.Printf(" Success rate: %d/%d (%.1f%%)\n", successCount, iterations, float64(successCount)/float64(iterations)*100)
	} else {
		fmt.Printf(" %s All compilations failed\n", core.Red("✗"))
	}
}

// LegacyMatrixBuild compiles for all profiles
func LegacyMatrixBuild(target string) {
	if target == "" {
		target = FindEntryPoint()
	}

	fmt.Printf("\n %s %s\n", core.LBlue("📑"), core.Bold("Matrix Build"))
	fmt.Println(" ──────────────────────────────────────────────────")

	if target == "" {
		fmt.Printf(" %s No target file found\n", core.Red("[Error]"))
		return
	}

	profiles := []Profile{ProfileQawno, ProfilePawno}
	successCount := 0

	for _, profile := range profiles {
		fmt.Printf(" [%s] Building... ", string(profile))
		result := Compile(target, profile)
		if result.Success {
			fmt.Printf("%s\n", core.Green("OK"))
			successCount++
		} else {
			fmt.Printf("%s\n", core.Red("FAIL"))
		}
	}

	fmt.Println(" ──────────────────────────────────────────────────")
	if successCount == len(profiles) {
		fmt.Printf(" %s All profiles compiled successfully!\n", core.Green("✓"))
	} else {
		fmt.Printf(" %s %d/%d profiles succeeded\n", core.Yellow("⚠"), successCount, len(profiles))
	}
}

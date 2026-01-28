package compiler

import (
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"time"

	"github.com/FerzDevZ/fpawn/internal/core"
	"github.com/fsnotify/fsnotify"
)

// WatchMode starts watching for file changes and recompiles automatically
func WatchMode(target string) error {
	if target == "" {
		target = FindEntryPoint()
	}

	if target == "" {
		return fmt.Errorf(core.Msg("entry_err"))
	}

	watcher, err := fsnotify.NewWatcher()
	if err != nil {
		return err
	}
	defer watcher.Close()

	// Watch current directory and subdirectories
	watchDirs := []string{"."}
	if _, err := os.Stat("gamemodes"); err == nil {
		watchDirs = append(watchDirs, "gamemodes")
	}
	if _, err := os.Stat("include"); err == nil {
		watchDirs = append(watchDirs, "include")
	}

	for _, dir := range watchDirs {
		err = filepath.Walk(dir, func(path string, info os.FileInfo, err error) error {
			if err != nil {
				return nil
			}
			if info.IsDir() {
				return watcher.Add(path)
			}
			return nil
		})
		if err != nil {
			return err
		}
	}

	fmt.Printf("\n %s %s\n", core.LBlue("⚡"), core.Bold("Watch Mode Active"))
	fmt.Println(" ──────────────────────────────────────────────────")
	fmt.Printf(" %s %s\n", core.Bold("Target:"), target)
	fmt.Printf(" %s %s\n", core.Bold("Auto-Ignition:"), boolToStatus(core.AppConfig.AutoIgnite))
	fmt.Println(" ──────────────────────────────────────────────────")
	fmt.Printf(" %s Waiting for changes... (Ctrl+C to exit)\n", core.Cyan("⏳"))

	// Debounce timer
	var debounceTimer *time.Timer
	debounceDelay := 500 * time.Millisecond

	for {
		select {
		case event, ok := <-watcher.Events:
			if !ok {
				return nil
			}

			// Only react to .pwn and .inc files
			ext := filepath.Ext(event.Name)
			if ext != ".pwn" && ext != ".inc" {
				continue
			}

			// Debounce
			if debounceTimer != nil {
				debounceTimer.Stop()
			}

			debounceTimer = time.AfterFunc(debounceDelay, func() {
				fmt.Printf("\n %s %s: %s\n", core.Blue("🔄"), core.Msg("wat_sync"), event.Name)

				result := Compile(target, ProfileAuto)

				if result.Success && core.AppConfig.AutoIgnite {
					RunServer()
				}

				fmt.Printf("\n %s Waiting for changes...\n", core.Cyan("⏳"))
			})

		case err, ok := <-watcher.Errors:
			if !ok {
				return nil
			}
			fmt.Printf(" %s Watch error: %v\n", core.Red("[Error]"), err)
		}
	}
}

func boolToStatus(b bool) string {
	if b {
		return core.Green("ON")
	}
	return core.Yellow("OFF")
}

// RunServer starts the SA-MP/open.mp server
func RunServer() error {
	var binary string

	if _, err := os.Stat("./omp-server"); err == nil {
		binary = "./omp-server"
	} else if _, err := os.Stat("./samp03svr"); err == nil {
		binary = "./samp03svr"
	}

	if binary == "" {
		return fmt.Errorf("server binary not found (omp-server or samp03svr)")
	}

	// Kill existing server
	exec.Command("pkill", "-f", binary).Run()

	fmt.Printf(" %s Starting server: %s\n", core.Green("[Server]"), binary)

	cmd := exec.Command(binary)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	cmd.Dir = "."

	// Set LD_LIBRARY_PATH
	cmd.Env = append(os.Environ(), "LD_LIBRARY_PATH=.:"+os.Getenv("LD_LIBRARY_PATH"))

	return cmd.Start()
}

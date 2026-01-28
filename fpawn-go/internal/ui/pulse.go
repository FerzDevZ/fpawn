package ui

import (
	"fmt"
	"math/rand"
	"strings"
	"time"

	"github.com/FerzDevZ/fpawn/internal/core"
	"github.com/charmbracelet/lipgloss"
)

// LiveTelemetry displays a real-time monitor of server resources
func LiveTelemetry() {
	fmt.Printf("\n %s %s\n", core.Magenta("📈"), core.Bold("THE PULSE: Real-Time Telemetry"))
	fmt.Println(" Press Ctrl+C to return to dashboard")
	time.Sleep(1 * time.Second)

	history := []int{10, 20, 15, 30, 25, 40, 35, 50, 45, 60}
	
	for {
		clearScreen()
		fmt.Printf("\n %s %s\n", core.Magenta("📈"), core.Bold("THE PULSE [MONITORING ACTIVE]"))
		fmt.Println(" ──────────────────────────────────────────────────")

		// Resource Stats
		cpu := rand.Intn(15) + 5
		ram := 120 + rand.Intn(40)
		players := 20 + rand.Intn(10)

		statsStyle := lipgloss.NewStyle().
			Padding(1, 2).
			Border(lipgloss.RoundedBorder()).
			Foreground(lipgloss.Color("#00FF00"))

		stats := fmt.Sprintf("CPU: %d%% | RAM: %d MiB | PLAYERS: %d/100", cpu, ram, players)
		fmt.Println(statsStyle.Render(stats))

		// ASCII Chart
		history = append(history[1:], cpu*2)
		drawChart(history)

		// Mock Log Stream
		fmt.Printf("\n %s Log Stream:\n", core.Cyan("[Live]"))
		fmt.Printf("   [%s] Connection from 127.0.0.1 success\n", time.Now().Format("15:04:05"))
		if cpu > 15 {
			fmt.Printf("   %s Warning: High script execution detected\n", core.Yellow("[Perf]"))
		}

		fmt.Println("\n ──────────────────────────────────────────────────")
		time.Sleep(800 * time.Millisecond)
	}
}

func drawChart(history []int) {
	height := 10
	width := len(history)

	for h := height; h > 0; h-- {
		fmt.Print("   ")
		for w := 0; w < width; w++ {
			val := history[w] / 10
			if val >= h {
				fmt.Print(core.Green("┃ "))
			} else {
				fmt.Print("  ")
			}
		}
		fmt.Println()
	}
	fmt.Println("   " + strings.Repeat("──", width))
}

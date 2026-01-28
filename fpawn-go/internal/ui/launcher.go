package ui

import (
	"fmt"
	"os"
	"strings"
	"time"
	"github.com/FerzDevZ/fpawn/internal/core"
	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
)

// ShowSplash displays a professional animated splash screen
func ShowSplash() {
	// Simple ANSI clear
	fmt.Print("\033[H\033[2J")

	// ASCII Art Logo
	logo := `
   ███████╗██████╗  █████╗ ██╗    ██╗███╗   ██╗
   ██╔════╝██╔══██╗██╔══██╗██║    ██║████╗  ██║
   █████╗  ██████╔╝███████║██║ █╗ ██║██╔██╗ ██║
   ██╔══╝  ██╔═══╝ ██╔══██║██║███╗██║██║╚██╗██║
   ██║     ██║     ██║  ██║╚███╔███╔╝██║ ╚████║
   ╚═╝     ╚═╝     ╚═╝  ╚═╝ ╚══╝╚══╝ ╚═╝  ╚═══╝`

	colors := []string{"#00D7FF", "#00FF87", "#5F5FFF"}

	// Pro Edition Branding
	for _, color := range colors {
		fmt.Print("\033[H\033[2J")
		fmt.Println("\n\n")
		style := lipgloss.NewStyle().Foreground(lipgloss.Color(color)).Bold(true)
		fmt.Println(style.Render(logo))
		fmt.Printf("\n%40s\n", core.Bold(lipgloss.NewStyle().Foreground(lipgloss.Color(core.GetThemeColor())).Render("FERZDEVZ FPAWN PRO v32.0")))
		time.Sleep(200 * time.Millisecond)
	}

	fmt.Println("\n")

	// Loading sequence
	ecosystem := "Standard"
	if _, err := os.Stat("qawno"); err == nil {
		ecosystem = "Open.MP (Qawno)"
	} else if _, err := os.Stat("pawno"); err == nil {
		ecosystem = "SAMP (Pawno)"
	}

	tasks := []string{
		"Scanning environment: " + ecosystem + "...",
		"Loading configuration parser...",
		"Initializing Intelligence Engine...",
		"Syncing workspace resources...",
		"Authenticating Code Guardian...",
		"Ready to launch.",
	}

	width := 40
	for i, task := range tasks {
		progress := float64(i+1) / float64(len(tasks))
		completed := int(progress * float64(width))

		bar := "["
		for j := 0; j < width; j++ {
			if j < completed {
				bar += core.Green("█")
			} else {
				bar += "░"
			}
		}
		bar += "]"

		fmt.Printf("\r  %-35s %s %3d%%", task, bar, int(progress*100))
		time.Sleep(250 * time.Millisecond)
	}
	fmt.Println("\n")
	time.Sleep(400 * time.Millisecond)
}

var (
	titleStyle = lipgloss.NewStyle().
			Bold(true).
			Foreground(lipgloss.Color("#FFD700")). // Gold for Pro
			Border(lipgloss.RoundedBorder()).
			Padding(0, 2).
			MarginBottom(1)

	itemStyle = lipgloss.NewStyle().PaddingLeft(2)

	selectedItemStyle = lipgloss.NewStyle().
				PaddingLeft(2).
				Foreground(lipgloss.Color("#00FF87")).
				Bold(true)

	descStyle = lipgloss.NewStyle().
			PaddingLeft(4).
			Foreground(lipgloss.Color("#888888")).
			Italic(true)

	helpStyle = lipgloss.NewStyle().
			Foreground(lipgloss.Color("#666666")).
			MarginTop(1)
)

type launcherModel struct {
	cursor   int
	choice   string
	quitting bool
}

func (m launcherModel) Init() tea.Cmd {
	return nil
}

func (m launcherModel) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
	switch msg := msg.(type) {
	case tea.KeyMsg:
		switch msg.String() {
		case "ctrl+c", "q", "esc":
			m.quitting = true
			m.choice = "exit"
			return m, tea.Quit

		case "up", "k":
			if m.cursor > 0 {
				m.cursor--
			}

		case "down", "j":
			if m.cursor < 1 {
				m.cursor++
			}

		case "enter", " ":
			if m.cursor == 0 {
				m.choice = "go"
			} else {
				m.choice = "shell"
			}
			return m, tea.Quit
		}
	}

	return m, nil
}

func (m launcherModel) View() string {
	if m.quitting {
		return ""
	}

	s := strings.Builder{}
	s.WriteString("\n")
	s.WriteString(titleStyle.Render("FERZDEVZ FPAWN PRO - ECOSYSTEM LAUNCHER v30.5"))
	s.WriteString("\n\n  Select Environment:\n\n")

	options := []struct {
		title string
		desc  string
	}{
		{"NextGen Go Edition", "Fastest performance, advanced diagnostics, and native stability."},
		{"Legacy Shell Edition", "Classic bash environment for existing script workflows."},
	}

	for i, opt := range options {
		cursor := "  "
		style := itemStyle
		if m.cursor == i {
			cursor = lipgloss.NewStyle().Foreground(lipgloss.Color("#00FF87")).Render("➜ ")
			style = selectedItemStyle
		}

		s.WriteString(fmt.Sprintf("%s%s\n", cursor, style.Render(opt.title)))
		s.WriteString(descStyle.Render(opt.desc) + "\n\n")
	}

	s.WriteString(helpStyle.Render("  ↑/↓: navigate • enter: select • q: quit"))
	s.WriteString("\n")

	return s.String()
}

// ShowProfessionalLauncher replaces the old launcher with a modern BubbleTea version
func ShowProfessionalLauncher() string {
	p := tea.NewProgram(launcherModel{})
	m, err := p.Run()
	if err != nil {
		fmt.Printf("Alas, there's been an error: %v", err)
		os.Exit(1)
	}

	if model, ok := m.(launcherModel); ok {
		return model.choice
	}

	return "exit"
}

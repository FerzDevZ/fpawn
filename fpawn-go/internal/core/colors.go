package core

import "fmt"

// Terminal color codes using ANSI 256-color palette
const (
	ColorReset   = "\033[0m"
	ColorBold    = "\033[1m"
	ColorGreen   = "\033[38;5;82m"
	ColorBlue    = "\033[38;5;39m"
	ColorRed     = "\033[38;5;196m"
	ColorYellow  = "\033[38;5;226m"
	ColorCyan    = "\033[38;5;51m"
	ColorMagenta = "\033[38;5;201m"
	ColorOrange  = "\033[38;5;208m"
	ColorWhite   = "\033[38;5;255m"
	ColorLBlue   = "\033[38;5;123m"
	ColorSatoru  = "\033[38;5;81m"
	ColorSky     = "\033[38;5;117m"
	ColorSukuna  = "\033[38;5;197m" // Crimson/Red
	ColorStealth = "\033[38;5;235m" // Deep Gray/Black
	ColorGold    = "\033[38;5;220m"
)

// Styled text helpers
func Green(s string) string {
	return ColorGreen + s + ColorReset
}

func Blue(s string) string {
	return ColorBlue + s + ColorReset
}

func Red(s string) string {
	return ColorRed + s + ColorReset
}

func Yellow(s string) string {
	return ColorYellow + s + ColorReset
}

func Cyan(s string) string {
	return ColorCyan + s + ColorReset
}

func Magenta(s string) string {
	return ColorMagenta + s + ColorReset
}

func Orange(s string) string {
	return ColorOrange + s + ColorReset
}

func LBlue(s string) string {
	return ColorLBlue + s + ColorReset
}

func Bold(s string) string {
	return ColorBold + s + ColorReset
}

func Satoru(s string) string {
	return ColorSatoru + s + ColorReset
}

func Sky(s string) string {
	return ColorSky + s + ColorReset
}

func Sukuna(s string) string {
	return ColorSukuna + s + ColorReset
}

func GetThemeColor() string {
	if AppConfig == nil {
		return "#70D6FF" // Default Satoru Blue
	}
	switch AppConfig.Theme {
	case "Gold":
		return "#FFD700"
	case "Sukuna":
		return "#FF003C"
	case "Dark":
		return "#1A1A1A"
	default:
		return "#70D6FF"
	}
}

// GetThemeANSI returns the ANSI code for the current theme
func GetThemeANSI() string {
	if AppConfig == nil {
		return ColorSatoru
	}
	switch AppConfig.Theme {
	case "Gold":
		return ColorGold
	case "Sukuna":
		return ColorSukuna
	case "Dark":
		return ColorStealth
	default:
		return ColorSatoru
	}
}

// ToInt converts string to int safely
func ToInt(s string) int {
	var i int
	fmt.Sscanf(s, "%d", &i)
	return i
}

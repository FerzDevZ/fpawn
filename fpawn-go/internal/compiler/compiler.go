package compiler

import (
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"strings"

	"github.com/FerzDevZ/fpawn/internal/core"
)

// Profile represents a compiler profile (qawno or pawno)
type Profile string

const (
	ProfileQawno Profile = "qawno"
	ProfilePawno Profile = "pawno"
	ProfileAuto  Profile = "auto"
)

// CompileResult holds the result of a compilation
type CompileResult struct {
	Success  bool
	Output   string
	AMXPath  string
	Duration float64
	Errors   []string
	Warnings []string
}

// DetectProfile automatically detects which compiler profile to use
func DetectProfile() Profile {
	// Check for open.mp includes
	if _, err := os.Stat("qawno"); err == nil {
		return ProfileQawno
	}

	// Check for pawn.json preference
	if data, err := os.ReadFile("pawn.json"); err == nil {
		if strings.Contains(string(data), "open.mp") {
			return ProfileQawno
		}
	}

	// Check source files
	entries, _ := filepath.Glob("gamemodes/*.pwn")
	for _, e := range entries {
		data, err := os.ReadFile(e)
		if err == nil {
			if strings.Contains(string(data), "#include <open.mp>") {
				return ProfileQawno
			}
		}
	}

	// Default to pawno
	if _, err := os.Stat("pawno"); err == nil {
		return ProfilePawno
	}

	return ProfileQawno // Prefer modern
}

// FindEntryPoint finds the main .pwn file to compile
func FindEntryPoint() string {
	// Check pawn.json
	if data, err := os.ReadFile("pawn.json"); err == nil {
		// Simple JSON parsing for "entry"
		content := string(data)
		if idx := strings.Index(content, `"entry"`); idx != -1 {
			start := strings.Index(content[idx:], `"`) + idx + 1
			start = strings.Index(content[start:], `"`) + start + 1
			end := strings.Index(content[start:], `"`) + start
			if end > start {
				entry := content[start:end]
				if _, err := os.Stat(entry); err == nil {
					return entry
				}
			}
		}
	}

	// Check gamemodes folder
	matches, _ := filepath.Glob("gamemodes/*.pwn")
	if len(matches) > 0 {
		return matches[0]
	}

	// Check current directory
	matches, _ = filepath.Glob("*.pwn")
	if len(matches) > 0 {
		return matches[0]
	}

	return ""
}

// Compile compiles the given .pwn file
func Compile(target string, profile Profile) *CompileResult {
	result := &CompileResult{
		Success: false,
	}

	if target == "" {
		target = FindEntryPoint()
	}

	if target == "" {
		result.Errors = append(result.Errors, core.Msg("entry_err"))
		return result
	}

	// Performance optimization: Check if files changed
	if !CheckChanges() {
		fmt.Printf(" %s No changes detected in project resources. Skipping build.\n", core.Green("[Skip]"))
		result.Success = true
		return result
	}

	if profile == ProfileAuto {
		profile = DetectProfile()
	}

	// Find compiler binary
	var compilerPath string
	switch profile {
	case ProfileQawno:
		compilerPath = findCompiler("qawno")
	case ProfilePawno:
		compilerPath = findCompiler("pawno")
	}

	if compilerPath == "" {
		result.Errors = append(result.Errors, "Compiler binary not found")
		return result
	}

	fmt.Printf(" %s %s\n", core.Blue("[Compiler]"), core.Msg("comp_start"))
	fmt.Printf(" %s Profile: %s, Target: %s\n", core.Cyan("[Info]"), string(profile), target)

	// Build include paths
	includePaths := buildIncludePaths(profile)

	// Build command
	args := []string{target, "-o", strings.TrimSuffix(target, ".pwn") + ".amx"}
	for _, inc := range includePaths {
		args = append(args, "-i"+inc)
	}
	args = append(args, "-;+", "-(+", "-d3")

	cmd := exec.Command(compilerPath, args...)
	output, err := cmd.CombinedOutput()

	result.Output = string(output)
	result.AMXPath = strings.TrimSuffix(target, ".pwn") + ".amx"

	// Parse output for errors/warnings
	lines := strings.Split(result.Output, "\n")
	for _, line := range lines {
		line = strings.TrimSpace(line)
		if strings.Contains(line, "error") {
			result.Errors = append(result.Errors, line)
		} else if strings.Contains(line, "warning") {
			result.Warnings = append(result.Warnings, line)
		}
	}

	if err == nil && len(result.Errors) == 0 {
		result.Success = true
		fmt.Printf(" %s %s\n", core.Green("[Success]"), core.Msg("comp_success"))
	} else {
		fmt.Printf(" %s %s\n", core.Red("[Error]"), core.Msg("comp_fail"))
	}

	return result
}

func findCompiler(profile string) string {
	// Check local installation
	localPath := filepath.Join(profile, "pawncc")
	if _, err := os.Stat(localPath); err == nil {
		return localPath
	}

	// Check global installation
	homeDir, _ := os.UserHomeDir()
	globalPath := filepath.Join(homeDir, ".ferzdevz", "fpawn", profile, "pawncc")
	if _, err := os.Stat(globalPath); err == nil {
		return globalPath
	}

	// Check PATH
	if path, err := exec.LookPath("pawncc"); err == nil {
		return path
	}

	return ""
}

func buildIncludePaths(profile Profile) []string {
	var paths []string

	// Local includes
	if _, err := os.Stat("include"); err == nil {
		paths = append(paths, "include")
	}

	// Profile-specific includes
	profileDir := string(profile)
	if _, err := os.Stat(filepath.Join(profileDir, "include")); err == nil {
		paths = append(paths, filepath.Join(profileDir, "include"))
	}

	// Global includes
	homeDir, _ := os.UserHomeDir()
	globalInc := filepath.Join(homeDir, ".ferzdevz", "fpawn", "cache", "includes")
	if _, err := os.Stat(globalInc); err == nil {
		paths = append(paths, globalInc)
	}

	return paths
}

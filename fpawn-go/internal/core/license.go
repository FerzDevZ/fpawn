package core

// LicenseInfo holds security status
type LicenseInfo struct {
	User     string
	Type     string
	Active   bool
	Serial   string
}

// CurrentLicense is a simplified proprietary placeholder
var CurrentLicense = LicenseInfo{
	User:   "FerzDevZ Owner",
	Type:   "PROPRIETARY",
	Active: true,
	Serial: "FDEVZ-POWER-XP",
}

// CheckLicense is now a simple placeholder for non-open source status
func CheckLicense() bool {
	return true
}

// SecurityGate is now always open for the user
func SecurityGate(feature string) bool {
	return true
}

.PHONY: build clean install

VERSION := 26.0
BINARY := fpawn
BUILD_DIR := build
GO := go

# Build for current platform
build:
	@echo "Building fpawn v$(VERSION)..."
	@mkdir -p $(BUILD_DIR)
	$(GO) build -ldflags="-s -w" -o $(BUILD_DIR)/$(BINARY) ./cmd/fpawn
	@echo "Build complete: $(BUILD_DIR)/$(BINARY)"

# Build for all platforms
build-all:
	@echo "Building for all platforms..."
	@mkdir -p $(BUILD_DIR)
	GOOS=linux GOARCH=amd64 $(GO) build -ldflags="-s -w" -o $(BUILD_DIR)/$(BINARY)-linux-amd64 ./cmd/fpawn
	GOOS=darwin GOARCH=amd64 $(GO) build -ldflags="-s -w" -o $(BUILD_DIR)/$(BINARY)-darwin-amd64 ./cmd/fpawn
	GOOS=windows GOARCH=amd64 $(GO) build -ldflags="-s -w" -o $(BUILD_DIR)/$(BINARY)-windows-amd64.exe ./cmd/fpawn
	@echo "Builds complete in $(BUILD_DIR)/"

# Install to user's local bin
install: build
	@echo "Installing fpawn..."
	@mkdir -p $(HOME)/.local/bin
	@cp $(BUILD_DIR)/$(BINARY) $(HOME)/.local/bin/
	@chmod +x $(HOME)/.local/bin/$(BINARY)
	@echo "Installed to $(HOME)/.local/bin/$(BINARY)"
	@echo "Make sure $(HOME)/.local/bin is in your PATH"

# Clean build artifacts
clean:
	@rm -rf $(BUILD_DIR)
	@echo "Cleaned build directory"

# Run tests
test:
	$(GO) test ./...

# Download dependencies
deps:
	$(GO) mod download
	$(GO) mod tidy

# Development run
run:
	$(GO) run ./cmd/fpawn

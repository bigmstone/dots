# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository for configuring development environments on macOS and Linux systems. The repository contains configuration files for shells, editors, terminals, and window managers, with an automated installation script.

## Key Commands

### Installation
```bash
# Full installation (installs packages and creates symlinks)
./install.sh

# The install script will:
# - Install Homebrew (if on macOS)
# - Install packages from brew.txt
# - Set up Rust, Python (via uv), and Go environments
# - Create symbolic links for all configuration files
# - Configure git, shells, and editors
```

### Common Development Tasks
```bash
# After making changes to shell configs
source ~/.zshrc

# After modifying Neovim config
# Launch nvim and run :Lazy sync to update plugins

# Update Homebrew packages
brew update && brew upgrade

# Check which dotfiles are symlinked
ls -la ~/ | grep dots
```

## Architecture & Structure

### Configuration Organization
- **Shell Configs**: `.zshrc`, `.aliases`, `.zpreztorc` - Zsh configuration with Prezto framework
- **Editor Configs**: `nvim/` (Neovim with Lua config), `.vimrc`, `.tmux.conf`
- **Terminal Configs**: `kitty/` (with extensive themes), `zellij/`
- **Window Manager**: `hypr/` (Hyprland), `eww/` (widgets)
- **Package Lists**: `brew.txt` (CLI tools), `brew-cask.txt` (GUI apps)

### Neovim Configuration
Located in `nvim/`, uses lazy.nvim for plugin management:
- `lua/lazyinit.lua` - Lazy.nvim bootstrap and plugin specifications
- `lua/setup.lua` - Core Neovim settings and configurations
- `lazy-lock.json` - Locked plugin versions

### Shell Environment
The `.zshrc` sets up:
- Prezto modules for enhanced Zsh functionality
- PATH configurations for various tools (Go, Rust, Python, etc.)
- Integration with tools like fzf, zoxide, starship
- Custom aliases defined in `.aliases`

### Installation Flow
The `install.sh` script:
1. Detects OS (macOS/Linux)
2. Installs package managers and base packages
3. Sets up language environments (Rust, Python, Go)
4. Creates symlinks from this repo to home directory
5. Configures git and shell environments
6. Handles platform-specific setup (e.g., Hyprland on Linux)

## Important Notes

- Private environment variables are stored in `.prienv` (created during install, not tracked)
- The repository uses symlinks extensively - modifications in `~/` will affect files in this repo
- Git status shows several modified files - these are actively maintained configs
- When adding new dotfiles, update `install.sh` to include them in the symlink process
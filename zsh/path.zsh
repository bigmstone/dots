# PATH configuration
# All PATH modifications in one place

# Core system paths
export PATH=/usr/local/bin:/usr/local/sbin:~/bin:$PATH

# Homebrew
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/opt/java/bin:$PATH"

# Language-specific paths
export PATH=$PATH:/usr/local/go/bin
export GOPATH=$HOME/dev/go
export PATH="$PATH:$HOME/dev/go/bin"
export PATH=~/Library/Python/3.6/bin:$PATH

# Node.js & package managers
export N_PREFIX="$HOME/n"; [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PNPM_HOME="/Users/mstone/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# Development tools
export PATH="$PATH:$HOME/dev/arcanist/bin"
export PATH="$HOME/Library/Haskell/bin:$PATH"

# User binaries
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/dev/bin:$PATH"
export PATH="$HOME/.bin:$PATH"

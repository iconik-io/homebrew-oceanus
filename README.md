# homebrew-oceanus
Custom Homebrew formulas and casks for Oceanus CLI tools and utilities.

This repository hosts custom Homebrew formulas and casks for Oceanus-related command-line tools, making it easy to install and update them via the Homebrew package manager on macOS and Linux.

## Installation

```bash
brew tap iconik-io/oceanus git@github.com:iconik-io/homebrew-oceanus.git

brew install --cask ovmb
brew install --cask ovmb@0.2.4
brew install --cask iconik-io/oceanus/ovmb --force

brew uninstall --cask ovmb
```

## Known Issues

- [ ] `uninstall` does not remove the symlink, so following `install` command fails. Until a permanent fix you can use the `--force`
 
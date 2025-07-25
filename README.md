# homebrew-oceanus
Custom Homebrew formulas and casks for Oceanus CLI tools and utilities.

This repository hosts custom Homebrew formulas and casks for Oceanus-related command-line tools, making it easy to install and update them via the Homebrew package manager on macOS and Linux.

## Installation

```bash
brew tap iconik-io/oceanus
brew tap iconik-io/oceanus git@github.com:iconik-io/homebrew-oceanus.git # or if you prefer the ssh protocol

brew install --cask ovmb
brew install --cask ovmb@1.2.3
brew install --cask iconik-io/oceanus/ovmb --force

brew update && brew upgrade ovmb

brew uninstall --cask ovmb
```
 
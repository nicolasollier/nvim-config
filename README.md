# My Neovim Configuration

This Neovim configuration contains my personal settings and preferred plugins.

## Installation

To use this configuration on a new machine:

```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/nvim-config.git ~/.config/nvim

# Or if you already have an nvim folder, backup it first
mv ~/.config/nvim ~/.config/nvim.backup
git clone https://github.com/YOUR_USERNAME/nvim-config.git ~/.config/nvim
```

## Synchronization

To sync changes:

```bash
# Add modifications
cd ~/.config/nvim
git add .
git commit -m "Update config"
git push origin main

# To pull changes on another machine
git pull origin main
```

## Structure

- `init.vim` : Main Neovim configuration
- `.gitignore` : Files to ignore by Git

## Notes

Don't forget to install your plugins after cloning this configuration!

# nvim-bootstrap

## Installation
### 1.  Install requirements
	```bash
	sudo dnf install -y bash git fzf fd-find ripgrep luarocks wget fontconfig
	```

### 2.  Install Neovim
	```bash
	sudo dnf install -y neovim python3-neovim
	```

### 3. Install a nerd Font (optional)
1. Create a Fonts Directory (if it doesn't exist) and move into it
	```bash
	mkdir -p ~/.local/share/fonts && cd ~/.local/share/fonts
	```
2. Visit the [Nerd font](https://www.nerdfonts.com/font-downloads) website, to choose a preferred font and copy the download link.
3. Download the font. (e.g. "JetBrainsMono")
	```bash
	curl -o JetBrainsMono.zip -L https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip
	```
4. Unzip the downloaded (e.g. `Hack.zip`) and move or copy the directory to `~/.local/share/fonts` directory.
	```bash
	unzip JetBrainsMono.zip
	```
5. Delete the original zip file
	```bash
	rm JetBrainsMono.zip
	```
6. Refresh Font Cache
    ```bash
    fc-cache -fv
    ```
7. Verify Installation
    ```bash
    fc-list : family style | grep -i JetBrainsMono
    ```

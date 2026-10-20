# CLI tools

Extra command-line tools these configs depend on. Install these on a fresh
machine, then the matching config directory will take effect.

## git-delta

Nicer git diff/pager with syntax highlighting and side-by-side view.
Config lives in `git/.gitconfig` (the `[core] pager`, `[interactive]` and
`[delta]` sections).

- Binary: `delta` (installed to `~/.cargo/bin` via `cargo install git-delta`)
- Homepage: https://github.com/dandavison/delta
- Verify: `delta --version`

## lnav

Log file navigator / viewer. Config lives in `lnav/.lnav/`:
- `config.json` – tuning, external-editor rules, the `leo` UI theme, log demux patterns
- `configs/leo/leo-theme.json` – custom Leo colorscheme
- `formats/installed/umac_log.json` – custom UMAC log format

- Binary: `lnav` (installed to `~/.local/bin`, static binary from GitHub releases)
- Homepage: https://github.com/tstack/lnav
- Verify: `lnav --version`

## lazygit

Terminal UI for git. Config lives in `lazygit/.config/lazygit/config.yml`
(currently empty — running stock defaults; the tracked file is a placeholder
for future customization).

- Binary: `lazygit` (installed to `~/.local/bin`, static binary from GitHub releases)
- Homepage: https://github.com/jesseduffield/lazygit
- Verify: `lazygit --version`

## foot

Wayland terminal emulator. Config lives in `foot/.config/foot/foot.ini`.

- Binary: `foot` (installed via system package manager)
- Homepage: https://codeberg.org/dnkl/foot
- Verify: `foot --version`

# Tools with no dotfiles

Command-line tools used regularly that carry no config of their own (or whose
setup lives in the shell rc files). Nothing to track here — just install them
on a fresh machine.

| Tool | Binary | Install location | Homepage |
|------|--------|------------------|----------|
| ripgrep | `rg` | `~/.local/bin` (static binary from GitHub releases) | https://github.com/BurntSushi/ripgrep |
| fd | `fd` | `~/.cargo/bin` (`cargo install fd-find`) | https://github.com/sharkdp/fd |
| zoxide | `zoxide` | `~/.cargo/bin` (`cargo install zoxide`) | https://github.com/ajeetdsouza/zoxide |
| fzf | `fzf` | `~/.fzf` (git clone + `install` script; sources `~/.fzf.bash`) | https://github.com/junegunn/fzf |
| tldr | `tldr` | `~/.cargo/bin` (`cargo install tealdeer`) | https://github.com/tealdeer-rs/tealdeer |

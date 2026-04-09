if status is-interactive
    # Commands to run in interactive sessions can go here
end

# starship prompt
if command -v starship >/dev/null 2>&1
    starship init fish | source
end

alias rebuild="sudo nixos-rebuild switch"
alias vimnix="hx ~/.dotfiles/nixos/configuration.nix"
alias nshell="nix-shell -p"
alias stowdot="stow -d ~/.dotfiles/ fish vim niri starship waybar helix jj fcitx5 cargo opencode ghostty television tmux --adopt && source ~/.config/fish/config.fish"
alias stnix="sudo stow -d ~/.dotfiles/ nixos -t /etc/nixos"
alias yz="yazi"
alias hx="helix"

# tv shell history
if command -v tv >/dev/null 2>&1
    tv init fish | source
end

if command -v sesh >/dev/null 2>&1; and not test -f ~/.config/fish/completions/sesh.fish
    sesh completion fish >~/.config/fish/completions/sesh.fish
end

# atuin shell history
if command -v atuin >/dev/null 2>&1
    atuin init fish | source
end

# zoxide cd replacement
if command -v zoxide >/dev/null 2>&1
    zoxide init fish | source
end

export EDITOR=helix

# fnm Node.js version manager
if command -v fnm >/dev/null 2>&1
    fnm env --shell=fish | source
end

# fish_vi_key_bindings

alias ll="eza -l"

alias lla="eza -la"
alias lt="eza -T"

if test -d /home/levy/tools/claw-code-main/rust/target/release
    set -gx PATH /home/levy/tools/claw-code-main/rust/target/release $PATH
end

export PATH="$HOME/.local/bin:$PATH"

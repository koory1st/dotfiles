if status is-interactive
    # Commands to run in interactive sessions can go here
end

starship init fish | source

alias rebuild="sudo nixos-rebuild switch"
alias vimnix="hx ~/.dotfiles/nixos/configuration.nix"
alias nshell="nix-shell -p"
alias stowdot="stow -d ~/.dotfiles/ fish vim niri starship waybar helix jj fcitx5 rime cargo opencode --adopt && source ~/.config/fish/config.fish"
alias stnix="sudo stow -d ~/.dotfiles/ nixos -t /etc/nixos"
alias yz="yazi"

atuin init fish | source

if command -v fastfetch >/dev/null
    fastfetch
end

zoxide init fish | source

export EDITOR=vim

# fish_vi_key_bindings

alias ll="eza -l"

alias lla="eza -la"
alias lt="eza -T"

if test -d /home/levy/tools/claw-code-main/rust/target/release
    set -gx PATH /home/levy/tools/claw-code-main/rust/target/release $PATH
end

fnm env --use-on-cd --shell fish | source


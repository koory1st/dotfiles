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

if command -v neofetch >/dev/null
    neofetch
end

zoxide init fish | source

export EDITOR=vim

# fish_vi_key_bindings

abbr -a ll eza -l

abbr -a lla eza -la
abbr -a lt eza -T

fnm env --use-on-cd --shell fish | source

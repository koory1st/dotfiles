if status is-interactive
    # Commands to run in interactive sessions can go here
end

starship init fish | source

alias rebuild="sudo nixos-rebuild switch"
alias vimnix="sudo vim /etc/nixos/configuration.nix"
alias nshell="nix-shell -p"
alias stowdot="stow -d ~/.dotfiles/ fish vim niri starship waybar helix && source ~/.config/fish/config.fish"

atuin init fish | source

if command -v neofetch >/dev/null
    neofetch
end

zoxide init fish | source

export EDITOR=hx

# fish_vi_key_bindings

abbr -a ll eza -l

abbr -a lla eza -la
abbr -a lt eza -T

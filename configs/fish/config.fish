source /usr/share/cachyos-fish-config/cachyos-config.fish

zoxide init fish | source

function fish_greeting
    ~/.config/fish/torii-greeting.sh
end

# Oh My Posh
oh-my-posh init fish --config ~/.config/ohmyposh/theme.json | source

abbr -a ll 'ls -lah'
abbr -a gs 'git status'
abbr -a gc 'git commit'
abbr -a fs 'fastfetch'
abbr -a sp 'sudo pacman'
abbr -a matrix 'neo-matrix -D --color=cyan -d 3'
abbr -a oc 'opencode'


bind ctrl-backspace backward-kill-word
bind ctrl-left backward-word
bind ctrl-right forward-word

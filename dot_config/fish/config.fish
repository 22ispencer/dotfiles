# if type -q tmux
# and status is-interactive
# and not set -q TMUX
# 	if not test -d ~/.tmux/plugins/tpm
# 		git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# 	end
# 	exec tmux
# end

if status is-interactive;
    # Commands to run in interactive sessions can go here
    if type -q fastfetch;
        fastfetch
    end

    fish_hybrid_key_bindings
    fish_vi_cursor

    set fish_greeting
    starship init fish | source
	zoxide init --cmd cd fish | source
end

# Fundle (package manager)
if not functions -q fundle;
    eval (curl -sfL https://git.io/fundle-install);
end
fundle plugin nickeb96/puffer-fish
fundle plugin jorgebucaran/autopair.fish
fundle plugin gazorby/fish-abbreviation-tips
fundle plugin PatrickF1/fzf.fish
fundle init

if test (uname) = Darwin;
	fish_add_path /opt/homebrew/bin
end

fish_add_path $HOME/go/bin
fish_add_path $HOME/.cargo/bin

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f /Users/isaacspencer/miniforge3/bin/conda
    eval /Users/isaacspencer/miniforge3/bin/conda "shell.fish" "hook" $argv | source
else
    if test -f "/Users/isaacspencer/miniforge3/etc/fish/conf.d/conda.fish"
        . "/Users/isaacspencer/miniforge3/etc/fish/conf.d/conda.fish"
    else
        set -x PATH "/Users/isaacspencer/miniforge3/bin" $PATH
    end
end
# <<< conda initialize <<<


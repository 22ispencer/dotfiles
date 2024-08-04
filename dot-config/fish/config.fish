if status is-interactive;
    # Commands to run in interactive sessions can go here
    if type -q neofetch;
        neofetch
    end

    fish_vi_key_bindings
    fish_vi_cursor

    set fish_greeting
    starship init fish | source
end

# Fundle (package manager)
if not functions -q fundle;
    eval (curl -sfL https://git.io/fundle-install);
end
fundle plugin nickeb96/puffer-fish
fundle plugin jorgebucaran/autopair.fish
fundle plugin jethrokuan/z
fundle plugin gazorby/fish-abbreviation-tips
fundle plugin PatrickF1/fzf.fish
fundle init

if test (uname) = Darwin;
	fish_add_path /opt/homebrew/bin
end

fish_add_path $HOME/go/bin
fish_add_path $HOME/.cargo/bin


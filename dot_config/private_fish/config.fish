set fish_greeting
set -gx EDITOR nvim
if status is-interactive
	zoxide init fish --cmd cd | source
	fastfetch
	starship init fish | source
	fish_vi_key_bindings
end

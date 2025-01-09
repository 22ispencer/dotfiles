set fish_greeting
if status is-interactive
	zoxide init fish --cmd cd | source
	fastfetch
	starship init fish | source
end

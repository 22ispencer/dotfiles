set fish_greeting
set -gx EDITOR nvim
if status is-interactive
	zoxide init fish --cmd cd | source
	fastfetch
	starship init fish | source
	fish_vi_key_bindings
end

# pnpm
set -gx PNPM_HOME "/home/isaacspencer/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

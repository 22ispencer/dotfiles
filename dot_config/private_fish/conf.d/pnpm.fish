switch "$fish_sysname"
	case "Darwin"
		set -gx PNPM_HOME "$HOME/Library/pnpm"
	case "Linux"
		set -gx PNPM_HOME "$HOME/.local/share/pnpm"
end
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end

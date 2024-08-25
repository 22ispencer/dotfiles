function tmuxinator_find
	set -f missing_utils 0
	if not type -q fzf;
		echo "missing fzf"
		set -f missing_utils 1;
	end
	if not type -q tmuxinator;
		echo "missing tmuxinator";
		set -f missing_utils 1;
	end
	if not type -q sd;
		echo "missing sd";
		set -f missing_utils 1;
	end;
	if not type -q tmux;
		echo "missing tmux";
		set -f missing_utils 1;
	end;
	if test $missing_utils -eq 1;
		exit;
	end;
	if set -l session (tmuxinator list | sed "1d" | sd "\s+" "\n" | fzf --tmux);
		tmuxinator start $session
	end
end

function gui
	nohup $argv &>/dev/null &
	disown
end

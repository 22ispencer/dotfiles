if not test (count $XDG_RUNTIME_DIR/wayland-*) -gt 0;
	ln -sf /mnt/wslg/runtime-dir/wayland-* $XDG_RUNTIME_DIR/
end

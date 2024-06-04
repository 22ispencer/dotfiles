-- 'Minicyan' color scheme
-- Derived from base16 (https://github.com/chriskempson/base16) and
-- mini_palette palette generator
local use_cterm, palette

-- Dark palette is an output of 'MiniBase16.mini_palette':
-- - Background '#0A2A2A' (LCh(uv) = 15-10-192)
-- - Foreground '#D0D0D0' (Lch(uv) = 83-0-0)
-- - Accent chroma 50
if vim.o.background == "dark" then
	palette = {
		base00 = "#2d2d2d",
		base01 = "#393939",
		base02 = "#515151",
		base03 = "#777777",
		base04 = "#b4b7b4",
		base05 = "#cccccc",
		base06 = "#e0e0e0",
		base07 = "#ffffff",
		base08 = "#d25252",
		base09 = "#f9a959",
		base0A = "#ffc66d",
		base0B = "#a5c261",
		base0C = "#bed6ff",
		base0D = "#6c99bb",
		base0E = "#d197d9",
		base0F = "#f97394",
	}
	use_cterm = true
end

-- Light palette is an 'inverted dark', output of 'MiniBase16.mini_palette':
-- - Background '#C0D2D2' (LCh(uv) = 83-10-192)
-- - Foreground '#262626' (Lch(uv) = 15-0-0)
-- - Accent chroma 80

if palette then
	require("mini.base16").setup({ palette = palette, use_cterm = use_cterm })
	vim.g.colors_name = "catppuccin"
end

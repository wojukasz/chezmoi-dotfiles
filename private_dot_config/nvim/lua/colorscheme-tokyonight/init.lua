function TOKYONIGHT_CONFIG()
    vim.g.tokyonight_style = "night"
    vim.g.tokyonight_italic_functions = true
    vim.g.tokyonight_sidebars = { "qf", "vista_kind", "terminal", "packer" }

    vim.cmd([[
    try
        colorscheme tokyonight
    catch
        colorscheme desert
    endtry
    ]])
end

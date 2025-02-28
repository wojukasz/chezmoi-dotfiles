function LSP_TROUBLE_CONFIG()
    local hastrouble, trouble = pcall(require, "trouble")

    if not hastrouble then
        return
    end

    trouble.setup {
        height = 15, -- height of the trouble list
        icons = true, -- use dev-icons for filenames
        mode = "workspace", -- "workspace" or "document"
        fold_open = "", -- icon used for open folds
        fold_closed = "", -- icon used for closed folds
        action_keys = { -- key mappings for actions in the trouble list
            close = "q", -- close the list
            cancel = "<esc>", -- cancel the preview and get back to your last window / buffer / cursor
            refresh = "r", -- manually refresh
            jump = {"<cr>", "<tab>"}, -- jump to the diagnostic or open / close folds
            jump_close = {"o"}, -- jump to the diagnostic and close the list
            hover = "K", -- opens a small poup with the full multiline message
            toggle_mode = "m", -- toggle between "workspace" and "document" mode
            toggle_preview = "P", -- toggle auto_preview
            preview = "p", -- preview the diagnostic location
            close_folds = {"zM", "zm"}, -- close all folds
            open_folds = {"zR", "zr"}, -- open all folds
            toggle_fold = {"zA", "za"}, -- toggle fold of current file
            previous = "k", -- preview item
            next = "j" -- next item
        },
        indent_lines = true, -- add an indent guide below the fold icons
        auto_open = false, -- automatically open the list when you have diagnostics
        auto_close = false, -- automatically close the list when you have no diagnostics
        auto_preview = true, -- automatically preview the location of the diagnostic. <esc> to close preview and go back
        auto_fold = false, -- automatically fold a file trouble list at creation
        signs = {
            -- icons / text used for a diagnostic
            error = "",
            warning = "",
            hint = "",
            information = ""
        },
        use_lsp_diagnostic_signs = false -- enabling this will use the signs defined in your lsp client
    }
end

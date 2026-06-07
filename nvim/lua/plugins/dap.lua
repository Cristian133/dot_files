return {
    {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = { "williamboman/mason.nvim" },
        config = function()
            require("mason-nvim-dap").setup({
                ensure_installed = { "coreclr" },
                handlers = {},
            })
        end,
    },
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "nvim-neotest/nvim-nio",
        },
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")

            dapui.setup()

            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end

            local map = vim.keymap.set
            map("n", "<F5>", dap.continue, { desc = "DAP Continue" })
            map("n", "<F6>", dap.step_over, { desc = "DAP Step Over" })
            map("n", "<F7>", dap.step_into, { desc = "DAP Step Into" })
            map("n", "<F8>", dap.step_out, { desc = "DAP Step Out" })
            map("n", "<leader>db", dap.toggle_breakpoint, { desc = "DAP Toggle Breakpoint" })
            map("n", "<leader>dB", function()
                dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
            end, { desc = "DAP Conditional Breakpoint" })
            map("n", "<leader>du", dapui.toggle, { desc = "DAP UI Toggle" })
        end,
    },
}

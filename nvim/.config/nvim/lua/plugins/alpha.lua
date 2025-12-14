return {
  "goolord/alpha-nvim",
  opts = function(_, dashboard)
    local logo = [[

██████╗ ██╗  ██╗███╗   ███╗███████╗          Z
██╔══██╗██║  ██║████╗ ████║██╔════╝      Z    
██║  ██║███████║██╔████╔██║███████╗    z      
██║  ██║██╔══██║██║╚██╔╝██║╚════██║ z         
██████╔╝██║  ██║██║ ╚═╝ ██║███████║
╚═════╝ ╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝
                                   
    ]]
    dashboard.section.header.val = vim.split(logo, "\n")
  end,
}

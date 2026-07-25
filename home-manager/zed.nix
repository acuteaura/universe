{pkgs, ...}: {
  programs.zed-editor = {
    enable = true;

    extensions = [
      "helm"
      "html"
      "jetbrains-icons"
      "just"
      "log"
      "make"
      "mcp-server-github"
      "nix"
      "nu"
      "postgres-context-server"
      "rose-pine-theme"
      "terraform"
      "toml"
      "typst"
      "vue"
    ];

    userSettings = {
      search = {
        button = false;
      };

      cli_default_open_behavior = "new_window";

      project_panel = {
        dock = "left";
      };

      outline_panel = {
        dock = "left";
      };

      collaboration_panel = {
        button = false;
        dock = "left";
      };

      git_panel = {
        dock = "left";
      };

      # we don't want predictions, and if we want them we want them subtle
      edit_predictions = {
        "provider" = "copilot";
        "mode" = "subtle";
      };

      # we can just use tailscale hostnames here
      ssh_connections = [
        {
          host = "sunhome";
          username = "aurelia";
          args = [];
          projects = [];
        }
        {
          host = "fool";
          username = "aurelia";
          args = [];
          projects = [];
        }
      ];

      agent_servers = {
        claude-acp = {
          type = "registry";
          default_config_options = {
            fast = "on";
            mode = "default";
            model = "default";
          };
        };
      };

      agent = {
        dock = "right";
        default_model = {
          model = "claude-opus-4.5";
          provider = "copilot_chat";
        };
        inline_assistant_model = {
          model = "claude-opus-4.5";
          provider = "copilot_chat";
        };
      };

      # shush
      telemetry = {
        diagnostics = false;
        metrics = false;
      };

      ui_font_size = 16;
      buffer_font_size = 15;

      terminal = {
        shell = {
          program = "fish";
        };
        font_family = "TX02 Nerd Font";
        font_size = 13;
      };

      # TODO: ensure this is somehow packaged in chezmoi or home-manager
      buffer_font_family = "TX-02";

      theme = {
        mode = "system";
        light = "Rosé Pine Dawn";
        dark = "Rosé Pine Moon";
      };

      icon_theme = "JetBrains Icons Dark";

      languages = {
        Nix = {
          language_servers = ["nil" "!nixd"];
        };
      };

      lsp = {
        # typst language server
        tinymist = {
          settings = {
            exportPdf = "onSave";
            outputPath = "$root/$name";
          };
        };
        nil = {
          settings = {
            diagnostics = {
              ignored = ["unused_binding"];
            };
            nix = {
              flake = {
                autoArchive = true;
              };
            };
          };
          initialization_options = {
            formatting = {
              command = ["alejandra" "--quiet" "--"];
            };
          };
        };
      };

      language_models = {};

      # revise if needed
      # had to set to get prettier and zed to stop fighting in a nuxt project
      jsx_tag_auto_close = {
        enabled = false;
      };

      tab_size = 2;
    };
  };
}

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
      # we don't want predictions, and if we want them we want them subtle
      features = {
        edit_prediction_provider = "copilot";
      };
      edit_predictions = {
        mode = "eager";
      };

      # configure LLMs
      # we want some degree of control here, but claude still beats them benchmarks
      agent = {
        inline_assistant_model = {
          provider = "copilot_chat";
          model = "claude-opus-4.5";
        };
        default_model = {
          provider = "copilot_chat";
          model = "claude-opus-4.5";
        };
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

      # shush
      telemetry = {
        diagnostics = false;
        metrics = false;
      };

      ui_font_size = 16;
      buffer_font_size = 15;

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

      # revise if needed
      # had to set to get prettier and zed to stop fighting in a nuxt project
      jsx_tag_auto_close = {
        enabled = false;
      };
    };
  };
}

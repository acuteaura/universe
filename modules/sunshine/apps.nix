{
  pkgs,
  setVirtScript,
  setPhyScript,
  steam-run-url,
  ...
}: let
  prepResDoUndo = [
    {
      do = "${setVirtScript}";
      undo = "${setPhyScript}";
    }
  ];
  prepResDoUndo1_5X = [
    {
      do = "${setVirtScript} --scale=1.5";
      undo = "${setPhyScript}";
    }
  ];
  prepResDoUndo2X = [
    {
      do = "${setVirtScript} --scale=2";
      undo = "${setPhyScript}";
    }
  ];
  steamImgDesktop = pkgs.fetchurl {
    url = "https://cdn2.steamgriddb.com/grid/05f88bb01f043276656e0fba39ebc445.png";
    hash = "sha256-5Q2NvE7VWVVSuBjVFhkwltAMHOGk54tYI3I0T258QrU=";
  };
  steamImgP3R = pkgs.fetchurl {
    url = "https://cdn2.steamgriddb.com/grid/a0937945c8169d3a9b8b35134274fd99.png";
    hash = "sha256-rmw7Y8s0YD5GsSQg6rI8p8dgOS/l/ilzsS5NTKudhGY=";
  };
  steamImgP4G = pkgs.fetchurl {
    url = "https://cdn2.steamgriddb.com/grid/c9f86254c83a54880faa476e653986aa.png";
    hash = "sha256-Wtv8IP9vB5Nv4dfZZ2vE63Agnp7ipNnDjcMk50CMf/k=";
  };
  steamImgP5R = pkgs.fetchurl {
    url = "https://cdn2.steamgriddb.com/grid/87883345025cdac97c0f89dceb6a5f53.png";
    hash = "sha256-YG0e3AyPU47hLPRRrS0YktfyOpQnkg2YSGQW4jHS/VQ=";
  };
in [
  {
    name = "Desktop";
    prep-cmd = prepResDoUndo;
    auto-detach = "true";
    image-path = "${steamImgDesktop}";
  }
  {
    name = "Desktop 1.5x";
    prep-cmd = prepResDoUndo1_5X;
    auto-detach = "true";
  }
  {
    name = "Desktop 2x";
    prep-cmd = prepResDoUndo2X;
    auto-detach = "true";
  }
  {
    name = "Steam";
    prep-cmd = prepResDoUndo;
    auto-detach = "true";
    cmd = "${steam-run-url}/bin/steam-run-url steam://open/gamepadui";
    image-path = "steam.png";
  }
  {
    name = "Persona 3 Reload";
    prep-cmd = prepResDoUndo;
    auto-detach = "true";
    cmd = "${steam-run-url}/bin/steam-run-url steam://rungameid/2161700";
    image-path = "${steamImgP3R}";
  }
  {
    name = "Persona 4 Golden";
    prep-cmd = prepResDoUndo;
    auto-detach = "true";
    cmd = "${steam-run-url}/bin/steam-run-url steam://rungameid/1113000";
    image-path = "${steamImgP4G}";
  }
  {
    name = "Persona 5 Royal";
    prep-cmd = prepResDoUndo;
    auto-detach = "true";
    cmd = "${steam-run-url}/bin/steam-run-url steam://rungameid/1687950";
    image-path = "${steamImgP5R}";
  }
]

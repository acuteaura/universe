{pkgs, ...}: {
  systemd.tmpfiles.rules = [
    "d /home/aurelia/.local/share/comfyui 0755 aurelia users -"
    "d /home/aurelia/.local/share/comfyui/storage 0755 aurelia users -"
    "d /home/aurelia/.local/share/comfyui/models 0755 aurelia users -"
    "d /home/aurelia/.local/share/comfyui/hf-hub 0755 aurelia users -"
    "d /home/aurelia/.local/share/comfyui/torch-hub 0755 aurelia users -"
    "d /home/aurelia/.local/share/comfyui/input 0755 aurelia users -"
    "d /home/aurelia/.local/share/comfyui/output 0755 aurelia users -"
    "d /home/aurelia/.local/share/comfyui/workflows 0755 aurelia users -"
  ];

  virtualisation.oci-containers = {
    backend = "podman";
    containers.comfyui = {
      autoStart = false;
      image = "yanwk/comfyui-boot:rocm";
      volumes = [
        "/home/aurelia/.local/share/comfyui/storage:/root"
        "/home/aurelia/.local/share/comfyui/models:/root/ComfyUI/models"
        "/home/aurelia/.local/share/comfyui/hf-hub:/root/.cache/huggingface/hub"
        "/home/aurelia/.local/share/comfyui/torch-hub:/root/.cache/torch/hub"
        "/home/aurelia/.local/share/comfyui/input:/root/ComfyUI/input"
        "/home/aurelia/.local/share/comfyui/output:/root/ComfyUI/output"
        "/home/aurelia/.local/share/comfyui/workflows:/root/ComfyUI/user/default/workflows"
      ];
      ports = ["8188:8188"];
      extraOptions = [
        "--device=/dev/kfd"
        "--device=/dev/dri"
        "--group-add=video"
        "--ipc=host"
        "--cap-add=SYS_PTRACE"
        "--security-opt=seccomp=unconfined"
      ];
    };
  };
}

{ pkgs, config, lib, ... }:

{
  # 啟用 Podman（distrobox 的後端）
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;       # 讓 docker 指令也能用
    defaultNetwork.settings.dns_enabled = true;
  };

  # 安裝 distrobox 和 podman 相關工具
  environment.systemPackages = with pkgs; [
    distrobox
    podman
    podman-compose
    podman-tui       # TUI 管理介面
    dive             # 分析 container image
  ];

  # 讓一般使用者可以用 rootless podman
  security.unprivilegedUsernsClone = true;

  # subuid / subgid（rootless container 必須）
  users.users.eric = {
    subUidRanges = [{ startUid = 100000; count = 65536; }];
    subGidRanges = [{ startGid = 100000; count = 65536; }];
  };
}

{pkgs, ...}: {
  # btrfs 自動維護
  services.btrfs.autoScrub = {
    enable = true;
    interval = "weekly";
    fileSystems = ["/"];
  };

  # snapper 自動快照
  services.snapper = {
    snapshotInterval = "hourly";
    cleanupInterval = "1d";
    configs = {
      root = {
        SUBVOLUME = "/";
        ALLOW_USERS = ["eric"];
        TIMELINE_CREATE = true;
        TIMELINE_CLEANUP = true;
        TIMELINE_LIMIT_HOURLY = "6";
        TIMELINE_LIMIT_DAILY = "7";
        TIMELINE_LIMIT_WEEKLY = "4";
        TIMELINE_LIMIT_MONTHLY = "3";
        TIMELINE_LIMIT_YEARLY = "1";
      };
      home = {
        SUBVOLUME = "/home";
        ALLOW_USERS = ["eric"];
        TIMELINE_CREATE = true;
        TIMELINE_CLEANUP = true;
        TIMELINE_LIMIT_HOURLY = "6";
        TIMELINE_LIMIT_DAILY = "7";
        TIMELINE_LIMIT_WEEKLY = "4";
        TIMELINE_LIMIT_MONTHLY = "3";
        TIMELINE_LIMIT_YEARLY = "1";
      };
    };
  };

  environment.systemPackages = with pkgs; [
    btrfs-progs        # btrfs 基本工具
    compsize           # 查看壓縮率
    btdu               # btrfs 磁碟使用分析（互動式）
    snapper            # 快照管理
    snapper-gui        # snapper 圖形介面
  ];
}

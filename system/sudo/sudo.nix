{...}: {
  security.sudo = {
    enable = true;
    extraRules = [
      {
        users = ["eric"];
        commands = [
          {
            command = "/run/current-system/sw/bin/nh";
            options = ["NOPASSWD"];
          }
          {
            command = "/run/current-system/sw/bin/nixos-rebuild";
            options = ["NOPASSWD"];
          }
        ];
      }
    ];
  };
}

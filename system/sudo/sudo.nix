{...}: {
  security.sudo.extraRules = [
    {
      users = ["eric"];
      commands = [
        {
          command = "ALL";
          options = ["NOPASSWD"];
        }
      ];
    }
  ];
}

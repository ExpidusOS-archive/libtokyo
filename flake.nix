{
  description = "A libadwaita wrapper for ExpidusOS with Tokyo Night's styling";

  inputs.expidus-sdk = {
    url = github:ExpidusOS/sdk;
  };

  inputs.adw-gtk3 = {
    url = github:lassekongo83/adw-gtk3;
    flake = false;
  };

  outputs = { self, expidus-sdk, adw-gtk3 }:
    with expidus-sdk.lib;
    expidus.flake.makeOverride {
      self = expidus.flake.makeSubmodules self {
        "gtk3/deps/adw-gtk3" = adw-gtk3;
      };
      name = "libtokyo";
    };
}

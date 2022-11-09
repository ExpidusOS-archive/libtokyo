{
  description = "A libadwaita wrapper for ExpidusOS with Tokyo Night's styling";

  inputs.expidus-sdk = {
    url = github:ExpidusOS/sdk;
  };

  outputs = { self, expidus-sdk }: expidus-sdk.libExpidus.mkFlake { inherit self; name = "libtokyo"; };
}

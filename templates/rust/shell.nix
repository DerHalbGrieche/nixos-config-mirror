{
  callPackage,
  rust-analyzer,
  rustfmt,
  clippy,
  lldb,
}: let
  mainPkg = callPackage ./default.nix {};
in
  mainPkg.overrideAttrs (oa: {
    nativeBuildInputs =
      [
      ]
      ++ (oa.nativeBuildInputs or []);
  })

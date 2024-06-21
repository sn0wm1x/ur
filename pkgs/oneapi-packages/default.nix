{ lib, newScope, ... }:
let
  files = builtins.readDir ./.;
  packages = builtins.removeAttrs files [ "default.nix" ];
in
lib.makeScope newScope (self: { } // builtins.mapAttrs (name: _: import "${./.}/${name}") packages)

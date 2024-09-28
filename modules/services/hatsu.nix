{ lib, pkgs, config, ... }:
let
  cfg = config.services.hatsu;
  env = {
    HATSU_DATABASE_URL = cfg.database.url;
    HATSU_LISTEN_HOST = cfg.host;
    HATSU_LISTEN_PORT = toString cfg.port;
    HATSU_DOMAIN = cfg.domain;
    HATSU_PRIMARY_ACCOUNT = cfg.primaryAccount;
  } // (
    lib.mapAttrs (_: toString) cfg.settings
  );
in
{
  meta.doc = ./hatsu.md;
  meta.maintainers = with lib.maintainers; [ kwaa ];

  options.services.hatsu = {
    enable = lib.mkEnableOption "Self-hosted and fully-automated ActivityPub bridge for static sites";

    package = lib.mkPackageOption pkgs "hatsu" { };

    dataDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/hatsu";
      description = "Hatsu data directory. (for sqlite database only)";
    };

    database = {
      url = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = "sqlite://${cfg.dataDir}/hatsu.sqlite?mode=rwc";
        example = "postgres://username:password@host/database";
        description = "Database URL.";
      };
    };

    host = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      description = "Host where hatsu should listen for incoming requests.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 3939;
      description = "Port where hatsu should listen for incoming requests.";
    };

    domain = lib.mkOption {
      type = lib.types.str;
      description = "The domain name of your instance (eg 'hatsu.local').";
    };

    primaryAccount = lib.mkOption {
      type = lib.types.str;
      description = "The primary account of your instance (eg 'example.com').";
    };

    settings = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      description = ''
        See [Environments](https://hatsu.cli.rs/admins/environments.html) for available settings.
      '';
      example = {
        HATSU_NODE_NAME = "nixos/modules";
        HATSU_NODE_DESCRIPTION = "services/web-apps/hatsu.nix";
      };
    };
  };

  config = lib.mkIf cfg.enable
    {
      systemd.services.hatsu = {
        environment = env;

        description = "Hatsu server";
        documentation = [ "https://hatsu.cli.rs/" ];

        wantedBy = [ "multi-user.target" ];
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];

        serviceConfig = {
          DynamicUser = true;
          WorkingDirectory = cfg.dataDir;
          ExecStart = "${lib.getExe cfg.package}";
        };
      };
    };
}

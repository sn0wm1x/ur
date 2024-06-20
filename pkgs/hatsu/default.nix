{ cmake
, fetchFromGitHub
, lib
, openssl
, pkg-config
, rustPlatform
}:
rustPlatform.buildRustPackage rec {
  pname = "hatsu";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "importantimport";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-gBzhuV0SDmNwl5PkpdGxkMBn5m4vEXfv23WK7+ZzQs8=";
  };

  cargoHash = "sha256-A2tl0jjKODA/qodxkIe/3V4ZDGV4X0myiduJsLtd7r0=";

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ openssl ];

  env = { OPENSSL_NO_VENDOR = true; };

  meta = with lib; {
    description = "Self-hosted and fully-automated ActivityPub bridge for static sites";
    homepage = "https://github.com/importantimport/hatsu";
    license = licenses.agpl3Only;
    mainProgram = "hatsu";
    maintainers = with maintainers; [ kwaa ];
    platforms = platforms.linux;
  };
}

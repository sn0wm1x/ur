{ cmake
, fetchFromGitHub
, lib
, openssl
, pkg-config
, rustPlatform
}:
rustPlatform.buildRustPackage rec {
  pname = "hatsu";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "importantimport";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-4x41Ez2Rq4Bs39LN4qRluDieHx+9bS+GCjvS/cQK84Y=";
  };

  cargoHash = "sha256-hOQ8/m4TY18ZFmLFxxnXUX1yr52tKNmebx6H0uIIGUo=";

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

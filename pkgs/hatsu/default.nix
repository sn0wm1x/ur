{ cmake
, fetchFromGitHub
, lib
, openssl
, pkg-config
, rustPlatform
}:
let
  pname = "hatsu";
  version = "0.2.0";
in
rustPlatform.buildRustPackage rec {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "importantimport";
    repo = pname;
    rev = "v${version}";
    sha256 = "";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ openssl ];

  OPENSSL_LIB_DIR = "${lib.getLib openssl}/lib";
  OPENSSL_INCLUDE_DIR = "${openssl.dev}/include";

  meta = with lib; {
    homepage = "https://github.com/importantimport/hatsu";
    description = "Self-hosted & Fully-automated ActivityPub Bridge for Static Sites.";
    license = licenses.agpl3Only;
    mainProgram = "hatsu";
    # maintainers = with maintainers; [ kwaa ];
  };
}

{ lib, stdenv, fetchurl, autoPatchelfHook }:
stdenv.mkDerivation rec {
  pname = "ollama-sycl-bin";
  version = "0.0.2";

  src = fetchurl {
    name = "ollama-linux-oneapi-amd64-${version}.tar.gz";
    url = "https://github.com/zhewang1-intc/ollama/releases/download/experimental-oneapi-v${version}/ollama-linux-oneapi-amd64.tar.gz";
    hash = "sha256-baUdTD2BdwDeFjoSuFehjEFgojAxpUc9GsBbhTBaZPk=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    stdenv.cc.cc.lib
  ];

  sourceRoot = ".";

  unpackPhase = ''
    tar -xzvf $src
  '';

  installPhase = ''
    runHook preInstall
    install -m755 -D ollama $out/bin/ollama
    runHook postInstall
  '';

  meta = {
    description =
      "Get up and running with large language models locally"
      + ", using SYCL for Intel GPU acceleration";
    homepage = "https://github.com/zhewang1-intc/ollama";
    changelog = "https://github.com/zhewang1-intc/ollama/releases/tag/experimental-oneapi-v${version}";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "ollama";
    maintainers = with lib.maintainers; [ kwaa ];
  };
}

{ lib
, stdenvNoCC
, fetchurl
, rpmextract
}:
let
  major = "2024.2";
  minor = "1";
  rel = "1079";
in
stdenvNoCC.mkDerivation ({
  pname = "intel-oneapi-compiler-dpcpp-cpp";
  version = "${major}.${minor}.${rel}";
  preferLocalBuild = true;

  src = fetchurl
    {
      url = "https://yum.repos.intel.com/oneapi/intel-oneapi-compiler-dpcpp-cpp-${major}-${major}.${minor}-${rel}.x86_64.rpm";
      hash = "sha256-vQKfLOO9zkYFRpvzK4nhRtzeqRCU/dna7vBkWNpKqgw=";
    };

  nativeBuildInputs = [ rpmextract ];

  unpackPhase = "rpmextract $src";

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir $out/bin
    mv opt/intel/oneapi/compiler/${major}/bin/ $out/bin/

    mkdir $out/lib
    mv opt/intel/oneapi/compiler/${major}/lib/ $out/lib/

    runHook postInstall
  '';

  meta = with lib; {
    broken = true; # WIP
    description = "Intel oneAPI DPC++/C++ Compiler";
    longDescription = " Standards driven high performance cross architecture DPC++/C++ compiler";
    homepage = "https://software.intel.com/content/www/us/en/develop/tools/oneapi.html";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.issl;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ kwaa ];
  };
})

{ stdenv
, lib
, fetchFromGitHub
, cmake
, ninja
, python3
}:
stdenv.mkDerivation rec {
  pname = "intel-llvm";
  version = "nightly-2024-08-16";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "llvm";
    rev = "refs/tags/${version}";
    sha256 = "";
  };

  nativeBuildInputs = [ cmake ninja python3 ];
  buildInputs = [ ];

  # cmakeFlags = with stdenv; [];

  buildPhase = ''
    python3 $src/buildbot/configure.py -t release
    python3 $src/buildbot/compile.py
  '';

  installPhase = ''
    mkdir -p $out/lib
    ls build
    cp -Ra build/. $out/lib/
  '';

  meta = {
    description = "Intel staging area for llvm.org contribution. Home for Intel LLVM-based projects.";
    homepage = "https://github.com/intel/llvm";
    license = lib.licenses.ncsa;
    maintainers = with lib.maintainers; [ kwaa ];
    platforms = [ "x86_64-linux" ];
  };
}

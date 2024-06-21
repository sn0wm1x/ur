{ lib
  # , stdenv
, stdenvNoCC
, fetchurl
, validatePkgConfig
, rpmextract
  # , enableStatic ? stdenv.hostPlatform.isStatic
}:
let
  # Release notes and download URLs are here:
  # https://registrationcenter.intel.com/en/products/
  version = "${mpiVersion}.${rel}";

  # mpiVersion = "2021.13.0";
  # rel = "719";
  mpiVersion = "2021.12.1";
  rel = "5";

  # shlibExt = stdenvNoCC.hostPlatform.extensions.sharedLibrary;

  oneapi-mpi = fetchurl {
    url = "https://yum.repos.intel.com/oneapi/intel-oneapi-mpi-${mpiVersion}-${rel}.x86_64.rpm";
    hash = "";
  };

  oneapi-mpi-devel = fetchurl {
    url = "https://yum.repos.intel.com/oneapi/intel-oneapi-mpi-devel-${mpiVersion}-${rel}.x86_64.rpm";
    hash = "";
  };

  oneapi-runtime-mpi = fetchurl {
    url = "https://yum.repos.intel.com/oneapi/intel-oneapi-runtime-mpi-${mpiVersion}-${rel}.x86_64.rpm";
    hash = "";
  };
in
stdenvNoCC.mkDerivation ({
  pname = "mpi";
  inherit version;

  dontUnpack = true;

  nativeBuildInputs = [ validatePkgConfig rpmextract ];

  buildPhase = ''
    rpmextract ${oneapi-mpi}
    rpmextract ${oneapi-mpi-devel}
    rpmextract ${oneapi-runtime-mpi}
  '';

  # installPhase = ''
  #   for f in $(find . -name 'mkl*.pc') ; do
  #     bn=$(basename $f)
  #     substituteInPlace $f \
  #       --replace $\{MKLROOT} "$out" \
  #       --replace "lib/intel64" "lib"

  #     sed -r -i "s|^prefix=.*|prefix=$out|g" $f
  #   done

  #   for f in $(find opt/intel -name 'mkl*iomp.pc') ; do
  #     substituteInPlace $f --replace "../compiler/lib" "lib"
  #   done

  #   # License
  #   install -Dm0655 -t $out/share/doc/mkl opt/intel/oneapi/mkl/${mpiVersion}/licensing/license.txt

  #   # Dynamic libraries
  #   mkdir -p $out/lib
  #   cp -a opt/intel/oneapi/mkl/${mpiVersion}/lib/${lib.optionalString stdenvNoCC.isLinux "intel64"}/*${shlibExt}* $out/lib
  #   cp -a opt/intel/oneapi/compiler/${mpiVersion}/${if stdenvNoCC.isDarwin then "mac" else "linux"}/compiler/lib/${lib.optionalString stdenvNoCC.isLinux "intel64_lin"}/*${shlibExt}* $out/lib

  #   # Headers
  #   cp -r opt/intel/oneapi/mkl/${mpiVersion}/include $out/

  #   # CMake config
  #   cp -r opt/intel/oneapi/mkl/${mpiVersion}/lib/cmake $out/lib
  # '' +
  # (if enableStatic then ''
  #   install -Dm0644 -t $out/lib opt/intel/oneapi/mkl/${mpiVersion}/lib/${lib.optionalString stdenvNoCC.isLinux "intel64"}/*.a
  #   install -Dm0644 -t $out/lib/pkgconfig opt/intel/oneapi/mkl/${mpiVersion}/lib/pkgconfig/*.pc
  # '' else ''
  #   cp opt/intel/oneapi/mkl/${mpiVersion}/lib/${lib.optionalString stdenvNoCC.isLinux "intel64"}/*${shlibExt}* $out/lib
  #   install -Dm0644 -t $out/lib/pkgconfig opt/intel/oneapi/mkl/${mpiVersion}/lib/pkgconfig/*dynamic*.pc
  # '') + ''
  #   # Setup symlinks for blas / lapack
  #   ln -s $out/lib/libmkl_rt${shlibExt} $out/lib/libblas${shlibExt}
  #   ln -s $out/lib/libmkl_rt${shlibExt} $out/lib/libcblas${shlibExt}
  #   ln -s $out/lib/libmkl_rt${shlibExt} $out/lib/liblapack${shlibExt}
  #   ln -s $out/lib/libmkl_rt${shlibExt} $out/lib/liblapacke${shlibExt}
  # '' + lib.optionalString stdenvNoCC.hostPlatform.isLinux ''
  #   ln -s $out/lib/libmkl_rt${shlibExt} $out/lib/libblas${shlibExt}".3"
  #   ln -s $out/lib/libmkl_rt${shlibExt} $out/lib/libcblas${shlibExt}".3"
  #   ln -s $out/lib/libmkl_rt${shlibExt} $out/lib/liblapack${shlibExt}".3"
  #   ln -s $out/lib/libmkl_rt${shlibExt} $out/lib/liblapacke${shlibExt}".3"
  # '';

  # fixDarwinDylibName fails for libmkl_cdft_core.dylib because the
  # larger updated load commands do not fit. Use install_name_tool
  # explicitly and ignore the error.
  # postFixup = lib.optionalString stdenvNoCC.isDarwin ''
  #   for f in $out/lib/*.dylib; do
  #     install_name_tool -id $out/lib/$(basename $f) $f || true
  #   done
  #   install_name_tool -change @rpath/libiomp5.dylib $out/lib/libiomp5.dylib $out/lib/libmkl_intel_thread.dylib
  #   install_name_tool -change @rpath/libtbb.12.dylib $out/lib/libtbb.12.dylib $out/lib/libmkl_tbb_thread.dylib
  #   install_name_tool -change @rpath/libtbbmalloc.2.dylib $out/lib/libtbbmalloc.2.dylib $out/lib/libtbbmalloc_proxy.dylib
  # '';

  # Per license agreement, do not modify the binary
  dontStrip = true;
  dontPatchELF = true;

  meta = with lib; {
    description = "Intel MPI Library";
    longDescription = ''
      Use this standards-based MPI implementation to deliver flexible,
      efficient, scalable cluster messaging on Intel architecture.
      This component is part of the Intel HPC Toolkit.
    '';
    homepage = "https://www.intel.com/content/www/us/en/developer/tools/oneapi/mpi-library.html";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.issl;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ kwaa ];
  };
})

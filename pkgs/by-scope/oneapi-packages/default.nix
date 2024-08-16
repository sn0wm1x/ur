{ lib, newScope, ... }:
lib.makeScope newScope (self: with self; {
  compiler-dpcpp-cpp = callPackage ./compiler-dpcpp-cpp { };
  llvm = callPackage ./llvm { };
  mpi = callPackage ./mpi { };
})

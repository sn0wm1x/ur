{ lib, newScope, ... }:
lib.makeScope newScope (self: with self; {
  dpcpp-cpp = callPackage ./dpcpp-cpp { };
  llvm = callPackage ./llvm { };
  mpi = callPackage ./mpi { };
})

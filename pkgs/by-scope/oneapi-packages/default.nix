{ lib, newScope, ... }:
lib.makeScope newScope (self: with self; {
  llvm = callPackage ./llvm { };
  mpi = callPackage ./mpi { };
})

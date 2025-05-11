{
  lib,
  stdenv,
  kattis-cli,
  kattis-test,
}:
let
  mkDate =
    longDate:
    (lib.concatStringsSep "-" [
      (lib.substring 0 4 longDate)
      (lib.substring 4 2 longDate)
      (lib.substring 6 2 longDate)
    ]);
  version = mkDate (kattis-test.lastModifiedDate or "19700101");
in
stdenv.mkDerivation {
  inherit version;
  pname = "kattis-test";

  src = kattis-test;
  propagatedBuildInputs = [ kattis-cli ];

  patchPhase = ''
    substituteInPlace kattis-test \
      --replace '"rustup",' "" \
      --replace '"run",' "" \
      --replace '"1.83.0",' ""
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp kattis-test $out/bin/kattis-test
  '';

  meta = with lib; {
    description = "Tool for running problem submissions against samples.";
    homepage = "https://github.com/tyilo/kattis-test";
    mainProgram = "kattis";
    platforms = platforms.all;
  };
}

{
  lib,
  stdenv,
  python3,
  kattis-cli,
}:
let
  mkDate =
    longDate:
    (lib.concatStringsSep "-" [
      (lib.substring 0 4 longDate)
      (lib.substring 4 2 longDate)
      (lib.substring 6 2 longDate)
    ]);

  version = mkDate (kattis-cli.lastModifiedDate or "19700101");

  pythonWithDeps = python3.pkgs.python.withPackages (
    pythonPkgs: with pythonPkgs; [
      requests
      lxml
    ]
  );
in
stdenv.mkDerivation {
  inherit version;
  pname = "kattis-cli";
  src = kattis-cli;

  propagatedBuildInputs = [ pythonWithDeps ];

  patchPhase = ''
    substituteInPlace ./submit.py \
    --replace "#!/usr/bin/env python" "#!${pythonWithDeps}/bin/python"
  '';

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/lib
    cp submit.py $out/lib/submit.py
    echo "$out/lib/submit.py \"\$@\"" > $out/bin/kattis
    chmod +x $out/bin/kattis
  '';

  meta = with lib; {
    description = "Kattis online judge command line tool";
    homepage = "https://github.com/Kattis/kattis-cli";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    mainProgram = "kattis";
    platforms = platforms.all;
  };
}

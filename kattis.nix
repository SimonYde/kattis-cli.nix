{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  kattis-cli,
}:
let
  python = python3.pkgs.python.withPackages (
    ps: with ps; [
      requests
      lxml
    ]
  );
in
stdenv.mkDerivation {
  pname = "kattis-cli";
  version = "unstable-2024-09-17";

  src = kattis-cli;
  propagatedBuildInputs = [ python ];

  patchPhase = ''
    substituteInPlace ./submit.py \
    --replace "#!/usr/bin/env python" "#!${python}/bin/python"
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

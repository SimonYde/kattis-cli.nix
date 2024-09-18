{
  lib,
  stdenv,
  fetchFromGitHub,
  kattis-cli,
  kattis-test,
}:
stdenv.mkDerivation {
  pname = "kattis-test";
  version = "unstable-2024-09-18";

  src = kattis-test;
  propagatedBuildInputs = [ kattis-cli ];

  patchPhase = ''
    substituteInPlace kattis-test \
      --replace '"rustup",' "" \
      --replace '"run",' "" \
      --replace '"1.72.1",' ""
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp kattis-test $out/bin/kattis-test
  '';

  meta = with lib; {
    description = "Tool for running problem submissions against samples.";
    homepage = "https://github.com/tyilo/kattis-test";
    maintainers = with maintainers; [ ];
    mainProgram = "kattis";
    platforms = platforms.all;
  };
}

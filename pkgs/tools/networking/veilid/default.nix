{ lib
, stdenv
, AppKit
, Security
, fetchFromGitLab
, rustPlatform
, protobuf
, capnproto
}:

rustPlatform.buildRustPackage rec {
  pname = "veilid";
  version = "0.2.0";

  src = fetchFromGitLab {
    owner = "veilid";
    repo = pname;
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "sha256-OgV6Rp5Az5iPUekeO8L28bxlXj/wZ5mOGmlXz14wcoQ=";
  };

  cargoLock = {
     lockFile = ./Cargo.lock;
     outputHashes = {
       "bugsalot-0.2.2" = "sha256-9zLzK22dOB7w+ejk1SfkA98z4rEzrB6mAVUpPFuDUnY=";
       "keychain-services-0.1.2" = "sha256-gkiE9PoSIgHngXc/BLMTL97/6dSnqAj42+q01CLbu+E=";
     };
   };

  nativeBuildInputs = [
    capnproto
    protobuf
  ];

  buildInputs = lib.optionals stdenv.isDarwin [ AppKit Security ];

  cargoBuildFlags = [
    "--workspace"
  ];

  doCheck = false;

  outputs = [ "out" "lib" "dev" ];

  postInstall = ''
    moveToOutput "lib" "$lib"
  '';

  meta = with lib; {
    description = "An open-source, peer-to-peer, mobile-first, networked application framework";
    homepage = "https://veilid.com";
    license = licenses.mpl20;
    maintainers = with maintainers; [ bbigras ];
  };
}

{ lib, rustPlatform, fetchFromGitHub, pkg-config, cmake, openssl, zlib, perl }:

let
  pname = "lsp-ai";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "SilasMarvin";
    repo = pname;
    rev = "66655f6285fe8aad8f2d72646e9ed47c06245525";
    hash = "sha256-DwqqZBzLevuRCW6QzGyWdE+JtpW6b3EMDuiWtajv/U4=";
  };

in rustPlatform.buildRustPackage {
  inherit pname version src;

  cargoLock = {
    lockFile = src + "/Cargo.lock";
    allowBuiltinFetchGit = true;
  };

  nativeBuildInputs = [ pkg-config cmake perl ];
  buildInputs = [ openssl openssl.dev zlib ];

  buildFeatures = [ "all" ];

  doCheck = false;

  OPENSSL_NO_VENDOR = 1;
  OPENSSL_DIR = "${openssl.dev}";
  OPENSSL_LIB_DIR = "${openssl.out}/lib";
  RUSTFLAGS = "-C target-cpu=native";

  meta = with lib; {
    description =
      "An open-source language server that serves as a backend for AI-powered functionality";
    homepage = "https://github.com/SilasMarvin/lsp-ai";
    license = licenses.mit;
    maintainers = with lib.maintainers; [ projectinitiative ];
  };
}

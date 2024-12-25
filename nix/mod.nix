let
  postInstall = ''
    for f in "$out"/bin/*; do
      local nrp="$(patchelf --print-rpath "$f" | sed -E 's@(:|^)'$NIX_BUILD_TOP'[^:]*:@\1@g')"
      patchelf --set-rpath "$nrp" "$f"
    done
  '';
in {
  Libwasmvm_1_5_5 = atom.pkgs.rustPlatform.buildRustPackage {
    useFetchCargoVendor = true;
    sourceRoot = "wasmvm-1.5.5/libwasmvm";
    cargoHash = "sha256-2iTEnkAGH+XuihGP6qX2xGFM4xGXI3dSj7kHdxhMQ1I=";
    pname = "libwasmvm";
    version = "1.5.5";
    src = atom.pkgs.fetchurl {
      hash = "sha256-BZ8iE57MRxxFxONs45HSq/0hJlHeUi89E1HuI2h2lqU=";
      url = "https://github.com/CosmWasm/wasmvm/archive/refs/tags/v1.5.5.tar.gz";
    };
  };
  Junod_26_0_0 = atom.pkgs.buildGoModule {
    pname = "junod";
    version = "26.0.0";
    src = atom.pkgs.fetchurl {
      url = "https://github.com/CosmosContracts/juno/archive/refs/tags/v26.0.0.tar.gz";
      sha256 = "sha256-/Gz+HVoYiPLw///CRCvBQTBeE1S3xkAPOUn53CtJS54=";
    };
    vendorHash = "sha256-iynKKINRg3y2NCVIyp8u7VBIeKlqlkDT74oeO/9jnbo=";
    subPackages = "cmd/junod";
    buildInputs = [mod.libwasmvm_1_5_5];
    inherit postInstall;
  };
}

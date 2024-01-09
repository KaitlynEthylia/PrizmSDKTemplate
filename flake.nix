{
	inputs = {
		utils.url = "github:numtide/flake-utils";
	};

	outputs = { nixpkgs, utils, ... }: utils.lib.eachDefaultSystem (system:
		let
			pkgs = import nixpkgs { inherit system; };
			target = "sh3eb-elf";
			callPackage = pkgs.lib.callPackageWith (pkgs // sh3-pkgs);
			sh3-pkgs = {
				mkg3a = callPackage ./nix/mkg3a.nix { };
				"${target}-binutils" = callPackage ./nix/binutils.nix { inherit target; };
				"${target}-gcc" = callPackage ./nix/gcc.nix { inherit target; };
				libfxcg = callPackage ./nix/libfxcg.nix { };
			};
		in rec {
			packages = {
				prizmsdk = callPackage ./nix { };
				default = packages.prizmsdk;
			};
			devShells = {
				default = packages.prizmsdk.overrideAttrs (self: prev: {
					CPATH = "${sh3-pkgs.libfxcg}/include";

					nativeBuildInputs = with pkgs; [
						clang-tools_17
					] ++ prev.nativeBuildInputs;
				});
			};
		});
}

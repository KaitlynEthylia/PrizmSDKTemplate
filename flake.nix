{
	inputs = {
		utils.url = "github:numtide/flake-utils";
	};

	outputs = { nixpkgs, utils, ... }: utils.lib.eachDefaultSystem (system:
		let
			target = "sh3eb-elf";
			sh3-overlay = final: prev: {
				"mkg3a" = final.callPackage ./nix/mkg3a.nix { };
				"${target}-binutils" = final.callPackage ./nix/binutils.nix { inherit target; };
				"${target}-gcc" = final.callPackage ./nix/gcc.nix { inherit target; };
				"libfxcg" = final.callPackage ./nix/libfxcg.nix { inherit target; };
			};
			pkgs = import nixpkgs { inherit system; overlays = [ sh3-overlay ]; };
		in rec {
			packages = {
				prizmsdk = pkgs.callPackage ./nix { inherit target; };
				default = packages.prizmsdk;
			};
			devShells = {
				default = pkgs.mkShell {
					packages = with pkgs; [
						clang-tools_17
					];
				};
				prizmsdk = packages.prizmsdk;
			};
		});
}

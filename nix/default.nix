{ pkgs, stdenv, target }:

stdenv.mkDerivation {
	pname = "prizmsdk";
	version = "0.0.0";

	src = ./..;

	FXCGSDK = pkgs.libfxcg;

	nativeBuildInputs = with pkgs; [
		"${target}-binutils"
		"${target}-gcc"
		mkg3a libfxcg
	];

	installPhase = ''
		mkdir -p $out/bin
		cp build/* $out/bin
	'';
}

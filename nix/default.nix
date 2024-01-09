{ stdenv
, fetchFromGitHub
, sh3eb-elf-binutils
, sh3eb-elf-gcc
, mkg3a
, libfxcg
}:
stdenv.mkDerivation {
	pname = "prizmsdk";
	version = "0.0.0";

	src = ./..;

	FXCGSDK = libfxcg;

	nativeBuildInputs = [
		sh3eb-elf-binutils
		sh3eb-elf-gcc
		mkg3a libfxcg
	];

	installPhase = ''
		mkdir -p $out/bin
		cp build/* $out/bin
	'';
}

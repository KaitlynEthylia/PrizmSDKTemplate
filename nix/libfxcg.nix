{ stdenv
, fetchFromGitHub
, sh3eb-elf-binutils
, sh3eb-elf-gcc
, mkg3a
}:
let
	version = "0.5.2";
in stdenv.mkDerivation {
	pname = "libfxcg";
	inherit version;

	src = fetchFromGitHub {
		owner = "Jonimoose";
		repo = "libfxcg";
		rev = "acf23fd3104706f5da28d44731e54ed6615678b1";
		sha256 = "sha256-ndDGEbJIjf3rLVCvspFohwe9qoTLoPGltUIpiOjz1E8=";
	};

	nativeBuildInputs = [
		sh3eb-elf-binutils
		sh3eb-elf-gcc
		mkg3a
	];

	dontStrip = true;
	installPhase = ''
		mkdir $out
		cp -r lib $out/lib
		cp -r include $out/include
		cp -r toolchain $out/toolchain
	'';
}

{ stdenv, fetchFromGitLab, cmake, libpng }:
let
	version = "0.5.0";
in stdenv.mkDerivation {
	pname = "mkg3a";
	inherit version;

	src = fetchFromGitLab {
		owner = "taricorp";
		repo = "mkg3a";
		rev = version;
		sha256 = "sha256-15GW9qKifEkmly/CViMzrl9mWw6lZPO4ZeADgm3tA+w=";
	};

	nativeBuildInputs = [ cmake ];
	buildInputs = [ libpng ];
}

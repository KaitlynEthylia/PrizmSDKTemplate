{ stdenv , fetchTarball , target }:
let
	version = "2.36.1";
in stdenv.mkDerivation {
	pname = "${target}-binutils";
	inherit version;

	src = fetchTarball {
		url = "https://ftp.gnu.org/gnu/binutils/binutils-${version}.tar.bz2";
		sha256 = "0hdyh6lmhdxkw856h6h970wbd77985asfjc2cvdw80ykh89kzklc";
	};

	inherit target;
	configurePhase = ''
		[[ -d binutils-build ]] && rm -rf binutils-build
		mkdir binutils-build

		cd binutils-build
		../configure --target=$target \
			--disable-nls --disable-tls --disable-libssp \
			--enable-multilib \
			--program-prefix=$target- \

		make configure-host -j$NIX_BUILD_CORES
	'';

	installPhase = ''
		make DESTDIR=$out install -j$NIX_BUILD_CORES
		cp -r $out/usr/local/* $out
		rm -rf $out/usr
   '';
}

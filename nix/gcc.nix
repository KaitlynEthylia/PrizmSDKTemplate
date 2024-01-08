{ pkgs, stdenv, fetchTarball, target }:
let
	version = "12.2.0";
in stdenv.mkDerivation {
	pname = "${target}-gcc";
	inherit version;

	src = fetchTarball {
		url = "https://gcc.gnu.org/pub/gcc/releases/gcc-${version}/gcc-${version}.tar.xz";
		sha256 = "sha256:1lpzbx0hvxwm7565af1brwbl8kg7pq6vzny7lrg7gdgimvnhal5v";
	};

	buildInputs = with pkgs; [ binutils libmpc gmp mpfr zlib ];

	inherit target;
	configurePhase = ''
		echo $version > gcc/BASE-VER

		[[ -d gcc-build ]] && rm -rf gcc-build
		mkdir gcc-build

		cd gcc-build
		../configure --target=$target \
			--disable-shared --disable-threads --disable-nls \
			--disable-tls --disable-libssp --disable-libgomp \
			--enable-multilib --enable-lto \
			--enable-languages=c,c++ \
			--program-prefix=$target- \
			--with-as=${pkgs.binutils}/bin/${target}-as \
			--with-ld=${pkgs.binutils}/bin/${target}-ld \
	'';

	hardeningDisable = [ "all" ];
	buildPhase = ''
		make all-gcc all-target-libgcc -j$NIX_BUILD_CORES
	'';

	dontStrip = true;
	installPhase = ''
		make DESTDIR=$out install-strip-gcc install-strip-target-libgcc -j$NIX_BUILD_CORES
		cp -r $out/usr/local/* $out
		rm -rf $out/usr
	'';
}

{ lib, stdenv, fetchFromGitHub, fetchpatch
, pkg-config, cmake, ninja, yasm
, libjpeg, openssl_1_1, libopus, ffmpeg, alsa-lib, libpulseaudio, protobuf
, openh264, usrsctp, libevent, libvpx
, libX11, libXtst, libXcomposite, libXdamage, libXext, libXrender, libXrandr, libXi
, glib, abseil-cpp, pcre, util-linuxMinimal, libselinux, libsepol, pipewire
, mesa, valgrind, libepoxy, libglvnd
}:

stdenv.mkDerivation {
  pname = "tg_owt";
  version = "unstable-2023-01-05";

  src = fetchFromGitHub {
    owner = "desktop-app";
    repo = "tg_owt";
    rev = "5098730b9eb6173f0b52068fe2555b7c1015123a";
    sha256 = "0dnh0l9qb9q43cvm4wfgmgqp48grqqz9fb7f48nvys1b6pzhh3pk";
    fetchSubmodules = true;
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ pkg-config cmake ninja yasm ];

  buildInputs = [
    libjpeg libopus ffmpeg alsa-lib libpulseaudio protobuf
    openh264 usrsctp libevent libvpx
    libX11 libXtst libXcomposite libXdamage libXext libXrender libXrandr libXi
    glib abseil-cpp pcre util-linuxMinimal libselinux libsepol pipewire
    mesa libepoxy libglvnd
  ];

  patches = [
    # GCC 12 Fix
    (fetchpatch {
      url = "https://github.com/desktop-app/tg_owt/pull/101/commits/86d2bcd7afb8706663d29e30f65863de5a626142.patch";
      hash = "sha256-iWS0mB8R0vqPU/0qf6Ax54UCAKYDVCPac2mi/VHbFm0=";
    })
  ];

  cmakeFlags = [
    # Building as a shared library isn't officially supported and may break at any time.
    "-DBUILD_SHARED_LIBS=OFF"
  ];

  propagatedBuildInputs = [
    # Required for linking downstream binaries.
    abseil-cpp openh264 usrsctp libevent libvpx openssl_1_1
  ];

  meta = with lib; {
    license = licenses.bsd3;
    maintainers = with maintainers; [ oxalica ];
  };
}

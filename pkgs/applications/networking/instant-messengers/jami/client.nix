{ version
, src
, jami-meta
, lib
, stdenv
, pkg-config
, cmake
, networkmanager # for libnm
, python3
, qttools # for translations
, wrapQtAppsHook
, ffmpeg_5
, jami-daemon
, libnotify
, qt5compat
, qtbase
, qtdeclarative
, qrencode
, qtmultimedia
, qtnetworkauth
, qtsvg
, qtwebengine
, qtwebchannel
, withWebengine ? true
}:

stdenv.mkDerivation {
  pname = "jami-client";
  inherit version src;

  sourceRoot = "source/client-qt";

  preConfigure = ''
    echo 'const char VERSION_STRING[] = "${version}";' > src/app/version.h
  '';

  nativeBuildInputs = [
    wrapQtAppsHook
    pkg-config
    cmake
    python3
    qttools
  ];

  buildInputs = [
    ffmpeg_5
    jami-daemon
    libnotify
    networkmanager
    qtbase
    qt5compat
    qrencode
    qtnetworkauth
    qtdeclarative
    qtmultimedia
    qtsvg
    qtwebchannel
  ] ++ lib.optionals withWebengine [
    qtwebengine
  ];

  cmakeFlags = [
    "-DLIBJAMI_INCLUDE_DIR=${jami-daemon}/include/jami"
    "-DLIBJAMI_XML_INTERFACES_DIR=${jami-daemon}/share/dbus-1/interfaces"
  ] ++ lib.optionals (!withWebengine) [
    "-DWITH_WEBENGINE=false"
  ];

  qtWrapperArgs = [
    # With wayland the titlebar is not themed and the wmclass is wrong.
    "--set-default QT_QPA_PLATFORM xcb"
  ];

  meta = jami-meta // {
    description = "The client based on QT" + jami-meta.description;
  };
}

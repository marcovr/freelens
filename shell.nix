{ pkgs ? import <nixpkgs> {} }:

let deps = with pkgs; [
  alsa-lib
  at-spi2-atk
  at-spi2-core
  atk
  cairo
  cups
  dbus
  expat
  gdk-pixbuf
  glib
  gtk3
  icu
  libdrm
  libgbm
  libx11
  libxcb
  libxcomposite
  libxcursor
  libxdamage
  libxext
  libxfixes
  libxi
  libxkbcommon
  libxrandr
  libxrender
  libxshmfence
  libxtst
  mesa
  nspr
  nss
  pango
  systemd
  gsettings-desktop-schemas
  hicolor-icon-theme
  libxml2
  sqlite
];
in
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    nodejs_22
    pnpm
    python3
    pkg-config
    gcc
    gnumake
    patchelf
  ];

  buildInputs = deps;

  shellHook = ''
    export LD_LIBRARY_PATH=${pkgs.lib.makeLibraryPath (deps ++ [ pkgs.stdenv.cc.cc ])}
    export XDG_DATA_DIRS=${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}:${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}:$XDG_DATA_DIRS

    # Patch Electron binary if it exists
    if [ -f freelens/dist/linux-unpacked/freelens ]; then
      echo "Patching Electron binary..."
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" freelens/dist/linux-unpacked/freelens
    fi

    echo "Nix shell for Freelens development loaded"
  '';
}

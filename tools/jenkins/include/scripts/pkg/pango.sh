#!/bin/bash

# Install pango
# see http://www.linuxfromscratch.org/blfs/view/svn/x/pango.html
PANGO_VERSION=1.42.2
PANGO_VERSION_SHORT=${PANGO_VERSION%.*}
PANGO_TAR="pango-${PANGO_VERSION}.tar.xz"
PANGO_SITE="http://ftp.gnome.org/pub/GNOME/sources/pango/${PANGO_VERSION_SHORT}"
if build_step && { force_build || { [ "${REBUILD_PANGO:-}" = "1" ]; }; }; then
    rm -rf $SDK_HOME/include/pango* $SDK_HOME/lib/libpango* $SDK_HOME/lib/pkgconfig/pango* || true
fi
if build_step && { force_build || { [ ! -s "$SDK_HOME/lib/pkgconfig/pango.pc" ] || [ "$(pkg-config --modversion pango)" != "$PANGO_VERSION" ]; }; }; then
    REBUILD_SVG=1
    start_build
    download "$PANGO_SITE" "$PANGO_TAR"
    untar "$SRC_PATH/$PANGO_TAR"
    pushd "pango-${PANGO_VERSION}"
    env FONTCONFIG_LIBS="-lfontconfig" CFLAGS="$BF -g" CXXFLAGS="$BF -g" ./configure --prefix="$SDK_HOME" --disable-docs --disable-static --enable-shared --with-included-modules=basic-fc
    make -j${MKJOBS}
    make install
    popd
    rm -rf "pango-${PANGO_VERSION}"
    end_build
fi

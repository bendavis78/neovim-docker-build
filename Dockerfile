FROM debian:bullseye-slim

ARG VERSION
ARG ARCH

RUN apt-get update && apt-get install -y \
    ninja-build gettext libtool libtool-bin autoconf automake cmake g++ \
    pkg-config unzip curl doxygen git

COPY ./src/neovim /neovim-build
RUN mkdir /neovim_${VERSION}_${ARCH}
WORKDIR /neovim-build
RUN make CMAKE_BUILD_TYPE=RelWithDebInfo CMAKE_INSTALL_PREFIX=/usr

RUN make DESTDIR=/neovim_${VERSION}_${ARCH} install

RUN mkdir /neovim_${VERSION}_${ARCH}/DEBIAN

RUN echo "\
Package: neovim\n\
Version: ${VERSION}\n\
Architecture: ${ARCH}\n\
Maintainer: Debian Vim Maintainers <team+vim@tracker.debian.org>\n\
Installed-Size: 4671\n\
Recommends: python3-pynvim, xclip | xsel, xxd\n\
Suggests: ctags, vim-scripts\n\
Provides: editor\n\
Section: editors\n\
Priority: optional\n\
Homepage: https://neovim.io/\n\
Description: heavily refactored vim fork\n\
 Neovim is a fork of Vim focused on modern code and features, rather than\n\
 running in legacy environments.\n\
 .\n\
 msgpack API enables structured communication to/from any programming language.\n\
 Remote plugins run as co-processes that communicate with Neovim safely and\n\
 asynchronously.\n\
 .\n\
 GUIs (or TUIs) can easily embed Neovim or communicate via TCP sockets using\n\
 the discoverable msgpack API.\n\
" > /neovim_${VERSION}_${ARCH}/DEBIAN/control
RUN dpkg-deb --build --root-owner-group /neovim_${VERSION}_${ARCH}
RUN apt install -y /neovim_${VERSION}_${ARCH}.deb

#!/bin/sh
dir="$(dirname $0)";
default_arch="$(arch)";
default_version="$(cd $dir/src/neovim && git describe --tags | sed -e 's/^v//' || exit 1)"

ARCH="${ARCH:-$default_arch}"
VERSION="${VERSION:-$default_version}"

echo "ARCH: $ARCH; VERSION: $VERSION"
exit 0;

echo "Building neovim-${VERSION}-${ARCH}..."
docker build --build-arg VERSION=${VERSION} --build-arg ARCH=${ARCH} -t nvim-build . &&
docker run --rm --entrypoint cat nvim-build "/neovim_${VERSION}_${ARCH}.deb" \
    > "$dir/neovim_${VERSION}_${ARCH}.deb"

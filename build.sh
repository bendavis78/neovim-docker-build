#!/bin/sh
ARCH=arm64

dir=$(dirname $0)
VERSION="$(cd $dir/src/neovim && git describe --tags | sed -e 's/^v//' || exit 1)"

echo "Building neovim-${VERSION}-${ARCH}..."
docker build --build-arg VERSION=${VERSION} --build-arg ARCH=${ARCH} -t nvim-build . &&
docker run --rm --entrypoint cat nvim-build "/neovim_${VERSION}_${ARCH}.deb" \
    > "$dir/neovim_${VERSION}_${ARCH}.deb"

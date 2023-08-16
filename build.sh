#!/bin/sh
dir="$(dirname $0)";
default_arch="$(arch)";
default_version="$(cd $dir/src/neovim && git describe --tags | sed -e 's/^v//' || exit 1)"

ARCH="${ARCH:-$default_arch}"
VERSION="${VERSION:-$default_version}"

if [[ "$VERSION" != "$default_version" ]]; then
    echo "Switching to neovim version ${VERSION}"
    (cd "${dir}/src/neovim" && git co "v${VERSION}" &> /dev/null) || {
        echo "Invalid neovim version: ${VERSION}"
        exit 1;
    }
fi

echo "[build.sh] Building neovim ${VERSION} for ${ARCH}"

docker build --build-arg VERSION="${VERSION}" --build-arg ARCH="${ARCH}" --platform="linux/${ARCH}" -t nvim-build . &&
docker run --rm --entrypoint cat nvim-build "/neovim_${VERSION}_${ARCH}.deb" \
    > "$dir/build/neovim_${VERSION}_${ARCH}.deb"

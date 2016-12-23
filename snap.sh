#!/bin/sh -e
echo ""
echo "---------------------------- INFO -----------------------------"
gcc --version
snap --version

if [ "$SNAP" != "yes" ]; then
    exit 0
fi

if [ -z "$SNAPCRAFT_SECRET" ]; then
    exit 0
fi

echo ""
echo "---------------------------- PACKAGING -----------------------------"

mkdir -p ".encrypted"
if [ ! -e ".encrypted/snapcraft.cfg.enc" ]; then
    echo "Seeding a new macaroon."
    echo "$SNAPCRAFT_CONFIG" > ".encrypted/snapcraft.cfg.enc"
fi

mkdir -p "$HOME/.config/snapcraft"
openssl enc -aes-256-cbc -base64 -pass env:SNAPCRAFT_SECRET -d -in ".encrypted/snapcraft.cfg.enc" -out "$HOME/.config/snapcraft/snapcraft.cfg"

if docker run -v $HOME:/root -v $(pwd):/cwd didrocks/snapcraft sh -c 'cd /cwd; snapcraft'; then
    if [ "${TRAVIS_BRANCH}" = "daily" ]; then
        docker run -v $HOME:/root -v $(pwd):/cwd didrocks/snapcraft sh -c "cd /cwd; snapcraft push *.snap --release edge"
    elif [ "${TRAVIS_BRANCH}" = "publish" ]; then
        docker run -v $HOME:/root -v $(pwd):/cwd didrocks/snapcraft sh -c "cd /cwd; snapcraft push *.snap"
    fi
fi

openssl enc -aes-256-cbc -base64 -pass env:SNAPCRAFT_SECRET -out ".encrypted/snapcraft.cfg.enc" < "$HOME/.config/snapcraft/snapcraft.cfg"
rm -f "$HOME/.config/snapcraft/snapcraft.cfg"

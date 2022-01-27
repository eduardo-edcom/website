#!/bin/sh

OPTS="-quality 50 -define webp:lossless=true";

for F in $@; do
	convert $F $OPTS $(echo $F | \
		sed -e 's/.png/.webp/g' \
		-e 's/.jpg/.webp/g' \
		-e 's/.jpeg/.webp/g');
done

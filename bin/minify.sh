#!/bin/sh

envsubst < $1 | sed -e 's|/\*\(\\\\\)\?\*/|/~\1~/|g' \
	-e 's|/\*[^*]*\*\+\([^/][^*]*\*\+\)*/||g' \
	-e 's|\([^:/]\)//.*$|\1|' \
	-e 's|^//.*$||' | \
	tr '\n' ' ' | sed -e 's|/\*[^*]*\*\+\([^/][^*]*\*\+\)*/||g' \
	-e 's|/\~\(\\\\\)\?\~/|/*\1*/|g' \
	-e 's|\s\+| |g' \
	-e 's| \([{;:,]\)|\1|g' \
	-e 's|\([{;:,]\) |\1|g';

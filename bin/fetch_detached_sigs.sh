#!/bin/sh
#
# /*
#  * Copyright (c) 2018 Aaron Bieber <aaron@bolddaemon.com>
#  *
#  * Permission to use, copy, modify, and distribute this software for any
#  * purpose with or without fee is hereby granted, provided that the above
#  * copyright notice and this permission notice appear in all copies.
#  *
#  * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
#  * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
#  * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
#  * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
#  * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
#  * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
#  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
# */


D=$PWD
if cd /usr/ports; then
	if grep -q ^DISTDIR /etc/mk.conf; then
		OUTDIR=$(grep ^DISTDIR /etc/mk.conf | awk '{print $NF}')
	else
		OUTDIR="/usr/ports/distfiles"
	fi
	for port in $(make show=PKGPATH | awk '$1 !~ "===" {print $1}'); do
		(
			echo "$port"
			if cd "$port"; then
				URL=$(make show=MASTER_SITES | awk '{print $1}')
				DIST=$(make show=DISTNAME)
				EXT=$(make show=EXTRACT_SUFX)

				for s in asc sig; do
					if [ ! -f "${OUTDIR}/${DIST}.${s}" ]; then
						if ftp -o "${OUTDIR}/${DIST}${EXT}.${s}" "${URL}${DIST}${EXT}.${s}"; then
							echo "Signature found for ${DIST}!"
							ftp -o "${OUTDIR}/${DIST}${EXT}" "${URL}${DIST}${EXT}"
						fi
					fi
				done
			fi
		)
	done
fi

if cd "$D"; then
	exit 0
fi

# One of gnupg, signify, opmsg
SIG_TYPE ?=	gnupg
# Typically .asc for detached signatures
SIG_SUFX ?=	.asc
SIG_FILE ?=	${DISTNAME}${EXTRACT_SUFX}${SIG_SUFX}
SIG_PATH ?=	${DISTDIR}/${SIG_FILE}

fetch-sig:
	@${ECHO_MSG} "===> Checking signature files for ${FULLPKGNAME}${_MASTER}"
	@if [ ! -f ${SIG_PATH} ]; then \
	  for site in ${MASTER_SITES}; do \
	    if ${_PFETCH} ${FETCH_CMD} -o ${SIG_PATH} $${site}${SIG_FILE}; then \
	      exit 0; \
	    fi; \
	  done; exit 1; \
	fi

verify: fetch fetch-sig
	@if [ ${SIG_TYPE} == "gnupg" ]; then \
		env GNUPGHOME=${PREFIX}/share/signing/gnupg/ \
			${PREFIX}/bin/gpg2 --verify \
			${SIG_PATH} && \
		echo "Signature OK" || \
		echo "Signature NOT VALID!" ; \
	fi;
	@if [ ${SIG_TYPE} == "opmsg" ]; then \
		${PREFIX}/bin/opmsg -c \
			${PREFIX}/share/signing/opmsg \
			-V ${DISTDIR}/${DISTNAME}${EXTRACT_SUFX} \
			--in ${SIG_PATH} ; \
	fi;

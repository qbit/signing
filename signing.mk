# One of gnupg, signify, opmsg
SIG_TYPE ?=	gnupg
SIG_SUFX ?=	.asc
SIG_FILE ?=	${DISTNAME}${EXTRACT_SUFX}
SIG_PATH ?=	${DISTDIR}/${SIG_FILE}

clean-sig:
	rm -f ${SIG_PATH}{.sig,.asc}

fetch-sig:
	@${ECHO_MSG} "===> Checking signature files for ${FULLPKGNAME}${_MASTER}"
	@for sig in ${SIG_SUFX} .asc .sig; do \
		if [ ! -f ${SIG_PATH}${SIG_SUFX} ] && \
			[ ! -f ${SIG_PATH}.asc ] && \
			[ ! -f ${SIG_PATH}.sig ]; then \
			for site in ${MASTER_SITES}; do \
				if ${_PFETCH} ${FETCH_CMD} -o ${SIG_PATH}$${sig} \
					$${site}${SIG_FILE}$${sig}; then \
					exit 0; \
				else \
					break; \
				fi; \
			done; \
		else \
			exit 0; \
		fi ; \
	done ; exit 1;

verify: fetch fetch-sig
	@if [ ${SIG_TYPE} == "gnupg" ]; then \
		if [ -f ${SIG_PATH}.asc ]; then \
			env GNUPGHOME=${PREFIX}/share/signing/gnupg/ \
				${PREFIX}/bin/gpg2 --verify \
				${SIG_PATH}.asc && \
			( echo "Signature OK"; exit 0 ) || \
			( echo "Signature NOT VALID!"; exit 1 ) ; \
		else \
			env GNUPGHOME=${PREFIX}/share/signing/gnupg/ \
				${PREFIX}/bin/gpg2 --verify \
				${SIG_PATH}.sig && \
			( echo "Signature OK"; exit 0 )|| \
			( echo "Signature NOT VALID!"; exit 1 ) ; \
		fi ; \
	fi;
	@if [ ${SIG_TYPE} == "opmsg" ]; then \
		${PREFIX}/bin/opmsg -c \
			${PREFIX}/share/signing/opmsg \
				-V ${DISTDIR}/${DISTNAME}${EXTRACT_SUFX} \
				--in ${SIG_PATH}.sig && \
		( echo "Signature OK"; exit 0 ) || \
		( echo "Signature NOT VALID!"; exit 1 ); \
	fi;

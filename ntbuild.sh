#!/bin/sh

# shellcheck disable=SC2044,SC2086
if test -e assets/RagePixel/RagePixelMonoDevelop/RagePixelMonoDevelop.csproj && test -x "$(which msbuild)"; then \
	cd assets/RagePixel/RagePixelMonoDevelop || exit; \
	msbuild RagePixelMonoDevelop.csproj || msbuild Packages.mdproj || msbuild RagePixelMonoDevelop.sln || {
		sh ./autogen.sh; \
		make -ki; \
		make ID || make TAGS || make CTAGS || make GTAGS || make cscope; \
		doxygen; \
		CSFLAGS=""; \
		dlldir="/usr/lib/pkgconfig/../../lib/cli"; \
		for cslib in pango atk gdk gtk glib unity unity-engine; do \
			if test -r "${dlldir}"/"${cslib}"-sharp-2.0/"${cslib}"-sharp.dll; then \
				CSFLAGS="${CSFLAGS} -r:${dlldir}/${cslib}-sharp-2.0/${cslib}-sharp.dll"; \
			elif test -r "${dlldir}"/"${cslib}"-sharp/"${cslib}"-sharp.dll; then \
				CSFLAGS="${CSFLAGS} -r:${dlldir}/${cslib}-sharp/${cslib}-sharp.dll"; \
			elif test -r "${dlldir}"/"${cslib}"-sharp.dll; then \
				CSFLAGS="${CSFLAGS} -r:${dlldir}/${cslib}-sharp.dll"; \
			fi; \
		done; \
		for csfile in $(find . -name '*.cs' -print); do \
			if test -r "${csfile}"; then \
				mcs "${csfile}" || mcs "${csfile}" ${CSFLAGS} || mcs -noconfig -codepage:utf8 -warn:4 -optimize- -debug "-define:DEBUG" "${csfile}" || mcs -noconfig -codepage:utf8 -warn:4 -optimize- -debug "-define:DEBUG" "${csfile}" ${CSFLAGS} || {
					for mytflag in exe winexe library module; do \
						mcs "${csfile}" ${CSFLAGS} -target:"${mytflag}" || mcs -noconfig -codepage:utf8 -warn:4 -optimize- -debug "-define:DEBUG" "${csfile}" -target:"${mytflag}" || mcs -noconfig -codepage:utf8 -warn:4 -optimize- -debug "-define:DEBUG" "${csfile}" ${CSFLAGS} -target:"${mytflag}";
					done; \
				} || stat "${csfile}"; \
			fi; \
		done; \
	}; \
fi

#!/bin/sh

# shellcheck disable=SC2044,SC2086
if test -e assets/RagePixel/RagePixelMonoDevelop/RagePixelMonoDevelop.csproj && test -x "$(which msbuild)"; then \
	cd assets/RagePixel/RagePixelMonoDevelop || exit; \
	msbuild || msbuild RagePixelMonoDevelop.csproj || msbuild Packages.mdproj || msbuild RagePixelMonoDevelop.sln || {
		sh ./autogen.sh; \
		make -ki; \
		if test -x "$(which mkid)"; then \
		  make ID || mkid --help || stat "$(which mkid)"; \
		fi; \
		if test -x "$(which etags)"; then \
		  make TAGS || make CTAGS || make GTAGS || etags --version || etags --help; \
		fi; \
		if test -x "$(which ctags)"; then \
		  make CTAGS || make GTAGS || make TAGS || ctags --version || ctags --help; \
		fi; \
		if test -x "$(which gtags)" || test -x "$(which global)"; then \
		  make GTAGS || make TAGS || gtags --version || gtags --help || global --version || global --help; \
		fi; \
		if test -x "$(which cscope)"; then \
		  make cscope || cscope --version || cscope --help || stat "$(which cscope)"; \
		fi; \
		doxygen; \
		if test -x "$(which csc)"; then \
		  csc --help || csc --version || stat "$(which csc)"; \
		fi; \
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
		echo "CSFLAGS are now: ${CSFLAGS}"; \
		for csfile in $(find . -name '*.cs' -print); do \
			if test -r "${csfile}"; then \
				echo "attempting to compile ${csfile}..."; \
				mcs "${csfile}" || mcs "${csfile}" ${CSFLAGS} || mcs -noconfig -codepage:utf8 -warn:4 -optimize- -debug "-define:DEBUG" "${csfile}" || mcs -noconfig -codepage:utf8 -warn:4 -optimize- -debug "-define:DEBUG" "${csfile}" ${CSFLAGS} || {
					for mytflag in exe winexe library module; do \
						echo "attempting to compile ${csfile} using the ${mytflag} target..."; \
						mcs "${csfile}" ${CSFLAGS} -target:"${mytflag}" || mcs -noconfig -codepage:utf8 -warn:4 -optimize- -debug "-define:DEBUG" "${csfile}" -target:"${mytflag}" || mcs -noconfig -codepage:utf8 -warn:4 -optimize- -debug "-define:DEBUG" "${csfile}" ${CSFLAGS} -target:"${mytflag}";
					done; \
				} || stat "${csfile}"; \
				if test -x "$(which dotnet-format)"; then \
					dotnet-format "${csfile}" || stat "$(which dotnet-format)"; \
				fi; \
			fi; \
		done; \
	}; \
fi

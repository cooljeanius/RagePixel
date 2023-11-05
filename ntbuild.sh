#!/bin/sh

# shellcheck disable=SC2044
if test -e assets/RagePixel/RagePixelMonoDevelop/RagePixelMonoDevelop.csproj && test -x "$(which msbuild)"; then \
	cd assets/RagePixel/RagePixelMonoDevelop || exit; \
	msbuild RagePixelMonoDevelop.csproj || msbuild Packages.mdproj || msbuild RagePixelMonoDevelop.sln || {
		sh ./autogen.sh; \
		make -ki; \
		doxygen; \
		CSFLAGS=""; \
		dlldir="/usr/lib/pkgconfig/../../lib/cli"; \
		for cslib in pango atk gdk gtk glib; do \
			if test -r "${dlldir}"/"${cslib}"-sharp-2.0/"${cslib}"-sharp.dll; then \
				CSFLAGS="${CSFLAGS} -r:${dlldir}/${cslib}-sharp-2.0/${cslib}-sharp.dll"; \
			fi; \
		done; \
		for csfile in $(find . -name '*.cs' -print); do \
			if test -r "${csfile}"; then \
				mcs "${csfile}" || mcs "${CSFLAGS}" "${csfile}" || mcs -noconfig -codepage:utf8 -warn:4 -optimize- -debug "-define:DEBUG" "${csfile}" || mcs -noconfig -codepage:utf8 -warn:4 -optimize- -debug "-define:DEBUG" "${CSFLAGS}" "${csfile}" || stat "${csfile}"; \
			fi; \
		done; \
	}; \
fi

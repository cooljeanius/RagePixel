#!/bin/sh

if test -e assets/RagePixel/RagePixelMonoDevelop/RagePixelMonoDevelop.csproj && test -x "$(which msbuild)"; then \
	cd assets/RagePixel/RagePixelMonoDevelop || exit; \
	msbuild RagePixelMonoDevelop.csproj || msbuild Packages.mdproj || msbuild RagePixelMonoDevelop.sln || {
		sh ./autogen.sh; \
		make -ki; \
	}; \
fi

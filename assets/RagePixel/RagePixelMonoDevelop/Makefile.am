# Yes we are intentionally overriding something here:
ASSEMBLY_COMPILER_COMMAND = @GMCS@

EXTRA_DIST = expansions.m4
MYDISTCLEANFILES = *~ *.log install-sh missing

#Warning: The resulting Makefile is an automatically generated file, do not edit!
if ENABLE_DEBUG_X86
 SUBDIRS =  . 
endif
if ENABLE_RELEASE_X86
 SUBDIRS =  . 
endif

# Include project specific makefile
include RagePixelMonoDevelop.make

distclean-local:
	-rm -rfv autom4te.cache || rmdir autom4te.cache
	-test -z "$(MYDISTCLEANFILES)" || rm -f $(MYDISTCLEANFILES)

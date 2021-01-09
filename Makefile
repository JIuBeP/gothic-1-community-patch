# Platform specific definitions
ifdef OS
	RM 			:=	del /Q
	FixPath		 =	$(subst /,\,$1)
	mkdir		 =	mkdir $(subst /,\,$(1)) > nul 2>&1 || (exit 0)
	rwildcard	 =	$(foreach d,$(wildcard $(1:=/*)),$(call rwildcard,$d,$2) $(filter $(subst *,%,$2),$d))
else ifeq ($(shell uname), Linux)
	ERR			 =	$(error 'Linux not supported')
	RM			 =	$(ERR)
	FixPath		 =	$(ERR)
	mkdir		 =	$(ERR)
	rwildcard	 =	$(ERR)
endif

# Meta data
META			:=	metadata.txt

# Include meta data
include $(META)
export VERSION=$(VBASE).$(VMAJOR).$(VMINOR)

# Directories
BUILDDIR		:=	build/
SRCDIR			:=	src/
SETUPDIR		:=	setup/
CONTENTDIR		:=	Ninja/$(PATCHNAME)/Content/

# Build software (added to PATH)
NSIS			:=	makensis
VDFS			:=	gothicvdfs

# TARGET
TARGET			:=	$(BUILDDIR)$(PATCHNAME).vdf
SCRIPTVERSION	:=	$(SRCDIR)$(CONTENTDIR)version.d
VM				:=	$(SRCDIR)$(PATCHNAME).vm
VMAUTO			:=	tmp.vm
SOURCES			:=	$(call rwildcard,$(subst /,,$(SRCDIR)),*.d *.src)
SETUP			:=	$(BUILDDIR)$(PATCHNAME)-$(VERSION).exe
SETUPSCR		:=	$(SETUPDIR)g1mod.nsi
SETUPINC		:=	$(SETUPDIR)g1mod.nsh \
					$(SETUPDIR)setup.ini \
					LICENSE


# Phony rules
all : $(SETUP)

clean :
	$(RM) $(call FixPath,$(BUILDDIR)*)

remake : clean all

.PHONY : all clean remake


# Build setup with the metadata
$(SETUP) : $(TARGET) $(SETUPSCR) $(SETUPINC) $(METADATA)
	$(NSIS) /X"SetCompressor /FINAL lzma" $(call FixPath,$(SETUPSCR))

# Build VDF
$(TARGET) : $(VMAUTO) $(SCRIPTVERSION) $(SOURCES)
	$(info Found resources:)
	$(foreach d,$(SOURCES),$(info - $d))
	@$(call mkdir,$(BUILDDIR))
	@ATTRIB -a -h -r -s $(SRCDIR)* /S
	CD $(call FixPath,$(SRCDIR)) && $(VDFS) /B $(call FixPath,../$(VMAUTO))

# Auto-fill the VDFS VM script with the metadata
$(VMAUTO) : $(META) $(VM)
	@ECHO [BEGINVDF]>                                                             "$(call FixPath,$@)"
	@ECHO Comment=$(LONGNAME)  $(VBASE).$(VMAJOR).$(VMINOR)>>                     "$(call FixPath,$@)"
	@ECHO BaseDir=.^\>>                                                           "$(call FixPath,$@)"
	@ECHO VDFName=.^\..^\$(call FixPath,$(TARGET))>>                              "$(call FixPath,$@)"
	@ECHO/>>                                                                      "$(call FixPath,$@)"
	@ECHO ;>>                                                                     "$(call FixPath,$@)"
	@TYPE $(call FixPath,$(VM))>>                                                 "$(call FixPath,$@)"

# Auto-generate version constant in Daedalus
$(SCRIPTVERSION): $(META)
	@ECHO /* This file is automatically generated. Do not edit */>                "$(call FixPath,$@)"
	@ECHO const int Ninja_G1CP_Version = $(VBASE)*10000+$(VMAJOR)*100+$(VMINOR);>>"$(call FixPath,$@)"

.INTERMEDIATE: $(VMAUTO)

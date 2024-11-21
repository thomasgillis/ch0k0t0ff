
# # build recipe for Fabtests
#-------------------------------------------------------------------------------
fabtests_opt ?= 
fabtests_opt += ${FABTESTS_MISC_OPTS}

# compile with CUDA support
ifdef CUDA_DIR
fabtests_opt += --with-cuda=$(CUDA_DIR)
endif

# ofi
ifdef FABTESTS_VER
ifdef OFI_VER
fabtests_opt += --with-libfabric=$(PREFIX)
else
$(error OFI_VER must be given for fabtests)
endif
endif

# check ofi & fabtests versions
ifdef FABTESTS_VER
ifneq ($(OFI_VER), $(FABTESTS_VER))
$(error "OFI (v$(OFI_VER)) and Fabtests (v$(FABTESTS_VER)) should have matching versions")
endif
endif

#-------------------------------------------------------------------------------
# dependency list
fabtests_dep = ofi

define fabtests_template_opt
	target="fabtests" \
	target_ver="$(FABTESTS_VER)" \
	target_dep="$(fabtests_dep)" \
	target_url="https://github.com/ofiwg/libfabric/archive/refs/tags/v$(FABTESTS_VER).tar.gz" \
	target_precmd="cd fabtests; ./autogen.sh" \
	target_confcmd="CC=$(CC) CXX=$(CXX) ./configure --prefix=${PREFIX}" \
	target_confopt="$(fabtests_opt)"
endef

#===============================================================================
.PHONY: fabtests
fabtests: $(fabtests_dep)
ifdef FABTESTS_VER
	@$(fabtests_template_opt) $(MAKE) --file=template.mak doit
else
	@$(fabtests_template_opt) $(MAKE) --file=template.mak tit
endif

#-------------------------------------------------------------------------------
.PHONY: fabtests_tar
fabtests_tar: 
ifdef FABTESTS_VER
	@$(fabtests_template_opt) $(MAKE) --file=template.mak tar
else
	@$(fabtests_template_opt) $(MAKE) --file=template.mak ttar
endif

#-------------------------------------------------------------------------------
.PHONY: fabtests_info
fabtests_info:
ifdef FABTESTS_VER
	@$(fabtests_template_opt) $(MAKE) --file=template.mak info
else
	@$(fabtests_template_opt) $(MAKE) --file=template.mak info_none
endif

#-------------------------------------------------------------------------------
.PHONY: fabtests_clean
fabtests_clean: 
	@$(fabtests_template_opt) $(MAKE) --file=template.mak clean

#-------------------------------------------------------------------------------
.PHONY: fabtests_reallyclean
fabtests_reallyclean: 
	@$(fabtests_template_opt) $(MAKE) --file=template.mak reallyclean



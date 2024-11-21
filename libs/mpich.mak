# # build recipe for MPICH
#-------------------------------------------------------------------------------
mpich_opt ?= 
mpich_opt += ${MPICH_MISC_OPTS}
#mpich_opt += --disable-fortran ${MPICH_MISC_OPTS}

# compile with CUDA support
ifdef CUDA_DIR
mpich_opt += --with-cuda=$(CUDA_DIR)
endif

# ------------  UCX ------------
ifdef UCX_VER
mpich_opt += --with-device=ch4:ucx
mpich_opt += --with-ucx=$(PREFIX)
else
#MPICH_UCX_DEP ?= --with-ucx=no
ifdef MPICH_UCX_DEP
mpich_opt += ${MPICH_UCX_DEP}
endif
endif
# ------------  OFI ------------
ifdef OFI_VER
# .............................
ifndef UCX_VER
mpich_opt += --with-device=ch4:ofi
mpich_opt += --with-libfabric=$(PREFIX)
else
mpich_opt += --with-libfabric=no
$(warning OFI and UCX will not been build both with MPICH, using UCX by default)
endif
# .............................
else
#MPICH_OFI_DEP ?= --with-libfabric=no
ifdef MPICH_OFI_DEP
mpich_opt += ${MPICH_OFI_DEP}
endif
endif
# ------------  PMIX ------------
ifdef PMIX_VER
mpich_opt += --with-pmi=pmix --with-pmix=$(PREFIX)
endif
# ------------  HWLOC ------------
ifdef HWLOC_VER
mpich_opt += --with-hwloc=${PREFIX}
endif

#-------------------------------------------------------------------------------
# dependency list
mpich_dep = ucx ofi pmix hwloc

define mpich_template_opt
	target="mpich" \
	target_ver="$(MPICH_VER)" \
	target_dep="$(mpich_dep)" \
	target_url="https://www.mpich.org/static/downloads/$(MPICH_VER)/mpich-$(MPICH_VER).tar.gz" \
	target_precmd="cd modules/yaksa; ./autogen.sh --pup-max-nesting=0; cd -" \
	target_confcmd="CC=$(CC) CXX=$(CXX) ./configure --prefix=${PREFIX}" \
	target_confopt="$(mpich_opt)"
endef

#===============================================================================
.PHONY: mpich
mpich: $(mpich_dep)
ifdef MPICH_VER
	@$(mpich_template_opt) $(MAKE) --file=template.mak doit
else
	@$(mpich_template_opt) $(MAKE) --file=template.mak tit
endif

#-------------------------------------------------------------------------------
.PHONY: mpich_tar
mpich_tar: 
ifdef MPICH_VER
	@$(mpich_template_opt) $(MAKE) --file=template.mak tar
else
	@$(mpich_template_opt) $(MAKE) --file=template.mak ttar
endif

#-------------------------------------------------------------------------------
.PHONY: mpich_info
mpich_info:
ifdef MPICH_VER
	@$(mpich_template_opt) $(MAKE) --file=template.mak info
else
	@$(mpich_template_opt) $(MAKE) --file=template.mak info_none
endif

#-------------------------------------------------------------------------------
.PHONY: mpich_clean
mpich_clean: 
	@$(mpich_template_opt) $(MAKE) --file=template.mak clean

#-------------------------------------------------------------------------------
.PHONY: mpich_reallyclean
mpich_reallyclean: 
	@$(mpich_template_opt) $(MAKE) --file=template.mak reallyclean



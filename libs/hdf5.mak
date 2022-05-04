# # build recipe for HDF5
#-------------------------------------------------------------------------------
# dependency list
hdf5_dep = ompi zlib

ifdef ZLIB_VER
hdf5_zlib = --with-zlib=$(PREFIX)
endif

define hdf5_template_opt
	target="hdf5" \
	target_ver="$(HDF5_VER)" \
	target_dep="$(hdf5_dep)" \
	target_url="http://www.hdfgroup.org/ftp/HDF5/releases/hdf5-1.12/hdf5-$(HDF5_VER)/src/hdf5-$(HDF5_VER).tar.bz2" \
	target_confcmd="CC=$(DBS_MPICC) CXX=$(DBS_MPICXX) FC=$(DBS_MPIFORT) F77=$(DBS_MPIFORT) ./configure --prefix=${PREFIX}" \
	target_confopt="--enable-parallel --enable-optimization=high --enable-build-mode=production --with-default-api-version=v110 $(hdf5_zlib)"
endef

#===============================================================================
.PHONY: hdf5
hdf5: $(hdf5_dep)
ifdef HDF5_VER
	@$(hdf5_template_opt) $(MAKE) --file=template.mak doit
else
	@$(hdf5_template_opt) $(MAKE) --file=template.mak tit
endif

#-------------------------------------------------------------------------------
.PHONY: hdf5_tar
hdf5_tar: 
ifdef HDF5_VER
	@$(hdf5_template_opt) $(MAKE) --file=template.mak tar
else
	@$(hdf5_template_opt) $(MAKE) --file=template.mak ttar
endif

#-------------------------------------------------------------------------------
.PHONY: hdf5_info
hdf5_info:
ifdef HDF5_VER
	@$(hdf5_template_opt) $(MAKE) --file=template.mak info
else
	@$(hdf5_template_opt) $(MAKE) --file=template.mak info_none
endif

#-------------------------------------------------------------------------------
.PHONY: hdf5_clean
hdf5_clean: 
	@$(hdf5_template_opt) $(MAKE) --file=template.mak clean

#-------------------------------------------------------------------------------
.PHONY: hdf5_reallyclean
hdf5_reallyclean: 
	@$(hdf5_template_opt) $(MAKE) --file=template.mak reallyclean


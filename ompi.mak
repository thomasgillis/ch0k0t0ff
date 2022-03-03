# build recipe for UCX
#===============================================================================
# get the user-defined variables
OMPI_VER ?= 4.1.2

#===============================================================================
# useful variables
OMPI_DIR = openmpi-$(OMPI_VER)

#===============================================================================
.PHONY: ompi
ompi: $(BUILD_DIR)/ompi.complete

#-------------------------------------------------------------------------------
ompi.complete:
	$(info >>>>>>>> OMPI)
	@cd $(BUILD_DIR)
	$(info get the tar $(TAR_DIR)/$(OMPI_DIR))
	@cp $(TAR_DIR)/$(OMPI_DIR).tar.gz $(BUILD_DIR)
	@tar -xvf $(OMPI_DIR).tar.gz
	@cd $(OMPI_DIR)
	$(info configure)
	CC=$(CC) CXX=$(CXX) FC=$(FC) F77=$(FC) ./configure --prefix=${PREFIX} \
		--without-verbs --enable-mpirun-prefix-by-default --with-cuda=no \
		$(OMPI_CONFIG)
	$(info install to $(PREFIX))
	make install -j
	$(info write the complete file)
	@cd $(BUILD_DIR)
	date > ompi.complete
	hostname >> ompi.complete

#-------------------------------------------------------------------------------
.PHONY: ompi_info
.NOTPARALLEL: ompi_info
ompi_info:
	$(info --------------------------------------------------------------------------------)
	$(info OMPI)
	$(info - version: $(OMPI_VER))
	$(info - user config: $(OMPI_CONFIG))
	$(info )

#-------------------------------------------------------------------------------
.PHONY: ompi_clean
ompi_clean: 
	@rm -rf ompi.complete

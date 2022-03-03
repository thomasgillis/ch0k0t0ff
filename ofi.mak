# build recipe for OFI aka libfabric
#===============================================================================
# get the user-defined variables
OFI_VER ?= 1.14.0

#===============================================================================
# useful variables
OFI_DIR = libfabric-$(OFI_VER)

#===============================================================================
.PHONY: ofi
ofi: $(BUILD_DIR)/ofi.complete

#-------------------------------------------------------------------------------
ofi.complete:
	$(info >>>>>>>> OFI)
	$(info building OFI aka LibFabric)
	@cd $(BUILD_DIR)
	$(info get the tar $(TAR_DIR)/v$(OFI_VER))
	@cp $(TAR_DIR)/v$(OFI_VER).tar.gz $(BUILD_DIR)
	@tar -xvf v$(OFI_VER).tar.gz
	@cd $(OFI_DIR)
	$(info configure)
	./autogen.sh
	CC=$(CC) CXX=$(CXX) FC=$(FC) F77=$(FC) ./configure --prefix=${PREFIX}
	$(info install to $(PREFIX))
	make install -j
	$(info write the complete file)
	@cd $(BUILD_DIR)
	date > ofi.complete
	hostname >> ofi.complete

#-------------------------------------------------------------------------------
.PHONY: ofi_info
.NOTPARALLEL: ofi_info
ofi_info:
	$(info --------------------------------------------------------------------------------)
	$(info OFI aka LibFabric)
	$(info - version: $(OFI_VER))
	$(info )

#-------------------------------------------------------------------------------
.PHONY: ofi_clean
ofi_clean: 
	@rm -rf ofi.complete

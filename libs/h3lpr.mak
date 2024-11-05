# build recipe for H3LPR
#===============================================================================
# useful variables
H3LPR_DIR = h3lpr-$(H3LPR_VER)

ifdef H3LPR_VER
H3LPR_CXXFLAGS = -fopenmp -O3 -g -std=c++17
H3LPR_CCFLAGS = -fopenmp -O3 -g -std=c99
H3LPR_LDFLAGS = -fopenmp -lstdc++
endif 


#===============================================================================
.PHONY: h3lpr
h3lpr: $(PREFIX)/h3lpr.complete

#-------------------------------------------------------------------------------
h3lpr_tar: $(TAR_DIR)/$(H3LPR_DIR).tar.gz

$(TAR_DIR)/$(H3LPR_DIR).tar.gz: | $(TAR_DIR)
ifdef H3LPR_VER
	cd $(TAR_DIR) &&  \
	rm -rf $(H3LPR_DIR) && \
	git clone git@github.com:van-Rees-Lab/h3lpr.git && \
	mv h3lpr $(H3LPR_DIR) && \
	cd $(H3LPR_DIR) && \
	git checkout $(H3LPR_VER) && \
	cd $(TAR_DIR)  && tar -czvf $(H3LPR_DIR).tar.gz $(H3LPR_DIR) && \
	rm -rf $(H3LPR_DIR)  
else
	touch $(TAR_DIR)/$(H3LPR_DIR).tar.gz
endif

#-------------------------------------------------------------------------------
$(PREFIX)/h3lpr.complete: | $(PREFIX) $(TAR_DIR)/$(H3LPR_DIR).tar.gz
ifdef H3LPR_VER
	mkdir -p $(COMP_DIR)  && \
	cd $(COMP_DIR)  && \
	cp $(TAR_DIR)/$(H3LPR_DIR).tar.gz $(COMP_DIR)  && \
	tar -xvf $(H3LPR_DIR).tar.gz  && \
	cd $(H3LPR_DIR) && \
	CC=${DBS_MPICC} CXX=${DBS_MPICXX} \
		CXXFLAGS="$(H3LPR_CXXFLAGS)" CCFLAGS="$(H3LPR_CCFLAGS)" LDFLAGS="$(H3LPR_LDFLAGS)" \
		$(MAKE) install -j 8 && \
	date > $@  && \
	hostname >> $@ && \
	git describe --always --dirty >> $@
else
	touch $(PREFIX)/h3lpr.complete
endif

#-------------------------------------------------------------------------------
.PHONY: h3lpr_info
.NOTPARALLEL: h3lpr_info
h3lpr_info:
ifdef H3LPR_VER
	$(info - H3LPR branch: $(H3LPR_VER))
else
	$(info - H3LPR not built)
endif

#-------------------------------------------------------------------------------
.PHONY: h3lpr_reallyclean
h3lpr_reallyclean: 
	@rm -rf $(TAR_DIR)/$(H3LPR_DIR).tar.gz
#-------------------------------------------------------------------------------
.PHONY: h3lpr_clean
h3lpr_clean: 
	@rm -rf $(PREFIX)/h3lpr.complete

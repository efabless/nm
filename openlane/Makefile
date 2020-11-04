NON_INTERACTIVE_BLOCKS=  nm
CLEAN_NON_INTERACTIVE_BLOCKS = $(foreach block,$(NON_INTERACTIVE_BLOCKS), clean-$(block))


all: $(NON_INTERACTIVE_BLOCKS) 

$(NON_INTERACTIVE_BLOCKS) : % : input/%/config.tcl 
ifeq ($(OPENLANE_ROOT),)
	@echo "Please export OPENLANE_ROOT"
	@exit 1
endif
	@echo "Executing ${OPENLANE_ROOT}/flow.tcl -design ./input/$* -run_path ./runs -save_path .. -save -tag $* -overwrite"
	@echo "###############################################"
	@sleep 1
	@${OPENLANE_ROOT}/flow.tcl -design ./input/$* -run_path ./runs -save_path .. -save -tag $* -overwrite

clean: 
	@echo "Use clean_all to clean everything :)"

clean_all: $(CLEAN_NON_INTERACTIVE_BLOCKS)

$(CLEAN_NON_INTERACTIVE_BLOCKS): clean-% :
	rm -rf runs/$*
	rm -rf ../gds/$**
	rm -rf ../mag/$**
	rm -rf ../lef/$**

TOPLEVEL_LANG = verilog

VERILOG_SOURCES = ../hdl/common/d_latch.v ../hdl/common/d_flip_flop.v ./test_module.v

TOPLEVEL = test_module

MODULE = test

include $(shell cocotb-config --makefiles)/Makefile.sim 
clean:
	@rm -rf sim_build __pycache__ results.xml *.vcd
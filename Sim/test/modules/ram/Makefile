# Directories
HDL_DIR_COMMON = ../../../hdl/common
HDL_DIR_MODULE = ../../../hdl/modules
SIM_DIR = ./simulation

# Automatically find all Verilog source files in HDL and TEST directories
HDL_SRCS_COMMON = $(wildcard $(HDL_DIR_COMMON)/*.v)
HDL_SRCS = $(HDL_SRCS_COMMON) $(HDL_DIR_MODULE)/ram.v 

TEST_SRCS = ram_tb.v

# Output binary for simulation
TB_BINARY = $(SIM_DIR)/testbench.out

# Compiler and simulator
IVERILOG = iverilog
VVP = vvp

# Compilation flags
IVERILOG_FLAGS = -o $(TB_BINARY)

# Default target: compile and run the testbench
all: run

# Compile the testbench (compile all HDL and testbench files)
compile:
	@mkdir -p $(SIM_DIR)  # Ensure simulation directory exists
	$(IVERILOG) $(IVERILOG_FLAGS) $(HDL_SRCS) $(TEST_SRCS)

# Run the compiled simulation
run: compile
	$(VVP) $(TB_BINARY)

# Clean simulation files
clean:
	rm -rf $(SIM_DIR)

# Additional help target
help:
	@echo "Makefile targets:"
	@echo "  all     - Compile and run the testbench"
	@echo "  compile - Compile the HDL and testbench files"
	@echo "  run     - Run the compiled testbench simulation"
	@echo "  clean   - Remove generated simulation files"


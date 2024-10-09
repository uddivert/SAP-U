# Directories
HDL_DIR = ./hdl/common
TEST_DIR = ./test
SIM_DIR = ./simulation

# Automatically find all Verilog source files in HDL and TEST directories
HDL_SRCS = $(wildcard $(HDL_DIR)/*.v)
TEST_SRCS = $(wildcard $(TEST_DIR)/*.v)

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
	$(IVERILOG) $(IVERILOG_FLAGS) $(HDL_SRCS) $(TEST_SRCS)

# Run the compiled simulation
run: compile
	$(VVP) $(TB_BINARY)

# Clean simulation files
clean:
	rm -f $(TB_BINARY)


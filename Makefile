VERILATOR := verilator

# Verilator arguments for both lint and simulation
VL_COMMON_ARGS :=

# Verilator lint arguments
VL_LINT_COMMON_ARGS := $(VL_COMMON_ARGS) -Wall
VL_RTL_LINT_ARGS := $(VL_LINT_COMMON_ARGS) --no-timing
VL_TB_LINT_ARGS := $(VL_LINT_COMMON_ARGS) --timing

# Verilator simulation arguments
VL_SIM_COMMON_ARGS := $(VL_COMMON_ARGS)
ifeq ($(WAVE), vcd)
VL_SIM_COMMON_ARGS += --trace
else ifeq ($(WAVE), fst)
VL_SIM_COMMON_ARGS += --trace-fst
endif
ifeq ($(ASSERT), 1)
VL_SIM_COMMON_ARGS += --assert
endif
ifeq ($(COVERAGE), 1)
VL_SIM_COMMON_ARGS += --coverage
endif

VL_SVTB_SIM_ARGS := $(VL_SIM_COMMON_ARGS) --timing

# Name of the IP block
IP_NAME := aprecv

# Top level module name of RTL and Testbench
RTL_TOP_NAME := srad_aprs_receiver_top
TB_TOP_NAME := srad_aprs_receiver_tb

# File list of RTL and Testbench
RTL_FLIST := rtl/$(IP_NAME).f
TB_FLIST := tb/$(IP_NAME)_tb.f

# Lint
.PHONY: lint-rtl
lint-rtl:
	$(VERILATOR) --lint-only $(VL_RTL_LINT_ARGS) -F $(RTL_FLIST) --top $(RTL_TOP_NAME)

.PHONY: lint-tb
lint-tb:
	$(VERILATOR) --lint-only $(VL_TB_LINT_ARGS) -F $(RTL_FLIST) -F $(TB_FLIST) --top $(TB_TOP_NAME)

# SystemVerilog Testbench Simulation
# Build simulation executable
sim/obj_dir/V$(TB_TOP_NAME):
	mkdir -p sim
	$(VERILATOR) --cc --exe --main $(VL_SVTB_SIM_ARGS) --top $(TB_TOP_NAME) -F $(RTL_FLIST) -F $(TB_FLIST) -Mdir sim/obj_dir
	$(MAKE) -C sim/obj_dir -f V$(TB_TOP_NAME).mk

.PHONY: build-sim
build-sim: sim/obj_dir/V$(TB_TOP_NAME)

# Run simulation
.PHONY: run-sim
run-sim: sim/obj_dir/V$(TB_TOP_NAME)
	cd sim ; ./obj_dir/V$(TB_TOP_NAME) $(SIM_ARGS)

# Clean
.PHONY: clean
clean:
	rm -rf sim/*

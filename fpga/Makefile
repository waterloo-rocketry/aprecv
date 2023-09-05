OUTDIR=outflow
VERILATOR_FLAGS=-Wno-TIMESCALEMOD -Wno-WIDTHEXPAND --build-jobs 0

all: sim

sim: $(OUTDIR)/Vsim
	./$(OUTDIR)/Vsim

.PHONY: clean
clean:
	$(RM) -rf $(OUTDIR)

# TODO not taking advantage of make's dependency here, improve it later
$(OUTDIR)/V%: *.v $(wildcard ip/*/*.v)
	verilator --binary --trace $(patsubst %,-I%,$(wildcard ip/*)) $(VERILATOR_FLAGS) --Mdir $(OUTDIR) sim.v

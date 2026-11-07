iverilog -o top.vvp top.v top_tb.v program_counter.v instruction_memory.v register.v immediate_generator.v control_unit.v alu_control.v alu_unit.v mux.v adder.v and.v data_memory.v branch_comp.v fir_bandpass.v

vvp top.vvp

gtkwave top.vcd

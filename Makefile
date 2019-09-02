.PHONY: all run clean

program?=asm/program/program.asm

all: tera_asm program.bin tera

program.bin: $(program) tera_asm
	@echo Assembling program.bin from \"$<\"...
	@./tera_asm $<

tera: src/*.v
	@echo Compiling TERA Computer Verilog source...
	@iverilog -o $@ $^

tera_asm: asm/assembler.c
	@echo Compiling TERA Assembler...
	@gcc -o $@ $<

run:
	@echo Running TERA Computer using program.bin...
	@./tera

clean:
	rm -f tera tera_asm program.bin dumpfile.vcd

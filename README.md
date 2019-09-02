TERA: The Eight-bit Register Architecture
=========================================

## Description ##

This is a behavioral-level Verilog computer implementation of TERA (The Eight-bit Register Architecture) for course ECE-151.
TERA is a RISC-type architecture, which employs a total of sixteen instructions.
In order to make the most of the 8-bit constraint, each instruction is associated with a corresponding 8-bit register (yielding a total of sixteen 8-bit registers).

The full documentation can be found under the `doc/` directory.

## Dependencies ##

* Icarus Verilog
* gcc
* make

## Compilation and Usage ##

To see the 8-bit TERA computer work, simply execute the following:

```bash
git clone https://github.com/archwa/tera_computer.git
cd tera_computer
make
make run
```

To assemble other programs besides asm/program/program.asm, the input assembly filepath must be passed in by setting the program variable in the Makefile.
This can be achieved by adding `program=[path/to/assembly/program]` after make, like so:

```bash
make program=asm/program/nested.asm
```

There are also phony targets `run` and `clean`.
`make run` will run the compiled Verilog computer, and `make clean` will remove all built files.
If, for any reason, the computer hangs during program execution, `\^c` will halt it (when using Icarus Verilog).
If there is a single greater than sign `>` present in the terminal, enter the text `finish` to exit the Verilog interpreter.

An assembler was also written using C to make building and testing the programs easier.  
Running `make` in this new directory will build the computer, assembler, and the program.
By default, it will assemble program.asm in the directory asm/program/.  

In the same directory, there are 2 other sample programs provided: **leaf.asm** and **nested.asm**:

* **leaf.asm** shows how a leaf procedure in TERA assembly appears and demonstrates the computer's ability to run such procedures by executing a routine that doubles a number until it is greater than 48.  

* **nested.asm** demonstrates the computer's ability to perform nested procedures by recursively calculating a summation of numbers less than or equal to the number in the **$arg1** register.  


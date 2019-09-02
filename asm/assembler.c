#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct {
	const char * token;
	const char * value;
} 

//instruction map
iMap[] = {
	{"not", "0001"},
	{"and", "0010"},
	{"or", "0011"},
	{"add", "0100"},
	{"rlf", "0101"},
	{"rrt", "0110"},
	{"sle", "0111"},
	{"sge", "1000"},
	{"bfs", "1001"},
	{"jal", "1010"},
	{"lli", "1011"},
	{"lhi", "1100"},
	{"lw", "1101"},
	{"sw", "1110"}},
	// mtr (move val($mov) into register)
	// rtm (move val(register) into $mov)

//register map
rMap[] = {
	{"$zero", "0000"},
	{"$not", "0001"}, {"$arg0", "0001"}, // alias for general purpose register
	{"$and", "0010"},
	{"$or", "0011"},
	{"$add", "0100"},
	{"$rlf", "0101"},
	{"$rrt", "0110"},
	{"$sle", "0111"},
	{"$sge", "1000"},
	{"$bfs", "1001"}, {"$arg1", "1001"}, // alias for general purpose register
	{"$jal", "1010"},
	{"$lli", "1011"}, {"$arg2", "1011"}, // alias for general purpose register
	{"$lhi", "1100"}, {"$arg3", "1100"}, // alias for general purpose register
	{"$lw", "1101"},
	{"$sw", "1110"}};
	// exclude $mov register (which would complicate instructions)


int main (int argc, char *argv[]) {
	FILE * fpin, * fpout;						// input file and output file pointers
	char * command[64], line[256], * token;				// misc. buffers
	int i = 0, j = 256, k = 0, noerr = 0, abort = 0;		// misc. vars + silly error tracking thingies

	// check for file I/O errors
	if (!(fpout = fopen("program.bin", "w+b"))) {
		// could not open the output file to write to
		printf("ERROR: File \"asm/program/program.bin\" could not be opened for writing!\n");
		exit(1);
	}

	if (argc < 2) {
		// no arguments / file name given
		printf("ERROR: No input file specified!\n");
		exit(1);
	} else if (argc == 2) {
		if (!(fpin = fopen(argv[1], "rb"))) {
		// specified file could not be opened
			printf("ERROR: File \"%s\" could not be opened!\n", argv[1]);
			exit(1);
		}
	} else {
		// too many arguments were given; interpret these as extra files
		printf("ERROR: Multiple input files! Please use only one input file.\n");
		exit(1);
	}

	
	// line parsing + replacement to output file
	while (fgets(line, 255, fpin)) {
		noerr = 0;						// set the "no error" flag to 0
		++k;							// increment the line number

		for (i = 0; line[i]; ++i) line[i] = tolower(line[i]);	// make the characters in the line lower-case
		if (line[0] == '#' || line[0] == '\n') continue;	// if the line is a comment or a blank space, skip parsing

		token = strtok(line, " \n\t");				// begin tokenizing the input line

		// further tokenize the input line
		for (i = 0; token; ++i) {
			command[i] = token;
			token = strtok(NULL, " \n\t");
		}

		for (i = 0; iMap[i].token; ++i) {
			if (!strcmp(command[0], iMap[i].token)) {
				// if the first part of the instruction matches one of those given in the instruction map
				fputs(iMap[i].value, fpout);
				noerr = 1;
				break;
			} else if (!strcmp(command[0], "mtr")) {
				// handle storing of $mov register to another register
				fputs("1111", fpout);
				noerr = 1;
				break;
			} else if (!strcmp(command[0], "rtm")) {
				// handle loading of $mov register
				noerr = 1;
				break;
			}
		}

		// if noerr is 0, there HAS to be some form of error with the instruction	
		if (!noerr) {
			abort = 1;
			printf("%s:%d: error: Invalid instruction \"%s\"\n", argv[1], k, command[0]);
		}


		// TODO:    - Make the immediate values able to be written in decimal, hex, or binary based on the letter given
		//	    - Add PC-relative jumps and addressing	
		//	    - Add support for labels, and jumping to those labels (!!!); this makes linking MUCH easier
		//	    - Check to see if the input number for immediate values is actually valid (not just check for a length/1111)
		//	    - Use a different form of error tracking (don't use noerr--this is dumb)
	
	
		noerr = 0;	// set the "no error" flag to 0 again to check for more errors with the second part of the input line
		for (i = 0; rMap[i].token; ++i) {
			if (!strcmp(command[1], rMap[i].token)) {
				// if second part of instruction is found as a register, print its value
				fputs(rMap[i].value, fpout);
				// if instruction is register to $mov, print $mov register address (1111)
				if (!strcmp(command[0], "rtm")) fputs("1111", fpout);
				noerr = 1;
				break;
			} else if ((!strcmp(command[0], "lli") || !strcmp(command[0], "lhi")) && strcmp(command[1], "1111") && strlen(command[1]) == 4) {
				// else, if the second part of the instruction is found, it must be a number (immediate instruction)
				// and the first part of the instruction must be an immediate instruction (load low/high immediate)
				fputs(command[1], fpout);
				noerr = 1;
				break;
			}
		}

		// if noerr is 0, there HAS to be some form of error with the instruction operand (not a register, or invalid immediate value)
		if (!noerr) {
			abort = 1;
			printf("%s:%d: error: Invalid instruction operand \"%s\"!\n", argv[1], k, command[1]);
			// if the input was an immediate value of 1111, tell the user that this is not allowed within TERA ISA
			if (!strcmp(command[1], "1111")) printf("  [!!!]  Loading \"1111\" values into $mov is prohibited\n");
		}

		fputc('\n', fpout);	// make a  newline for 
		--j;			// decrement the "number of lines remaining" variable
	}

	// print 00000000 for all the lines that remain (basically a bunch of no operations)
	for (i = 0; i < j; ++i) {
		fputs("00000000\n", fpout);
	}

	// close both input file and output file
	fclose(fpin);
	fclose(fpout);


	// if a serious error was encountered, abort the program; delete the output file
	if (abort) {
		remove("asm/program/program.bin");
		printf("\nAborting...\n\n");
	}

	return 0;
}

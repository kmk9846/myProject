#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define NUMMEMORY 65536 /* maximum number of data words in memory */
#define NUMREGS 8 /* number of machine registers */
#define MAXLINELENGTH 1000

#define ADD 0
#define NOR 1
#define LW 2
#define SW 3
#define BEQ 4
#define JALR 5 /* JALR will not implemented for this project */
#define HALT 6
#define NOOP 7

#define NOOPINSTRUCTION 0x1c00000

typedef struct IFIDStruct {
	int instr;
	int pcPlus1;
} IFIDType;

typedef struct IDEXStruct {
	int instr;
	int pcPlus1;
	int readRegA;
	int readRegB;
	int offset;
} IDEXType;

typedef struct EXMEMStruct {
	int instr;
	int branchTarget;
	int aluResult;
	int readRegB;
} EXMEMType;

typedef struct MEMWBStruct {
	int instr;
	int writeData;
} MEMWBType;

typedef struct WBENDStruct {
	int instr;
	int writeData;
} WBENDType;

typedef struct stateStruct {
	int pc;
	int instrMem[NUMMEMORY];
	int dataMem[NUMMEMORY];
	int reg[NUMREGS];
	int numMemory;
	IFIDType IFID;
	IDEXType IDEX;
	EXMEMType EXMEM;
	MEMWBType MEMWB;
	WBENDType WBEND;
	int cycles; /* number of cycles run so far */
} stateType;

void printState(stateType *statePtr);
void printInstruction(int instr);
int convertNum(int num);
void forwarding(const stateType, IDEXType*); // for hazard

int
main(int argc, char *argv[])
{
	char line[MAXLINELENGTH];
	stateType state;
	FILE *filePtr;
	
	if (argc != 2) {
		printf("error: usage: %s <machine-code file>\n", argv[0]);
		exit(1);
	}
	
	filePtr = fopen(argv[1], "r");
	if (filePtr == NULL) {
		printf("error: can't open file %s\n", argv[1]);
		perror("fopen");
		exit(1);
	}
	
	for (state.numMemory = 0; fgets(line, MAXLINELENGTH, filePtr) != NULL; state.numMemory++) {
		if (sscanf(line, "%d", &state.instrMem[state.numMemory]) != 1) {
			printf("error in reading address %d\n", state.numMemory);
			exit(1);
		}

		state.dataMem[state.numMemory] = state.instrMem[state.numMemory];
		printf("memory[%d]=%d\n", state.numMemory, state.instrMem[state.numMemory]);

		if (state.numMemory >= NUMMEMORY)
			exit(1);
	}

	/* project 2 */

	printf( "%d memory words\n", state.numMemory );
	printf( "\tinstruction memory:\n" );

	for(int i = 0; i < state.numMemory; i++)
	{
		printf( "\t\tinstrMem[ %d ] ", i );
		printInstruction(state.instrMem[i]);
	}

	// initialized
	state.cycles = 0;
	state.pc = 0;

	for (int i = 0; i < NUMREGS; i++)
		state.reg[i] = 0;

	state.IFID.instr = NOOPINSTRUCTION;
	state.IDEX.instr = NOOPINSTRUCTION;
	state.EXMEM.instr = NOOPINSTRUCTION;
	state.MEMWB.instr = NOOPINSTRUCTION;
	state.WBEND.instr = NOOPINSTRUCTION;

	stateType newState;
	int op, flush = 0;

	while (1) {
		printState(&state);
		
		/* check for halt */
		if ((state.MEMWB.instr>>22) == HALT) {
			printf("machine halted\n");
			printf("total of %d cycles executed\n", state.cycles);
			exit(0);
		}
		
		newState = state;
		newState.cycles++;

		/* --------------------- IF stage --------------------- */
		IFIDType output;

		output.instr = state.instrMem[state.pc];
		output.pcPlus1 = state.pc + 1;

		newState.pc = output.pcPlus1;
		newState.IFID = output;

		/* --------------------- ID stage --------------------- */
		IFIDType input2 = state.IFID;
		IDEXType output2;

		output2.instr = input2.instr;
		output2.pcPlus1 = input2.pcPlus1;

		output2.readRegA = state.reg[((input2.instr>>19) & 0x7)];
		output2.readRegB = state.reg[((input2.instr>>16) & 0x7)];
		output2.offset = (input2.instr & 0xFFFF);
		output2.offset = convertNum(output2.offset);

		int regA = ((output2.instr>>19) & 0x7);
		int regB = ((output2.instr>>16) & 0x7);
		int res = (state.IDEX.instr>>22) == LW && 
				(regA == ((state.IDEX.instr>>16) & 0x7) || regB == ((state.IDEX.instr>>16) & 0x7));
		
		if (res == 1) { // data hazard
			newState.pc = state.pc;
			newState.IFID = input2;
			output2.instr = NOOPINSTRUCTION;
			output2.pcPlus1 = output2.readRegA = output2.readRegB = output2.offset = 0;
		}
		newState.IDEX = output2;
		
		/* --------------------- EX stage --------------------- */
		IDEXType input3 = state.IDEX;
		EXMEMType output3;
		
		if (flush == 1) {
			output3.aluResult = 0;
			flush = 0;
		}

		output3.instr = input3.instr;
		forwarding(state, &input3);

		int dataRegA = input3.readRegA;
		int dataRegB = input3.readRegB;
		int offset = input3.offset;

		output3.readRegB = dataRegB;
		output3.branchTarget = input3.pcPlus1 + offset;

		switch((state.IDEX.instr>>22)) {
			case ADD:
				output3.aluResult = dataRegA + dataRegB;
				break;
			case NOR:
				output3.aluResult = ~(dataRegA | dataRegB);
				break;
			case LW:
			case SW:
				output3.aluResult = dataRegA + offset;
				break;
			case BEQ:
				output3.aluResult = dataRegA - dataRegB;
				break;
			case JALR:
			case HALT:
				break;
			case NOOP:
				break;
			default: 
				printInstruction(state.IDEX.instr);
				exit(1);
				break;
		}
		newState.EXMEM = output3;

		/* --------------------- MEM stage --------------------- */
		EXMEMType input4 = state.EXMEM;
		MEMWBType output4;

		output4.instr = input4.instr;		
		op = (input4.instr>>22);

		if (op == ADD || op == NOR)
			output4.writeData = input4.aluResult;
		else if (op == LW)
			output4.writeData = state.dataMem[input4.aluResult];
		else if (op == SW)
			newState.dataMem[input4.aluResult] = input4.readRegB;

		newState.MEMWB = output4;
		
		if ((state.EXMEM.instr>>22) == BEQ && state.EXMEM.aluResult == 0) {
			newState.IFID.instr = NOOPINSTRUCTION;
			newState.IFID.pcPlus1 = 0;
			newState.IDEX.instr = NOOPINSTRUCTION;
			newState.IDEX.pcPlus1 = newState.IDEX.readRegA = newState.IDEX.readRegB = newState.IDEX.offset = 0;
			newState.EXMEM.instr = NOOPINSTRUCTION;
			newState.EXMEM.branchTarget = newState.EXMEM.aluResult = newState.EXMEM.readRegB = 0;
			newState.pc = state.EXMEM.branchTarget;
			flush = 1;
		}

		/* --------------------- WB stage --------------------- */
		MEMWBType input5 = state.MEMWB;
		WBENDType output5;

		output5.instr = input5.instr;
		output5.writeData = input5.writeData;
		op = (input5.instr>>22);

		int destReg;

		if (op == ADD || op == NOR) {
			destReg = (input5.instr & 0xFFFF);
			newState.reg[destReg] = input5.writeData;
		} else if (op == LW) {
			destReg = ((input5.instr>>16) & 0x7);
			newState.reg[destReg] = input5.writeData;
		}
		newState.WBEND = output5;

		/* ---------------------------------------------------- */
		state = newState; /* this is the last statement before end of the loop.
							It marks the end of the cycle and updates the
							current state with the values calculated in this
							cycle */
	}
}

void
printState(stateType *statePtr)
{
	int i;
	printf("\n@@@\nstate before cycle %d starts\n", statePtr->cycles);
	printf("\tpc %d\n", statePtr->pc);
	
	printf("\tdata memory:\n");
		for (i=0; i<statePtr->numMemory; i++) {
			printf("\t\tdataMem[ %d ] %d\n", i, statePtr->dataMem[i]);
		}
	printf("\tregisters:\n");
		for (i=0; i<NUMREGS; i++) {
			printf("\t\treg[ %d ] %d\n", i, statePtr->reg[i]);
		}
	printf("\tIFID:\n");
		printf("\t\tinstruction ");
		printInstruction(statePtr->IFID.instr);
		printf("\t\tpcPlus1 %d\n", statePtr->IFID.pcPlus1);
	printf("\tIDEX:\n");
		printf("\t\tinstruction ");
		printInstruction(statePtr->IDEX.instr);
		printf("\t\tpcPlus1 %d\n", statePtr->IDEX.pcPlus1);
		printf("\t\treadRegA %d\n", statePtr->IDEX.readRegA);
		printf("\t\treadRegB %d\n", statePtr->IDEX.readRegB);
		printf("\t\toffset %d\n", statePtr->IDEX.offset);
	printf("\tEXMEM:\n");
		printf("\t\tinstruction ");
		printInstruction(statePtr->EXMEM.instr);
		printf("\t\tbranchTarget %d\n", statePtr->EXMEM.branchTarget);
		printf("\t\taluResult %d\n", statePtr->EXMEM.aluResult);
		printf("\t\treadRegB %d\n", statePtr->EXMEM.readRegB);
	printf("\tMEMWB:\n");
		printf("\t\tinstruction ");
		printInstruction(statePtr->MEMWB.instr);
		printf("\t\twriteData %d\n", statePtr->MEMWB.writeData);
	printf("\tWBEND:\n");
		printf("\t\tinstruction ");
		printInstruction(statePtr->WBEND.instr);
		printf("\t\twriteData %d\n", statePtr->WBEND.writeData);
}

void
printInstruction(int instr)
{
	char opcodeString[10];

	int nOpCode = (instr>>22);	
	if (nOpCode == ADD) {
		strcpy(opcodeString, "add");
	} else if (nOpCode == NOR) {
		strcpy(opcodeString, "nor");
	} else if (nOpCode == LW) {
		strcpy(opcodeString, "lw");
	} else if (nOpCode == SW) {
		strcpy(opcodeString, "sw");
	} else if (nOpCode == BEQ) {
		strcpy(opcodeString, "beq");
	} else if (nOpCode == JALR) {
		strcpy(opcodeString, "jalr");
	} else if (nOpCode == HALT) {
		strcpy(opcodeString, "halt");
	} else if (nOpCode == NOOP) {
		strcpy(opcodeString, "noop");
	} else {
		strcpy(opcodeString, "data");
	}
	
	printf("%s %d %d %d\n", opcodeString, ((instr>>19) & 0x7), ((instr>>16) & 0x7), (instr & 0xFFFF));
}

int convertNum(int num)
{
	/* convert a 16-bit number into a 32-bit Sun integer */
	if (num & (1<<15) ) {
		num -= (1<<16);
	}
	return(num);
}

void forwarding(const stateType state, IDEXType* IDEX)
{
	int regA = ((IDEX->instr>>19) & 0x7);
	int regB = ((IDEX->instr>>16) & 0x7);
	int op;

	// WBEND
	op = (state.WBEND.instr>>22);
	if (op == ADD || op == NOR) {
		if(regA == (state.WBEND.instr & 0xFFFF))
			IDEX->readRegA = state.WBEND.writeData;
		if(regB == (state.WBEND.instr & 0xFFFF))
			IDEX->readRegB = state.WBEND.writeData;
	} else if (op == LW) {
		if(regA == ((state.WBEND.instr>>16) & 0x7))
			IDEX->readRegA = state.WBEND.writeData;
		if(regB == ((state.WBEND.instr>>16) & 0x7))
			IDEX->readRegB = state.WBEND.writeData;
	}

	// MEM/WB
	op = (state.MEMWB.instr>>22);
	if (op == ADD || op == NOR) {
		if(regA == (state.MEMWB.instr & 0xFFFF)) 
			IDEX->readRegA = state.MEMWB.writeData;
		if(regB == (state.MEMWB.instr & 0xFFFF)) 
			IDEX->readRegB = state.MEMWB.writeData;
	} else if (op == LW) {
		if(regA == ((state.MEMWB.instr>>16) & 0x7))
			IDEX->readRegA = state.MEMWB.writeData;
		if(regB == ((state.MEMWB.instr>>16) & 0x7))
			IDEX->readRegB = state.MEMWB.writeData;
	}

	// EX/MEM
	op = (state.EXMEM.instr>>22);
	if (op == ADD || op == NOR) {
		if(regA == (state.EXMEM.instr & 0xFFFF))
			IDEX->readRegA = state.EXMEM.aluResult;
		if(regB == (state.EXMEM.instr & 0xFFFF))
			IDEX->readRegB = state.EXMEM.aluResult;
	} else if (op == LW) {
		if (regA == ((state.EXMEM.instr>>16) & 0x7) || regB == ((state.EXMEM.instr>>16) & 0x7))
			exit(1);
	}
}

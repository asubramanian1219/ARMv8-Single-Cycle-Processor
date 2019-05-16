`define OPCODE_ANDREG 11'b?0001010??? //opcodes
`define OPCODE_ORRREG 11'b?0101010???
`define OPCODE_ADDREG 11'b?0?01011???
`define OPCODE_SUBREG 11'b?1?01011???

`define OPCODE_ADDIMM 11'b?0?10001???
`define OPCODE_SUBIMM 11'b?1?10001???

`define OPCODE_MOVZ   11'b110100101??

`define OPCODE_B      11'b?00101?????
`define OPCODE_CBZ    11'b?011010????

`define OPCODE_LDUR   11'b??111000010
`define OPCODE_STUR   11'b??111000000

module control(
    output reg reg2loc,
    output reg alusrc,
    output reg mem2reg,
    output reg regwrite,
    output reg memread,
    output reg memwrite,
    output reg branch,
    output reg uncond_branch,
    output reg [3:0] aluop,
    output reg [2:0] signop,
    input [10:0] opcode
);

always @(*)
begin
    casez (opcode)

        /* Add cases here for each instruction your processor supports */

        default:
        begin
            reg2loc       <= 1'bx;
            alusrc        <= 1'bx;
            mem2reg       <= 1'bx;
            regwrite      <= 1'b0;
            memread       <= 1'b0;
            memwrite      <= 1'b0;
            branch        <= 1'b0;
            uncond_branch <= 1'b0;
            aluop         <= 4'bxxxx;
            signop        <= 3'bxxx;
            
        end
        `OPCODE_ANDREG:
        begin
            reg2loc <=1'b0; //Rn
          alusrc <=1'b0; //Input to ALU is the second read output from the RegFile
          	mem2reg <= 1'b0; //Memory is unused
          	regwrite <= 1'b1; //Memory will be written to, since this is an R-type instruction
          	memread       <= 1'b0; 
            memwrite      <= 1'b0;
            branch        <= 1'b0; //No branching involved, obviously
            uncond_branch <= 1'b0;
            aluop         <= 4'b0000; //add
          signop        <= 3'bxxx; //sign extender is unused.
            
        end
      	`OPCODE_ORRREG:
          begin
            reg2loc <=1'b0; //Everything for all i-type instructions will be the same, except for the alu op code
          	alusrc <=1'b0;
          	mem2reg <= 1'b0;
          	regwrite <= 1'b1;
          	memread       <= 1'b0;
            memwrite      <= 1'b0;
            branch        <= 1'b0;
            uncond_branch <= 1'b0;
            aluop         <= 4'b0001;
            signop        <= 3'bxxx;
            
          end
      	`OPCODE_ADDREG:
          begin
            reg2loc <=1'b0;
          	alusrc <=1'b0;
          	mem2reg <= 1'b0;
          	regwrite <= 1'b1;
          	memread       <= 1'b0;
            memwrite      <= 1'b0;
            branch        <= 1'b0;
            uncond_branch <= 1'b0;
            aluop         <= 4'b0010;
            signop        <= 3'bxxx;
            
          end
      	`OPCODE_SUBREG:
          begin
            
          	reg2loc <=1'b0;
          	alusrc <=1'b0;
          	mem2reg <= 1'b0;
          	regwrite <= 1'b1;
          	memread       <= 1'b0;
            memwrite      <= 1'b0;
            branch        <= 1'b0;
            uncond_branch <= 1'b0;
            aluop         <= 4'b0110;
            signop        <= 3'bxxx;
            
          end
      	`OPCODE_ADDIMM:
          begin
            reg2loc <=1'bx; //second register not needed.
            alusrc <=1'b1; //Output from sign extender
          	mem2reg <= 1'b0; //memory unused
          	regwrite <= 1'b1; //register is being written to
          	memread       <= 1'b0; //data memory unused
            memwrite      <= 1'b0;
            branch        <= 1'b0; //no branches... pretty obvious
            uncond_branch <= 1'b0; 
            aluop         <= 4'b0010; //add
            signop        <= 3'b000; //sign extender set to I type
           
          end
      	`OPCODE_SUBIMM:
          begin //exactly the same as previous except for the  ALU opcode
            reg2loc <=1'bx;
          	alusrc <=1'b1;
          	mem2reg <= 1'b0;
          	regwrite <= 1'b1;
          	memread       <= 1'b0;
            memwrite      <= 1'b0;
            branch        <= 1'b0;
            uncond_branch <= 1'b0;
            aluop         <= 4'b0110;
            signop        <= 3'b000;
          end
      	`OPCODE_B:
          begin
            reg2loc <=1'bx;//second register unused
          	alusrc <=1'bx; //ALU unused
          	mem2reg <= 1'bx; //memory unused
          	regwrite <= 1'b0; //no writing to register
          	memread       <= 1'b0; //memory not used
            memwrite      <= 1'b0;
            branch        <= 1'bx; //if uncondbranch is 1, a branch will always happen, so we don't care about what the condition branch is
            uncond_branch <= 1'b1; //obviously
            aluop         <= 4'bxxxx; //ALU is unused
            signop        <= 3'b010; //signop is set to B type
            
          end
          `OPCODE_CBZ:
            begin
              reg2loc <=1'b1; //second register is specified by I[4:0]
              alusrc <=1'b0; //output from sign extender
              mem2reg <= 1'bx; //memory unused
              regwrite <= 1'b0; //not writing  to a register
              memread       <= 1'b0;
              memwrite      <= 1'b0;
              branch        <= 1'b1; //conditional branch is 1
              uncond_branch <= 1'b0;//We don't ALWAYS want a branch, so uncondition branch MUST be 0.
              aluop         <= 4'b0111; //pass B
              signop        <= 3'b011; //CB type
            end
      	`OPCODE_LDUR:
          begin
          	reg2loc <=1'bx; //register unused.
          	alusrc <=1'b1; //output of register B
          	mem2reg <= 1'b1; //memory contents written to register
          	regwrite <= 1'b1; //will write to register
          	memread       <= 1'b1; //Memory will be read
            memwrite      <= 1'b0; //But not  written to.
            branch        <= 1'b0; //obivous
            uncond_branch <= 1'b0; //this too
            aluop         <= 4'b0010; //add reg output and byte offset together
            signop        <= 3'b001; //D type
            
          end
      	`OPCODE_STUR:
          begin
            reg2loc <=1'b1; //same as above
          	alusrc <=1'b1; 
          	mem2reg <= 1'bx; //we aren't writing to register
          	regwrite <= 1'b0; //we aren't writing to register
          	memread       <= 1'b0; //memory not being read
            memwrite      <= 1'b1;//but it is written to
            branch        <= 1'b0;//obvious
            uncond_branch <= 1'b0;//obvious
            aluop         <= 4'b0010;//same as above
            signop        <= 3'b001;//d type
          end
         `OPCODE_MOVZ:
           begin
            reg2loc <=1'bx;//second register not used
             alusrc <=1'b1; //Sign extender output
          	mem2reg <= 1'b0; //memory unused
          	regwrite <= 1'b1; //result written to register.
          	memread       <= 1'b0; //memory unused
            memwrite      <= 1'b0; 
            branch        <= 1'b0; //obviously
            uncond_branch <= 1'b0;
            aluop         <= 4'b0111; //pass sign ext output into the ALU
             signop        <= 3'b100; //move extend
           end
          	
    endcase
end

endmodule


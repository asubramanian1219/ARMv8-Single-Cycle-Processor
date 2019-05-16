module NextPClogic(NextPC, CurrentPC, SignExtImm64, Branch, ALUZero, Uncondbranch);
  
  input wire signed [63:0] CurrentPC;
  
  input wire signed [63:0] SignExtImm64; //inputs
  
  input wire Branch, ALUZero, Uncondbranch;
  
  output reg [63:0] NextPC; //outputs
  
  always@(*)
  begin
    if(Uncondbranch==1)
      NextPC=CurrentPC+(SignExtImm64<<2); //branch
    else if(Branch==0&&Uncondbranch==0&&ALUZero==0) //default
      NextPC=CurrentPC+4; //don't branch
    else if(Branch==0&&Uncondbranch==0&&ALUZero==1) //if output of ALU is zero but branch is not desired
    	NextPC=CurrentPC+4; //don't branch
 	else if(Branch==1&&Uncondbranch==0&&ALUZero==0)
      NextPC=CurrentPC+4; //don't branch since this is a CBZ and  ALUZero is not 1
  	else if(Branch==1&&Uncondbranch==0&&ALUZero==1)
      NextPC=CurrentPC+(SignExtImm64<<2); //branch 
    
  end
endmodule
  
  
  
  
  
  
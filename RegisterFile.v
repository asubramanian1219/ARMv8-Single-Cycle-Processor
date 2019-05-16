// Code your design here
module RegisterFile(BusA, BusB, BusW, RA, RB, RW, RegWr, Clk);
  output [63:0] BusA, BusB; //registers' outputs
  input [63:0] BusW; //Whatever  you're writing into the register.
  input [4:0] RA, RB, RW; //Registers to be read from/written to
  input RegWr; //write enable
  input Clk; //clock

  reg [63:0] regs [31:0]; //regster file itself
  

  assign #2 BusA = regs[RA]; 
  assign #2 BusB = regs[RB];
  
  always@(posedge Clk)
    begin
      regs[31]<=0;
    end
  
  always @ (negedge Clk) 
  begin
    if(RegWr)
      if (RW != 5'd31)
        regs[RW] <= #3 BusW;
      else
      // register 31=XZR
        regs[31] <= #3 'd0; 
  end
endmodule
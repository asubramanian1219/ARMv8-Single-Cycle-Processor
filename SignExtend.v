// Code your design here
`timescale 1ns/1ps


`define I 3'b000
`define D 3'b001
`define B 3'b010
`define CB 3'b011
`define MOV 3'b100

module SignExtend(
  output reg [63:0] exNum,
  input wire [25:0] instr,
  input wire [2:0] ctrl,
  input wire [1:0] ShftAmt
  
);
  always@(*)
    begin
      case(ctrl)
        `I:exNum<={{52{1'b0}},instr[21:10]}; //Sign extend bits 10 to 21 (unsigned immediate)
        `D:exNum<={{55{instr[20]}},instr[20:12]}; //sign extend bits 12 to 20 (address)
        `B:exNum<={{38{instr[25]}},instr[25:0]}; //sign extend branch address
        `CB:exNum<={{45{instr[23]}},instr[23:5]}; //sign extend CB address.
        `MOV:exNum<=({{48{1'b0}},instr[20:5]})<<(ShftAmt*16); //sign extend immediate and shift accordingly.
      endcase
    end
endmodule
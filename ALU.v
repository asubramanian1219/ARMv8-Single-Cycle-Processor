// Code your design here
`timescale 1ns/1ps
`define AND   4'b0000 //This is the ALUop code.
`define OR    4'b0001
`define ADD   4'b0010
`define SUB   4'b0110
`define PassB 4'b0111


module ALU(BusW, BusA, BusB, ALUCtrl, Zero);
    
    parameter n = 64;

    output reg [n-1:0] BusW;
    input  wire [n-1:0] BusA, BusB;
    input wire [3:0] ALUCtrl;
    output wire Zero;
    
    //reg     [n-1:0] BusW;
    
  always @(*) begin
        case(ALUCtrl)
        `AND: begin
			BusW <= #20 BusA&BusB; //and
        end
	    `OR: begin
			BusW <= #20 BusA|BusB;//or
	    end
	   	`ADD: begin
			BusW <= #20 BusA+BusB;//add
        end
        `SUB: begin
			BusW <= #20 BusA-BusB;//sub
		
	    end
        `PassB: begin
			BusW <= #20 BusB; //pass B
	    end
        endcase
    end

  assign Zero = (BusW==0)?1'b1:1'b0; //If the output is 0, set Zero to 1, otherwise set it to 0
endmodule
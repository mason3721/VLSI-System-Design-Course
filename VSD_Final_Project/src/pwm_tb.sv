`timescale 1ns/10ps
`define CYCLE 10
`include "pwm.sv"

module test;


logic [31:0] num;
logic clk;
logic rst;
logic pwm_o_0;
logic pwm_o_1;
logic pwm_o_2;
logic pwm_o_3;

logic [7:0] counter;
logic [31:0] num_local;

  pwm pwm0 (.*
  );

  always #(`CYCLE/2) clk = ~clk;  
  
  
  initial begin
    clk = 0;
    rst = 0;
	
	#(`CYCLE*2)
	rst = 1;
	num = {8'd0,8'd10,8'd250,8'd100};
	
	#(`CYCLE*1000)
	num = {8'd0,8'd15,8'd150,8'd60};
	#(`CYCLE*1000)
    #(`CYCLE*30) $finish;
  end

  initial begin
    $fsdbDumpfile("test.fsdb");
    $fsdbDumpvars("+struct", "+mda", test);
  end
endmodule

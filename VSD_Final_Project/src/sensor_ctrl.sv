module sensor_ctrl(
  input clk,
  input rst,
  // Core inputs
  input sctrl_en,
  input sctrl_clear,
  input [5:0] sctrl_addr,
  // Sensor inputs
  input sensor_ready,
  input [31:0] sensor_out_0,
  input [31:0] sensor_out_1,
  input [31:0] sensor_out_2,
  input [31:0] sensor_out_3,
  input [31:0] sensor_out_4,
  input [31:0] sensor_out_5,
  input [31:0] sensor_out_6,
  input [31:0] sensor_out_7,
  // Core outputs
  output logic sctrl_interrupt,
  output logic [31:0] sctrl_out,
  // Sensor outputs
  output logic sensor_en
);

  logic [31:0] mem[7:0] ;
  logic full;


  always_comb
  begin
    sctrl_out = mem[sctrl_addr];
    sensor_en = (sctrl_en && (~full) && (~sctrl_clear));
    sctrl_interrupt = full;
  end

  
  always_ff@(posedge clk)
  begin
    if (rst) begin
      for (int i=0; i<8; i++)
        mem[i] <= 32'd0;
	end
    else if (sctrl_en && (~full) && sensor_ready) begin
		mem[0] <= sensor_out_0;
		mem[1] <= sensor_out_1;
		mem[2] <= sensor_out_2;
		mem[3] <= sensor_out_3;
		mem[4] <= sensor_out_4;
		mem[5] <= sensor_out_5;
		mem[6] <= sensor_out_6;
		mem[7] <= sensor_out_7;
	 end
  end

  always_ff@(posedge clk)
  begin
    if (rst)
      full <= 1'b0;
    else if (sctrl_clear)
      full <= 1'b0;
    else if (sctrl_en  && sensor_ready)
      full <= 1'b1;
  end
endmodule
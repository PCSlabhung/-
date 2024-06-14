module Checkdigit(
    // Input signals
    in_num,
	in_valid,
	rst_n,
	clk,
    // Output signals
    out_valid,
    out
);

//---------------------------------------------------------------------
//   INPUT AND OUTPUT DECLARATION                         
//---------------------------------------------------------------------
input [3:0] in_num;
input in_valid, rst_n, clk;
output logic out_valid;
output logic [3:0] out;

//---------------------------------------------------------------------
//   LOGIC DECLARATION
//---------------------------------------------------------------------

logic [3:0]counter,counter_in;
logic [3:0] sum, sum_in, bit0, bit1;
//---------------------------------------------------------------------
//   Your design                        
//---------------------------------------------------------------------
assign out_valid = (counter == 0)? 1 : 0;
assign out = (sum == 0)? 15 : 10 - sum;
assign bit0 = (in_num > 4)? in_num + in_num - 10 + 1:in_num + in_num;
assign bit1 = (counter % 2 )? bit0 : in_num;
assign sum_in = (in_valid)?((sum + bit1 > 9)? sum + bit1 - 10: sum + bit1) : 0;
assign counter_in = (in_valid)? counter -1 : 15;

always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		sum <= 10;
		counter <= 15;
	end
	else begin
		counter <= counter_in;
		sum <= sum_in;
	end
end


endmodule
module Divider(
  // Input signals
	clk,
	rst_n,
    in_valid,
    in_data,
  // Output signals
    out_valid,
	out_data
);

//---------------------------------------------------------------------
//   INPUT AND OUTPUT DECLARATION                         
//---------------------------------------------------------------------
input clk, rst_n, in_valid;
input [3:0] in_data;
output logic out_valid, out_data;
 
//---------------------------------------------------------------------
//   LOGIC DECLARATION
//---------------------------------------------------------------------
logic out_data_comb,out_valid_comb;
logic [5:0] curstate, nextstate;
logic [5:0] counter, counter_DFF;
logic [3:0] input1,input2,input3,input4;
logic [3:0] input1_DFF,input2_DFF,input3_DFF,input4_DFF;
logic [3:0] A,B,C,D;
logic [3:0] A_DFF,B_DFF,C_DFF,D_DFF;
logic [3:0] sort1,sort2,sort3,sort4;
logic [3:0] temp1,temp2,temp3,temp4;
logic [3:0] temp_1,temp_2,temp_3,temp_4;
logic [3:0] sort1_DFF,sort2_DFF,sort3_DFF,sort4_DFF;
logic [3:0] temp1_DFF,temp2_DFF,temp3_DFF,temp4_DFF;
logic [3:0] temp_1_DFF,temp_2_DFF,temp_3_DFF,temp_4_DFF;
logic [19:0] divided;
logic [19:0] divided_DFF;
logic [9:0] divisor;
//---------------------------------------------------------------------
//   PARAMETER DECLARATION
//---------------------------------------------------------------------
parameter S_input = 0, S_decode = 1, S_sorting = 2, S_division = 3, S_P2S = 4;
//---------------------------------------------------------------------
//   Your design                        
//---------------------------------------------------------------------
//more bit
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		divided_DFF <= 0;
	end
	else begin
		divided_DFF <= divided;
	end
end
//sorting parameter
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		sort1_DFF <= 0;
		sort2_DFF <= 0;
		sort3_DFF <= 0;
		sort4_DFF <= 0;
		temp1_DFF <= 0;
		temp2_DFF <= 0;
		temp3_DFF <= 0;
		temp4_DFF <= 0;
		temp_1_DFF <= 0;
		temp_2_DFF <= 0;
		temp_3_DFF <= 0;
		temp_4_DFF <= 0;
	end
	else begin
		sort1_DFF <= sort1;
		sort2_DFF <= sort2;
		sort3_DFF <= sort3;
		sort4_DFF <= sort4;
		temp1_DFF <= temp1;
		temp2_DFF <= temp2;
		temp3_DFF <= temp3;
		temp4_DFF <= temp4;
		temp_1_DFF <= temp_1;
		temp_2_DFF <= temp_2;
		temp_3_DFF <= temp_3;
		temp_4_DFF <= temp_4;
	end
end
//input
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		input1_DFF <= 0;
		input2_DFF <= 0;
		input3_DFF <= 0;
		input4_DFF <= 0;
	end
	else begin
		input1_DFF <= input1;
		input2_DFF <= input2;
		input3_DFF <= input3;
		input4_DFF <= input4;
	end
end
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		A_DFF <= 0;
		B_DFF <= 0;
		C_DFF <= 0;
		D_DFF <= 0;
	end
	else begin
		A_DFF <= A;
		B_DFF <= B;
		C_DFF <= C;
		D_DFF <= D;
	end
end
//output
always @(posedge clk or negedge rst_n)begin 
	if(!rst_n)begin
		out_valid <= 0;
		out_data <= 0;
	end
	else begin
		out_data <= out_data_comb;
		out_valid <= out_valid_comb;
	end
end
//FSM
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		curstate <= 0;
	end
	else begin
		curstate <= nextstate;
	end
end
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		counter_DFF <= 0;
	end
	else begin
		counter_DFF <= counter;
	end
end
always @(*)begin
	counter = 0;
	nextstate = 0;
	case(curstate)
		S_input:begin
			if(in_valid)begin
				counter = counter_DFF + 1;
			end
			if(counter_DFF == 3)begin
				nextstate = S_decode;
				counter = 0;
			end
			else begin
				nextstate = S_input;
			end
		end
		S_decode:begin
			nextstate = S_sorting;
			counter = 0;
		end
		S_sorting:begin
			nextstate = S_division;
			counter = 0;
		end
		S_division:begin
			counter = counter_DFF + 1;
			if(counter_DFF == 10)begin
				nextstate = S_P2S;
				counter = 0;
				
			end
			else begin
				nextstate = S_division;
			end
		end
		S_P2S:begin
			counter = counter_DFF + 1;
			
			if(counter_DFF == 9)begin
				nextstate = S_input;
				counter = 0;
			end
			else begin
				nextstate = S_P2S;
			end
		end
	endcase
end
always@(*)begin
	input1 = input1_DFF;
	input2 = input2_DFF;
	input3 = input3_DFF;
	input4 = input4_DFF;
	if(curstate == S_input && in_valid)begin
		case(counter_DFF)
			0:begin
				input1 = in_data;
			end
			1:begin
				input2 = in_data;
			end
			2:begin
				input3 = in_data;
			end
			3:begin
				input4 = in_data;
			end
		endcase
	end
end
always@(*)begin
	A =A_DFF;
	B = B_DFF;
	C= C_DFF;
	D =D_DFF;
	if(curstate == S_decode)begin
		case(input1_DFF)
			4'b0011:A = 0;
			4'b0100:A = 1;
			4'b0101:A = 2;
			4'b0110:A = 3;
			4'b0111:A = 4;
			4'b1000:A = 5;
			4'b1001:A = 6;
			4'b1010:A = 7;
			4'b1011:A = 8;
			4'b1100:A = 9;
			default:A = 0;
		endcase
		case(input2_DFF)
			4'b0011:B = 0;
			4'b0100:B = 1;
			4'b0101:B = 2;
			4'b0110:B = 3;
			4'b0111:B = 4;
			4'b1000:B = 5;
			4'b1001:B = 6;
			4'b1010:B = 7;
			4'b1011:B = 8;
			4'b1100:B = 9;
			default:B = 0;
		endcase
		case(input3_DFF)
			4'b0011:C = 0;
			4'b0100:C = 1;
			4'b0101:C = 2;
			4'b0110:C = 3;
			4'b0111:C = 4;
			4'b1000:C = 5;
			4'b1001:C = 6;
			4'b1010:C = 7;
			4'b1011:C = 8;
			4'b1100:C = 9;
			default:C = 0;
		endcase
		case(input4_DFF)
			4'b0011:D = 0;
			4'b0100:D = 1;
			4'b0101:D = 2;
			4'b0110:D = 3;
			4'b0111:D = 4;
			4'b1000:D = 5;
			4'b1001:D = 6;
			4'b1010:D = 7;
			4'b1011:D = 8;
			4'b1100:D = 9;
			default:D = 0;
		endcase
	end
end

always@(*)begin
	if(curstate == S_sorting)begin
		if(A_DFF > B_DFF)begin
			temp1 = A_DFF;
			temp2 = B_DFF;
		end
		else begin
			temp1 = B_DFF;
			temp2 = A_DFF;
		end
		if(C_DFF > D_DFF)begin
			temp3 = C_DFF;
			temp4 = D_DFF;
		end
		else begin
			temp3 = D_DFF;
			temp4 = C_DFF;
		end
		if(temp1 > temp3)begin
			temp_1 = temp1;
			temp_2 = temp3;
		end
		else begin
			temp_1 = temp3;
			temp_2 = temp1;
		end
		if(temp2 < temp4)begin
			temp_4 = temp2;
			temp_3 = temp4;
		end
		else begin
			temp_4 = temp4;
			temp_3 = temp2;
		end
		sort1 = temp_1;
		sort4 = temp_4;
		if(temp_2 > temp_3)begin
			sort2 = temp_2;
			sort3 = temp_3;
		end
		else begin
			sort2 = temp_3;
			sort3 = temp_2;
		end
	end
	else begin
		sort1 = sort1_DFF;
		sort2 = sort2_DFF;
		sort3 = sort3_DFF;
		sort4 = sort4_DFF;
		temp1 = temp1_DFF;
		temp2 = temp2_DFF;
		temp3 = temp3_DFF;
		temp4 = temp4_DFF;
		temp_1 = temp_1_DFF;
		temp_2 = temp_2_DFF;
		temp_3 = temp_3_DFF;
		temp_4 = temp_4_DFF;
	end
end
logic[19:0] new_divider;
logic [9:0] sum;
logic [9:0] zero;
logic [9:0] subtract;
logic [9:0] back;
assign zero = 0;
always@(*)begin
	divisor = sort2_DFF;
	divided = divided_DFF;
	new_divider = divided_DFF;
	subtract = 0;
	back = 0;
	if(curstate == S_division)begin
		case(counter_DFF)
			0:begin
				sum = 100*sort1_DFF + 10*sort3_DFF + sort4_DFF;
				divided = sum;
				
			end
			1:begin
				new_divider = divided_DFF << 1;
				if(new_divider[19:10] >= divisor)begin
					subtract = new_divider[19:10] - divisor;
					back = new_divider[9:0] + 1;
					divided = { subtract, back};
					
				end
				else begin
					divided = new_divider;
				end
			end
			2:begin
				new_divider = divided_DFF << 1;
				if(new_divider[19:10] >= divisor)begin
					subtract = new_divider[19:10] - divisor;
					back = new_divider[9:0] + 1;
					divided = {subtract , back};
					
				end
				else begin
					divided = new_divider;
				end
			end
			3:begin
				new_divider = divided_DFF << 1;
				if(new_divider[19:10] >= divisor)begin
					subtract = new_divider[19:10] - divisor;
					back = new_divider[9:0] + 1;
					divided = {subtract, back};
					
				end
				else begin
					divided = new_divider;
				end
			end
			4:begin
				new_divider = divided_DFF << 1;
				if(new_divider[19:10] >= divisor)begin
					subtract = new_divider[19:10] - divisor;
					back = new_divider[9:0] + 1;
					divided = {subtract , back};
					
				end
				else begin
					divided = new_divider;
				end
			end
			5:begin
				new_divider = divided_DFF << 1;
				if(new_divider[19:10] >= divisor)begin
					subtract = new_divider[19:10] - divisor;
					back = new_divider[9:0] + 1;
					divided = {subtract , back};
					
				end
				else begin
					divided = new_divider;
				end
			end
			6:begin
				new_divider = divided_DFF << 1;
				if(new_divider[19:10] >= divisor)begin
					subtract = new_divider[19:10] - divisor;
					back = new_divider[9:0] + 1;
					divided = {subtract, back};
					
				end
				else begin
					divided = new_divider;
				end
			end
			7:begin
				new_divider = divided_DFF << 1;
				if(new_divider[19:10] >= divisor)begin
					subtract = new_divider[19:10] - divisor;
					back = new_divider[9:0] + 1;
					divided = {subtract , back};
					
				end
				else begin
					divided = new_divider;
				end
			end
			8:begin
				
				new_divider = divided_DFF << 1;
				if(new_divider[19:10] >= divisor)begin
					subtract = new_divider[19:10] - divisor;
					back = new_divider[9:0] + 1;
					divided = {subtract ,back};
					
				end
				else begin
					divided = new_divider;
				end
			end
			9:begin
				new_divider = divided_DFF << 1;
				if(new_divider[19:10] >= divisor)begin
					subtract = new_divider[19:10] - divisor;
					back = new_divider[9:0] + 1;
					divided = {subtract, back};
					
				end
				else begin
					
					divided = new_divider;
				end
			end
			10:begin
				new_divider = divided_DFF << 1;
				if(new_divider[19:10] >= divisor)begin
					subtract=new_divider[19:10] - divisor;
					back = new_divider[9:0] + 1;
					divided = {subtract, back};
					
				end
				else begin
					divided = new_divider;
				end
			end
		endcase
	end
end
always@(*)begin
	out_valid_comb = 0;
	out_data_comb = 0;
	if(curstate == S_P2S)begin
		case(counter_DFF)
			0:begin
				out_data_comb = divided_DFF[9];
				out_valid_comb = 1;
			end
			1:begin
				out_data_comb = divided_DFF[8];
				out_valid_comb = 1;
			end
			2:begin
				out_data_comb = divided_DFF[7];
				out_valid_comb = 1;
			end
			3:begin
				out_data_comb = divided_DFF[6];
				out_valid_comb = 1;
			end
			4:begin
				out_data_comb = divided_DFF[5];
				out_valid_comb = 1;
			end
			5:begin
				out_data_comb = divided_DFF[4];
				out_valid_comb = 1;
			end
			6:begin
				out_data_comb = divided_DFF[3];
				out_valid_comb = 1;
			end
			7:begin
				out_data_comb = divided_DFF[2];
				out_valid_comb = 1;
			end
			8:begin
				out_data_comb = divided_DFF[1];
				out_valid_comb = 1;
			end
			9:begin
				out_data_comb = divided_DFF[0];
				out_valid_comb = 1;
			end
		endcase
	end
end
endmodule
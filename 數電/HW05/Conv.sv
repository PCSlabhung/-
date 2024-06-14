module Conv(
  // Input signals
  clk,
  rst_n,
  image_valid,
  filter_valid,
  in_data,
  // Output signals
  out_valid,
  out_data
);

//---------------------------------------------------------------------
//   INPUT AND OUTPUT DECLARATION                         
//---------------------------------------------------------------------
parameter s_input_filter = 0, s_input_image = 1, s_out = 2;
input clk, rst_n, image_valid, filter_valid;
input [3:0] in_data;
output logic [15:0] out_data;
output logic out_valid;

//---------------------------------------------------------------------
//   Your design                       
//---------------------------------------------------------------------
logic signed [3:0] filter_1_times_5_DFF[4:0];
logic signed [3:0] filter_1_times_5_comb[4:0];

logic signed [3:0] filter_5_times_1_DFF[4:0];
logic signed [3:0] filter_5_times_1_comb[4:0];

logic signed [3:0] image_to_conv[4:0];
logic signed [3:0] image_in;

logic signed [9:0] image_after_conv_first_DFF[3:0];
logic signed [9:0] image_after_conv_second_DFF[3:0];
logic signed [9:0] image_after_conv_third_DFF[3:0];
logic signed [9:0] image_after_conv_forth_DFF[3:0];
logic signed [9:0] image_after_conv_fifth_DFF[3:0];
logic signed [9:0] image_after_conv_sixth_DFF[3:0];
logic signed [9:0] image_after_conv_seventh_DFF[3:0];
logic signed [9:0] image_after_conv_eighth_DFF[3:0];
logic signed [9:0] image_after_conv_first_comb[3:0];
logic signed [9:0] image_after_conv_second_comb[3:0];
logic signed [9:0] image_after_conv_third_comb[3:0];
logic signed [9:0] image_after_conv_forth_comb[3:0];
logic signed [9:0] image_after_conv_fifth_comb[3:0];
logic signed [9:0] image_after_conv_sixth_comb[3:0];
logic signed [9:0] image_after_conv_seventh_comb[3:0];
logic signed [9:0] image_after_conv_eighth_comb[3:0];

/*logic signed[15:0] image_first_out_comb[3:0];
logic signed[15:0] image_second_out_comb[3:0];
logic signed[15:0] image_third_out_comb[3:0];
logic signed[15:0] image_forth_out_comb[3:0];
logic signed[15:0] image_first_out_DFF[3:0];
logic signed[15:0] image_second_out_DFF[3:0];
logic signed[15:0] image_third_out_DFF[3:0];
logic signed[15:0] image_forth_out_DFF[3:0];*/

logic out_valid_comb;
logic[3:0] counter_comb, counter_DFF;
logic signed[15:0] out_data_comb1 ,out_data_comb2, out_data_comb3, out_data_comb4,out_data_comb5,out_data_comb;
logic signed[9:0] out_data_comb1_1,out_data_comb2_1,out_data_comb3_1,out_data_comb4_1,out_data_comb5_1;
logic signed[3:0] out_data_comb1_2,out_data_comb2_2,out_data_comb3_2,out_data_comb4_2,out_data_comb5_2;
logic signed[9:0] out_data_DFF1_1,out_data_DFF2_1,out_data_DFF3_1,out_data_DFF4_1,out_data_DFF5_1;
logic signed[3:0] out_data_DFF1_2,out_data_DFF2_2,out_data_DFF3_2,out_data_DFF4_2,out_data_DFF5_2;
logic signed[15:0] out_data_DFF1, out_data_DFF2, out_data_DFF3, out_data_DFF4, out_data_DFF5;
logic[6:0] counter_comb_2,counter_DFF_2;
//logic[1:0] curstate, nextstate;
logic signed[7:0] conv_1,conv_2,conv_3,conv_4,conv_5;
logic signed[7:0] conv_1_DFF,conv_2_DFF,conv_3_DFF,conv_4_DFF,conv_5_DFF;
logic signed[9:0] conv, conv_comb;
logic signed[15:0] out_data_pipe1, out_data_pipe2;
logic signed[15:0] out_data_pipe1_DFF, out_data_pipe2_DFF;
logic [3:0] counter_divided;
logic [2:0] counter_mode;
logic [3:0] little_counter, little_counter_DFF;
logic [3:0] counter_divided_2;
//-----------declaration------------
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		conv_1_DFF <= 0;
		conv_2_DFF <= 0;
		conv_3_DFF <= 0;
		conv_4_DFF <= 0;
		conv_5_DFF <= 0;
	end
	else begin
		conv_1_DFF <= conv_1;
		conv_2_DFF <= conv_2;
		conv_3_DFF <= conv_3;
		conv_4_DFF <= conv_4;
		conv_5_DFF <= conv_5;
	end
end
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		out_data_DFF1_1 <= 0;
		out_data_DFF1_2 <= 0;
		out_data_DFF2_1 <= 0;
		out_data_DFF2_2 <= 0;
		out_data_DFF3_1 <= 0;
		out_data_DFF3_2 <= 0;
		out_data_DFF4_1 <= 0;
		out_data_DFF4_2 <= 0;
		out_data_DFF5_1 <= 0;
		out_data_DFF5_2 <= 0;
	end
	else begin
		out_data_DFF1_1 <= out_data_comb1_1;
		out_data_DFF1_2 <= out_data_comb1_2;
		out_data_DFF2_1 <= out_data_comb2_1;
		out_data_DFF2_2 <= out_data_comb2_2;
		out_data_DFF3_1 <= out_data_comb3_1;
		out_data_DFF3_2 <= out_data_comb3_2;
		out_data_DFF4_1 <= out_data_comb4_1;
		out_data_DFF4_2 <= out_data_comb4_2;
		out_data_DFF5_1 <= out_data_comb5_1;
		out_data_DFF5_2 <= out_data_comb5_2;
	end
end
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		out_valid <= 0;
		out_data_DFF1 <= 0;
		out_data_DFF2 <= 0;
		out_data_DFF3 <= 0;
		out_data_DFF4 <= 0;
		out_data_DFF5 <= 0;
	end
	else begin
		out_data_DFF1 <= out_data_comb1;
		out_data_DFF2 <= out_data_comb2;
		out_data_DFF3 <= out_data_comb3;
		out_data_DFF4 <= out_data_comb4;
		out_data_DFF5 <= out_data_comb5;
		out_valid <= out_valid_comb;
	end
end
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		out_data_pipe1_DFF <= out_data_pipe1;
		out_data_pipe2_DFF <= out_data_pipe2;
	end
	else begin
		out_data_pipe1_DFF <= out_data_pipe1;
		out_data_pipe2_DFF <= out_data_pipe2;
	end
end
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		little_counter_DFF <= 0;
	end
	else begin
		little_counter_DFF <= little_counter;
	end
end
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		conv <= 0;
	end
	else begin
		conv <= conv_comb;
	end
end
//counter
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		counter_DFF <= 0;
		counter_DFF_2 <= 0;
	end
	else begin
		counter_DFF <= counter_comb;
		counter_DFF_2 <= counter_comb_2;
	end
end
//FSM
/*always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		curstate <= s_input_filter;
	end
	else begin
		curstate <= nextstate;
	end
end*/
//filter DFF
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		filter_1_times_5_DFF <= '{5{0}};
		filter_5_times_1_DFF <= '{5{0}};
	end
	else begin
		integer i;
		for(i = 0;i < 5;i++)begin
			filter_1_times_5_DFF <= filter_1_times_5_comb;
			filter_5_times_1_DFF <= filter_5_times_1_comb;
		end
	end
end
//image DFF
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		image_to_conv[0] <= 0;
		image_to_conv[1] <= 0;
		image_to_conv[2] <= 0;
		image_to_conv[3] <= 0;
		image_to_conv[4] <= 0;
	end
	else begin
		image_to_conv[0] <= image_in;
		image_to_conv[1] <= image_to_conv[0];
		image_to_conv[2] <= image_to_conv[1];
		image_to_conv[3] <= image_to_conv[2];
		image_to_conv[4] <= image_to_conv[3];
	end
end
//image after first conv
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		
			image_after_conv_first_DFF <= '{4{0}};
			image_after_conv_second_DFF <= '{4{0}};
			image_after_conv_third_DFF <= '{4{0}};
			image_after_conv_forth_DFF <= '{4{0}};
			image_after_conv_fifth_DFF <= '{4{0}};
			image_after_conv_sixth_DFF <= '{4{0}};
			image_after_conv_seventh_DFF <= '{4{0}};
			image_after_conv_eighth_DFF <= '{4{0}};
		
	end
	else begin
		integer i;
		for(i = 0;i < 4;i++)begin
			image_after_conv_first_DFF <= image_after_conv_first_comb;
			image_after_conv_second_DFF <= image_after_conv_second_comb;
			image_after_conv_third_DFF <= image_after_conv_third_comb;
			image_after_conv_forth_DFF <= image_after_conv_forth_comb;
			image_after_conv_fifth_DFF <= image_after_conv_fifth_comb;
			image_after_conv_sixth_DFF <= image_after_conv_sixth_comb;
			image_after_conv_seventh_DFF <= image_after_conv_seventh_comb;
			image_after_conv_eighth_DFF <= image_after_conv_eighth_comb;
		end
	end
end
always@ (posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		out_data <= 0;
	end
	else begin
		out_data <= out_data_comb;
	end
end

//image after second conv
/*always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		integer i;
		for(i = 0;i < 4;i++)begin
			image_first_out_DFF[i] <= 0;
			image_second_out_DFF[i] <= 0;
			image_third_out_DFF[i] <= 0;
			image_forth_out_DFF[i] <= 0;
		end
		//image_forth_out_DFF <= 0;
	end
	else begin
		integer i;
		for(i = 0;i < 4; i++)begin
			image_first_out_DFF[i] <= image_first_out_comb[i];
			image_second_out_DFF[i] <= image_second_out_comb[i];
			image_third_out_DFF[i] <= image_third_out_comb[i];
			image_forth_out_DFF[i] <= image_forth_out_comb[i];
		end
		//image_forth_out_DFF <= image_forth_out_comb;
	end
end*/
//FSM 
/*always@(*)begin
	case(curstate)
		s_input_filter:begin
			if(filter_valid)begin
				counter_comb = counter_DFF + 1;
			end
			else begin
				counter_comb = counter_DFF;
			end
			if(counter_DFF == 9)begin
				nextstate = s_input_image;
				counter_comb = 0;
			end
			else begin
				nextstate = s_input_filter;
			end
		end
		s_input_image:begin
			counter_comb = counter_DFF + 1;
			if(counter_DFF == 66)begin
				counter_comb = 0;
				nextstate = s_input_filter;
			end
			else begin
				nextstate = s_input_image;
			end
		end
		s_calculate1:begin
			nextstate = s_out;
			counter_comb = 0;
		end
		s_out:begin
			counter_comb = counter_DFF + 1;
			if(counter_DFF < 15)begin
				nextstate = s_out;
			end
			else begin
				counter_comb = 0;
				nextstate = s_input_filter;
			end
		end
		default:begin
			counter_comb = 0;
			nextstate = 0;
		end
	endcase
end*/
//input filter
assign counter_comb = (image_valid)? 0:(filter_valid)?counter_DFF + 1 : 0;
assign counter_comb_2 = (filter_valid)? 0:counter_DFF_2 + 1;
always@(*) begin
	integer i;
	for(i = 0;i < 5;i++)begin
		filter_1_times_5_comb[i] = filter_1_times_5_DFF[i];
		filter_5_times_1_comb[i] = filter_5_times_1_DFF[i];
	end
	if(filter_valid)begin
			case(counter_DFF)
				0:filter_1_times_5_comb[4] = in_data;
				1:filter_1_times_5_comb[3] = in_data;
				2:filter_1_times_5_comb[2] = in_data;
				3:filter_1_times_5_comb[1] = in_data;
				4:filter_1_times_5_comb[0] = in_data;
				5:filter_5_times_1_comb[4] = in_data;
				6:filter_5_times_1_comb[3] = in_data;
				7:filter_5_times_1_comb[2] = in_data;
				8:filter_5_times_1_comb[1] = in_data;
				9:filter_5_times_1_comb[0] = in_data;
			endcase
	end
end
//input image and first conv
/*assign counter_mode = counter_DFF % 8;
assign counter_divided = counter_DFF / 8;*/
always@(*)begin
	image_in = 0;
	image_after_conv_eighth_comb = image_after_conv_eighth_DFF;
	image_after_conv_seventh_comb = image_after_conv_seventh_DFF;
	image_after_conv_sixth_comb = image_after_conv_sixth_DFF;
	image_after_conv_fifth_comb = image_after_conv_fifth_DFF;
	image_after_conv_forth_comb = image_after_conv_forth_DFF;
	image_after_conv_third_comb = image_after_conv_third_DFF;
	image_after_conv_second_comb = image_after_conv_second_DFF;
	image_after_conv_first_comb = image_after_conv_first_DFF;
	if(image_valid)begin
		image_in = in_data;
	end
	conv_1 = image_to_conv[4] * filter_1_times_5_DFF[4];
	conv_2 = image_to_conv[3] * filter_1_times_5_DFF[3];
	conv_3 = image_to_conv[2] * filter_1_times_5_DFF[2];
	conv_4 = image_to_conv[1] * filter_1_times_5_DFF[1];
	conv_5 = image_to_conv[0] * filter_1_times_5_DFF[0];
	conv = conv_1_DFF + conv_2_DFF + conv_3_DFF + conv_4_DFF + conv_5_DFF;
	case(counter_DFF_2)
		//----first line-------
		6:image_after_conv_first_comb[0] = conv;
		7:image_after_conv_first_comb[1] = conv;
		8:image_after_conv_first_comb[2] = conv;
		9:image_after_conv_first_comb[3] = conv;
		//----second line-------
		14:image_after_conv_second_comb[0] = conv;
		15:image_after_conv_second_comb[1] = conv;
		16:image_after_conv_second_comb[2] = conv;
		17:image_after_conv_second_comb[3] = conv;
		//-----third line-------
		22:image_after_conv_third_comb[0] = conv;
		23:image_after_conv_third_comb[1] = conv;
		24:image_after_conv_third_comb[2] = conv;
		25:image_after_conv_third_comb[3] = conv;
		//-----forth line-------
		30:image_after_conv_forth_comb[0] = conv;
		31:image_after_conv_forth_comb[1] = conv;
		32:image_after_conv_forth_comb[2] = conv;
		33:image_after_conv_forth_comb[3] = conv;
		//-----fifth line-------
		38:begin 
			image_after_conv_fifth_comb[0] = conv;
			
		end
		39:begin 
			image_after_conv_fifth_comb[1] = conv;
			
		end
		40:begin
			image_after_conv_fifth_comb[2] = conv;
		
		end
		41:begin
			image_after_conv_fifth_comb[3] = conv;
			
		end
		
		//-----sixth line-------
		46:begin 
			image_after_conv_sixth_comb[0] = conv;
		end
		47:begin 
			image_after_conv_sixth_comb[1] = conv;
		end
		48:begin 
			image_after_conv_sixth_comb[2] = conv;
		end
		49:begin 
			image_after_conv_sixth_comb[3] = conv;
		end
		
		//-----seventh line-------
		54:begin 
			image_after_conv_seventh_comb[0] = conv;			
		end
		55:begin 
			image_after_conv_seventh_comb[1] = conv;
		end
		56:begin 
			image_after_conv_seventh_comb[2] = conv;
		end
		57:begin 
			image_after_conv_seventh_comb[3] = conv;
		end
		
		//-----eighth line-------
		62:begin
			image_after_conv_eighth_comb[0] = conv;	
		end
		63:begin
			image_after_conv_eighth_comb[1] = conv;			
		end
		64:begin 
			image_after_conv_eighth_comb[2] = conv;	
		end
		65:begin 
			image_after_conv_eighth_comb[3] = conv;
		end
		
	endcase
		
end
/*assign 	counter_divided = counter_DFF_2 / 8;
assign 	counter_mode = counter_DFF_2 - counter_divided * 8;
assign  little_counter = (image_valid || out_valid)? little_counter_DFF + 1: 0;*/
/*always@(*)begin
	integer i;
	for(i = 0;i < 4;i++)begin
		image_after_conv_first_comb[i] = image_after_conv_first_DFF[i];
		image_after_conv_second_comb[i] = image_after_conv_second_DFF[i];
		image_after_conv_third_comb[i] = image_after_conv_third_DFF[i];
		image_after_conv_forth_comb[i] = image_after_conv_forth_DFF[i];
		image_after_conv_fifth_comb[i] = image_after_conv_fifth_DFF[i];
	end


	if(counter_mode == 2)begin
		integer i;
		for(i = 0; i< 4;i++)begin
			image_after_conv_second_comb[i] = image_after_conv_first_DFF[i];
			image_after_conv_third_comb[i] = image_after_conv_second_DFF[i];
			image_after_conv_forth_comb[i] = image_after_conv_third_DFF[i];
			image_after_conv_fifth_comb[i] = image_after_conv_forth_DFF[i];
		end
	end
	
	
	
	image_in = 0;
	
	image_first_out_comb[0] = image_first_out_DFF[0];
	image_second_out_comb[0] = image_second_out_DFF[0];
	image_third_out_comb[0] = image_third_out_DFF[0];
	image_forth_out_comb[0] = image_forth_out_DFF[0];
	
	image_first_out_comb[2] = image_first_out_DFF[2];
	image_second_out_comb[2] = image_second_out_DFF[2];
	image_third_out_comb[2] = image_third_out_DFF[2];
	image_forth_out_comb[2] = image_forth_out_DFF[2];
	
	image_first_out_comb[3] = image_first_out_DFF[3];
	image_second_out_comb[3] = image_second_out_DFF[3];
	image_third_out_comb[3] = image_third_out_DFF[3];
	image_forth_out_comb[3] = image_forth_out_DFF[3];
	
	image_first_out_comb[1] = image_first_out_DFF[1];
	image_second_out_comb[1] = image_second_out_DFF[1];
	image_third_out_comb[1] = image_third_out_DFF[1];
	image_forth_out_comb[1] = image_forth_out_DFF[1];

		if(image_valid)begin
		image_in = in_data;
		end
		conv_comb = image_to_conv[3] * filter_1_times_5_DFF[4] 
			 + image_to_conv[2] * filter_1_times_5_DFF[3]
			 + image_to_conv[1] * filter_1_times_5_DFF[2]
			 + image_to_conv[0] * filter_1_times_5_DFF[1]
			 + image_in * filter_1_times_5_DFF[0];
		case(little_counter_DFF)
			5:image_after_conv_first_comb[0] = conv;
			6:image_after_conv_first_comb[1] = conv;
			7:image_after_conv_first_comb[2] = conv;
			0:image_after_conv_first_comb[3] = conv;
		endcase
		case(counter_divided)
			5:begin
				if(little_counter_DFF == 1)begin
					integer i;
					for(i = 0;i < 4;i++)begin
						image_first_out_comb[i] = image_after_conv_first_DFF[i] * filter_5_times_1_DFF[0]
									+ image_after_conv_second_DFF[i] * filter_5_times_1_DFF[1]
									+ image_after_conv_third_DFF[i] * filter_5_times_1_DFF[2]
									+ image_after_conv_forth_DFF[i] * filter_5_times_1_DFF[3]
									+ image_after_conv_fifth_DFF[i] * filter_5_times_1_DFF[4];
					end
				end
			end
			6:begin
				if(little_counter_DFF == 1)begin
					integer i;
					for(i = 0;i < 4;i++)begin
						image_second_out_comb[i] = image_after_conv_first_DFF[i] * filter_5_times_1_DFF[0]
									+ image_after_conv_second_DFF[i] * filter_5_times_1_DFF[1]
									+ image_after_conv_third_DFF[i] * filter_5_times_1_DFF[2]
									+ image_after_conv_forth_DFF[i] * filter_5_times_1_DFF[3]
									+ image_after_conv_fifth_DFF[i] * filter_5_times_1_DFF[4];
					end
				end
			end
			7:begin
				if(little_counter_DFF == 1)begin
					integer i;
					for(i = 0;i < 4;i++)begin
						image_third_out_comb[i] = image_after_conv_first_DFF[i] * filter_5_times_1_DFF[0]
									+ image_after_conv_second_DFF[i] * filter_5_times_1_DFF[1]
									+ image_after_conv_third_DFF[i] * filter_5_times_1_DFF[2]
									+ image_after_conv_forth_DFF[i] * filter_5_times_1_DFF[3]
									+ image_after_conv_fifth_DFF[i] * filter_5_times_1_DFF[4];
					end
				end
					
			end
			
		endcase
		if(counter_divided >= 7 )begin
			case(little_counter_DFF)
				6:begin
					image_forth_out_comb[0] = image_after_conv_first_DFF[0] * filter_5_times_1_DFF[0]
										+ image_after_conv_second_DFF[0] * filter_5_times_1_DFF[1]
										+ image_after_conv_third_DFF[0] * filter_5_times_1_DFF[2]
										+ image_after_conv_forth_DFF[0] * filter_5_times_1_DFF[3]
										+ image_after_conv_fifth_DFF[0] * filter_5_times_1_DFF[4];
				end
				7:begin
					image_forth_out_comb[1] = image_after_conv_first_DFF[1] * filter_5_times_1_DFF[0]
										+ image_after_conv_second_DFF[1] * filter_5_times_1_DFF[1]
										+ image_after_conv_third_DFF[1] * filter_5_times_1_DFF[2]
										+ image_after_conv_forth_DFF[1] * filter_5_times_1_DFF[3]
										+ image_after_conv_fifth_DFF[1] * filter_5_times_1_DFF[4];
				end
				0:begin
					image_forth_out_comb[2] = image_after_conv_first_DFF[2] * filter_5_times_1_DFF[0]
										+ image_after_conv_second_DFF[2] * filter_5_times_1_DFF[1]
										+ image_after_conv_third_DFF[2] * filter_5_times_1_DFF[2]
										+ image_after_conv_forth_DFF[2] * filter_5_times_1_DFF[3]
										+ image_after_conv_fifth_DFF[2] * filter_5_times_1_DFF[4];
				end
				1:begin
					image_forth_out_comb[3]= image_after_conv_first_DFF[3] * filter_5_times_1_DFF[0]
										+ image_after_conv_second_DFF[3] * filter_5_times_1_DFF[1]
										+ image_after_conv_third_DFF[3] * filter_5_times_1_DFF[2]
										+ image_after_conv_forth_DFF[3] * filter_5_times_1_DFF[3]
										+ image_after_conv_fifth_DFF[3] * filter_5_times_1_DFF[4];
				end
			endcase
		end
		
end*/


//out
assign out_data_pipe1 = out_data_DFF1 + out_data_DFF2 ; 
assign out_data_pipe2 = out_data_DFF4 + out_data_DFF5 + out_data_DFF3 ;
assign out_data_comb = (out_valid_comb)? out_data_pipe1_DFF + out_data_pipe2_DFF : 0;
assign out_valid_comb = (counter_DFF_2 > 53 && counter_DFF_2 < 70)? 1 : 0;
assign little_counter = (counter_DFF_2 >= 51)? little_counter_DFF + 1 : 0;
assign	out_data_comb1 = out_data_DFF1_1 * out_data_DFF1_2;
assign	out_data_comb2 = out_data_DFF2_1 * out_data_DFF2_2;
assign	out_data_comb3 = out_data_DFF3_1 * out_data_DFF3_2; 
assign	out_data_comb4 = out_data_DFF4_1 * out_data_DFF4_2;
assign  out_data_comb5 = out_data_DFF5_1 * out_data_DFF5_2;
always@(*)begin
	out_data_comb1_2 = filter_5_times_1_DFF[4];
	out_data_comb2_2 = filter_5_times_1_DFF[3];
	out_data_comb3_2 = filter_5_times_1_DFF[2];
	out_data_comb4_2 = filter_5_times_1_DFF[1];
	out_data_comb5_2 = filter_5_times_1_DFF[0];
	
	case(little_counter_DFF)
			0:begin 
				out_data_comb1_1 = image_after_conv_first_DFF[0] ;
				out_data_comb2_1 = image_after_conv_second_DFF[0];
				out_data_comb3_1 = image_after_conv_third_DFF[0]; 
				out_data_comb4_1 = image_after_conv_forth_DFF[0] ;
				out_data_comb5_1 = image_after_conv_fifth_DFF[0];
			end
			1:begin 
				out_data_comb1_1 = image_after_conv_first_DFF[1];
				out_data_comb2_1 = image_after_conv_second_DFF[1];
				out_data_comb3_1 = image_after_conv_third_DFF[1];
				out_data_comb4_1 = image_after_conv_forth_DFF[1];
				out_data_comb5_1 = image_after_conv_fifth_DFF[1];
			end
			2:begin 
				out_data_comb1_1 = image_after_conv_first_DFF[2];
				out_data_comb2_1 = image_after_conv_second_DFF[2];
				out_data_comb3_1 = image_after_conv_third_DFF[2];
				out_data_comb4_1 = image_after_conv_forth_DFF[2];
				out_data_comb5_1 = image_after_conv_fifth_DFF[2];			
			end
			3:begin 
				out_data_comb1_1 = image_after_conv_first_DFF[3];
				out_data_comb2_1 = image_after_conv_second_DFF[3];
				out_data_comb3_1 = image_after_conv_third_DFF[3];
				out_data_comb4_1 = image_after_conv_forth_DFF[3];
				out_data_comb5_1 = image_after_conv_fifth_DFF[3];
			end	
			
			4:begin  
				out_data_comb1_1 = image_after_conv_second_DFF[0];
				out_data_comb2_1 = image_after_conv_third_DFF[0];
				out_data_comb3_1 = image_after_conv_forth_DFF[0];
				out_data_comb4_1 = image_after_conv_fifth_DFF[0];
				out_data_comb5_1 = image_after_conv_sixth_DFF[0];				 
			end
			5:begin 
				out_data_comb1_1 = image_after_conv_second_DFF[1];
				out_data_comb2_1 = image_after_conv_third_DFF[1];
				out_data_comb3_1 = image_after_conv_forth_DFF[1];
				out_data_comb4_1 = image_after_conv_fifth_DFF[1];
				out_data_comb5_1 = image_after_conv_sixth_DFF[1];
		
			end
			6:begin 
				out_data_comb1_1 = image_after_conv_second_DFF[2];
				out_data_comb2_1 = image_after_conv_third_DFF[2];
				out_data_comb3_1 = image_after_conv_forth_DFF[2];
				out_data_comb4_1 = image_after_conv_fifth_DFF[2];
				out_data_comb5_1 = image_after_conv_sixth_DFF[2];
			end
			7:begin
				out_data_comb1_1 = image_after_conv_second_DFF[3];
				out_data_comb2_1 = image_after_conv_third_DFF[3];
				out_data_comb3_1 = image_after_conv_forth_DFF[3];
				out_data_comb4_1 = image_after_conv_fifth_DFF[3];
				out_data_comb5_1 = image_after_conv_sixth_DFF[3];
			end
			
			8:begin 
				out_data_comb1_1 = image_after_conv_third_DFF[0];
				out_data_comb2_1 = image_after_conv_forth_DFF[0];
				out_data_comb3_1 = image_after_conv_fifth_DFF[0];
				out_data_comb4_1 = image_after_conv_sixth_DFF[0];
				out_data_comb5_1 = image_after_conv_seventh_DFF[0];
			end
			9:begin 
				out_data_comb1_1 = image_after_conv_third_DFF[1];
				out_data_comb2_1 = image_after_conv_forth_DFF[1];
				out_data_comb3_1 = image_after_conv_fifth_DFF[1];
				out_data_comb4_1 = image_after_conv_sixth_DFF[1];
				out_data_comb5_1 = image_after_conv_seventh_DFF[1];
			end
			10:begin 
				out_data_comb1_1 = image_after_conv_third_DFF[2];
				out_data_comb2_1 = image_after_conv_forth_DFF[2];
				out_data_comb3_1 = image_after_conv_fifth_DFF[2];
				out_data_comb4_1 = image_after_conv_sixth_DFF[2];
				out_data_comb5_1 = image_after_conv_seventh_DFF[2];
			end
			11:begin
				out_data_comb1_1 = image_after_conv_third_DFF[3];
				out_data_comb2_1 = image_after_conv_forth_DFF[3];
				out_data_comb3_1 = image_after_conv_fifth_DFF[3];
				out_data_comb4_1 = image_after_conv_sixth_DFF[3];
				out_data_comb5_1 = image_after_conv_seventh_DFF[3];
			end
			
			12:begin 
				out_data_comb1_1 = image_after_conv_forth_DFF[0];
				out_data_comb2_1 = image_after_conv_fifth_DFF[0];
				out_data_comb3_1 = image_after_conv_sixth_DFF[0];
				out_data_comb4_1 = image_after_conv_seventh_DFF[0];
				out_data_comb5_1 = image_after_conv_eighth_DFF[0];
			end
			13:begin 
				out_data_comb1_1 = image_after_conv_forth_DFF[1];
				out_data_comb2_1 =  image_after_conv_fifth_DFF[1];
				out_data_comb3_1 = image_after_conv_sixth_DFF[1];
				out_data_comb4_1 = image_after_conv_seventh_DFF[1];
				out_data_comb5_1 = image_after_conv_eighth_DFF[1];
			end
			14:begin 
				out_data_comb1_1 = image_after_conv_forth_DFF[2];
				out_data_comb2_1 = image_after_conv_fifth_DFF[2];
				out_data_comb3_1 = image_after_conv_sixth_DFF[2];
				out_data_comb4_1 = image_after_conv_seventh_DFF[2];
				out_data_comb5_1 = image_after_conv_eighth_DFF[2];
			end
			15:begin
				out_data_comb1_1 = image_after_conv_forth_DFF[3];
				out_data_comb2_1 = image_after_conv_fifth_DFF[3];
				out_data_comb3_1 = image_after_conv_sixth_DFF[3];
				out_data_comb4_1 = image_after_conv_seventh_DFF[3];
				out_data_comb5_1 = image_after_conv_eighth_DFF[3];
			end
		endcase
		/* case(little_counter_DFF)
			0:begin 
				out_data_comb1 = image_after_conv_first_DFF[0] * filter_5_times_1_DFF[4];
				out_data_comb2 = image_after_conv_second_DFF[0] * filter_5_times_1_DFF[3];
				out_data_comb3 = image_after_conv_third_DFF[0] * filter_5_times_1_DFF[2];
				out_data_comb4 = image_after_conv_forth_DFF[0] * filter_5_times_1_DFF[1];
				out_data_comb5 =  image_after_conv_fifth_DFF[0] * filter_5_times_1_DFF[0];
			end
			1:begin 
				out_data_comb1 = image_after_conv_first_DFF[1] * filter_5_times_1_DFF[4];
				out_data_comb2 = image_after_conv_second_DFF[1] * filter_5_times_1_DFF[3];
				out_data_comb3 = image_after_conv_third_DFF[1] * filter_5_times_1_DFF[2];
				out_data_comb4 = image_after_conv_forth_DFF[1] * filter_5_times_1_DFF[1];
				out_data_comb5 = image_after_conv_fifth_DFF[1] * filter_5_times_1_DFF[0]; 
			end
			2:begin 
				out_data_comb1 = image_after_conv_first_DFF[2] * filter_5_times_1_DFF[4];
				out_data_comb2 = image_after_conv_second_DFF[2] * filter_5_times_1_DFF[3];
				out_data_comb3 = image_after_conv_third_DFF[2] * filter_5_times_1_DFF[2];
				out_data_comb4 = image_after_conv_forth_DFF[2] * filter_5_times_1_DFF[1];
				out_data_comb5 = image_after_conv_fifth_DFF[2] * filter_5_times_1_DFF[0];				
			end
			3:begin 
				out_data_comb1 = image_after_conv_first_DFF[3] * filter_5_times_1_DFF[4];
				out_data_comb2 = image_after_conv_second_DFF[3] * filter_5_times_1_DFF[3];
				out_data_comb3 = image_after_conv_third_DFF[3] * filter_5_times_1_DFF[2];
				out_data_comb4 = image_after_conv_forth_DFF[3] * filter_5_times_1_DFF[1];
				out_data_comb5 = image_after_conv_fifth_DFF[3] * filter_5_times_1_DFF[0];
			end	
			
			4:begin  
				out_data_comb1 = image_after_conv_second_DFF[0] * filter_5_times_1_DFF[4];
				out_data_comb2 = image_after_conv_third_DFF[0] * filter_5_times_1_DFF[3];
				out_data_comb3 = image_after_conv_forth_DFF[0] * filter_5_times_1_DFF[2];
				out_data_comb4 = image_after_conv_fifth_DFF[0] * filter_5_times_1_DFF[1];
				out_data_comb5 = image_after_conv_sixth_DFF[0] * filter_5_times_1_DFF[0]; 				 
			end
			5:begin 
				out_data_comb1 = image_after_conv_second_DFF[1] * filter_5_times_1_DFF[4];
				out_data_comb2 = image_after_conv_third_DFF[1] * filter_5_times_1_DFF[3];
				out_data_comb3 = image_after_conv_forth_DFF[1] * filter_5_times_1_DFF[2];
				out_data_comb4 = image_after_conv_fifth_DFF[1] * filter_5_times_1_DFF[1];
				out_data_comb5 = image_after_conv_sixth_DFF[1] * filter_5_times_1_DFF[0];
		
			end
			6:begin 
				out_data_comb1 = image_after_conv_second_DFF[2] * filter_5_times_1_DFF[4];
				out_data_comb2 = image_after_conv_third_DFF[2] * filter_5_times_1_DFF[3];
				out_data_comb3 = image_after_conv_forth_DFF[2] * filter_5_times_1_DFF[2];
				out_data_comb4 = image_after_conv_fifth_DFF[2] * filter_5_times_1_DFF[1];
				out_data_comb5 = image_after_conv_sixth_DFF[2] * filter_5_times_1_DFF[0];
			end
			7:begin
				out_data_comb1 = image_after_conv_second_DFF[3] * filter_5_times_1_DFF[4];
				out_data_comb2 = image_after_conv_third_DFF[3] * filter_5_times_1_DFF[3];
				out_data_comb3 = image_after_conv_forth_DFF[3] * filter_5_times_1_DFF[2];
				out_data_comb4 = image_after_conv_fifth_DFF[3] * filter_5_times_1_DFF[1];
				out_data_comb5 = image_after_conv_sixth_DFF[3] * filter_5_times_1_DFF[0];
			end
			
			8:begin 
				out_data_comb1 = image_after_conv_third_DFF[0] * filter_5_times_1_DFF[4];
				out_data_comb2 = image_after_conv_forth_DFF[0] * filter_5_times_1_DFF[3];
				out_data_comb3 = image_after_conv_fifth_DFF[0] * filter_5_times_1_DFF[2];
				out_data_comb4 = image_after_conv_sixth_DFF[0] * filter_5_times_1_DFF[1];
				out_data_comb5 = image_after_conv_seventh_DFF[0] * filter_5_times_1_DFF[0];
			end
			9:begin 
				out_data_comb1 = image_after_conv_third_DFF[1] * filter_5_times_1_DFF[4];
				out_data_comb2 = image_after_conv_forth_DFF[1] * filter_5_times_1_DFF[3];
				out_data_comb3 = image_after_conv_fifth_DFF[1] * filter_5_times_1_DFF[2];
				out_data_comb4 = image_after_conv_sixth_DFF[1] * filter_5_times_1_DFF[1];
				out_data_comb5 = image_after_conv_seventh_DFF[1] * filter_5_times_1_DFF[0];
			end
			10:begin 
				out_data_comb1 = image_after_conv_third_DFF[2] * filter_5_times_1_DFF[4];
				out_data_comb2 = image_after_conv_forth_DFF[2] * filter_5_times_1_DFF[3];
				out_data_comb3 = image_after_conv_fifth_DFF[2] * filter_5_times_1_DFF[2];
				out_data_comb4 = image_after_conv_sixth_DFF[2] * filter_5_times_1_DFF[1];
				out_data_comb5 = image_after_conv_seventh_DFF[2] * filter_5_times_1_DFF[0];
			end
			11:begin
				out_data_comb1 = image_after_conv_third_DFF[3] * filter_5_times_1_DFF[4];
				out_data_comb2 = image_after_conv_forth_DFF[3] * filter_5_times_1_DFF[3];
				out_data_comb3 = image_after_conv_fifth_DFF[3] * filter_5_times_1_DFF[2];
				out_data_comb4 = image_after_conv_sixth_DFF[3] * filter_5_times_1_DFF[1];
				out_data_comb5 = image_after_conv_seventh_DFF[3] * filter_5_times_1_DFF[0];
			end
			
			12:begin 
				out_data_comb1 = image_after_conv_forth_DFF[0] * filter_5_times_1_DFF[4];
				out_data_comb2 = image_after_conv_fifth_DFF[0] * filter_5_times_1_DFF[3];
				out_data_comb3 = image_after_conv_sixth_DFF[0] * filter_5_times_1_DFF[2];
				out_data_comb4 = image_after_conv_seventh_DFF[0] * filter_5_times_1_DFF[1];
				out_data_comb5 = image_after_conv_eighth_DFF[0] * filter_5_times_1_DFF[0];
			end
			13:begin 
				out_data_comb1 = image_after_conv_forth_DFF[1] * filter_5_times_1_DFF[4];
				out_data_comb2 =  image_after_conv_fifth_DFF[1] * filter_5_times_1_DFF[3];
				out_data_comb3 = image_after_conv_sixth_DFF[1] * filter_5_times_1_DFF[2];
				out_data_comb4 = image_after_conv_seventh_DFF[1] * filter_5_times_1_DFF[1];
				out_data_comb5 = image_after_conv_eighth_DFF[1] * filter_5_times_1_DFF[0];
			end
			14:begin 
				out_data_comb1 = image_after_conv_forth_DFF[2] * filter_5_times_1_DFF[4];
				out_data_comb2 = image_after_conv_fifth_DFF[2] * filter_5_times_1_DFF[3];
				out_data_comb3 = image_after_conv_sixth_DFF[2] * filter_5_times_1_DFF[2];
				out_data_comb4 = image_after_conv_seventh_DFF[2] * filter_5_times_1_DFF[1];
				out_data_comb5 = image_after_conv_eighth_DFF[2] * filter_5_times_1_DFF[0];
			end
			15:begin
				out_data_comb1 = image_after_conv_forth_DFF[3] * filter_5_times_1_DFF[4];
				out_data_comb2 = image_after_conv_fifth_DFF[3] * filter_5_times_1_DFF[3];
				out_data_comb3 = image_after_conv_sixth_DFF[3] * filter_5_times_1_DFF[2];
				out_data_comb4 = image_after_conv_seventh_DFF[3] * filter_5_times_1_DFF[1];
				out_data_comb5 = image_after_conv_eighth_DFF[3] * filter_5_times_1_DFF[0];
			end
		endcase */
	
end
/*always@(*)begin
	out_valid = 0;
	out_data = 0;

		case(counter_DFF_2)
			51:begin out_data = image_first_out_DFF[0]; out_valid = 1; end
			52:begin out_data = image_first_out_DFF[1]; out_valid = 1; end
			53:begin out_data = image_first_out_DFF[2]; out_valid = 1; end
			54:begin out_data = image_first_out_DFF[3]; out_valid = 1; end	
			
			55:begin out_data = image_second_out_DFF[0]; out_valid = 1; end
			56:begin out_data = image_second_out_DFF[1]; out_valid = 1; end
			57:begin out_data = image_second_out_DFF[2]; out_valid = 1; end
			58:begin out_data = image_second_out_DFF[3]; out_valid = 1; end
			
			59:begin out_data = image_third_out_DFF[0]; out_valid = 1; end
			60:begin out_data = image_third_out_DFF[1]; out_valid = 1; end
			61:begin out_data = image_third_out_DFF[2]; out_valid = 1; end
			62:begin out_data = image_third_out_DFF[3]; out_valid = 1; end
			
			63:begin out_data = image_forth_out_DFF[0]; out_valid = 1; end
			64:begin out_data = image_forth_out_DFF[1]; out_valid = 1; end
			65:begin out_data = image_forth_out_DFF[2]; out_valid = 1; end
			66:begin out_data = image_forth_out_DFF[3]; out_valid = 1; end
		endcase
	
end*/
endmodule


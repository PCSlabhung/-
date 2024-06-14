
module MIPS(
    //Input 
    clk,
    rst_n,
    in_valid,
    instruction,
	output_reg,
    //OUTPUT
    out_valid,
    out_1,
	out_2,
	out_3,
	out_4,
	instruction_fail
);

    //Input 
input clk;
input rst_n;
input in_valid;
input [31:0] instruction;
input [19:0] output_reg;
    //OUTPUT
output logic out_valid, instruction_fail;
output logic [31:0] out_1, out_2, out_3, out_4;
//--------declaration----------
logic first_in_valid_reg;
logic [31:0] instruction_in, first_instrucion_DFF;
logic [19:0] output_reg_in, first_output_reg_DFF;
logic[31:0] reg1, reg2, reg3, reg4, reg5, reg6; 
/* reg1 10001 reg2 10010 reg3 01000 reg4 10111 reg5 11111  reg6 10000 */
logic[31:0] reg1_in, reg2_in, reg3_in, reg4_in, reg5_in, reg6_in;

//-----decoder variable
logic decoder_instruciont_fail, decoder_instruciont_fail_1, decoder_instruciont_fail_2, decoder_instruciont_fail_3,decoder_instruciont_fail_4;
logic[19:0] output_reg_second_DFF_in;
logic[2:0] funct_in;
logic opcode_in;
//logic[31:0] Rs_in, Rt_in, Rd_in;
logic[4:0] Shamt_in;
logic[15:0] imm_in;
logic[4:0] Rd_address, Rt_address, Rs_address;

//second DFF out
logic second_instructionfail_DFF_out;
logic second_in_valid_reg;
logic[4:0] Rd_address_reg, Rt_address_reg, Rs_address_reg;
logic[2:0] second_funct_DFF_out;
logic second_opcode_DFF_out;
logic[4:0] second_Shamt_DFF_out;
logic[15:0] second_imm_DFF_out;
logic[19:0] second_out_reg_DFF_out;

//ALU variable
logic[31:0] Rs, Rd, Rt;
logic instrucionfail_in;
logic[31:0] answer_in;
logic[19:0] third_out_reg_DFF_in;
logic third_in_valid_DFF_in;
// Third DFF out
logic third_in_valid_DFF_out;
logic third_instrucionfail_DFF_out;
logic[19:0] third_out_reg_DFF_out;
//output selection variable
logic out_valid_in;
logic output_instrucionfail_in;
logic[31:0] out_1_in, out_2_in, out_3_in, out_4_in;
//--------my design -----------


assign instruction_in = (in_valid)? instruction : 0;
assign output_reg_in = (in_valid)? output_reg : 0;
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		reg1 <= 0;
		reg2 <= 0;
		reg3 <= 0;
		reg4 <= 0;
		reg5 <= 0;
		reg6 <= 0;
	end
	else begin
		reg1 <= reg1_in;
		reg2 <= reg2_in;
		reg3 <= reg3_in;
		reg4 <= reg4_in;
		reg5 <= reg5_in;
		reg6 <= reg6_in;
	end
end

// input DFF
always@(posedge clk or negedge rst_n)begin 
	if(!rst_n)begin
		first_instrucion_DFF <= 0;
		first_output_reg_DFF <= 0;
		first_in_valid_reg <= 0;
	end
	else begin
		first_in_valid_reg <= in_valid;
		first_instrucion_DFF <= instruction_in;
		first_output_reg_DFF <= output_reg_in;
	end
end

// second DFF
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		second_in_valid_reg <= 0;
		second_Shamt_DFF_out <= 0;
		second_funct_DFF_out <= 0;
		second_imm_DFF_out <= 0;
		second_opcode_DFF_out <= 0;
		Rd_address_reg <= 0;
		Rt_address_reg <= 0;
		Rs_address_reg <= 0;
		second_out_reg_DFF_out <= 0;
		second_instructionfail_DFF_out <= 0;
	end
	else begin
		second_instructionfail_DFF_out <= decoder_instruciont_fail;
		second_out_reg_DFF_out <= output_reg_second_DFF_in;
		second_in_valid_reg <= first_in_valid_reg;
		second_Shamt_DFF_out <= Shamt_in;
		second_funct_DFF_out <= funct_in;
		second_imm_DFF_out <= imm_in;
		second_opcode_DFF_out <= opcode_in;
		Rd_address_reg <= Rd_address;
		Rs_address_reg <= Rs_address;
		Rt_address_reg <= Rt_address;
	end

end

//third DFF
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		third_in_valid_DFF_out <= 0;;
		third_instrucionfail_DFF_out <= 0;
		third_out_reg_DFF_out <= 0;
	end
	else begin
		third_in_valid_DFF_out <= third_in_valid_DFF_in;
		third_instrucionfail_DFF_out <= instrucionfail_in;
		third_out_reg_DFF_out <= third_out_reg_DFF_in;
	end
end

//output DFF
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		out_1 <= 0;
		out_2 <= 0;
		out_3 <= 0;
		out_4 <= 0;
		instruction_fail <= 0;
		out_valid <= 0;
	end
	else begin
		out_1 <= out_1_in;
		out_2 <= out_2_in;
		out_3 <= out_3_in;
		out_4 <= out_4_in;
		instruction_fail <= output_instrucionfail_in;
		out_valid <= out_valid_in;
	end
end
// Decoder and read register/* reg1 10001 reg2 10010 reg3 01000 reg4 10111 reg5 11111  reg6 10000 */
always@(*)begin 
	opcode_in = 0;
	Shamt_in = 0;
	imm_in = 0;
	Rd_address = 0;
	Rt_address = 0;
	Rs_address = 0;
	output_reg_second_DFF_in = 0;
	funct_in = 0;
	decoder_instruciont_fail = 1;
	decoder_instruciont_fail_1 = 1;
	decoder_instruciont_fail_2 = 1;
	decoder_instruciont_fail_3 = 1;
	if(first_in_valid_reg)begin
		output_reg_second_DFF_in = first_output_reg_DFF;
		Rs_address = first_instrucion_DFF[25:21];
		Rt_address = first_instrucion_DFF[20:16];
		Rd_address = first_instrucion_DFF[15:11];
		opcode_in = 0;
		if(first_instrucion_DFF[31:26] == 6'b000_000)begin
			opcode_in = 1'b0;
			decoder_instruciont_fail_4 = 0;
		end
		else if(first_instrucion_DFF[31:26] == 6'b001_000)begin
			opcode_in = 1'b1;
			decoder_instruciont_fail_4 = 0;
		end
		else begin
			decoder_instruciont_fail_4 = 1; 
		end
		
		Shamt_in = first_instrucion_DFF[10:6];
		imm_in = first_instrucion_DFF[15:0];
		
		if(opcode_in == 1'b0 )begin
			case(first_instrucion_DFF[5:0])
				6'b100_000:funct_in = 0;
				6'b100_100:funct_in = 1;
				6'b100_101:funct_in = 2;
				6'b100_111:funct_in = 3;
				6'b000_000:funct_in = 4;
				6'b000_010:funct_in = 5;
				default:decoder_instruciont_fail_4 = 1;
			endcase
			case(first_instrucion_DFF[25:21])
				5'b10001:begin decoder_instruciont_fail_1 = 0;/*Rs_address = 3'b100;*/ end
				5'b10010:begin decoder_instruciont_fail_1 = 0;/*Rs_address = 3'b110; */end
				5'b01000:begin decoder_instruciont_fail_1 = 0;/*Rs_address = 3'b010;*/ end
				5'b10111:begin decoder_instruciont_fail_1 = 0;/*Rs_address = 3'b101;*/ end
				5'b11111:begin decoder_instruciont_fail_1 = 0;/*Rs_address = 3'b111;*/ end
				5'b10000:begin decoder_instruciont_fail_1 = 0;/*Rs_address = 3'b011;*/ end
			endcase
			case(first_instrucion_DFF[20:16])
				5'b10001:begin decoder_instruciont_fail_2 = 0;/*Rt_address = 3'b100;*/ end
				5'b10010:begin decoder_instruciont_fail_2 = 0;/*Rt_address = 3'b110;*/ end
				5'b01000:begin decoder_instruciont_fail_2 = 0;/*Rt_address = 3'b010;*/ end
				5'b10111:begin decoder_instruciont_fail_2 = 0;/*Rt_address = 3'b101;*/ end
				5'b11111:begin decoder_instruciont_fail_2 = 0;/*Rt_address = 3'b111;*/ end
				5'b10000:begin decoder_instruciont_fail_2 = 0;/*Rt_address = 3'b011;*/ end
			endcase
			case(first_instrucion_DFF[15:11])
				5'b10001:begin decoder_instruciont_fail_3 = 0;/*Rd_address = 3'b100;*/ end
				5'b10010:begin decoder_instruciont_fail_3 = 0;/*Rd_address = 3'b110;*/ end
				5'b01000:begin decoder_instruciont_fail_3 = 0;/*Rd_address = 3'b010;*/ end
				5'b10111:begin decoder_instruciont_fail_3 = 0;/*Rd_address = 3'b101;*/ end
				5'b11111:begin decoder_instruciont_fail_3 = 0;/*Rd_address = 3'b111;*/ end
				5'b10000:begin decoder_instruciont_fail_3 = 0;/*Rd_address = 3'b011;*/ end
			endcase
			if(decoder_instruciont_fail_1 || decoder_instruciont_fail_2 ||decoder_instruciont_fail_3 || decoder_instruciont_fail_4)begin
				decoder_instruciont_fail = 1;
			end
			else begin
				decoder_instruciont_fail = 0;
			end
		end
		else if(opcode_in == 1)begin
			case(first_instrucion_DFF[25:21])
				5'b10001:begin decoder_instruciont_fail_1 = 0;/*Rs_address = 3'b100;*/ end
				5'b10010:begin decoder_instruciont_fail_1 = 0;/*Rs_address = 3'b110;*/ end
				5'b01000:begin decoder_instruciont_fail_1 = 0;/*Rs_address = 3'b010;*/ end
				5'b10111:begin decoder_instruciont_fail_1 = 0;/*Rs_address = 3'b101;*/ end
				5'b11111:begin decoder_instruciont_fail_1 = 0;/*Rs_address = 3'b111;*/ end
				5'b10000:begin decoder_instruciont_fail_1 = 0;/*Rs_address = 3'b011;*/ end
			endcase
			case(first_instrucion_DFF[20:16])
				5'b10001:begin decoder_instruciont_fail_2 = 0;/*Rt_address = 3'b100;*/ end
				5'b10010:begin decoder_instruciont_fail_2 = 0;/*Rt_address = 3'b110;*/ end
				5'b01000:begin decoder_instruciont_fail_2 = 0;/*Rt_address = 3'b010;*/ end
				5'b10111:begin decoder_instruciont_fail_2 = 0;/*Rt_address = 3'b101;*/ end
				5'b11111:begin decoder_instruciont_fail_2 = 0;/*Rt_address = 3'b111;*/ end
				5'b10000:begin decoder_instruciont_fail_2 = 0;/*Rt_address = 3'b011;*/ end
			endcase
			if(decoder_instruciont_fail_1 || decoder_instruciont_fail_2 || decoder_instruciont_fail_4)begin
				decoder_instruciont_fail = 1;
			end
			else begin
				decoder_instruciont_fail = 0;
			end
		end
	end
end

//ALU calculation
always@(*)begin
	answer_in = 0;
	reg1_in = reg1;
	reg2_in = reg2;
	reg3_in = reg3;
	reg4_in = reg4;
	reg5_in = reg5;
	reg6_in = reg6;
	third_out_reg_DFF_in = 0;
	third_in_valid_DFF_in = second_in_valid_reg;
	instrucionfail_in = 1;
	Rs = 0;Rt = 0; Rd = 0;
	if(second_in_valid_reg && !second_instructionfail_DFF_out)begin
		third_out_reg_DFF_in = second_out_reg_DFF_out;
		case(Rs_address_reg)
			5'b10001:Rs = reg1;
			5'b10010:Rs = reg2;
			5'b01000:Rs = reg3;
			5'b10111:Rs = reg4;
			5'b11111:Rs = reg5;
			5'b10000:Rs = reg6;
			default: instrucionfail_in = 1;
		endcase
		case(Rt_address_reg)
			5'b10001:Rt = reg1;
			5'b10010:Rt = reg2;
			5'b01000:Rt = reg3;
			5'b10111:Rt = reg4;
			5'b11111:Rt = reg5;
			5'b10000:Rt = reg6;
			default: instrucionfail_in = 1;
		endcase
		case(Rd_address_reg)
			5'b10001:Rd = reg1;
			5'b10010:Rd = reg2;
			5'b01000:Rd = reg3;
			5'b10111:Rd = reg4;
			5'b11111:Rd = reg5;
			5'b10000:Rd = reg6;
			default: instrucionfail_in = 1;
		endcase
		case(second_opcode_DFF_out)
			1'b0:begin
				instrucionfail_in = 0;
				case(second_funct_DFF_out)
					3'd0:begin
						answer_in = Rs + Rt;
						case(Rd_address_reg)
							5'b10001:reg1_in = answer_in;
							5'b10010:reg2_in = answer_in;
							5'b01000:reg3_in = answer_in;
							5'b10111:reg4_in = answer_in;
							5'b11111:reg5_in = answer_in;
							5'b10000:reg6_in = answer_in;
						endcase
					end
					3'd1:begin
						answer_in = Rs & Rt;
						case(Rd_address_reg)
							5'b10001:reg1_in = answer_in;
							5'b10010:reg2_in = answer_in;
							5'b01000:reg3_in = answer_in;
							5'b10111:reg4_in = answer_in;
							5'b11111:reg5_in = answer_in;
							5'b10000:reg6_in = answer_in;
						endcase
					end
					3'd2:begin
						answer_in = Rs | Rt;
						case(Rd_address_reg)
							5'b10001:reg1_in = answer_in;
							5'b10010:reg2_in = answer_in;
							5'b01000:reg3_in = answer_in;
							5'b10111:reg4_in = answer_in;
							5'b11111:reg5_in = answer_in;
							5'b10000:reg6_in = answer_in;
						endcase
					end
					3'd3:begin
						answer_in = ~(Rs | Rt);
						case(Rd_address_reg)
							5'b10001:reg1_in = answer_in;
							5'b10010:reg2_in = answer_in;
							5'b01000:reg3_in = answer_in;
							5'b10111:reg4_in = answer_in;
							5'b11111:reg5_in = answer_in;
							5'b10000:reg6_in = answer_in;
						endcase
					end
					3'd4:begin
						answer_in = Rt<<(second_Shamt_DFF_out);
						case(Rd_address_reg)
							5'b10001:reg1_in = answer_in;
							5'b10010:reg2_in = answer_in;
							5'b01000:reg3_in = answer_in;
							5'b10111:reg4_in = answer_in;
							5'b11111:reg5_in = answer_in;
							5'b10000:reg6_in = answer_in;
						endcase
					end
					3'd5:begin
						answer_in = Rt>>(second_Shamt_DFF_out);
						case(Rd_address_reg)
							5'b10001:reg1_in = answer_in;
							5'b10010:reg2_in = answer_in;
							5'b01000:reg3_in = answer_in;
							5'b10111:reg4_in = answer_in;
							5'b11111:reg5_in = answer_in;
							5'b10000:reg6_in = answer_in;
						endcase
					end
					default:begin
						instrucionfail_in = 1;
						case(Rd_address_reg)
							5'b10001:reg1_in = reg1;
							5'b10010:reg2_in = reg2;
							5'b01000:reg3_in = reg3;
							5'b10111:reg4_in = reg4;
							5'b11111:reg5_in = reg5;
							5'b10000:reg6_in = reg6;
						endcase
					end
				endcase
				
			end
			1'b1:begin
				instrucionfail_in = 0;
				answer_in = Rs + second_imm_DFF_out;
				case(Rt_address_reg)
					5'b10001:reg1_in = answer_in;
					5'b10010:reg2_in = answer_in;
					5'b01000:reg3_in = answer_in;
					5'b10111:reg4_in = answer_in;
					5'b11111:reg5_in = answer_in;
					5'b10000:reg6_in = answer_in;
				endcase
			end
			default :begin
				instrucionfail_in = 1;
			end
		endcase
	end
end	
//out selecting
always@(*)begin
	out_valid_in = 0;
	out_1_in = 0;
	out_2_in = 0;
	out_3_in = 0;
	out_4_in = 0;
	output_instrucionfail_in = 0;
	if(third_in_valid_DFF_out)begin
		out_valid_in = 1;
		if(third_instrucionfail_DFF_out)begin
			out_1_in = 0;
			out_2_in = 0;
			out_3_in = 0;
			out_4_in = 0;
			output_instrucionfail_in = 1;
		end
		else begin
			case(third_out_reg_DFF_out[4:0])
				5'b10001:out_1_in = reg1;
				5'b10010:out_1_in = reg2;
				5'b01000:out_1_in = reg3;
				5'b10111:out_1_in = reg4;
				5'b11111:out_1_in = reg5;
				5'b10000:out_1_in = reg6;
			endcase
			case(third_out_reg_DFF_out[9:5])
				5'b10001:out_2_in = reg1;
				5'b10010:out_2_in = reg2;
				5'b01000:out_2_in = reg3;
				5'b10111:out_2_in = reg4;
				5'b11111:out_2_in = reg5;
				5'b10000:out_2_in = reg6;
			endcase
			case(third_out_reg_DFF_out[14:10])
				5'b10001:out_3_in = reg1;
				5'b10010:out_3_in = reg2;
				5'b01000:out_3_in = reg3;
				5'b10111:out_3_in = reg4;
				5'b11111:out_3_in = reg5;
				5'b10000:out_3_in = reg6;
			endcase
			case(third_out_reg_DFF_out[19:15])
				5'b10001:out_4_in = reg1;
				5'b10010:out_4_in = reg2;
				5'b01000:out_4_in = reg3;
				5'b10111:out_4_in = reg4;
				5'b11111:out_4_in = reg5;
				5'b10000:out_4_in = reg6;
			endcase
		end
	end
end
endmodule




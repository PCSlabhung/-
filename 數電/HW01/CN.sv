module CN(
    // Input signals
    opcode,
	in_n0,
	in_n1,
	in_n2,
	in_n3,
	in_n4,
	in_n5,
    // Output signals
    out_n
);

//---------------------------------------------------------------------
//   INPUT AND OUTPUT DECLARATION                         
//---------------------------------------------------------------------
input [3:0] in_n0, in_n1, in_n2, in_n3, in_n4, in_n5;
input [4:0] opcode;
output logic [8:0] out_n;

//---------------------------------------------------------------------
//   LOGIC DECLARATION
//---------------------------------------------------------------------

logic [4:0]NUM [5:0];
logic [4:0]NUM2 [5:0];
logic [4:0]NUM3 [5:0];

//---------------------------------------------------------------------
//   Your design                        
//---------------------------------------------------------------------
register_file r1(.address(in_n0),.value(NUM[0]));
register_file r2(.address(in_n1),.value(NUM[1]));
register_file r3(.address(in_n2),.value(NUM[2]));
register_file r4(.address(in_n3),.value(NUM[3]));
register_file r5(.address(in_n4),.value(NUM[4]));
register_file r6(.address(in_n5),.value(NUM[5]));
sort6 s1(NUM[0], NUM[1], NUM[2], NUM[3], NUM[4], NUM[5] , NUM2[0], NUM2[1] , NUM2[2], NUM2[3], NUM2[4], NUM2[5]);
always@(*)begin
	case(opcode[4:3])
	2'b11:begin
		NUM3[5] = NUM2[5];
		NUM3[4] = NUM2[4];
		NUM3[3] = NUM2[3];
		NUM3[2] = NUM2[2];
		NUM3[1] = NUM2[1];
		NUM3[0] = NUM2[0];
		end
	2'b10:begin
		NUM3[5] = NUM2[0];
		NUM3[4] = NUM2[1];
		NUM3[3] = NUM2[2];
		NUM3[2] = NUM2[3];
		NUM3[1] = NUM2[4];
		NUM3[0] = NUM2[5];
		end
	2'b01:begin
		
		NUM3[5] = NUM[0];
		NUM3[4] = NUM[1];
		NUM3[3] = NUM[2];
		NUM3[2] = NUM[3];
		NUM3[1] = NUM[4];
		NUM3[0] = NUM[5];
		end
	2'b00:begin
		NUM3[5] = NUM[5];
		NUM3[4] = NUM[4];
		NUM3[3] = NUM[3];
		NUM3[2] = NUM[2];
		NUM3[1] = NUM[1];
		NUM3[0] = NUM[0];
		end
	default:begin
		
	end
	endcase
	case(opcode[2:0])
	3'b000:begin
			out_n = NUM3[2] - NUM3[1];
		end
	3'b001:begin
			out_n = NUM3[0] + NUM3[3];
		end
	3'b010:begin
			out_n = (NUM3[3]*NUM3[4])/2;
		end
	3'b011:begin
			out_n = NUM3[1] + NUM3[5]*2;
		end
	3'b100:begin
			out_n = NUM3[1] & NUM3[2];
		end
	3'b101:begin
			out_n = ~NUM3[0];
		end
	3'b110:begin
			out_n = NUM3[3] ^ NUM3[4];
		end
	3'b111:begin
			out_n = NUM3[1]<<1;
		end
	default:
		out_n = 00000;
	endcase
end


endmodule



//---------------------------------------------------------------------
//   Register design from TA (Do not modify, or demo fails)
//---------------------------------------------------------------------
module register_file(
    address,
    value
);
input [3:0] address;
output logic [4:0] value;

always_comb begin
    case(address)
    4'b0000:value = 5'd9;
    4'b0001:value = 5'd27;
    4'b0010:value = 5'd30;
    4'b0011:value = 5'd3;
    4'b0100:value = 5'd11;
    4'b0101:value = 5'd8;
    4'b0110:value = 5'd26;
    4'b0111:value = 5'd17;
    4'b1000:value = 5'd3;
    4'b1001:value = 5'd12;
    4'b1010:value = 5'd1;
    4'b1011:value = 5'd10;
    4'b1100:value = 5'd15;
    4'b1101:value = 5'd5;
    4'b1110:value = 5'd23;
    4'b1111:value = 5'd20;
    default: value = 0;
    endcase
end

endmodule
module sort3(in_num1,in_num2,in_num3,out_num1,out_num2,out_num3);
input logic[4:0] in_num1, in_num2, in_num3;
output logic[4:0] out_num1, out_num2, out_num3;
logic num1biggernum2;
always@(*)begin
	/*if(in_num1 >= in_num2 && in_num1 >= in_num3)begin
		out_num3 = in_num1;
		if(in_num2 > in_num3) begin
			out_num1 = in_num3;
			out_num2 = in_num2;
		end
		else begin
			out_num1 = in_num2;
			out_num2 = in_num3;
		end
	end
	else if(in_num2 >= in_num1 && in_num2 >= in_num3)begin
		out_num3 = in_num2;
		if(in_num1 > in_num3) begin
			out_num1 = in_num3;
			out_num2 = in_num1;
		end
		else begin
			out_num1 = in_num1;
			out_num2 = in_num3;
		end
	end
	else begin
		out_num3 = in_num3;
		if(in_num1 > in_num2) begin
			out_num1 = in_num2;
			out_num2 = in_num1;
		end
		else begin
			out_num1 = in_num1;
			out_num2 = in_num2;
		end
	end*/
	if(in_num1 >= in_num2)begin
		out_num1 = in_num2;
		out_num2 = in_num1;
		num1biggernum2 = 1;
	end
	else begin
		out_num1 = in_num1;
		out_num2 = in_num2;
		num1biggernum2 = 0;
	end
	if(in_num3 < out_num1 )begin
		if(num1biggernum2)begin
			out_num3 = in_num1;
			out_num2 = in_num2;
			out_num1 = in_num3;
		end
		else begin
			out_num3 = in_num2;
			out_num2 = in_num1;
			out_num1 = in_num3;
		end
	end
	else if(in_num3 < out_num2)begin
		if(num1biggernum2)begin
			out_num3 = in_num1;
			out_num2 = in_num3;
		end
		else begin
			out_num3 = in_num2;
			out_num2 = in_num3;
		end 
	end
	else begin
		out_num3 = in_num3;
	end
	

end
endmodule

module sort6(in_num1,in_num2,in_num3,in_num4,in_num5,in_num6,out_num1,out_num2,out_num3,out_num4,out_num5,out_num6);
input logic [4:0] in_num1,in_num2,in_num3,in_num4,in_num5,in_num6;
output logic [4:0] out_num1,out_num2,out_num3,out_num4,out_num5,out_num6;
logic [4:0] in_num11,in_num12,in_num13,in_num21,in_num22,in_num23;
logic [2:0] index1,index2;

sort3 s1(in_num1,in_num2,in_num3,in_num11,in_num12,in_num13);
sort3 s2(in_num4,in_num5,in_num6,in_num21,in_num22,in_num23);
always@(*)begin
	index1 = 0;
	index2 = 0;
	if(in_num11<in_num21) begin
		out_num1 = in_num11;
		index1 = index1 + 1;
	end
	else begin
		out_num1 = in_num21;
		index2 = index2 + 1;
	end
	//out_num1 completed
	if(index1 == 1)begin
		if(in_num12 < in_num21)begin
			out_num2 = in_num12;
			index1 = index1 + 1;
		end
		else begin
			out_num2 = in_num21;
			index2 = index2 + 1;
		end
	end
	else begin
		if(in_num22 < in_num11)begin
			out_num2 = in_num22;
			index2 = index2+1;
		end
		else begin
			out_num2 = in_num11;
			index1 = index1 + 1;
		end
	end
	//out_num2 completed
	if(index1 == 2)begin
		if(in_num13 < in_num21)begin
			out_num3 = in_num13;
			index1 = index1 + 1;
		end
		else begin
			out_num3 = in_num21;
			index2 = index2 + 1;
		end
	end
	else if(index1 == 1)begin
		if(in_num12 < in_num22)begin
			out_num3 = in_num12;
			index1 = index1 + 1;
		end
		else begin
			out_num3 = in_num22;
			index2 = index2 + 1;
		end
	end
	else begin
		if(in_num11 < in_num23)begin
			out_num3 = in_num11;
			index1 = index1 + 1;
		end
		else begin
			out_num3 = in_num23;
			index2 = index2 + 1;
		end
	end
	//out_num3 completed
	if(index1 == 3)begin
		out_num4 = in_num21;
		index2 = index2 +  1;
	end
	else if (index1 == 2)begin
		if(in_num13 < in_num22)begin
			out_num4 = in_num13;
			index1  = index1 + 1;
		end
		else begin
			out_num4 = in_num22;
			index2 = index2 + 1;
		end
	end
	else if(index1 == 1) begin
		if(in_num12 < in_num23)begin
			out_num4 = in_num12;
			index1 = index1 + 1;
		end
		else begin
			out_num4 = in_num23;
			index2 = index2 + 1;
		end
	end
	else begin
		out_num4 = in_num11;
		index1 = index1 + 1;
	end
	//out_num4 completed
	if(index1 == 3)begin
		out_num5 = in_num22;
		index2 = index2 + 1;
	end
	else if(index1 == 2)begin
		if(in_num13 < in_num23)begin
			out_num5 = in_num13;
			index1 = index1 + 1;
		end
		else begin
			out_num5 = in_num23;
			index2 = index2 + 1;
		end
	end
	else begin
		out_num5 = in_num12;
		index1 = index1 + 1;
	end
	//out_num5 completed
	if(index1 == 3)begin
		out_num6 = in_num23;
		index2 = index2 + 1;
	end
	else begin
		out_num6 = in_num13;
		index1 = index1 + 1;
	end
	
	
		
end
endmodule 
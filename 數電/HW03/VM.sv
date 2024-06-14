
module VM(
    //Input 
    clk,
    rst_n,
    in_item_valid,
    in_coin_valid,
    in_coin,
    in_rtn_coin,
    in_buy_item,
    in_item_price,
    //OUTPUT
    out_monitor,
    out_valid,
    out_consumer,
    out_sell_num
);

    //Input 
input clk;
input rst_n;
input in_item_valid;
input in_coin_valid;
input [5:0] in_coin;
input in_rtn_coin;
input [2:0] in_buy_item;
input [4:0] in_item_price;
    //OUTPUT
output logic [8:0] out_monitor;
output logic out_valid;
output logic [3:0] out_consumer;
output logic [5:0] out_sell_num;
//---------declaration------------
parameter  S_initem = 2'b00,S_incoin = 2'b01, S_bought = 2'b11;
logic[2:0] in_buy_item_in , in_buy_item_DFF;
logic in_rtn_coin_in, in_rtn_coin_DFF;
logic[2:0] counter , counter_in;
logic[2:0] curstate, next;
logic[8:0] out_monitor_in , money, money_in;
/*logic[3:0] out_consumer_in50, out_consumer_in20, out_consumer_in10, out_consumer_in5, out_consumer_in1;
logic[3:0] out_consumer_DFF50, out_consumer_DFF20, out_consumer_DFF10, out_consumer_DFF5, out_consumer_DFF1;*/
logic[5:0] out_sell_num_in [5:0];
logic[5:0] out_sell_num_DFF [5:0] ;
logic[4:0] in_item_price_DFF [5:0];
logic[4:0] in_item_price_in [5:0];
//---------------------------------------------------------------------
//  Your design(Using FSM)                            
//---------------------------------------------------------------------

assign in_item_price_in[5] = (counter_in == 6 && in_item_valid) ? in_item_price : in_item_price_DFF[5];
assign in_item_price_in[4] = (counter_in == 5 && in_item_valid) ? in_item_price : in_item_price_DFF[4];
assign in_item_price_in[3] = (counter_in == 4 && in_item_valid) ? in_item_price : in_item_price_DFF[3];
assign in_item_price_in[2] = (counter_in == 3 && in_item_valid) ? in_item_price : in_item_price_DFF[2];
assign in_item_price_in[1] = (counter_in == 2 && in_item_valid) ? in_item_price : in_item_price_DFF[1];
assign in_item_price_in[0] = (counter_in == 1 && in_item_valid) ? in_item_price : in_item_price_DFF[0];

always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		in_buy_item_DFF <= 0;
		in_rtn_coin_DFF <= 0;
	end
	else begin
		in_buy_item_DFF <= in_buy_item_in;
		in_rtn_coin_DFF <= in_rtn_coin_in;
	end
end
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		
		in_item_price_DFF[1]<= 0;
		in_item_price_DFF[2]<= 0;
		in_item_price_DFF[3]<= 0;
		in_item_price_DFF[4]<= 0;
		in_item_price_DFF[5]<= 0;
		in_item_price_DFF[0]<= 0;
	end
	else begin
		in_item_price_DFF[1] <= in_item_price_in[1];
		in_item_price_DFF[2] <= in_item_price_in[2];
		in_item_price_DFF[3] <= in_item_price_in[3];
		in_item_price_DFF[4] <= in_item_price_in[4];
		in_item_price_DFF[5] <= in_item_price_in[5];
		in_item_price_DFF[0] <= in_item_price_in[0];
	end
end
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		out_sell_num_DFF[5] <= 0;
		out_sell_num_DFF[4] <= 0;
		out_sell_num_DFF[3] <= 0;
		out_sell_num_DFF[2] <= 0;
		out_sell_num_DFF[1] <= 0;
		out_sell_num_DFF[0] <= 0;
	end
	else begin
		out_sell_num_DFF[5] <= out_sell_num_in[5];
		out_sell_num_DFF[4] <= out_sell_num_in[4];
		out_sell_num_DFF[3] <= out_sell_num_in[3];
		out_sell_num_DFF[2] <= out_sell_num_in[2];
		out_sell_num_DFF[1] <= out_sell_num_in[1];
		out_sell_num_DFF[0] <= out_sell_num_in[0];
	end
end
//assign out_consumer = 0;
//assign out_sell_num = 0;
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		curstate <= 0;
		counter <= 0;
	end
	else begin
		curstate <= next;
		counter <= counter_in;
	end
end
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		out_monitor <= 0;
		money <= 0;
	end
	else begin
		out_monitor <= out_monitor_in;
		money <= money_in;
	end
end
always@(*)begin
	if(!rst_n)begin
		next = 0;
		out_valid = 0;
		counter_in = 6;
		money_in = 0;
		in_buy_item_in = 0;
		in_rtn_coin_in = 0;
		out_sell_num = 0;
		out_consumer = 0;
		out_monitor_in = 0;
	end
	else begin
		out_monitor_in = out_monitor;
		in_buy_item_in = (in_buy_item)? in_buy_item : in_buy_item_DFF;
		in_rtn_coin_in = (in_rtn_coin)? in_rtn_coin : in_rtn_coin_DFF;
		out_consumer = 0;
		out_sell_num = 0;
		case(curstate)
			/*S_idle:begin
				counter_in = 6;
				out_valid = 0;
				money_in = 0;
				if(in_item_valid)begin
					next = S_initem;	
				end
				else begin
					next = S_idle;
				end
			end*/
			S_initem:begin
				out_valid = 0;
				money_in = money;
				if(counter > 1)begin
					counter_in = counter - 1;
					next = S_initem;
				end
				else if(counter == 1)begin
					counter_in = counter - 1;
					next = S_incoin;
				end
				else begin
					next = S_incoin;
					counter_in = 0;
				end 
			end
			S_incoin:begin
				counter_in = 6;
				out_valid = 0;
				if(in_item_valid )begin
					next = S_initem;
				end
				else if(in_buy_item_DFF || in_rtn_coin_DFF)begin
					next = S_bought;
				end
				else begin
					next = S_incoin;
				end
				if(in_coin_valid)begin
					out_monitor_in = out_monitor + in_coin;
				end
				else if(in_buy_item && out_monitor < in_item_price_DFF[6 - in_buy_item])begin
					out_monitor_in = out_monitor;
				end
			    else if(in_buy_item || in_rtn_coin)begin
					out_monitor_in = 0;
				end
				if(out_monitor != 0 )begin
					money_in = out_monitor;
				end
				else if(in_buy_item_DFF )begin
					if(in_item_price_DFF[6 - in_buy_item_DFF] > money)begin
						money_in = 0;
					end
					else begin
						money_in = money - in_item_price_DFF[6 - in_buy_item_DFF];
					end
				end
				else if(in_rtn_coin_DFF)begin
					money_in = money;
				end
				else begin
					money_in = money;
				end
			end
			S_bought:begin
				money_in = money;
				case(counter)
					6:begin
						next =S_bought;
						out_sell_num = out_sell_num_DFF[5];
						out_valid = 1;
						counter_in = counter - 1;
						in_buy_item_in = 0;
						in_rtn_coin_in = 0;
						if(in_buy_item_DFF)begin
							if(money == out_monitor && money != 0)begin
								out_consumer = 0;
							end
							else begin
								out_consumer = in_buy_item_DFF;
							end
						end
						else begin
							out_consumer = 0;
						end
					end
					5:begin
						next =S_bought;
						out_sell_num = out_sell_num_DFF[4];
						out_valid = 1;
						counter_in = counter - 1;
						if(money == out_monitor)begin
							out_consumer = 0;
						end
						else begin
							out_consumer = money / 50;
							money_in = money - out_consumer * 50;
						end
					end
					4:begin
						next = S_bought;
						out_sell_num = out_sell_num_DFF[3];
						out_valid = 1;
						counter_in = counter - 1; 
						if(money == out_monitor)begin
							out_consumer = 0;
						end
						else begin
							out_consumer = money / 20;
							money_in = money - out_consumer * 20;
						end
					end
					3:begin
						next = S_bought;
						out_sell_num = out_sell_num_DFF[2];
						out_valid = 1;
						counter_in = counter - 1;
						if(money == out_monitor)begin
							out_consumer = 0;
						end
						else begin
							out_consumer = money / 10;
							money_in = money - out_consumer * 10;
						end
					end
					2:begin
						next = S_bought;
						out_sell_num = out_sell_num_DFF[1];
						out_valid = 1;
						counter_in = counter - 1;
						if(money == out_monitor)begin
							out_consumer = 0;
						end
						else begin
							out_consumer = money / 5;
							money_in = money - out_consumer * 5;
						end
					end
					1:begin
						next =S_bought;
						out_sell_num = out_sell_num_DFF[0];
						out_valid = 1;
						counter_in = counter - 1;
						if(money == out_monitor)begin
							out_consumer = 0;
						end
						else begin
							out_consumer = money ;
							money_in = 0;
						end
					end
					default:begin
						out_sell_num = 0;
						out_valid = 0;
						counter_in = 0;
						out_consumer = 0;
						money_in = 0;
						next = S_incoin;
					end
				endcase
				
			end
			default: begin
				money_in = 0;
				next = 0;
				out_valid = 0;
				counter_in = 6;
			end
			
		endcase
	end
end
always@(*)begin
	out_sell_num_in[5] = out_sell_num_DFF[5];
	out_sell_num_in[4] = out_sell_num_DFF[4];
	out_sell_num_in[3] = out_sell_num_DFF[3];
	out_sell_num_in[2] = out_sell_num_DFF[2];
	out_sell_num_in[1] = out_sell_num_DFF[1];
	out_sell_num_in[0] = out_sell_num_DFF[0];
	if(in_item_valid)begin
		out_sell_num_in[5] = 0;
		out_sell_num_in[4] = 0;
		out_sell_num_in[3] = 0;
		out_sell_num_in[2] = 0;
		out_sell_num_in[1] = 0;
		out_sell_num_in[0] = 0;
	end
	else if(in_buy_item_DFF && money != out_monitor)begin
		out_sell_num_in[6 - in_buy_item_in]  = out_sell_num_DFF[6 - in_buy_item_in] + 1;
	end
	else begin
		out_sell_num_in[5] = out_sell_num_DFF[5];
		out_sell_num_in[4] = out_sell_num_DFF[4];
		out_sell_num_in[3] = out_sell_num_DFF[3];
		out_sell_num_in[2] = out_sell_num_DFF[2];
		out_sell_num_in[1] = out_sell_num_DFF[1];
		out_sell_num_in[0] = out_sell_num_DFF[0];
	end
end


endmodule



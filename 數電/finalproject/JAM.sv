module JAM(
  // Input signals
	clk,
	rst_n,
    in_valid,
    in_cost,
  // Output signals
	out_valid,
    out_job,
	out_cost
);

//---------------------------------------------------------------------
//   INPUT AND OUTPUT DECLARATION                         
//---------------------------------------------------------------------
input clk, rst_n, in_valid;
input [6:0] in_cost;
output logic out_valid;
output logic [3:0] out_job;
output logic [9:0] out_cost;
//---------------------------------------------------------------------
//   PARAMETER DECLARATION
//---------------------------------------------------------------------
parameter S_find_every = 1,S_calculate_every = 3,S_find_every2 = 4, S_output = 2,S_input = 0;
//---------------------------------------------------------------------
//   LOGIC DECLARATION
//---------------------------------------------------------------------
logic out_valid_comb;
logic [3:0] out_job_comb;
logic [9:0] out_cost_comb;
logic [6:0] worker_cost_DFF1[0:7];
logic [6:0] worker_cost_DFF2[0:7];
logic [6:0] worker_cost_DFF3[0:7];
logic [6:0] worker_cost_DFF4[0:7];
logic [6:0] worker_cost_DFF5[0:7];
logic [6:0] worker_cost_DFF6[0:7];
logic [6:0] worker_cost_DFF7[0:7];
logic [6:0] worker_cost_DFF8[0:7];
logic [6:0] worker_cost_comb1[0:7];
logic [6:0] worker_cost_comb2[0:7];
logic [6:0] worker_cost_comb3[0:7];
logic [6:0] worker_cost_comb4[0:7];
logic [6:0] worker_cost_comb5[0:7];
logic [6:0] worker_cost_comb6[0:7];
logic [6:0] worker_cost_comb7[0:7];
logic [6:0] worker_cost_comb8[0:7];
logic [2:0] job_assigned[0:7];
logic [2:0] job_assigned2[0:7];

logic [2:0] job_assigned_delay[0:7];
logic [2:0] job_assigned2_delay[0:7];
logic [2:0] job_assigned_delay_delay[0:7];
logic [2:0] job_assigned2_delay_delay[0:7];
logic [2:0] new_job_assign[0:7];

logic [2:0] new_job_assign2[0:7];

logic [14:0] counter_2;
logic [14:0] counter_2_DFF;

logic [2:0] fornow_best_job_assigned[0:7];
logic [2:0] fornow_best_job_assigned_DFF[0:7];
logic [2:0] curstate,nextstate;
logic [3:0] counter,counter_DFF;
logic [2:0] change;
logic [2:0] smallest_but_larger_index;
logic [9:0] best_answer_DFF,best_answer, current_answer_1_DFF,current_answer_1,current_answer_2_DFF,current_answer_2;
logic in_valid_DFF;
logic last_answer_come;
logic last_answer_come_DFF;
integer i;
//---------------------------------------------------------------------
//   Your design                        
//---------------------------------------------------------------------
/*always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		best_answer_DFF <= 0;
	end
	else begin
		best_answer_DFF <= best_answer;
	end
end*/
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		counter_2_DFF <= 0;
	end
	else begin
		counter_2_DFF <= counter_2;
	end
end
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		last_answer_come_DFF <= 0;
	end
	else begin
		last_answer_come_DFF <= last_answer_come;
	end
end
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		current_answer_1_DFF <= 0;
		current_answer_2_DFF <= 0;
	end
	else begin
		current_answer_1_DFF <= current_answer_1;
		current_answer_2_DFF <= current_answer_2;
	end
end
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		for(i = 0;i < 8;i++)begin
			job_assigned_delay_delay[i] <= i;
		end
	end
	else begin
		for(i = 0;i < 8;i++)begin
			job_assigned_delay_delay[i] <= job_assigned_delay[i];
		end
	end
end
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		for(i = 0;i < 8;i++)begin
			job_assigned2_delay_delay[i] <= i;
		end
	end
	else begin
		for(i = 0;i < 8;i++)begin
			job_assigned2_delay_delay[i] <= job_assigned2_delay[i];
		end
	end
end
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		in_valid_DFF <=0;
	end
	else begin
		in_valid_DFF <= in_valid;
	end
end
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		for(i = 0;i < 8;i++)begin
			job_assigned_delay[i] <= i;
		end
	end
	else begin
		for(i = 0;i < 8;i++)begin
			job_assigned_delay[i] <= job_assigned[i];
		end
	end
end
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		for(i = 0;i < 8;i++)begin
			job_assigned2_delay[i] <= i;
		end
	end
	else begin
		for(i = 0;i < 8;i++)begin
			job_assigned2_delay[i] <= job_assigned2[i];
		end
	end
end
/* always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		current_answer_DFF <= 0;
	end
	else begin
		current_answer_DFF <= current_answer;
	end	
end */
//counter
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		counter_DFF <= 0;
	end
	else begin
		counter_DFF <= counter;
	end
end
//input DFF
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		worker_cost_DFF1 <= '{8{0}};
		worker_cost_DFF2 <= '{8{0}};
		worker_cost_DFF3 <= '{8{0}};
		worker_cost_DFF4 <= '{8{0}};
		worker_cost_DFF5 <= '{8{0}};
		worker_cost_DFF6 <= '{8{0}};
		worker_cost_DFF7 <= '{8{0}};
		worker_cost_DFF8 <= '{8{0}};
	end
	else begin
		integer i;
		for(int i = 0; i < 8;i++)begin
			worker_cost_DFF1[i] <= worker_cost_comb1[i];
			worker_cost_DFF2[i] <= worker_cost_comb2[i];
			worker_cost_DFF3[i] <= worker_cost_comb3[i];
			worker_cost_DFF4[i] <= worker_cost_comb4[i];
			worker_cost_DFF5[i] <= worker_cost_comb5[i];
			worker_cost_DFF6[i] <= worker_cost_comb6[i];
			worker_cost_DFF7[i] <= worker_cost_comb7[i];
			worker_cost_DFF8[i] <= worker_cost_comb8[i];
		end
	end
end
//FSM
/* always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		curstate <= S_input;
	end
	else begin
		curstate <= nextstate;
	end
end */

//job assign so far 
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		job_assigned[0] <= 0;
		job_assigned[1] <= 1;
		job_assigned[2] <= 2;
		job_assigned[3] <= 3;
		job_assigned[4] <= 4;
		job_assigned[5] <= 5;
		job_assigned[6] <= 6;
		job_assigned[7] <= 7;
	end
	else begin
		integer i;
		for(i = 0;i < 8;i++)begin
			job_assigned[i] <= new_job_assign[i];
		end
	end
end
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		job_assigned2[0] <= 4;
		job_assigned2[1] <= 0;
		job_assigned2[2] <= 1;
		job_assigned2[3] <= 2;
		job_assigned2[4] <= 3;
		job_assigned2[5] <= 5;
		job_assigned2[6] <= 6;
		job_assigned2[7] <= 7;
	end
	else begin
		integer i;
		for(i = 0;i < 8;i++)begin
			job_assigned2[i] <= new_job_assign2[i];
		end
	end
end
//best answer
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		
		fornow_best_job_assigned_DFF[0] <= 0;
		fornow_best_job_assigned_DFF[1] <= 1;
		fornow_best_job_assigned_DFF[2] <= 2;
		fornow_best_job_assigned_DFF[3] <= 3;
		fornow_best_job_assigned_DFF[4] <= 4;
		fornow_best_job_assigned_DFF[5] <= 5;
		fornow_best_job_assigned_DFF[6] <= 6;
		fornow_best_job_assigned_DFF[7] <= 7;
		
	end
	else begin
		integer i;
		for(i = 0;i < 8;i++)begin
			fornow_best_job_assigned_DFF[i] <= fornow_best_job_assigned[i];
		end
	end
end
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		out_cost <= 0;
		out_valid <= 0;
		out_job <= 0;
	end
	else begin
		out_cost <= out_cost_comb;
		out_job <= out_job_comb;
		out_valid <= out_valid_comb;
	end
end
//FSM
/*always@(*)begin
	case(curstate)
		S_input:begin
			if(in_valid)begin
				counter = counter_DFF + 1;
			end
			else begin
				counter = 0;
			end
			if(counter_DFF == 63)begin
				nextstate = S_find_every2;
				counter = 0;
			end
			else begin
				nextstate = S_input;
			end
		end
		S_find_every:begin
			counter = 0;
			nextstate = S_find_every2;
		end
		S_find_every2:begin
			counter = 0;
			nextstate = S_calculate_every;
		end
		S_find_every2:begin
			if(job_assigned_delay[0] == 7 && job_assigned_delay[1] == 6 && job_assigned_delay[2] == 5 && job_assigned_delay[3] == 4 && job_assigned_delay[4] == 3 && job_assigned_delay[5] == 2 && job_assigned_delay[6] == 1 && job_assigned_delay[7] == 0)begin
				nextstate = S_output;
			end
			else begin
				nextstate = S_find_every2;
			end
			counter = 0;
		end
		S_output:begin
			counter = counter_DFF + 1;
			if(counter_DFF == 7)begin
				nextstate = S_input;
				counter = 0;
			end
			else begin
				nextstate = S_output;
			end
		end	
		default:begin
			counter = 0;
			nextstate = 0;
		end
	endcase
end*/

//input

always@(*)begin
	
	if(in_valid)begin
		worker_cost_comb8[7] = in_cost;
		for(i = 1;i < 8;i++)begin
			worker_cost_comb1[i - 1] = worker_cost_DFF1[i];
			worker_cost_comb2[i - 1] = worker_cost_DFF2[i];
			worker_cost_comb3[i - 1] = worker_cost_DFF3[i];
			worker_cost_comb4[i - 1] = worker_cost_DFF4[i];
			worker_cost_comb5[i - 1] = worker_cost_DFF5[i];
			worker_cost_comb6[i - 1] = worker_cost_DFF6[i];
			worker_cost_comb7[i - 1] = worker_cost_DFF7[i];
			worker_cost_comb8[i - 1] = worker_cost_DFF8[i];
		end
		worker_cost_comb7[7] = worker_cost_DFF8[0];
		worker_cost_comb6[7] = worker_cost_DFF7[0];
		worker_cost_comb5[7] = worker_cost_DFF6[0];
		worker_cost_comb4[7] = worker_cost_DFF5[0];
		worker_cost_comb3[7] = worker_cost_DFF4[0];
		worker_cost_comb2[7] = worker_cost_DFF3[0];
		worker_cost_comb1[7] = worker_cost_DFF2[0];
	end
	else begin
		for(i = 0;i < 8;i++)begin
			worker_cost_comb1[i] = worker_cost_DFF1[i];
			worker_cost_comb2[i] = worker_cost_DFF2[i];
			worker_cost_comb3[i] = worker_cost_DFF3[i];
			worker_cost_comb4[i] = worker_cost_DFF4[i];
			worker_cost_comb5[i] = worker_cost_DFF5[i];
			worker_cost_comb6[i] = worker_cost_DFF6[i];
			worker_cost_comb7[i] = worker_cost_DFF7[i];
			worker_cost_comb8[i] = worker_cost_DFF8[i];
		end
	end
end

//find every 

 /*FindSmallestvalue f1(.index(change), .jobassign1(job_assigned[0]), .jobassign2(job_assigned[1]), 
					.jobassign3(job_assigned[2]), .jobassign4(job_assigned[3]), 
					.jobassign5(job_assigned[4]), .jobassign6(job_assigned[5]),
					.jobassign7(job_assigned[6]), .jobassign8(job_assigned[7]),
					.smallest_but_largerindex(smallest_but_larger_index)
);*/ 
/* logic [6:0] min;
always@(*)begin
	min = job_assigned[7];
	smallest_but_larger_index = 7;
	case(change)
			7:begin
				smallest_but_larger_index = 7;
			end	
			6:begin
				smallest_but_larger_index = 7;
			end
			5:begin
				if(job_assigned[6] < job_assigned[7] && job_assigned[6] > job_assigned[5])begin
					smallest_but_larger_index = 6;
				end
				else if(job_assigned[7] < job_assigned[5])begin
					smallest_but_larger_index = 6;
				end
				else begin
					smallest_but_larger_index = 7;
				end
			end
			4:begin
				min = job_assigned[5];
				for(i = 5; i < 8;i++)begin
				if(job_assigned[i] < min && job_assigned[i] > job_assigned[4])begin
					min = job_assigned[i];
					smallest_but_larger_index = i;
				end
				end
			end
			3:begin
				min = job_assigned[4];
				for(i = 4; i < 8;i++)begin
				if(job_assigned[i] < min && job_assigned[i] > job_assigned[3])begin
					min = job_assigned[i];
					smallest_but_larger_index = i;
				end
				end
			end
			2:begin
				min = job_assigned[3];
				for(i = 3; i < 8;i++)begin
				if(job_assigned[i] < min && job_assigned[i] > job_assigned[2])begin
					min = job_assigned[i];
					smallest_but_larger_index = i;
				end
				end
			end
			1:begin
				min = job_assigned[2];
				for(i = 2; i < 8;i++)begin
				if(job_assigned[i] < min && job_assigned[i] > job_assigned[1])begin
					min = job_assigned[i];
					smallest_but_larger_index = i;
				end
				end
			end
			0:begin
				min = job_assigned[1];
				for(i = 1; i < 8;i++)begin
				if(job_assigned[i] < min && job_assigned[i] > job_assigned[0])begin
					min = job_assigned[i];
					smallest_but_larger_index = i;
				end
				end
			end
		endcase
end */

//int sum = 0;
//find every possible job assignment
always@(*)begin
	for(i = 0;i < 8;i++)begin
		new_job_assign[i] = job_assigned[i];
	end
	if(!in_valid_DFF && out_valid!= 1)begin
		
		
		if(job_assigned[7] > job_assigned[6])begin
				//$display("1");
				new_job_assign[6] = job_assigned[7];
				new_job_assign[7] = job_assigned[6];
		end
		else if(job_assigned[6] > job_assigned[5])begin
				//$display("2");
				if(job_assigned[7] > job_assigned[5])begin
					new_job_assign[5] = job_assigned[7];
					new_job_assign[6] = job_assigned[5];
					new_job_assign[7] = job_assigned[6];
				end
				else begin	
					new_job_assign[5] = job_assigned[6];
					new_job_assign[6] = job_assigned[7];
					new_job_assign[7] = job_assigned[5];
				end
		end
		else if(job_assigned[5] > job_assigned[4])begin
				//$display("2");
				if(job_assigned[7] > job_assigned[4])begin
					new_job_assign[4] = job_assigned[7];
					new_job_assign[5] = job_assigned[4];
					new_job_assign[6] = job_assigned[6];
					new_job_assign[7] = job_assigned[5];
				end
				else if(job_assigned[6] > job_assigned[4])begin
					new_job_assign[4] = job_assigned[6];
					new_job_assign[5] = job_assigned[7];
					new_job_assign[6] = job_assigned[4];
					new_job_assign[7] = job_assigned[5];
				end
				else begin
					new_job_assign[4] = job_assigned[5];
					new_job_assign[5] = job_assigned[7];
					new_job_assign[6] = job_assigned[6];
					new_job_assign[7] = job_assigned[4];
				end
				
		end
		else if(job_assigned[4] > job_assigned[3])begin
				//$display("3");
				if(job_assigned[7] > job_assigned[3])begin
					new_job_assign[3] = job_assigned[7];
					new_job_assign[4] = job_assigned[3];
					new_job_assign[5] = job_assigned[6];
					new_job_assign[6] = job_assigned[5];
					new_job_assign[7] = job_assigned[4];
				end
				else if(job_assigned[6] > job_assigned[3])begin
					new_job_assign[3] = job_assigned[6];
					new_job_assign[4] = job_assigned[7];
					new_job_assign[5] = job_assigned[3];
					new_job_assign[6] = job_assigned[5];
					new_job_assign[7] = job_assigned[4];
				end
				else if(job_assigned[5] > job_assigned[3])begin
					new_job_assign[3] = job_assigned[5];
					new_job_assign[4] = job_assigned[7];
					new_job_assign[5] = job_assigned[6];
					new_job_assign[6] = job_assigned[3];
					new_job_assign[7] = job_assigned[4];
				end
				else begin
					new_job_assign[3] = job_assigned[4];
					new_job_assign[4] = job_assigned[7];
					new_job_assign[5] = job_assigned[6];
					new_job_assign[6] = job_assigned[5];
					new_job_assign[7] = job_assigned[3];
				end
			
		end
		else if(job_assigned[3] > job_assigned[2])begin
				//$display("4");
				if(job_assigned[7] > job_assigned[2])begin
					new_job_assign[2] = job_assigned[7];
					new_job_assign[3] = job_assigned[2];
					new_job_assign[4] = job_assigned[6];
					new_job_assign[5] = job_assigned[5];
					new_job_assign[6] = job_assigned[4];
					new_job_assign[7] = job_assigned[3];
				end
				else if(job_assigned[6] > job_assigned[2])begin
					new_job_assign[2] = job_assigned[6];
					new_job_assign[3] = job_assigned[7];
					new_job_assign[4] = job_assigned[2];
					new_job_assign[5] = job_assigned[5];
					new_job_assign[6] = job_assigned[4];
					new_job_assign[7] = job_assigned[3];
				end
				else if(job_assigned[5] > job_assigned[2])begin
					new_job_assign[2] = job_assigned[5];
					new_job_assign[3] = job_assigned[7];
					new_job_assign[4] = job_assigned[6];
					new_job_assign[5] = job_assigned[2];
					new_job_assign[6] = job_assigned[4];
					new_job_assign[7] = job_assigned[3];
				end
				else if(job_assigned[4] > job_assigned[2])begin
					new_job_assign[2] = job_assigned[4];
					new_job_assign[3] = job_assigned[7];
					new_job_assign[4] = job_assigned[6];
					new_job_assign[5] = job_assigned[5];
					new_job_assign[6] = job_assigned[2];
					new_job_assign[7] = job_assigned[3];
				end
				else begin
					new_job_assign[2] = job_assigned[3];
					new_job_assign[3] = job_assigned[7];
					new_job_assign[4] = job_assigned[6];
					new_job_assign[5] = job_assigned[5];
					new_job_assign[6] = job_assigned[4];
					new_job_assign[7] = job_assigned[2];
				end
				
		end
		else if(job_assigned[2] > job_assigned[1])begin
			//$display("5");
			if(job_assigned[7] > job_assigned[1])begin
				new_job_assign[1] = job_assigned[7];
				new_job_assign[2] = job_assigned[1];
				new_job_assign[3] = job_assigned[6];
				new_job_assign[4] = job_assigned[5];
				new_job_assign[5] = job_assigned[4];
				new_job_assign[6] = job_assigned[3];
				new_job_assign[7] = job_assigned[2];
			end
			else if(job_assigned[6] > job_assigned[1])begin
				new_job_assign[1] = job_assigned[6];
				new_job_assign[2] = job_assigned[7];
				new_job_assign[3] = job_assigned[1];
				new_job_assign[4] = job_assigned[5];
				new_job_assign[5] = job_assigned[4];
				new_job_assign[6] = job_assigned[3];
				new_job_assign[7] = job_assigned[2];
			end
			else if(job_assigned[5] > job_assigned[1])begin
				new_job_assign[1] = job_assigned[5];
				new_job_assign[2] = job_assigned[7];
				new_job_assign[3] = job_assigned[6];
				new_job_assign[4] = job_assigned[1];
				new_job_assign[5] = job_assigned[4];
				new_job_assign[6] = job_assigned[3];
				new_job_assign[7] = job_assigned[2];
			end
			else if(job_assigned[4] > job_assigned[1])begin
				new_job_assign[1] = job_assigned[4];
				new_job_assign[2] = job_assigned[7];
				new_job_assign[3] = job_assigned[6];
				new_job_assign[4] = job_assigned[5];
				new_job_assign[5] = job_assigned[1];
				new_job_assign[6] = job_assigned[3];
				new_job_assign[7] = job_assigned[2];
			end
			else if(job_assigned[3] > job_assigned[1])begin
				new_job_assign[1] = job_assigned[3];
				new_job_assign[2] = job_assigned[7];
				new_job_assign[3] = job_assigned[6];
				new_job_assign[4] = job_assigned[5];
				new_job_assign[5] = job_assigned[4];
				new_job_assign[6] = job_assigned[1];
				new_job_assign[7] = job_assigned[2];
			end
			else begin
				new_job_assign[1] = job_assigned[2];
				new_job_assign[2] = job_assigned[7];
				new_job_assign[3] = job_assigned[6];
				new_job_assign[4] = job_assigned[5];
				new_job_assign[5] = job_assigned[4];
				new_job_assign[6] = job_assigned[3];
				new_job_assign[7] = job_assigned[1];
			end
			
		end
		else if(job_assigned[1] > job_assigned[0])begin
			//$display("6");
			if(job_assigned[7] > job_assigned[0])begin
				new_job_assign[0] = job_assigned[7];
				new_job_assign[1] = job_assigned[0];
				new_job_assign[2] = job_assigned[6];
				new_job_assign[3] = job_assigned[5];
				new_job_assign[4] = job_assigned[4];
				new_job_assign[5] = job_assigned[3];
				new_job_assign[6] = job_assigned[2];
				new_job_assign[7] = job_assigned[1];
			end
			else if(job_assigned[6] > job_assigned[0])begin
				new_job_assign[0] = job_assigned[6];
				new_job_assign[1] = job_assigned[7];
				new_job_assign[2] = job_assigned[0];
				new_job_assign[3] = job_assigned[5];
				new_job_assign[4] = job_assigned[4];
				new_job_assign[5] = job_assigned[3];
				new_job_assign[6] = job_assigned[2];
				new_job_assign[7] = job_assigned[1];
			end
			else if(job_assigned[5] > job_assigned[0])begin
				new_job_assign[0] = job_assigned[5];
				new_job_assign[1] = job_assigned[7];
				new_job_assign[2] = job_assigned[6];
				new_job_assign[3] = job_assigned[0];
				new_job_assign[4] = job_assigned[4];
				new_job_assign[5] = job_assigned[3];
				new_job_assign[6] = job_assigned[2];
				new_job_assign[7] = job_assigned[1];
			end
			else if(job_assigned[4] > job_assigned[0])begin
				new_job_assign[0] = job_assigned[4];
				new_job_assign[1] = job_assigned[7];
				new_job_assign[2] = job_assigned[6];
				new_job_assign[3] = job_assigned[5];
				new_job_assign[4] = job_assigned[0];
				new_job_assign[5] = job_assigned[3];
				new_job_assign[6] = job_assigned[2];
				new_job_assign[7] = job_assigned[1];
			end
			else if(job_assigned[3] > job_assigned[0])begin
				new_job_assign[0] = job_assigned[3];
				new_job_assign[1] = job_assigned[7];
				new_job_assign[2] = job_assigned[6];
				new_job_assign[3] = job_assigned[5];
				new_job_assign[4] = job_assigned[4];
				new_job_assign[5] = job_assigned[0];
				new_job_assign[6] = job_assigned[2];
				new_job_assign[7] = job_assigned[1];
			end
			else if(job_assigned[2] > job_assigned[0])begin
				new_job_assign[0] = job_assigned[2];
				new_job_assign[1] = job_assigned[7];
				new_job_assign[2] = job_assigned[6];
				new_job_assign[3] = job_assigned[5];
				new_job_assign[4] = job_assigned[4];
				new_job_assign[5] = job_assigned[3];
				new_job_assign[6] = job_assigned[0];
				new_job_assign[7] = job_assigned[1];
			end
			else begin
				new_job_assign[0] = job_assigned[1];
				new_job_assign[1] = job_assigned[7];
				new_job_assign[2] = job_assigned[6];
				new_job_assign[3] = job_assigned[5];
				new_job_assign[4] = job_assigned[4];
				new_job_assign[5] = job_assigned[3];
				new_job_assign[6] = job_assigned[2];
				new_job_assign[7] = job_assigned[0];
			end
				
		end
		
 	
		//$display("%d",change);
		//$display("%d\n",sum);
		//$display("%d",smallest_but_larger_index);
		//$display("\n");
		//sum = sum + 1;
 	end
	else begin
		for(i = 0;i < 8;i++)begin
			new_job_assign[i] = i;
		end
	end
end
int sum = 0;
always@(*)begin
	for(i = 0;i < 8;i++)begin
		new_job_assign2[i] = job_assigned2[i];
	end
	counter_2 = counter_2_DFF;
	if(!in_valid_DFF)begin
		
		if(job_assigned2[7] > job_assigned2[6])begin
				counter_2 = counter_2_DFF + 1;
				new_job_assign2[6] = job_assigned2[7];
				new_job_assign2[7] = job_assigned2[6];
		end
		else if(job_assigned2[6] > job_assigned2[5])begin
				counter_2 = counter_2_DFF + 1;
				if(job_assigned2[7] > job_assigned2[5])begin
					new_job_assign2[5] = job_assigned2[7];
					new_job_assign2[6] = job_assigned2[5];
					new_job_assign2[7] = job_assigned2[6];
				end
				else begin	
					new_job_assign2[5] = job_assigned2[6];
					new_job_assign2[6] = job_assigned2[7];
					new_job_assign2[7] = job_assigned2[5];
				end
		end
		else if(job_assigned2[5] > job_assigned2[4])begin
				counter_2 = counter_2_DFF + 1;
				if(job_assigned2[7] > job_assigned2[4])begin
					new_job_assign2[4] = job_assigned2[7];
					new_job_assign2[5] = job_assigned2[4];
					new_job_assign2[6] = job_assigned2[6];
					new_job_assign2[7] = job_assigned2[5];
				end
				else if(job_assigned2[6] > job_assigned2[4])begin
					new_job_assign2[4] = job_assigned2[6];
					new_job_assign2[5] = job_assigned2[7];
					new_job_assign2[6] = job_assigned2[4];
					new_job_assign2[7] = job_assigned2[5];
				end
				else begin
					new_job_assign2[4] = job_assigned2[5];
					new_job_assign2[5] = job_assigned2[7];
					new_job_assign2[6] = job_assigned2[6];
					new_job_assign2[7] = job_assigned2[4];
				end
				
		end
		else if(job_assigned2[4] > job_assigned2[3])begin
				counter_2 = counter_2_DFF + 1;
				if(job_assigned2[7] > job_assigned2[3])begin
					new_job_assign2[3] = job_assigned2[7];
					new_job_assign2[4] = job_assigned2[3];
					new_job_assign2[5] = job_assigned2[6];
					new_job_assign2[6] = job_assigned2[5];
					new_job_assign2[7] = job_assigned2[4];
				end
				else if(job_assigned2[6] > job_assigned2[3])begin
					new_job_assign2[3] = job_assigned2[6];
					new_job_assign2[4] = job_assigned2[7];
					new_job_assign2[5] = job_assigned2[3];
					new_job_assign2[6] = job_assigned2[5];
					new_job_assign2[7] = job_assigned2[4];
				end
				else if(job_assigned2[5] > job_assigned2[3])begin
					new_job_assign2[3] = job_assigned2[5];
					new_job_assign2[4] = job_assigned2[7];
					new_job_assign2[5] = job_assigned2[6];
					new_job_assign2[6] = job_assigned2[3];
					new_job_assign2[7] = job_assigned2[4];
				end
				else begin
					new_job_assign2[3] = job_assigned2[4];
					new_job_assign2[4] = job_assigned2[7];
					new_job_assign2[5] = job_assigned2[6];
					new_job_assign2[6] = job_assigned2[5];
					new_job_assign2[7] = job_assigned2[3];
				end
			
		end
		else if(job_assigned2[3] > job_assigned2[2])begin
				counter_2 = counter_2_DFF + 1;
				if(job_assigned2[7] > job_assigned2[2])begin
					new_job_assign2[2] = job_assigned2[7];
					new_job_assign2[3] = job_assigned2[2];
					new_job_assign2[4] = job_assigned2[6];
					new_job_assign2[5] = job_assigned2[5];
					new_job_assign2[6] = job_assigned2[4];
					new_job_assign2[7] = job_assigned2[3];
				end
				else if(job_assigned2[6] > job_assigned2[2])begin
					new_job_assign2[2] = job_assigned2[6];
					new_job_assign2[3] = job_assigned2[7];
					new_job_assign2[4] = job_assigned2[2];
					new_job_assign2[5] = job_assigned2[5];
					new_job_assign2[6] = job_assigned2[4];
					new_job_assign2[7] = job_assigned2[3];
				end
				else if(job_assigned2[5] > job_assigned2[2])begin
					new_job_assign2[2] = job_assigned2[5];
					new_job_assign2[3] = job_assigned2[7];
					new_job_assign2[4] = job_assigned2[6];
					new_job_assign2[5] = job_assigned2[2];
					new_job_assign2[6] = job_assigned2[4];
					new_job_assign2[7] = job_assigned2[3];
				end
				else if(job_assigned2[4] > job_assigned2[2])begin
					new_job_assign2[2] = job_assigned2[4];
					new_job_assign2[3] = job_assigned2[7];
					new_job_assign2[4] = job_assigned2[6];
					new_job_assign2[5] = job_assigned2[5];
					new_job_assign2[6] = job_assigned2[2];
					new_job_assign2[7] = job_assigned2[3];
				end
				else begin
					new_job_assign2[2] = job_assigned2[3];
					new_job_assign2[3] = job_assigned2[7];
					new_job_assign2[4] = job_assigned2[6];
					new_job_assign2[5] = job_assigned2[5];
					new_job_assign2[6] = job_assigned2[4];
					new_job_assign2[7] = job_assigned2[2];
				end
				
		end
		else if(job_assigned2[2] > job_assigned2[1])begin
			counter_2 = counter_2_DFF + 1;
			if(job_assigned2[7] > job_assigned2[1])begin
				new_job_assign2[1] = job_assigned2[7];
				new_job_assign2[2] = job_assigned2[1];
				new_job_assign2[3] = job_assigned2[6];
				new_job_assign2[4] = job_assigned2[5];
				new_job_assign2[5] = job_assigned2[4];
				new_job_assign2[6] = job_assigned2[3];
				new_job_assign2[7] = job_assigned2[2];
			end
			else if(job_assigned2[6] > job_assigned2[1])begin
				new_job_assign2[1] = job_assigned2[6];
				new_job_assign2[2] = job_assigned2[7];
				new_job_assign2[3] = job_assigned2[1];
				new_job_assign2[4] = job_assigned2[5];
				new_job_assign2[5] = job_assigned2[4];
				new_job_assign2[6] = job_assigned2[3];
				new_job_assign2[7] = job_assigned2[2];
			end
			else if(job_assigned2[5] > job_assigned2[1])begin
				new_job_assign2[1] = job_assigned2[5];
				new_job_assign2[2] = job_assigned2[7];
				new_job_assign2[3] = job_assigned2[6];
				new_job_assign2[4] = job_assigned2[1];
				new_job_assign2[5] = job_assigned2[4];
				new_job_assign2[6] = job_assigned2[3];
				new_job_assign2[7] = job_assigned2[2];
			end
			else if(job_assigned2[4] > job_assigned2[1])begin
				new_job_assign2[1] = job_assigned2[4];
				new_job_assign2[2] = job_assigned2[7];
				new_job_assign2[3] = job_assigned2[6];
				new_job_assign2[4] = job_assigned2[5];
				new_job_assign2[5] = job_assigned2[1];
				new_job_assign2[6] = job_assigned2[3];
				new_job_assign2[7] = job_assigned2[2];
			end
			else if(job_assigned2[3] > job_assigned2[1])begin
				new_job_assign2[1] = job_assigned2[3];
				new_job_assign2[2] = job_assigned2[7];
				new_job_assign2[3] = job_assigned2[6];
				new_job_assign2[4] = job_assigned2[5];
				new_job_assign2[5] = job_assigned2[4];
				new_job_assign2[6] = job_assigned2[1];
				new_job_assign2[7] = job_assigned2[2];
			end
			else begin
				new_job_assign2[1] = job_assigned2[2];
				new_job_assign2[2] = job_assigned2[7];
				new_job_assign2[3] = job_assigned2[6];
				new_job_assign2[4] = job_assigned2[5];
				new_job_assign2[5] = job_assigned2[4];
				new_job_assign2[6] = job_assigned2[3];
				new_job_assign2[7] = job_assigned2[1];
			end
			
		end
		else if(job_assigned2[1] > job_assigned2[0])begin
			counter_2 = counter_2_DFF + 1;
			if(job_assigned2[7] > job_assigned2[0])begin
				new_job_assign2[0] = job_assigned2[7];
				new_job_assign2[1] = job_assigned2[0];
				new_job_assign2[2] = job_assigned2[6];
				new_job_assign2[3] = job_assigned2[5];
				new_job_assign2[4] = job_assigned2[4];
				new_job_assign2[5] = job_assigned2[3];
				new_job_assign2[6] = job_assigned2[2];
				new_job_assign2[7] = job_assigned2[1];
			end
			else if(job_assigned2[6] > job_assigned2[0])begin
				new_job_assign2[0] = job_assigned2[6];
				new_job_assign2[1] = job_assigned2[7];
				new_job_assign2[2] = job_assigned2[0];
				new_job_assign2[3] = job_assigned2[5];
				new_job_assign2[4] = job_assigned2[4];
				new_job_assign2[5] = job_assigned2[3];
				new_job_assign2[6] = job_assigned2[2];
				new_job_assign2[7] = job_assigned2[1];
			end
			else if(job_assigned2[5] > job_assigned2[0])begin
				new_job_assign2[0] = job_assigned2[5];
				new_job_assign2[1] = job_assigned2[7];
				new_job_assign2[2] = job_assigned2[6];
				new_job_assign2[3] = job_assigned2[0];
				new_job_assign2[4] = job_assigned2[4];
				new_job_assign2[5] = job_assigned2[3];
				new_job_assign2[6] = job_assigned2[2];
				new_job_assign2[7] = job_assigned2[1];
			end
			else if(job_assigned2[4] > job_assigned2[0])begin
				new_job_assign2[0] = job_assigned2[4];
				new_job_assign2[1] = job_assigned2[7];
				new_job_assign2[2] = job_assigned2[6];
				new_job_assign2[3] = job_assigned2[5];
				new_job_assign2[4] = job_assigned2[0];
				new_job_assign2[5] = job_assigned2[3];
				new_job_assign2[6] = job_assigned2[2];
				new_job_assign2[7] = job_assigned2[1];
			end
			else if(job_assigned2[3] > job_assigned2[0])begin
				new_job_assign2[0] = job_assigned2[3];
				new_job_assign2[1] = job_assigned2[7];
				new_job_assign2[2] = job_assigned2[6];
				new_job_assign2[3] = job_assigned2[5];
				new_job_assign2[4] = job_assigned2[4];
				new_job_assign2[5] = job_assigned2[0];
				new_job_assign2[6] = job_assigned2[2];
				new_job_assign2[7] = job_assigned2[1];
			end
			else if(job_assigned2[2] > job_assigned2[0])begin
				new_job_assign2[0] = job_assigned2[2];
				new_job_assign2[1] = job_assigned2[7];
				new_job_assign2[2] = job_assigned2[6];
				new_job_assign2[3] = job_assigned2[5];
				new_job_assign2[4] = job_assigned2[4];
				new_job_assign2[5] = job_assigned2[3];
				new_job_assign2[6] = job_assigned2[0];
				new_job_assign2[7] = job_assigned2[1];
			end
			else begin
				new_job_assign2[0] = job_assigned2[1];
				new_job_assign2[1] = job_assigned2[7];
				new_job_assign2[2] = job_assigned2[6];
				new_job_assign2[3] = job_assigned2[5];
				new_job_assign2[4] = job_assigned2[4];
				new_job_assign2[5] = job_assigned2[3];
				new_job_assign2[6] = job_assigned2[2];
				new_job_assign2[7] = job_assigned2[0];
			end
				
		end
	/* 	
		if(job_assigned2[0] == 4 && job_assigned2[1] == 0 &&
		job_assigned2[2] == 6 && job_assigned2[3] == 2 && 
		job_assigned2[4] == 5 && job_assigned2[5] == 1 &&
		job_assigned2[6] == 3 && job_assigned2[7] == 7)begin
			$display("%d",sum);
			$display("%d",current_answer_2);
			$display("%d",current_answer_1);
		end
		else begin
			
			//sum = sum + 1;
		end  */
 	end
	else begin
	//	sum = 0;
		counter_2 = 0;
		new_job_assign2[0] = 4;
		new_job_assign2[1] = 0;
		new_job_assign2[2] = 1;
		new_job_assign2[3] = 2;
		new_job_assign2[4] = 3;
		new_job_assign2[5] = 5;
		new_job_assign2[6] = 6;
		new_job_assign2[7] = 7;
	end
end
//find every2

//calsulate each assignment
assign best_answer = worker_cost_DFF1[fornow_best_job_assigned_DFF[0]] + worker_cost_DFF2[fornow_best_job_assigned_DFF[1]] +
					worker_cost_DFF3[fornow_best_job_assigned_DFF[2]] + worker_cost_DFF4[fornow_best_job_assigned_DFF[3]] +
					worker_cost_DFF5[fornow_best_job_assigned_DFF[4]] + worker_cost_DFF6[fornow_best_job_assigned_DFF[5]] +
					worker_cost_DFF7[fornow_best_job_assigned_DFF[6]] + worker_cost_DFF8[fornow_best_job_assigned_DFF[7]];

assign current_answer_1 = worker_cost_DFF1[job_assigned[0]] + worker_cost_DFF2[job_assigned[1]] +
							worker_cost_DFF3[job_assigned[2]] + worker_cost_DFF4[job_assigned[3]]+
							worker_cost_DFF5[job_assigned[4]] + worker_cost_DFF6[job_assigned[5]] +
							worker_cost_DFF7[job_assigned[6]] + worker_cost_DFF8[job_assigned[7]];
assign current_answer_2 = worker_cost_DFF1[job_assigned2[0]] + worker_cost_DFF2[job_assigned2[1]] +
							worker_cost_DFF3[job_assigned2[2]] + worker_cost_DFF4[job_assigned2[3]]+
							worker_cost_DFF5[job_assigned2[4]] + worker_cost_DFF6[job_assigned2[5]] +
							worker_cost_DFF7[job_assigned2[6]] + worker_cost_DFF8[job_assigned2[7]];
logic [9:0] better_answer;

assign better_answer = (current_answer_1_DFF > current_answer_2_DFF)? current_answer_2_DFF : current_answer_1_DFF;
always@(*)begin
	fornow_best_job_assigned[0] = fornow_best_job_assigned_DFF[0];
	fornow_best_job_assigned[1] = fornow_best_job_assigned_DFF[1];
	fornow_best_job_assigned[2] = fornow_best_job_assigned_DFF[2];
	fornow_best_job_assigned[3] = fornow_best_job_assigned_DFF[3];
	fornow_best_job_assigned[4] = fornow_best_job_assigned_DFF[4];
	fornow_best_job_assigned[5] = fornow_best_job_assigned_DFF[5];
	fornow_best_job_assigned[6] = fornow_best_job_assigned_DFF[6];
	fornow_best_job_assigned[7] = fornow_best_job_assigned_DFF[7];
	last_answer_come = last_answer_come_DFF;
	if(!in_valid_DFF)begin
		if(last_answer_come_DFF == 0)begin
			if(best_answer > better_answer)begin
				if(better_answer == current_answer_1_DFF)begin
					for(i = 0;i < 8;i++)begin
						fornow_best_job_assigned[i] = job_assigned_delay[i];
					end
					last_answer_come = 0;
				end
				else begin
					for(i = 0;i < 8;i++)begin
						fornow_best_job_assigned[i] = job_assigned2_delay[i];
					end
					last_answer_come = 1;
				end
			end
		end
		else begin
			if(better_answer == current_answer_1_DFF)begin
				if(best_answer >= better_answer)begin
					for(i = 0;i < 8;i++)begin
						fornow_best_job_assigned[i] = job_assigned_delay[i];
					end
					last_answer_come = 0;
				end
				
			end
			else begin
				if(best_answer > better_answer)begin
					for(i = 0;i < 8;i++)begin
						fornow_best_job_assigned[i] = job_assigned2_delay[i];
					end
					last_answer_come = 1;
				end
				
			end
		end
/* 		if(better_answer == current_answer_2_DFF)begin
			if(best_answer > better_answer)begin
				for(i = 0;i < 8;i++)begin
					fornow_best_job_assigned[i] = job_assigned2_delay[i];
				end
				last_answer_come = 1;
			end
		end
		else begin
			if(last_answer_come_DFF == 0)begin
				if(best_answer > better_answer)begin
					for(i = 0;i < 8;i++)begin
						fornow_best_job_assigned[i] = job_assigned_delay[i];
					end
				end
				last_answer_come = 0;
			end
			else begin
				if(best_answer >= better_answer)begin
					for(i = 0;i < 8;i++)begin
						fornow_best_job_assigned[i] = job_assigned_delay[i];
					end
				end
				last_answer_come = 0;
			end
		end */
		
		
	end
	else begin
		fornow_best_job_assigned[0] = 0;
		fornow_best_job_assigned[1] = 1;
		fornow_best_job_assigned[2] = 2;
		fornow_best_job_assigned[3] = 3;
		fornow_best_job_assigned[4] = 4;
		fornow_best_job_assigned[5] = 5;
		fornow_best_job_assigned[6] = 6;
		fornow_best_job_assigned[7] = 7;
	end
	
end
logic yes;

//output
logic yes_DFF;
logic yes_DFF_DFF;
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		yes_DFF <= 0;
	end
	else begin
		yes_DFF <= yes;
	end
end
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		yes_DFF_DFF <= 0;
	end
	else begin
		yes_DFF_DFF <= yes_DFF;
	end
end
assign yes = (counter_2_DFF == 20159)? 1 :0;
assign counter = (yes_DFF_DFF ) ? counter_DFF + 1 : 0;
/* assign yes = job_assigned2_delay_delay[0] == 7 && job_assigned2_delay_delay[1] == 6 &&
		job_assigned2_delay_delay[2] == 5 && job_assigned2_delay_delay[3] == 4 && 
		job_assigned2_delay_delay[4] == 3 && job_assigned2_delay_delay[5] == 2 &&
		job_assigned2_delay_delay[6] == 1 && job_assigned2_delay_delay[7] == 0; */
always@(*)begin
	out_cost_comb = 0;
	out_job_comb = 0;
	out_valid_comb = 0;
	if(yes_DFF_DFF && !in_valid)begin
		/* case(counter_DFF)
			0:begin
				out_cost_comb = best_answer;
				out_job_comb = fornow_best_job_assigned_DFF[0] + 1;
				out_valid_comb = 1;
			end
			1:begin
				out_cost_comb = best_answer;
				out_job_comb = fornow_best_job_assigned_DFF[1] + 1;
				out_valid_comb = 1;
			end
			2:begin
				out_cost_comb = best_answer;
				out_job_comb = fornow_best_job_assigned_DFF[2] + 1;
				out_valid_comb = 1;
			end
			3:begin
				out_cost_comb = best_answer;
				out_job_comb = fornow_best_job_assigned_DFF[3] + 1;
				out_valid_comb = 1;
			end
			4:begin
				out_cost_comb = best_answer;
				out_job_comb = fornow_best_job_assigned_DFF[4] + 1;
				out_valid_comb = 1;
			end
			5:begin
				out_cost_comb = best_answer;
				out_job_comb = fornow_best_job_assigned_DFF[5] + 1;
				out_valid_comb = 1;
			end
			6:begin
				out_cost_comb = best_answer;
				out_job_comb = fornow_best_job_assigned_DFF[6] + 1;
				out_valid_comb = 1;
			end
			7:begin
				out_cost_comb = best_answer;
				out_job_comb = fornow_best_job_assigned_DFF[7] + 1;
				out_valid_comb = 1;
			end
		endcase */
		if(counter_DFF <= 7)begin
			out_cost_comb = best_answer;
			out_job_comb = fornow_best_job_assigned_DFF[counter_DFF] + 1;
			out_valid_comb = 1;
		end
	end
	
end
endmodule


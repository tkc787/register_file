// module Mux_16_test;
// 	reg [31:0] R[0:15];
// 	wire [31:0] Y;
// 	reg [3:0] S;
// 	Mux_16_1 mux_test(Y, S, R);
// 	initial #100 $finish;
// 	initial begin
// 		S = 'h0;
// 		R[0] = 'hFFFFFFFF;
// 		R[1] = 'h0000FFFF;
// 		R[2] = 'hFFFF0000;
// 		R[3] = 'hAAAA0000;
// 		R[4] = 'hAABBAABB;
// 		repeat (4) #5 S = S + 'h1;
// 	end
// 	initial $monitor("Output = %b ", Y);
// endmodule

// module decoder_test;
// 	reg Ld;
// 	wire [15:0] Y;
// 	reg [3:0] D;
// 	binary_decoder test(Y, D, Ld);
// 	initial #100 $finish;
// 	initial begin
// 		D = 'h0;
// 		ld = 1'b0;
// 		// ld = 1'b1;
// 		repeat (15) #5 D = D + 'h1;
// 	end
// 	initial $monitor("Output = %b ", O);	
// endmodule

// module register_test;
// 	reg clk, ld;
// 	reg [31:0] D;
// 	wire [31:0] Q;
// 	register reg_test (Q, D, clk, ld);
// 	initial #500 $finish;
// 	initial begin
// 		D = 'hFFFFFF00;
// 		clk = 1'b0;
// 		ld = 1'b1;
// 		// forever #25 D = D + 'h1;
// 		repeat (20) begin 
// 			#5 clk = ~clk;
// 			if(clk == 1)
// 				D = D + 'h1;
// 		end
// 		// repeat (10) #55 D = D + 'h1;
// 	end
// 	initial $monitor("Output = %b ", Q);
// endmodule

module binary_decoder (output reg Y [0:15], input [3:0] D, input ld);
	integer result = 1;
	integer i;
	always @(ld, D) 
	begin
		for(i = 0; i < 16; i = i +1) begin
			Y[i] = 0;
		end
		if(ld) begin
			Y[D] = 1;
		end
	end
endmodule

module register (output reg [31:0] Q, input [31:0] D, input clk, input ld);
	always @ (posedge clk)
		if(ld) begin
			Q = D;
		end
endmodule

module Mux_16_1 (output reg [31:0] Y, input [3:0] S, input [31:0] data[0:15]);
	always @ (S)
		Y = data[S];
endmodule

module register_file_test;

	reg clk, ld;
	reg [31:0] input_data;
	reg [3:0] d_select;
	reg [3:0] m1_select;
	reg [3:0] m2_select;
	wire w0 [0:15];
	wire [31:0] w1 [0:15];
	wire [31:0] w2;
	wire [31:0] w3;
	integer index;
	binary_decoder d (w0, d_select, ld);
	generate
	genvar i; 
	for (i = 0; i < 16; i = i + 1) begin
	    register r (w1[i], input_data, clk, w0[i]);
	end endgenerate
	// register r [15:0](w1, input_data, clk, w0[0]);
	Mux_16_1 mux1 (w2, m1_select, w1);

	Mux_16_1 mux2 (w3, m2_select, w1);
	initial #500 $finish;

// Test Mux outputs
	initial begin
	// $display ("")
		input_data = 'hFFFFFF00;
		d_select = 'b0000;
		clk = 1'b0;
		ld = 1'b1;
		index = 0;
		// #1 clk = ~clk;
		m1_select = 'b0000;
		m2_select = 'b1111;
		repeat (32) begin
			#1 clk = ~clk;
			if(!clk) begin
				input_data = input_data + 1;
				d_select = d_select + 1;
			end
		end		
		$display("\nDisplaying values stored in Registers");

		repeat(16) begin
			$display("Value stored in Register%d is: %h\n", index, w1[index++]);
		end		
		$display("_______________________________________________________________________________________________");
		repeat (32) begin
			#1 clk = ~clk;
			if(!clk) begin
				m1_select = m1_select + 1;
				m2_select = m2_select - 1;
			end
		end
	end
	initial $monitor("|   mux1 sel = %b   |   mux1 out = %h   | mux2 sel = %b   |   mux2 out = %h   |", m1_select, w2, m2_select,w3);
endmodule
module binary_decoder (output reg [15:0]Y, input [3:0] D, input ld);
	integer result = 1;
	always @(ld, D) 
	begin
		if(ld) begin
			if(D == 0)
				Y = 1;
			else
				Y = result << D;
		end
		else begin
			Y = 0;
		end
	end
endmodule

module register (output reg [31:0] Q, input [31:0] D, input clk, ld);
	always @ (posedge clk, ld)
		if(clk && ld)
			Q = D;
endmodule

module Mux_16_1 (output reg [31:0] Y, input [3:0] S, input [31:0] data[0:15]);
	always @ (S)
		Y = data[S];
endmodule

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

module decoder_test;
	reg Ld;
	wire [15:0] Y;
	reg [3:0] D;
	binary_decoder test(Y, D, Ld);
	initial #100 $finish;
	initial begin
		D = 'h0;
		ld = 1'b0;
		// ld = 1'b1;
		repeat (15) #5 D = D + 'h1;
	end
	initial $monitor("Output = %b ", O);	
endmodule

module register_test;
	reg clk, ld;
	reg [31:0] D;
	wire [31:0] Q;
	register reg_test (Q, D, clk, ld);
	initial #500 $finish;
	initial begin
		D = 'hFFFFFF00;
		clk = 1'b0;
		ld = 1'b1;
		// forever #25 D = D + 'h1;
		repeat (20) begin 
			#5 clk = ~clk;
			if(clk == 1)
				D = D + 'h1;
		end
		// repeat (10) #55 D = D + 'h1;
	end
	initial $monitor("Output = %b ", Q);
endmodule

module register_file;
	reg clk, ld, [31:0] input_data, [3:0] d_select, [3:0] m1_select;
	wire [15:0] w0, [31:0] w1, [31:0] w2;
	binary_decoder d(w0, d_select, ld);
	register r [0:15](w1, input_data, clk, w0);
	Mux_16_1 mux (w2, m1_select, w1);


endmodule
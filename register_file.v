module binary_decoder (output reg [15:0] O, input [3:0] D, input Ld);
	integer result = 1;
	always @(Ld, D) 
	begin
		if(Ld) begin
			if(D == 0)
				O = 1;
			else
				O = result << D;
		end
		else begin
			O = 0;
		end
	end
endmodule

module Mux_16_1 (output reg [31:0] Y, input [3:0] S, input [31:0] data[0:15]);
	always @ (S)
		Y = data[S];
endmodule

module Register (output reg [31:0]);

endmodule

module Mux_16_test;
	reg [31:0] R[0:15];
	wire [31:0] Y;
	reg [3:0] S;
	Mux_16_1 mux_test(Y, S, R);
	initial #100 $finish;
	initial begin
		S = 'h0;
		R[0] = 'hFFFFFFFF;
		R[1] = 'h0000FFFF;
		R[2] = 'hFFFF0000;
		R[3] = 'hAAAA0000;
		R[4] = 'hAABBAABB;
		repeat (4) #5 S = S + 'h1;
	end
	initial $monitor("Output = %b ", Y);
endmodule

// module decoder_test;
// 	reg Ld;
// 	wire [15:0] O;
// 	reg [3:0] D;
// 	binary_decoder test(O, D, Ld);
// 	initial #100 $finish;
// 	initial begin
// 		D = 'h0;
// 		Ld = 1'b0;
// 		// Ld = 1'b1;
// 		repeat (15) #5 D = D + 'h1;
// 	end
// 	initial $monitor("Output = %b ", O);	
// endmodule



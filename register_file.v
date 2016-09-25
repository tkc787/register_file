module binary_decoder (output reg [15:0] O, input [3:0] D, input Ld);
	integer result = 1;
	always @(Ld, D) 
	begin
		if(Ld) begin
//			case(D)
//				'h0:	O = 0;
//				'h1:	O = 2;
//				'h2:	O = 4;
//				'h3:	O = 8;
//				'h4:	O = 16;
//				'h5:	O = 32;
//				'h6:	O = 64;
//				'h7:	O = 128;
//				'h8:	O = 256;
//				'h9:	O = 512;
//				'ha:	O = 1024;
//				'hb:	O = 2048;
//				'hc:	O = 4096;
//				'hd:	O = 8192;
//				'he:	O = 16384;
//				'hf:	O = 32768;
//			endcase
			if(D == 0)
				O = 0;
			else
				O = result << D;
		end
	end
endmodule

module decoder_test;
	reg Ld; wire [15:0] O; reg [3:0] D;
	binary_decoder test(O, D, Ld);
	initial #100 $finish;
	initial begin
		D = 'h0;
		Ld = 1'b0;
		Ld = 1'b1;
		repeat (15) #5 D = D + 'h1;
	end
	initial $monitor("Output = %b ", O);	
endmodule
module vector256 
( 
  input [7:0]a,
  input [7:0]d,
  input clk,
  input we,
  output [7:0]spo
);  
    reg [7:0] spo;
    reg [7:0] mem [0:255];    
    always @(posedge clk) begin
            spo <= mem[a];
            if (we) mem[a][ 7: 0] <= d[ 7: 0];
    end
endmodule
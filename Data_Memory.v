module Data_Memory # (
parameter  ADDR_WIDTH = 32,
parameter  DATA_WIDTH = 32
)(
input           clk, mem_write, mem_read,
input           [ADDR_WIDTH-1:0] addr,
input           [DATA_WIDTH-1:0] write_data,
output reg      [DATA_WIDTH-1:0] read_data
);

  //  reg [DATA_WIDTH-1:0] memory [0:(1 << ADDR_WIDTH)-1]; 4 TỶ PHẦN TỬ => BỊ TRÀN 
      reg [DATA_WIDTH-1:0] memory [0:ADDR_WIDTH];
    
    always @(posedge clk) begin
        if (mem_write)
            memory[addr] <= write_data;  
    end
    
    always @(*) begin
        if (mem_read)
            read_data = memory[addr];
        else
            read_data = {DATA_WIDTH{1'b0}};
    end
endmodule

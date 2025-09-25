module Register_File #(
parameter DATA_WIDTH = 32, 
parameter REG_COUNT = 32
)(
input   WE3,                             //RegWrite
input   clk,                             //clk
input   [$clog2(REG_COUNT)-1:0] A1,      //read reg 1
input   [$clog2(REG_COUNT)-1:0] A2,      // read reg 2
input   [$clog2(REG_COUNT)-1:0] A3,      // write reg
input   [DATA_WIDTH-1:0] WD3,            //write data
output  [DATA_WIDTH-1:0] RD1,            //read data 1
output  [DATA_WIDTH-1:0] RD2             //read data 2
);

    reg [DATA_WIDTH-1:0] register [0:REG_COUNT-1];
    
    // Ensure x0 (register[0]) always reads as 0
    assign RD1 = (A1 == 0) ? 0 : register[A1];
    assign RD2 = (A2 == 0) ? 0 : register[A2];
    
    always @ (posedge clk) begin
    if (WE3 && (A3 != 0))           
        register[A3] <= WD3;
    end
    
    // Optional initialization of all registers to 0
    integer i;
    initial begin
        for (i = 0; i < REG_COUNT; i = i + 1) begin
            register[i] = 0;
        end
    end

    // Observe register contents on every negative clock edge
    always @(negedge clk) begin
        $display("Register contents at time %0t:", $time);
        for (i = 0; i < REG_COUNT; i = i + 1) begin
            $display("x%02d: 0x%h", i, register[i]);
        end
    end
endmodule
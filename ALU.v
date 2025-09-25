module ALU #(
parameter DATA_WIDTH = 32
)(
input [DATA_WIDTH - 1:0] A,B,
input [$clog2(DATA_WIDTH) - 2:0] alu_control,
output reg [DATA_WIDTH - 1:0] result,
output zero
);

reg [DATA_WIDTH:0] sub_result; 
reg [DATA_WIDTH-1:0] shift_data;
reg [$clog2(DATA_WIDTH) - 1:0] shift_amount;

//main ALU
always@(*)
    begin
        //default values 
        result = {DATA_WIDTH{1'b0}};//result
        sub_result = {DATA_WIDTH{1'b0}};
        shift_data = {DATA_WIDTH{1'b0}};
        shift_amount = 5'b0;
        sub_result = {1'b0,A} + ({1'b0,~B}+1); //subtraction result

        //main ALU operations      
        case (alu_control)
        4'b0000:    //add
            begin   
                result = A + B;    
            end
        4'b0001:     //sub
            begin  
                result = sub_result[DATA_WIDTH-1:0];  
            end
        4'b0010:    //set less than (SLT)
            begin   
                result = (A[DATA_WIDTH - 1] ^ B[DATA_WIDTH - 1])? A[DATA_WIDTH - 1]: sub_result[DATA_WIDTH - 1];    
            end    
        4'b0011:    //set less than unsigned (SLTU) 
            begin                                          
                result = ~sub_result[32];   
            end   
        4'b0100:    //xor  
            begin   
                result = A ^ B;
            end   
        4'b0101:    //or  
            begin                        
                result = A | B;   
            end
        4'b0110:
            begin   //and                              
                result = A & B;    
            end
        4'b0111:    //sll (shift left logical)
            begin   
                shift_amount = B[4:0];
                shift_data = A;

                if (shift_amount [0]) shift_data = {shift_data[DATA_WIDTH-2:0],1'b0};
                if (shift_amount [1]) shift_data = {shift_data[DATA_WIDTH-3:0],2'b0};
                if (shift_amount [2]) shift_data = {shift_data[DATA_WIDTH-5:0],4'b0};
                if (shift_amount [3]) shift_data = {shift_data[DATA_WIDTH-9:0],8'b0};
                if (shift_amount [4]) shift_data = {shift_data[DATA_WIDTH-17:0],16'b0};         

                result = shift_data;
            end
        4'b1000:    //srl (shift right logical)
            begin  
                shift_amount = B[4:0];
                shift_data = A;

                if (shift_amount [0]) shift_data = {1'b0,shift_data[DATA_WIDTH-1:1]};
                if (shift_amount [1]) shift_data = {2'b0,shift_data[DATA_WIDTH-1:2]};
                if (shift_amount [2]) shift_data = {4'b0,shift_data[DATA_WIDTH-1:4]};
                if (shift_amount [3]) shift_data = {8'b0,shift_data[DATA_WIDTH-1:8]};
                if (shift_amount [4]) shift_data = {16'b0,shift_data[DATA_WIDTH-1:16]};

                result = shift_data;
            end    
        4'b1001:    //sra (shift right arithmetic)
            begin  
                shift_amount = B[4:0];
                shift_data = A;

                if (shift_amount [0]) shift_data = {A[DATA_WIDTH-1],shift_data[DATA_WIDTH-1:1]};
                if (shift_amount [1]) shift_data = {{2{A[DATA_WIDTH-1]}},shift_data[DATA_WIDTH-1:2]};
                if (shift_amount [2]) shift_data = {{4{A[DATA_WIDTH-1]}},shift_data[DATA_WIDTH-1:4]};
                if (shift_amount [3]) shift_data = {{8{A[DATA_WIDTH-1]}},shift_data[DATA_WIDTH-1:8]};
                if (shift_amount [4]) shift_data = {{16{A[DATA_WIDTH-1]}},shift_data[DATA_WIDTH-1:16]};

                result = shift_data;
            end
        default:    //default case
            begin 
                result = {DATA_WIDTH{1'b0}};
            end
        endcase  
    end
    assign zero = (result == 0);
endmodule
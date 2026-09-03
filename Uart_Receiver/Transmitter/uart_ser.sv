module serializer #(parameter DATA_W = 8)(
    input  logic [DATA_W-1:0] i_data,
    input  logic   i_valid,
    input  logic   i_shift_en,
    input  logic   i_clk,
    input  logic   i_rst_n,
    output logic    o_serial_out
);

logic [DATA_W-1:0] shift_reg;

always_ff @(posedge i_clk or negedge i_rst_n)
begin
    if(!i_rst_n) begin
        shift_reg <= {DATA_W{1'b0}};
    end
    else if(i_valid) begin
        shift_reg <= i_data;
    end
    else if(i_shift_en) begin
        shift_reg <= {1'b0, shift_reg[DATA_W-1:1]};
    end
end

assign o_serial_out = shift_reg[0];

endmodule
```
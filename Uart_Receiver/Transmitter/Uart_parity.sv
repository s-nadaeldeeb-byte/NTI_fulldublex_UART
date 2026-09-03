module uart_parity #(
    parameter DATA_W = 8
)(
    input  logic [DATA_W-1:0] i_data,
    input  logic     i_par_en,
    input  logic     i_par_odd,
    output logic     o_parity_bit
);

int i;
int count_ones;

always_comb begin
count_ones = 0;
o_parity_bit = 0;

    for(i = 0; i < DATA_W; i = i + 1) begin
        if(i_data[i] == 1)
            count_ones = count_ones + 1;
    end

    if(i_par_en) begin
        if(i_par_odd == 0) begin
            if(count_ones % 2 == 0)
                o_parity_bit = 0;
            else
                o_parity_bit = 1;
        end
        else begin
            if(count_ones % 2 == 0)
                o_parity_bit = 1;
            else
                o_parity_bit = 0;
        end
    end

end

endmodule


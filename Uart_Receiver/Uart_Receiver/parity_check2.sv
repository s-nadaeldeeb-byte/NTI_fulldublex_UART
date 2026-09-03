module uart_rx_parity #( parameter DATA_W = 8)(
    input logic [DATA_W-1:0] i_data,
    input logic      i_par_en,
    input logic      i_par_odd,
    input logic      i_rx_parity,
    output logic    o_parity_err
);
 
int i;
int count_ones;
logic expected_parity;
 
always_comb begin
count_ones = 0;
expected_parity = 0;
o_parity_err = 0;
 
    for(i = 0; i < DATA_W; i = i + 1) begin
        if(i_data[i] == 1)
            count_ones = count_ones + 1;
    end
    if(i_par_odd == 0) begin
        if(count_ones % 2 == 0)
            expected_parity = 0;
        else
            expected_parity = 1;
    end
    else begin
        if(count_ones % 2 == 0)
            expected_parity = 1;
        else
            expected_parity = 0;
    end
 
    if(i_par_en) begin
        if(i_rx_parity == expected_parity)
            o_parity_err = 0;
        else
            o_parity_err = 1;
    end
    else
        o_parity_err = 0;
 
end
 
endmodule
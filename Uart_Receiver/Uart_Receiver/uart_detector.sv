module uart_rx_detector (
    input logic i_clk,
    input logic i_rst_n,
    input logic i_rx,
    input logic i_idle,
    output logic o_start,
    output logic o_rx_bit
);

logic rx_q;

always_ff @(posedge i_clk or negedge i_rst_n) begin
   
    if (i_rst_n==0)
        rx_q <= 1'b1;
    else
        rx_q <= i_rx;
end

always_comb begin
    o_start = i_idle && rx_q && !i_rx;
    o_rx_bit = i_rx;
end

endmodule
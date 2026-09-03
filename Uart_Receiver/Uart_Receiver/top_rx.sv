module uart_rx #(
    parameter DATA_W = 8
)(
    input logic i_clk,
    input logic i_rst_n,
    input logic i_rx,
    input logic i_par_en,
    input logic i_par_odd,
    output logic [DATA_W-1:0] o_data,
    output logic o_valid,
    output logic o_busy,
    output logic o_parity_err,
    output logic o_frame_err
);

logic idle_flag;
logic start_detected;
logic rx_bit;

logic data_en;
logic parity_en;
logic stop_en;
logic done;

logic [DATA_W-1:0] received_data;
logic rx_parity_bit;
logic parity_err_w;

assign idle_flag = ~o_busy;

assign o_data = received_data;
assign o_valid = done;
assign o_parity_err = parity_err_w;

uart_rx_detector u_detector (
    .i_clk(i_clk),
    .i_rst_n(i_rst_n),
    .i_rx(i_rx),
    .i_idle(idle_flag),
    .o_start(start_detected),
    .o_rx_bit(rx_bit)
);

uart_rx_fsm #(
    .DATA_W(DATA_W)
) u_fsm (
    .i_clk(i_clk),
    .i_rst_n(i_rst_n),
    .i_start_detected(start_detected),
    .i_par_en(i_par_en),
    .i_rx_bit(rx_bit),
    .o_data_en(data_en),
    .o_parity_en(parity_en),
    .o_stop_en(stop_en),
    .o_busy(o_busy),
    .o_done(done),
    .o_frame_err(o_frame_err)
);

uart_rx_ser2par #(
    .DATA_W(DATA_W)
) u_ser2par (
    .i_clk(i_clk),
    .i_rst_n(i_rst_n),
    .i_data_en(data_en),
    .i_rx_bit(rx_bit),
    .i_done(done),
    .o_data(received_data)
);


always_ff @(posedge i_clk or negedge i_rst_n) begin
    if(i_rst_n==0)
       rx_parity_bit <= 1'b0;
    else if(parity_en)
        rx_parity_bit <= rx_bit;
end

uart_rx_parity #(
    .DATA_W(DATA_W)
) u_parity (
    .i_data(received_data),
    .i_par_en(i_par_en),
    .i_par_odd(i_par_odd),
    .i_rx_parity(rx_parity_bit),
    .o_parity_err(parity_err_w)
);

endmodule
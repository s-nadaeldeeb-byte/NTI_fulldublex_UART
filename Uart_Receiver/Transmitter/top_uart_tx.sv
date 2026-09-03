
module uart_tx #( parameter DATA_W = 8)(
 input  logic [DATA_W-1:0] i_data,
 input  logic   i_valid,
 input  logic  i_clk,
 input  logic   i_rst_n,
 input  logic    i_par_en,
 input  logic     i_par_odd,
 output logic    o_tx,
 output logic    o_busy
);

logic serial_out;
logic [1:0] mux_sel;
logic shift_en;
logic parity_bit;
logic start;
logic stop;
logic accept;

assign start  = 1'b0;
assign stop   = 1'b1;
assign accept = i_valid & ~o_busy;

logic [DATA_W-1:0] data_lat;
logic              par_en_lat;
logic              par_odd_lat;

always_ff @(posedge i_clk or negedge i_rst_n)
begin
    if(!i_rst_n)
    begin
        data_lat   <= {DATA_W{1'b0}};
        par_en_lat <= 1'b0;
        par_odd_lat <= 1'b0;
    end
    else if(accept)
    begin
        data_lat   <= i_data;
        par_en_lat <= i_par_en;
        par_odd_lat <= i_par_odd;
    end
end

serializer #(.DATA_W(DATA_W)) serializer_top(
    .i_data(i_data),
    .i_valid(accept),
    .i_shift_en(shift_en),
    .i_clk(i_clk),
    .i_rst_n(i_rst_n),
    .o_serial_out(serial_out)
);

uart_fsm FSM_top(
    .i_valid(i_valid),
    .i_par_en(par_en_lat),
    .i_clk(i_clk),
    .i_rst_n(i_rst_n),
    .o_busy(o_busy),
    .o_shift_en(shift_en),
    .o_mux_sel(mux_sel)
);

uart_parity #(.DATA_W(DATA_W)) parity_top(
    .i_data(data_lat),
    .i_par_en(par_en_lat),
    .i_par_odd(par_odd_lat),
    .o_parity_bit(parity_bit)
);

uart_mux MUX_top(
    .i_start(start),
    .i_stop(stop),
    .i_serial_out(serial_out),
    .i_parity_bit(parity_bit),
    .i_mux_sel(mux_sel),
    .o_tx(o_tx)
);

endmodule
```

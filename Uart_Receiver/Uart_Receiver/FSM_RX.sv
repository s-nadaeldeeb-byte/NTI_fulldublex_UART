module uart_rx_fsm #(parameter DATA_W = 8) (
 input logic i_clk,
 input logic i_rst_n,
 input logic i_start_detected,
 input logic i_par_en,
 input logic i_rx_bit,
 output logic o_data_en,
 output logic o_parity_en,
 output logic o_stop_en,
 output logic o_busy,
 output logic o_done,
 output logic o_frame_err
);

typedef enum logic [1:0] {idle, data, parity, stop} state_t;
state_t state;
int counter;

always_ff @(posedge i_clk or negedge i_rst_n) begin
    if (i_rst_n == 0) begin
        state <= idle;
        counter <= 0;
        o_busy <= 0;
        o_done <= 0;
        o_frame_err <= 0;
    end
    else begin
        o_done <= 0;

        if (state == idle) begin
            o_busy <= 0;
            if (i_start_detected) begin
                state <= data;
                counter <= 0;
                o_busy <= 1;
            end
        end

        if (state == data) begin
            if (counter == DATA_W-1) begin
                counter <= 0;
                if (i_par_en)
                    state <= parity;
                else
                    state <= stop;
            end
            else
                counter <= counter + 1;
        end

        if (state == parity)
            state <= stop;

        if (state == stop) begin
            o_frame_err <= (i_rx_bit != 1);
            o_busy <= 0;
            o_done <= 1;
            state <= idle;
        end
    end
end

always_comb begin
    o_data_en   = (state == data);
    o_parity_en = (state == parity);
    o_stop_en   = (state == stop);
end

endmodule
module uart_rx_ser2par #(parameter DATA_W = 8)(
input logic i_clk,
input logic i_rst_n,
input logic i_data_en,
input logic i_rx_bit,
input logic i_done,
output logic [DATA_W-1:0] o_data
);

int counter;

always_ff @(posedge i_clk or negedge i_rst_n) begin
    // FIX: active-low reset check (was i_rst_n==1).
    if(i_rst_n==0) begin
        o_data <= '0;
        counter <= 0;
    end
    else begin

        if(i_data_en) begin
            o_data[counter] <= i_rx_bit;

            if(counter == DATA_W - 1)
                counter <= 0;
            else
                counter <= counter + 1;
        end

        if(i_done)
            counter <= 0;

    end
end

endmodule

module uart_fsm(
    input  logic    i_valid,
    input  logic    i_par_en,
    input  logic    i_clk,
    input  logic    i_rst_n,
    output logic    o_busy,
    output logic    o_shift_en,
    output logic [1:0] o_mux_sel
);

parameter logic [2:0] S0 = 3'b000;
parameter logic [2:0] S1 = 3'b001;
parameter logic [2:0] S2 = 3'b010;
parameter logic [2:0] S3 = 3'b011;
parameter logic [2:0] S4 = 3'b100;

logic [2:0] state;
logic [2:0] next_state;
logic [2:0] count;

always_ff @(posedge i_clk or negedge i_rst_n)
begin
    if(!i_rst_n)
    begin
        state <= S0;
        count <= 0;
    end
    else
    begin
        state <= next_state;

        if(state == S2)
            count <= count + 1;
        else
            count <= 0;
    end
end

always_comb
begin

    next_state = state;
    o_mux_sel = 2'b00;
    o_shift_en = 0;
    o_busy = (state == S0) ? 1'b0 : 1'b1;

    case(state)

    S0:
    begin
        if(i_valid == 1)
            next_state = S1;

        o_shift_en = 0;
        o_mux_sel = 2'b11;
    end

    // Start bit
    S1:
    begin
        next_state = S2;
        o_shift_en = 0;
        o_mux_sel = 2'b00;
    end

    // Data bits
    S2:
    begin
        o_shift_en = 1;
        o_mux_sel = 2'b01;

        // After 8 data bits
        if(count == 7)
        begin
            if(i_par_en == 1)
                next_state = S3;
            else
                next_state = S4;
        end
    end

    // Parity bit
    S3:
    begin
        next_state = S4;
        o_shift_en = 0;
        o_mux_sel = 2'b10;
    end

    // Stop bit
    S4:
    begin
        next_state = S0;
        o_shift_en = 0;
        o_mux_sel = 2'b11;
    end

    default:
    begin
        next_state = S0;
    end

    endcase
end

endmodule
```
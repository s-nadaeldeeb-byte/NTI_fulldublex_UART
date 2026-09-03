module uart_mux(
    input  logic   i_start,
    input  logic   i_stop,
    input  logic   i_serial_out,
    input  logic   i_parity_bit,
    input  logic [1:0] i_mux_sel,
    output logic   o_tx
);

always_comb
begin
    case(i_mux_sel)

    2'b00:
        o_tx = i_start;

    2'b01:
        o_tx = i_serial_out;

    2'b10:
        o_tx = i_parity_bit;

    2'b11:
        o_tx = i_stop;

    default:
        o_tx = i_stop;

    endcase
end

endmodule
```

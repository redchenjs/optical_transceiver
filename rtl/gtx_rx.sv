/*
 * gtx_rx.sv
 *
 *  Created on: 2021-08-08 13:52
 *      Author: Jack Chen <redchenjs@live.com>
 */

module gtx_rx(
    input logic clk_i,
    input logic rst_n_i,

    input logic  [1:0] ctrl_i,
    input logic [15:0] data_i,

    output logic [15:0] data_o
);

logic [15:0] data;
logic        data_vld;

assign data_o = data;

always_ff @(posedge clk_i or negedge rst_n_i)
begin
    if (!rst_n_i) begin
        data     <= 16'h0000;
        data_vld <= 1'b0;
    end else begin
        case (ctrl_i)
            2'b00: begin
                data <= data_vld ? data_i : data;
            end
            2'b11: begin
                data_vld <= (data_i == 16'hbcbc) ? 1'b1 : 1'b0;
            end
        endcase
    end
end

endmodule

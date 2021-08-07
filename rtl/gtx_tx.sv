/*
 * gtx_tx.sv
 *
 *  Created on: 2021-06-09 16:38
 *      Author: Jack Chen <redchenjs@live.com>
 */

module gtx_tx(
    input logic clk_i,
    input logic rst_n_i,

    input logic [15:0] data_i,

    output logic  [1:0] ctrl_o,
    output logic [15:0] data_o
);

logic  [1:0] ctrl;
logic [15:0] data;

logic [7:0] data_cnt;

assign ctrl_o = ctrl;
assign data_o = data;

always_ff @(posedge clk_i or negedge rst_n_i)
begin
    if (!rst_n_i) begin
        ctrl <= 2'b00;
        data <= 16'h0000;

        data_cnt <= 8'h00;
    end else begin
        ctrl <= (data_cnt == 8'h00) ? 2'b11 : 2'b00;
        data <= (data_cnt == 8'h00) ? 16'hbcbc : {data_cnt, data_cnt};

        data_cnt <= (data_cnt == 8'h0f) ? 8'h00 : data_cnt + 1'b1;
    end
end

endmodule

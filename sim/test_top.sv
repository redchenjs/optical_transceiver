/*
 * test_top.sv
 *
 *  Created on: 2021-05-22 14:11
 *      Author: Jack Chen <redchenjs@live.com>
 */

`timescale 1ns / 1ps

module test_top;

logic sfp_rx_p_i;
logic sfp_rx_n_i;
logic sfp_tx_p_o;
logic sfp_tx_n_o;

assign sfp_rx_p_i = sfp_tx_p_o;
assign sfp_rx_n_i = sfp_tx_n_o;

logic [15:0] data_i;
logic [15:0] data_o;

logic sys_clk;
logic sys_rst_n;

logic ref_clk_p;
logic ref_clk_n;

logic gt0_txusrclk2;
logic gt0_rxusrclk2;

logic gt0_tx_fsm_reset_done;
logic gt0_rx_fsm_reset_done;

logic [15:0] gt0_rxdata;
logic  [1:0] gt0_rxcharisk;

logic [15:0] gt0_txdata;
logic  [1:0] gt0_txcharisk;

gtx_tx gtx_tx(
    .clk_i(gt0_txusrclk2),
    .rst_n_i(gt0_tx_fsm_reset_done),

    .data_i(data_i),

    .ctrl_o(gt0_txcharisk),
    .data_o(gt0_txdata)
);

gtx_rx gtx_rx(
    .clk_i(gt0_rxusrclk2),
    .rst_n_i(gt0_rx_fsm_reset_done),

    .ctrl_i(gt0_rxcharisk),
    .data_i(gt0_rxdata),

    .data_o(data_o)
);

gtx gtx(
    .sysclk_in(sys_clk),

    .q0_clk1_gtrefclk_pad_p_in(ref_clk_p),
    .q0_clk1_gtrefclk_pad_n_in(ref_clk_n),

    .soft_reset_tx_in(~sys_rst_n),
    .soft_reset_rx_in(~sys_rst_n),
    .dont_reset_on_data_error_in(1'b0),

    .gt0_tx_fsm_reset_done_out(gt0_tx_fsm_reset_done),
    .gt0_rx_fsm_reset_done_out(gt0_rx_fsm_reset_done),

    .gt0_data_valid_in(gt0_rx_fsm_reset_done),

    .gt0_txusrclk_out(),
    .gt0_txusrclk2_out(gt0_txusrclk2),
    .gt0_rxusrclk_out(),
    .gt0_rxusrclk2_out(gt0_rxusrclk2),

    .gt0_cpllfbclklost_out(),
    .gt0_cplllock_out(),
    .gt0_cpllreset_in(~sys_rst_n),

    .gt0_drpaddr_in(9'h000),
    .gt0_drpdi_in(16'h0000),
    .gt0_drpdo_out(),
    .gt0_drpen_in(1'b0),
    .gt0_drprdy_out(),
    .gt0_drpwe_in(1'b0),

    .gt0_dmonitorout_out(),

    .gt0_eyescanreset_in(~sys_rst_n),
    .gt0_rxuserrdy_in(1'b1),

    .gt0_eyescandataerror_out(),
    .gt0_eyescantrigger_in(1'b0),

    .gt0_rxdata_out(gt0_rxdata),

    .gt0_rxdisperr_out(),
    .gt0_rxnotintable_out(),

    .gt0_gtxrxp_in(sfp_rx_p_i),
    .gt0_gtxrxn_in(sfp_rx_n_i),

    .gt0_rxphmonitor_out(),
    .gt0_rxphslipmonitor_out(),

    .gt0_rxdfelpmreset_in(~sys_rst_n),

    .gt0_rxmonitorout_out(),
    .gt0_rxmonitorsel_in(2'b00),

    .gt0_rxoutclkfabric_out(),

    .gt0_gtrxreset_in(~sys_rst_n),
    .gt0_rxpmareset_in(~sys_rst_n),

    .gt0_rxcharisk_out(gt0_rxcharisk),
    .gt0_rxresetdone_out(),

    .gt0_gttxreset_in(~sys_rst_n),
    .gt0_txuserrdy_in(1'b1),

    .gt0_txdata_in(gt0_txdata),

    .gt0_gtxtxp_out(sfp_tx_p_o),
    .gt0_gtxtxn_out(sfp_tx_n_o),

    .gt0_txoutclkfabric_out(),
    .gt0_txoutclkpcs_out(),

    .gt0_txcharisk_in(gt0_txcharisk),
    .gt0_txresetdone_out(),

    .gt0_qplloutclk_out(),
    .gt0_qplloutrefclk_out()
);

initial begin
    sys_clk   <= 1'b1;
    sys_rst_n <= 1'b0;

    ref_clk_p <= 1'b1;
    ref_clk_n <= 1'b0;

    #2 sys_rst_n <= 1'b1;
end

always begin
    #5 sys_clk <= ~sys_clk;
end

always_ff @(posedge gt0_txusrclk2 or negedge gt0_tx_fsm_reset_done)
begin
    if (!gt0_tx_fsm_reset_done) begin
        data_i <= 16'h0000;
    end else begin
        data_i <= $random();
    end
end

always begin
    #5 ref_clk_p <= ~ref_clk_p;
       ref_clk_n <= ~ref_clk_n;
end

always begin
    #750000 sys_rst_n <= 1'b0;
    #25 $stop;
end

endmodule

/*
 * top_kc705.sv
 *
 *  Created on: 2021-07-27 19:05
 *      Author: Jack Chen <redchenjs@live.com>
 */

module top_kc705(
    input logic sys_clk_p_i,
    input logic sys_clk_n_i,

    input logic ref_clk_p_i,
    input logic ref_clk_n_i,

    input logic user_clk_p_i,
    input logic user_clk_n_i,

    output logic user_clk_p_o,
    output logic user_clk_n_o,

    input logic cpu_rst_i,

    input  logic uart_rx_i,
    output logic uart_tx_o,

    input  logic sfp_rx_p_i,
    input  logic sfp_rx_n_i,
    output logic sfp_tx_p_o,
    output logic sfp_tx_n_o,

    input  logic sfp_los_i,
    output logic sfp_tx_disable_o,

    input  logic sm_fan_tach_i,
    output logic sm_fan_pwm_o,

    input  logic [6:2] gpio_sw_i,
    output logic [7:0] gpio_led_o
);

logic sys_clk;
logic sys_clk_i;
logic sys_rst_n;

logic user_clk;

logic gt0_txusrclk2;
logic gt0_rxusrclk2;

logic [15:0] gt0_rxdata;
logic        gt0_rxoutclkfabric;
logic  [1:0] gt0_rxcharisk;
logic        gt0_rxresetdone;

logic [15:0] gt0_txdata;
logic        gt0_txoutclkfabric;
logic        gt0_txoutclkpcs;
logic  [1:0] gt0_txcharisk;
logic        gt0_txresetdone;

assign gpio_led_o[7] = sys_rst_n;
assign gpio_led_o[6] = 1'b0;
assign gpio_led_o[5] = 1'b0;
assign gpio_led_o[4] = 1'b0;
assign gpio_led_o[3] = gt0_rxoutclkfabric;
assign gpio_led_o[2] = gt0_txoutclkfabric;
assign gpio_led_o[1] = gt0_rxresetdone;
assign gpio_led_o[0] = gt0_txresetdone;

assign sm_fan_pwm_o = 1'b0;

IBUFDS sys_clk_buf(
    .O(sys_clk_i),
    .I(sys_clk_p_i),
    .IB(sys_clk_n_i)
);

IBUFDS user_clk_buf_i(
    .I(user_clk_p_i),
    .IB(user_clk_n_i),
    .O(user_clk)
);

OBUFDS user_clk_buf_o(
   .O(user_clk_p_o),
   .OB(user_clk_n_o),
   .I(user_clk)
);

sys_ctl sys_ctl(
    .clk_i(sys_clk_i),
    .rst_n_i(~cpu_rst_i),

    .sys_clk_o(sys_clk),
    .sys_rst_n_o(sys_rst_n)
);

gtx gtx(
    .sysclk_in(sys_clk),

    .q0_clk1_gtrefclk_pad_p_in(ref_clk_p_i),
    .q0_clk1_gtrefclk_pad_n_in(ref_clk_n_i),

    .soft_reset_tx_in(~sys_rst_n),
    .soft_reset_rx_in(~sys_rst_n),
    .dont_reset_on_data_error_in(1'b0),

    .gt0_tx_mmcm_lock_out(),

    .gt0_tx_fsm_reset_done_out(),
    .gt0_rx_fsm_reset_done_out(),

    .gt0_data_valid_in(1'b0),

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

    .gt0_rxoutclkfabric_out(gt0_rxoutclkfabric),

    .gt0_gtrxreset_in(~sys_rst_n),
    .gt0_rxpmareset_in(~sys_rst_n),

    .gt0_rxcharisk_out(gt0_rxcharisk),
    .gt0_rxresetdone_out(gt0_rxresetdone),

    .gt0_gttxreset_in(~sys_rst_n),
    .gt0_txuserrdy_in(1'b1),

    .gt0_txdata_in(gt0_txdata),

    .gt0_gtxtxp_out(sfp_tx_p_o),
    .gt0_gtxtxn_out(sfp_tx_n_o),

    .gt0_txoutclkfabric_out(gt0_txoutclkfabric),
    .gt0_txoutclkpcs_out(gt0_txoutclkpcs),

    .gt0_txcharisk_in(gt0_txcharisk),
    .gt0_txresetdone_out(gt0_txresetdone),

    .gt0_qplloutclk_out(),
    .gt0_qplloutrefclk_out()
);

endmodule

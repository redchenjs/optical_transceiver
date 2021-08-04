/*
 * top_kc705.sv
 *
 *  Created on: 2021-07-27 19:05
 *      Author: Jack Chen <redchenjs@live.com>
 */

module top_kc705(
    input logic sys_clk_p_i,
    input logic sys_clk_n_i,

    input logic cpu_rst_i,

    input  logic uart_rx_i,
    output logic uart_tx_o,

    input  logic sm_fan_tach_i,
    output logic sm_fan_pwm_o,

    input  logic [6:2] gpio_sw_i,
    output logic [7:0] gpio_led_o
);

logic sys_clk;
logic sys_clk_i;
logic sys_rst_n;

logic [7:0] uart_rx_data;
logic       uart_rx_data_vld;
logic       uart_rx_data_rdy;

logic [7:0] uart_tx_data;
logic       uart_tx_data_vld;
logic       uart_tx_data_rdy;

assign gpio_led_o[7] = sys_rst_n;
assign gpio_led_o[6] = 1'b0;
assign gpio_led_o[5] = 1'b0;
assign gpio_led_o[4] = 1'b0;
assign gpio_led_o[3] = uart_rx_data_vld;
assign gpio_led_o[2] = uart_rx_data_rdy;
assign gpio_led_o[1] = uart_tx_data_vld;
assign gpio_led_o[0] = uart_tx_data_rdy;

assign sm_fan_pwm_o = 1'b0;

IBUFGDS clk_buf(
    .O(sys_clk_i),
    .I(sys_clk_p_i),
    .IB(sys_clk_n_i)
);

sys_ctl sys_ctl(
    .clk_i(sys_clk_i),
    .rst_n_i(~cpu_rst_i),

    .sys_clk_o(sys_clk),
    .sys_rst_n_o(sys_rst_n)
);

uart_rx uart_rx(
    .clk_i(sys_clk),
    .rst_n_i(sys_rst_n),

    .uart_rx_i(uart_rx_i),
    .uart_rx_data_rdy_i(uart_rx_data_rdy),

    .uart_rx_baud_div_i(32'd215),

    .uart_rx_data_o(uart_rx_data),
    .uart_rx_data_vld_o(uart_rx_data_vld)
);

uart_tx uart_tx(
   .clk_i(sys_clk),
   .rst_n_i(sys_rst_n),

   .uart_tx_data_i(uart_tx_data),
   .uart_tx_data_vld_i(uart_tx_data_vld),

   .uart_tx_baud_div_i(32'd215),

   .uart_tx_o(uart_tx_o),
   .uart_tx_data_rdy_o(uart_tx_data_rdy)
);

gtx gtx(
    
);

endmodule

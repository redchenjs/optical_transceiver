set_property BITSTREAM.CONFIG.CONFIGRATE 50 [current_design]
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]

create_clock -period 5.0 [get_ports ref_clk_p_i]

set_property -dict {PACKAGE_PIN AF17 IOSTANDARD DIFF_HSTL_II_18} [get_ports sys_clk_p_i]
set_property -dict {PACKAGE_PIN AG17 IOSTANDARD DIFF_HSTL_II_18} [get_ports sys_clk_n_i]
set_property -dict {PACKAGE_PIN U8} [get_ports ref_clk_p_i]
set_property -dict {PACKAGE_PIN U7} [get_ports ref_clk_n_i]
set_property -dict {PACKAGE_PIN Y6} [get_ports sfp_rx_p_i]
set_property -dict {PACKAGE_PIN Y5} [get_ports sfp_rx_n_i]
set_property -dict {PACKAGE_PIN V2} [get_ports sfp_tx_p_o]
set_property -dict {PACKAGE_PIN V1} [get_ports sfp_tx_n_o]
set_property -dict {PACKAGE_PIN V26 IOSTANDARD LVCMOS33} [get_ports {xadc_gpio_i[0]}]
set_property -dict {PACKAGE_PIN V27 IOSTANDARD LVCMOS33} [get_ports {xadc_gpio_o[2]}]

set_false_path -to [get_pins -filter {REF_PIN_NAME=~*CLR} -of_objects [get_cells -hierarchical -filter {NAME =~ *rst_n_a*}]]
set_false_path -to [get_pins -filter {REF_PIN_NAME=~*CLR} -of_objects [get_cells -hierarchical -filter {NAME =~ *rst_n_b*}]]

set_false_path -from [get_ports {xadc_gpio_i[*]}]
set_false_path -to [get_ports {xadc_gpio_o[*]}]
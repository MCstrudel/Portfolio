set_property PACKAGE_PIN M15 [get_ports {sp[0]}]
set_property PACKAGE_PIN H17 [get_ports {sp[1]}]
set_property PACKAGE_PIN H18 [get_ports {sp[2]}]
set_property PACKAGE_PIN H19 [get_ports {sp[3]}]
set_property PACKAGE_PIN F21 [get_ports {sp[4]}]
set_property PACKAGE_PIN H22 [get_ports {sp[5]}]
set_property PACKAGE_PIN G22 [get_ports {sp[6]}]
set_property PACKAGE_PIN F22 [get_ports {sp[7]}]
set_property PACKAGE_PIN N15 [get_ports force_ccw]
set_property PACKAGE_PIN R18 [get_ports force_cw]
set_property PACKAGE_PIN P16 [get_ports sync_rst]
set_property PACKAGE_PIN R16 [get_ports arst]
set_property PACKAGE_PIN V12 [get_ports {abcdefgdec_n[0]}]
set_property PACKAGE_PIN W12 [get_ports {abcdefgdec_n[1]}]
set_property PACKAGE_PIN W10 [get_ports {abcdefgdec_n[2]}]
set_property PACKAGE_PIN W11 [get_ports {abcdefgdec_n[3]}]
set_property PACKAGE_PIN V9 [get_ports {abcdefgdec_n[4]}]
set_property PACKAGE_PIN V10 [get_ports {abcdefgdec_n[5]}]
set_property PACKAGE_PIN V8 [get_ports {abcdefgdec_n[6]}]
set_property PACKAGE_PIN W8 [get_ports {abcdefgdec_n[7]}]
set_property PACKAGE_PIN AA8 [get_ports {a_n[0]}]
set_property PACKAGE_PIN AB9 [get_ports {a_n[1]}]
set_property PACKAGE_PIN AB10 [get_ports {a_n[2]}]
set_property PACKAGE_PIN AB11 [get_ports {a_n[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {a_n[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {a_n[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {a_n[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {a_n[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {abcdefgdec_n[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {abcdefgdec_n[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {abcdefgdec_n[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {abcdefgdec_n[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {abcdefgdec_n[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {abcdefgdec_n[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {abcdefgdec_n[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {abcdefgdec_n[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sp[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sp[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sp[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sp[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sp[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sp[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sp[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sp[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports a]
set_property IOSTANDARD LVCMOS33 [get_ports arst]
set_property IOSTANDARD LVCMOS33 [get_ports b]
set_property IOSTANDARD LVCMOS33 [get_ports force_ccw]
set_property IOSTANDARD LVCMOS33 [get_ports force_cw]
set_property IOSTANDARD LVCMOS33 [get_ports motor_ccw]
set_property IOSTANDARD LVCMOS33 [get_ports motor_cw]
set_property IOSTANDARD LVCMOS33 [get_ports refclk]
set_property IOSTANDARD LVCMOS33 [get_ports sync_rst]
set_property PACKAGE_PIN Y9 [get_ports refclk]
set_property PACKAGE_PIN AA11 [get_ports motor_ccw]
set_property PACKAGE_PIN Y11 [get_ports motor_cw]
set_property PACKAGE_PIN Y10 [get_ports a]
set_property PACKAGE_PIN AA9 [get_ports b]

create_clock -period 10.000 -name refclk -waveform {0.000 5.000}
create_generated_clock -name mclk_div -source [get_pins {RCU/ru_0/mclk_cnt_reg[6]}] -divide_by 128 -add -master_clock refclk [get_pins RCU/cu_0/refclk]

set_property IOSTANDARD LVCMOS33 [get_ports {light[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {light[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {light[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {light[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {light[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {light[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {light[0]}]
set_property PACKAGE_PIN D4 [get_ports {light[6]}]
set_property PACKAGE_PIN D3 [get_ports {light[4]}]
set_property PACKAGE_PIN E3 [get_ports {light[5]}]
set_property PACKAGE_PIN F4 [get_ports {light[3]}]
set_property PACKAGE_PIN F3 [get_ports {light[2]}]
set_property PACKAGE_PIN E2 [get_ports {light[1]}]
set_property PACKAGE_PIN D2 [get_ports {light[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {light2[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {light2[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {light2[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {light2[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {light2[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {light2[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {light2[0]}]
set_property PACKAGE_PIN B4 [get_ports {light2[6]}]
set_property PACKAGE_PIN A4 [get_ports {light2[5]}]
set_property PACKAGE_PIN A3 [get_ports {light2[4]}]
set_property PACKAGE_PIN B1 [get_ports {light2[3]}]
set_property PACKAGE_PIN A1 [get_ports {light2[2]}]
set_property PACKAGE_PIN B3 [get_ports {light2[1]}]
set_property PACKAGE_PIN B2 [get_ports {light2[0]}]

#数码管位选
set_property IOSTANDARD LVCMOS33 [get_ports {an[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {an[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {an[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {an[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {an2[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {an2[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {an2[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {an2[3]}]

set_property PACKAGE_PIN H1 [get_ports {an[0]}]
set_property PACKAGE_PIN C1 [get_ports {an[1]}]
set_property PACKAGE_PIN C2 [get_ports {an[2]}]
set_property PACKAGE_PIN G2 [get_ports {an[3]}]
set_property PACKAGE_PIN G6 [get_ports {an2[0]}]
set_property PACKAGE_PIN E1 [get_ports {an2[1]}]
set_property PACKAGE_PIN F1 [get_ports {an2[2]}]
set_property PACKAGE_PIN G1 [get_ports {an2[3]}]


#开关SW0-SW7控制adress
set_property IOSTANDARD LVCMOS33 [get_ports {adress[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {adress[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {adress[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {adress[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {adress[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {adress[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {adress[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {adress[7]}]

set_property PACKAGE_PIN R1 [get_ports {adress[0]}]
set_property PACKAGE_PIN N4 [get_ports {adress[1]}]
set_property PACKAGE_PIN M4 [get_ports {adress[2]}]
set_property PACKAGE_PIN R2 [get_ports {adress[3]}]
set_property PACKAGE_PIN P2 [get_ports {adress[4]}]
set_property PACKAGE_PIN P3 [get_ports {adress[5]}]
set_property PACKAGE_PIN P4 [get_ports {adress[6]}]
set_property PACKAGE_PIN P5 [get_ports {adress[7]}]

#CLK,start,clkreset,reset,read,enable，switih
set_property IOSTANDARD LVCMOS33  [get_ports clk]
set_property IOSTANDARD LVCMOS33  [get_ports clkreset]
set_property IOSTANDARD LVCMOS33  [get_ports enable]
set_property IOSTANDARD LVCMOS33  [get_ports read]
set_property IOSTANDARD LVCMOS33  [get_ports reset]
set_property IOSTANDARD LVCMOS33  [get_ports start]
set_property IOSTANDARD LVCMOS33  [get_ports btn]
set_property IOSTANDARD LVCMOS33  [get_ports hex2bcd]



set_property PACKAGE_PIN P17 [get_ports clk]

set_property PACKAGE_PIN V1 [get_ports start]
set_property PACKAGE_PIN R11 [get_ports read]
set_property PACKAGE_PIN R17  [get_ports btn]



set_property PACKAGE_PIN R3 [get_ports clkreset]
set_property PACKAGE_PIN T3 [get_ports reset]
set_property PACKAGE_PIN T5 [get_ports enable]
set_property PACKAGE_PIN U3  [get_ports hex2bcd]



create_clock -period 20.000 -name clk -waveform {0.000 5.000} [get_ports clk]

set_input_delay -clock [get_clocks clk] -min -add_delay 0.000 [get_ports {adress[*]}]
set_input_delay -clock [get_clocks clk] -max -add_delay 0.000 [get_ports {adress[*]}]
set_input_delay -clock [get_clocks clk] -min -add_delay 0.000 [get_ports clkreset]
set_input_delay -clock [get_clocks clk] -max -add_delay 0.000 [get_ports clkreset]
set_input_delay -clock [get_clocks clk] -min -add_delay 0.000 [get_ports read]
set_input_delay -clock [get_clocks clk] -max -add_delay 0.000 [get_ports read]
set_output_delay -clock [get_clocks clk] -min -add_delay 0.000 [get_ports {an[*]}]
set_output_delay -clock [get_clocks clk] -max -add_delay 0.000 [get_ports {an[*]}]
set_output_delay -clock [get_clocks clk] -min -add_delay 0.000 [get_ports {an2[*]}]
set_output_delay -clock [get_clocks clk] -max -add_delay 0.000 [get_ports {an2[*]}]
set_output_delay -clock [get_clocks clk] -min -add_delay 0.000 [get_ports {light[*]}]
set_output_delay -clock [get_clocks clk] -max -add_delay 0.000 [get_ports {light[*]}]
set_output_delay -clock [get_clocks clk] -min -add_delay 0.000 [get_ports {light2[*]}]
set_output_delay -clock [get_clocks clk] -max -add_delay 0.000 [get_ports {light2[*]}]





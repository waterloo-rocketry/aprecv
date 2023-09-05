# Efinity Interface Designer SDC
# Version: 2023.1.150
# Date: 2023-09-12 22:21

# Copyright (C) 2017 - 2023 Efinix Inc. All rights reserved.

# Device: T20Q144
# Project: aprecv
# Timing Model: C3 (final)

# PLL Constraints
#################
create_clock -period 5.5556 main_clk

# GPIO Constraints
####################
# set_output_delay -clock <CLOCK> -max <MAX CALCULATION> [get_ports {sdo_o}]
# set_output_delay -clock <CLOCK> -min <MIN CALCULATION> [get_ports {sdo_o}]

# LVDS RX GPIO Constraints
############################
# set_input_delay -clock <CLOCK> -max <MAX CALCULATION> [get_ports {pll_clk_i}]
# set_input_delay -clock <CLOCK> -min <MIN CALCULATION> [get_ports {pll_clk_i}]

# LVDS Rx Constraints
####################

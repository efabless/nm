set script_dir [file dirname [file normalize [info script]]]
# Design

set ::env(DESIGN_NAME) "nm"

set ::env(VERILOG_FILES) $script_dir/../../../verilog/rtl/*.v

set ::env(CLOCK_PERIOD) "115.000"
set ::env(CLOCK_PORT) "G_CLK"

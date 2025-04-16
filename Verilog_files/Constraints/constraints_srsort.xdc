#----------------------------------------------------------------------------
# Primary Clock Definition - 142.86MHz (7ns)
#----------------------------------------------------------------------------
create_clock -name clk -period 7.000 [get_ports clk]

#----------------------------------------------------------------------------
# Clock Uncertainty and Jitter Settings
#----------------------------------------------------------------------------
set_clock_uncertainty -setup 0.08 [get_clocks clk]
set_clock_uncertainty -hold 0.04 [get_clocks clk]

#----------------------------------------------------------------------------
# Input and Output Delay Constraints
#----------------------------------------------------------------------------
set_input_delay -clock clk -max 1.000 [get_ports {in0[*]}]
set_input_delay -clock clk -min 0.250 [get_ports {in0[*]}]

# Input delay constraints for control signals
set_input_delay -clock clk -max 1.000 [get_ports {reset start}]
set_input_delay -clock clk -min 0.250 [get_ports {reset start}]

#----------------------------------------------------------------------------
# Clock Distribution Optimization
#----------------------------------------------------------------------------
set_property CLOCK_DEDICATED_ROUTE BACKBONE [get_nets clk]

#----------------------------------------------------------------------------
# Comparator Path Optimization
#----------------------------------------------------------------------------

set_max_delay -from [get_pins */SR_chain/*/SR_N0/data_reg[*]/C] -to [get_pins */SR_chain/*/SR_N0/down[*]] 2.400
set_max_delay -from [get_pins */SR_chain/*/treg/data_reg[*]/C] -to [get_pins */SR_chain/*/SR_N0/data_reg[*]/D] 2.400


set_max_delay -from [get_pins */SR_chain/*/SR_N0/data_reg[*]/C] -to [get_pins */SR_chain/*/c0/CMP] 2.000
set_max_delay -from [get_pins */treg/data_reg[*]/C] -to [get_pins */SR_full/*/c0/CMP] 2.000

#----------------------------------------------------------------------------
# Physical Implementation Constraints - New pblocks for CORDIC and DBSCAN
#----------------------------------------------------------------------------
# Physical constraints for comparators
create_pblock pblock_comparators
add_cells_to_pblock [get_pblocks pblock_comparators] [get_cells -hierarchical *c0]
resize_pblock [get_pblocks pblock_comparators] -add {SLICE_X0Y0:SLICE_X10Y10}

# Create a pblock for the SR_chain module
create_pblock pblock_SR_chain
add_cells_to_pblock [get_pblocks pblock_SR_chain] [get_cells -hierarchical -filter {NAME =~ */SR_chain/*}]
resize_pblock [get_pblocks pblock_SR_chain] -add {SLICE_X0Y11:SLICE_X80Y100}

# Create a pblock for the control logic
create_pblock pblock_control
add_cells_to_pblock [get_pblocks pblock_control] [get_cells -hierarchical -filter {NAME =~ */SR_chain_control/*}]
resize_pblock [get_pblocks pblock_control] -add {SLICE_X81Y0:SLICE_X100Y50}

# Create a pblock for the CORDIC module
create_pblock pblock_CORDIC
add_cells_to_pblock [get_pblocks pblock_CORDIC] [get_cells -hierarchical -filter {NAME =~ */CORDIC0/*}]
resize_pblock [get_pblocks pblock_CORDIC] -add {SLICE_X101Y0:SLICE_X120Y50}

# Create a pblock for the DBSCAN_ARG module
create_pblock pblock_DBSCAN_ARG
add_cells_to_pblock [get_pblocks pblock_DBSCAN_ARG] [get_cells -hierarchical -filter {NAME =~ */DBSCANARG/*}]
resize_pblock [get_pblocks pblock_DBSCAN_ARG] -add {SLICE_X121Y0:SLICE_X130Y20}

# Create a pblock for the DBSCAN_ABS module
create_pblock pblock_DBSCAN_ABS
add_cells_to_pblock [get_pblocks pblock_DBSCAN_ABS] [get_cells -hierarchical -filter {NAME =~ */DBSCANABS/*}]
resize_pblock [get_pblocks pblock_DBSCAN_ABS] -add {SLICE_X121Y25:SLICE_X130Y45}

# Keep comparators and their adjacent logic physically close
set_property LOC_FIXED TRUE [get_cells -hierarchical *c0*]

#----------------------------------------------------------------------------
# Specific timing constraints for CORDIC and DBSCAN modules
#----------------------------------------------------------------------------
# CORDIC module timing constraints
set_max_delay -from [get_pins */CORDIC0/*/C] -to [get_pins */CORDIC0/*/D] 3.500

# DBSCAN modules timing constraints
set_max_delay -from [get_pins */DBSCANARG/*/C] -to [get_pins */DBSCANARG/*/D] 3.500
set_max_delay -from [get_pins */DBSCANABS/*/C] -to [get_pins */DBSCANABS/*/D] 3.500

#----------------------------------------------------------------------------
# Synthesis and Implementation Directives
#----------------------------------------------------------------------------
# Specify max fanout for critical comparator nets
set_max_fanout 3 [get_nets -hierarchical *cmp*]

# Ensure dedicated routing resources for comparator signals
set_property ROUTE_PRIORITY HIGH [get_nets -hierarchical *cmp*]

# Force high-speed logic resources for comparator logic
set_property PERFORMANCE_PRIORITY HIGH [get_cells -hierarchical *c0*]

# Use HIGH_EFFORT optimization for the comparator paths
set_property SYNTHESIS_EFFORT HIGH [get_cells -hierarchical *c0*]

# Add high performance optimization for CORDIC and DBSCAN modules
set_property PERFORMANCE_PRIORITY HIGH [get_cells -hierarchical -filter {NAME =~ */CORDIC0/*}]
set_property PERFORMANCE_PRIORITY HIGH [get_cells -hierarchical -filter {NAME =~ */DBSCANARG/*}]
set_property PERFORMANCE_PRIORITY HIGH [get_cells -hierarchical -filter {NAME =~ */DBSCANABS/*}]

# Combined synthesis options
set_property -name {STEPS.SYNTH_DESIGN.ARGS.MORE OPTIONS} -value {-no_dsp -no_bram -directive Default} -objects [get_runs synth_1]

# Prevent comparator logic from being mapped to SRLs (shift registers)
set_property SHREG_EXTRACT NO [get_cells -hierarchical *c0*]

# Force use of faster LUT components for comparator logic
set_property USE_CARRY_CHAIN FALSE [get_cells -hierarchical *c0*]

# Do not allow the tool to merge comparator logic with other functions
set_property DONT_MERGE TRUE [get_cells -hierarchical *c0*]

# Use faster but larger logic implementation
set_property EXTRACT_ENABLE NO [get_cells -hierarchical *c0*]

# Use SLICEM for comparator logic but allow more flexibility for placement
set_property SLICE_TYPE SLICEM [get_cells -hierarchical *c0*]

# Place comparator input registers near their destination comparators
set_property PARENT [get_cells -hierarchical *c0*] [get_cells -hierarchical *SR_N0/data_reg*]

# Override default timing-driven placement for critical comparator path
set_property CRITICAL_PATH_PRIORITY HIGH [get_nets -hierarchical -filter {NAME =~ *cmp*}]

# Set critical path priority for CORDIC and DBSCAN modules
set_property CRITICAL_PATH_PRIORITY HIGH [get_nets -hierarchical -filter {NAME =~ */CORDIC0/*}]
set_property CRITICAL_PATH_PRIORITY HIGH [get_nets -hierarchical -filter {NAME =~ */DBSCANARG/*}]
set_property CRITICAL_PATH_PRIORITY HIGH [get_nets -hierarchical -filter {NAME =~ */DBSCANABS/*}]

set_false_path -from [get_ports reset]
#----------------------------------------------------------------------------
# Implementation Strategy Optimization
#----------------------------------------------------------------------------
# Set timing-driven options for implementation - XC7Z020 specific
set_property STEPS.SYNTH_DESIGN.ARGS.RETIMING true [get_runs synth_1]
set_property STEPS.SYNTH_DESIGN.ARGS.FANOUT_LIMIT 500 [get_runs synth_1]
set_property STEPS.OPT_DESIGN.ARGS.DIRECTIVE Explore [get_runs impl_1]
set_property STEPS.PLACE_DESIGN.ARGS.DIRECTIVE TimingAware [get_runs impl_1]
set_property STEPS.PHYS_OPT_DESIGN.IS_ENABLED true [get_runs impl_1]
set_property STEPS.PHYS_OPT_DESIGN.ARGS.DIRECTIVE TimingOptimize [get_runs impl_1]
set_property STEPS.ROUTE_DESIGN.ARGS.DIRECTIVE TimingOptimize [get_runs impl_1]
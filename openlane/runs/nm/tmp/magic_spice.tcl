
lef read /home/aag/latest_pdk//sky130A/libs.ref/sky130_fd_sc_hd/techlef/sky130_fd_sc_hd.tlef
if {  [info exist ::env(EXTRA_LEFS)] } {
	set lefs_in $::env(EXTRA_LEFS)
	foreach lef_file $lefs_in {
		lef read $lef_file
	}
}
def read /project/openlane/runs/nm/results/routing/nm.def
load nm -dereference
cd /project/openlane/runs/nm/results/magic/
extract do local
extract no capacitance
extract no coupling
extract no resistance
extract no adjust
# extract warn all
extract

ext2spice lvs
ext2spice nm.ext
feedback save /project/openlane/runs/nm/logs/magic/magic_ext2spice.feedback.txt
# exec cp nm.spice /project/openlane/runs/nm/results/magic/nm.spice


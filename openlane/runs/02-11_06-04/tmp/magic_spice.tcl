
lef read /home/mk/foss/pdks/sky130A/libs.ref/sky130_fd_sc_hd/techlef/sky130_fd_sc_hd.tlef
if {  [info exist ::env(EXTRA_LEFS)] } {
	set lefs_in $::env(EXTRA_LEFS)
	foreach lef_file $lefs_in {
		lef read $lef_file
	}
}
def read /openLANE_flow/designs/spm/runs/02-11_06-04/results/routing/spm.def
load spm -dereference
cd /openLANE_flow/designs/spm/runs/02-11_06-04/results/magic/
extract do local
extract no capacitance
extract no coupling
extract no resistance
extract no adjust
# extract warn all
extract

ext2spice lvs
ext2spice spm.ext
feedback save /openLANE_flow/designs/spm/runs/02-11_06-04/logs/magic/magic_ext2spice.feedback.txt
# exec cp spm.spice /openLANE_flow/designs/spm/runs/02-11_06-04/results/magic/spm.spice


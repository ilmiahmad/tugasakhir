v {xschem version=3.4.6RC file_version=1.2
}
G {}
K {}
V {}
S {}
E {}
N -180 -260 -180 -230 {
lab=IN}
N 50 -260 50 -230 {
lab=VB}
N 180 -260 180 -230 {
lab=VCC}
C {new_lif.sym} 10 10 0 0 {name=x1}
C {devices/code.sym} -390 -170 0 0 {name=TT_MODELS
only_toplevel=true
format="tcleval( @value )"
value="
** opencircuitdesign pdks install
.lib $::SKYWATER_MODELS/sky130.lib.spice tt

"
spice_ignore=false}
C {devices/code_shown.sym} -390 -10 0 0 {name=s1 only_toplevel=false value="

* Simulation Settings
.tran 1u 1m
.options savecurrents
.control
  run
  plot v(MEM) v(OUT)
.endc
"}
C {devices/lab_pin.sym} -180 -170 0 0 {name=p34 lab=0}
C {devices/lab_pin.sym} -180 -260 0 0 {name=p35 lab=IN}
C {devices/vsource.sym} 50 -200 0 0 {name=VPLUS1 value=0.2
spice_ignore=false}
C {devices/lab_pin.sym} 50 -170 0 0 {name=p1 lab=0}
C {devices/lab_pin.sym} 50 -260 0 0 {name=p2 lab=VB}
C {devices/vsource.sym} 180 -200 0 0 {name=VPLUS3 value=1.8
spice_ignore=false}
C {devices/lab_pin.sym} 180 -170 0 0 {name=p6 lab=0}
C {devices/lab_pin.sym} 180 -260 0 0 {name=p7 lab=VCC}
C {devices/lab_pin.sym} -140 0 0 0 {name=p3 lab=VB}
C {devices/lab_pin.sym} -140 -20 0 0 {name=p8 lab=IN}
C {devices/lab_pin.sym} 160 -20 0 1 {name=p9 lab=VCC}
C {devices/lab_pin.sym} 160 20 0 1 {name=p11 lab=OUT}
C {devices/lab_pin.sym} 160 0 0 1 {name=p10 lab=0}
C {devices/lab_pin.sym} 160 40 0 1 {name=p4 lab=MEM}
C {devices/isource.sym} -180 -200 0 0 {name=IPLUS2 value=100u
spice_ignore=false}

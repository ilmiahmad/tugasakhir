v {xschem version=3.4.6RC file_version=1.2
}
G {}
K {}
V {}
S {}
E {}
N -590 -220 -590 -190 {
lab=IN}
N -430 -220 -430 -190 {
lab=VCC}
C {st.sym} -200 -60 0 0 {name=x1}
C {devices/code.sym} -800 -130 0 0 {name=TT_MODELS
only_toplevel=true
format="tcleval( @value )"
value="
** opencircuitdesign pdks install
.lib $::SKYWATER_MODELS/sky130.lib.spice tt

"
spice_ignore=false}
C {devices/code_shown.sym} -800 30 0 0 {name=s1 only_toplevel=false value="

* Simulation Settings
.tran 1u 1m
.options savecurrents
.control
  run
  plot v(IN) v(OUT)
.endc
"}
C {devices/lab_pin.sym} -590 -130 0 0 {name=p34 lab=0}
C {devices/lab_pin.sym} -590 -220 0 0 {name=p35 lab=IN}
C {devices/vsource.sym} -430 -160 0 0 {name=VPLUS3 value=1.8
spice_ignore=false}
C {devices/lab_pin.sym} -430 -130 0 0 {name=p6 lab=0}
C {devices/lab_pin.sym} -430 -220 0 0 {name=p7 lab=VCC}
C {devices/vsource.sym} -590 -160 0 0 {name=VPLUS2 value="0 PWL(0us 0V 1ms 1.8V)"
spice_ignore=false}
C {devices/lab_pin.sym} -350 -80 0 0 {name=p3 lab=IN}
C {devices/lab_pin.sym} -50 -80 0 1 {name=p4 lab=VCC}
C {devices/lab_pin.sym} -50 -60 0 1 {name=p5 lab=0}
C {devices/lab_pin.sym} -50 -40 0 1 {name=p8 lab=OUT}

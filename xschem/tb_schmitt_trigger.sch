v {xschem version=3.4.6RC file_version=1.2
}
G {}
K {}
V {}
S {}
E {}
C {devices/code.sym} -730 -380 0 0 {name=TT_MODELS
only_toplevel=true
format="tcleval( @value )"
value="
** opencircuitdesign pdks install
.lib $::SKYWATER_MODELS/sky130.lib.spice tt

"
spice_ignore=false}
C {devices/code_shown.sym} -730 -210 0 0 {name=s1 only_toplevel=false value="

* Simulation Settings
.tran 0.1n 50n
.control
  run
  plot v(IN) v(OUT)
.endc
"}
C {devices/vsource.sym} -527.5 -342.5 0 0 {name=V1 value=1.8 savecurrent=false}
C {devices/lab_wire.sym} -527.5 -372.5 0 0 {name=p5 sig_type=std_logic lab=VDD}
C {devices/vsource.sym} -430 -342.5 0 0 {name=V2 value="0 PWL(0n 0V 50n 1.8V)" savecurrent=false}
C {devices/lab_wire.sym} -430 -372.5 0 0 {name=p6 sig_type=std_logic lab=IN}
C {devices/lab_wire.sym} -527.5 -312.5 0 0 {name=p8 sig_type=std_logic lab=0}
C {devices/lab_wire.sym} -430 -312.5 0 0 {name=p9 sig_type=std_logic lab=0}
C {schmitt_trigger.sym} -280 -190 0 0 {name=x1}
C {devices/lab_pin.sym} -130 -220 0 1 {name=p3 sig_type=std_logic lab=VDD}
C {devices/lab_pin.sym} -130 -200 0 1 {name=p1 sig_type=std_logic lab=0}
C {devices/lab_pin.sym} -130 -180 0 1 {name=p2 sig_type=std_logic lab=RST}
C {devices/lab_pin.sym} -130 -160 0 1 {name=p4 sig_type=std_logic lab=OUT}
C {devices/lab_pin.sym} -430 -220 0 0 {name=p7 sig_type=std_logic lab=IN}

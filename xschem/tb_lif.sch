v {xschem version=3.4.6RC file_version=1.2
}
G {}
K {}
V {}
S {}
E {}
N -60 -270 -60 -240 {
lab=VLKG}
N 30 -270 30 -240 {
lab=VRESET}
N 110 -270 110 -240 {
lab=VDD}
C {devices/code.sym} -460 -180 0 0 {name=TT_MODELS
only_toplevel=true
format="tcleval( @value )"
value="
** opencircuitdesign pdks install
.lib $::SKYWATER_MODELS/sky130.lib.spice tt

"
spice_ignore=false}
C {devices/code_shown.sym} -460 -10 0 0 {name=s1 only_toplevel=false value="

* Simulation Settings
.tran 1u 100u
.control
  run
  plot I(Vmeas)
.endc
"}
C {devices/lab_pin.sym} -250 -240 0 0 {name=p34 lab=VDD}
C {devices/lab_pin.sym} -250 -120 0 0 {name=p35 lab=IN}
C {devices/vsource.sym} -60 -210 0 0 {name=VPLUS1 value=0.1
spice_ignore=false}
C {devices/lab_pin.sym} -60 -180 0 0 {name=p1 lab=0}
C {devices/lab_pin.sym} -60 -270 0 0 {name=p2 lab=VLKG}
C {devices/vsource.sym} 30 -210 0 0 {name=VPLUS2 value=0.5
spice_ignore=false}
C {devices/lab_pin.sym} 30 -180 0 0 {name=p4 lab=0}
C {devices/lab_pin.sym} 30 -270 0 0 {name=p5 lab=VRESET}
C {devices/vsource.sym} 110 -210 0 0 {name=VPLUS3 value=1.8
spice_ignore=false}
C {devices/lab_pin.sym} 110 -180 0 0 {name=p6 lab=0}
C {devices/lab_pin.sym} 110 -270 0 0 {name=p7 lab=VDD}
C {lif.sym} -30 -60 0 0 {name=x1}
C {devices/lab_pin.sym} -180 -80 0 0 {name=p3 lab=IN}
C {devices/lab_pin.sym} -180 -60 0 0 {name=p8 lab=VLKG}
C {devices/lab_pin.sym} -180 -40 0 0 {name=p9 lab=VRESET}
C {devices/lab_pin.sym} 120 -80 0 1 {name=p10 lab=VDD}
C {devices/lab_pin.sym} 120 -60 0 1 {name=p11 lab=0}
C {devices/lab_pin.sym} 120 -40 0 1 {name=p12 lab=OUT}
C {devices/isource.sym} -250 -210 0 0 {name=I0 value=100u}
C {devices/ammeter.sym} -250 -150 0 0 {name=Vmeas savecurrent=true spice_ignore=0}

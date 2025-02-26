v {xschem version=3.4.6RC file_version=1.2
}
G {}
K {}
V {}
S {}
E {}
N -130 -300 -130 -270 {
lab=VLKG}
N -40 -300 -40 -270 {
lab=VRESET}
N 40 -300 40 -270 {
lab=VCC}
N -320 -210 -320 -150 {lab=MEM}
C {devices/code_shown.sym} -530 -40 0 0 {name=s1 only_toplevel=false value="

* Simulation Settings
.tran 10n 100u
.control
  run
  plot v(MEM) v(SPIKE)
.endc
"}
C {devices/lab_pin.sym} -320 -270 0 0 {name=p34 lab=VCC}
C {devices/lab_pin.sym} -320 -150 0 0 {name=p35 lab=MEM}
C {devices/vsource.sym} -130 -240 0 0 {name=VPLUS1 value=0
spice_ignore=false}
C {devices/lab_pin.sym} -130 -210 0 0 {name=p1 lab=0}
C {devices/lab_pin.sym} -130 -300 0 0 {name=p2 lab=VLKG}
C {devices/vsource.sym} -40 -240 0 0 {name=VPLUS2 value=0.5
spice_ignore=false}
C {devices/lab_pin.sym} -40 -210 0 0 {name=p4 lab=0}
C {devices/lab_pin.sym} -40 -300 0 0 {name=p6 lab=VRESET}
C {devices/vsource.sym} 40 -240 0 0 {name=VPLUS3 value=1.8
spice_ignore=false}
C {devices/lab_pin.sym} 40 -210 0 0 {name=p7 lab=0}
C {devices/lab_pin.sym} 40 -300 0 0 {name=p9 lab=VCC}
C {devices/isource.sym} -320 -240 0 0 {name=I0 value=5n}
C {devices/code.sym} -560 -260 0 0 {name=TT_MODELS1
only_toplevel=true
format="tcleval( @value )"
value=".lib $::SKYWATER_MODELS/sky130.lib.spice tt

.include $::SKYWATER_STDCELLS/sky130_fd_sc_hd.spice


"}
C {lif.sym} -40 -70 0 0 {name=x1}
C {devices/lab_pin.sym} -190 -90 0 0 {name=p3 lab=MEM}
C {devices/lab_pin.sym} -190 -70 0 0 {name=p5 lab=VLKG}
C {devices/lab_pin.sym} -190 -50 0 0 {name=p8 lab=VRESET}
C {devices/lab_pin.sym} 110 -90 0 1 {name=p10 lab=VCC}
C {devices/lab_pin.sym} 110 -70 0 1 {name=p11 lab=0}
C {devices/lab_pin.sym} 110 -50 0 1 {name=p12 lab=SPIKE}

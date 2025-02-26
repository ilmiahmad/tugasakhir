v {xschem version=3.4.6RC file_version=1.2
}
G {}
K {}
V {}
S {}
E {}
N -90 60 -90 90 {
lab=IN}
N -240 -200 -240 -170 {
lab=VCC}
N -50 -10 120 -10 {lab=IN}
N -90 -80 -90 -40 {lab=VCC}
N 160 -80 160 -40 {lab=VCC}
N -150 -10 -90 -10 {lab=VCC}
N -150 -50 -150 -10 {lab=VCC}
N -150 -50 -90 -50 {lab=VCC}
N 160 -10 240 -10 {lab=VCC}
N 240 -70 240 -10 {lab=VCC}
N 160 -80 240 -80 {lab=VCC}
N -90 20 -90 60 {lab=IN}
N -90 90 40 90 {lab=IN}
N 40 -10 40 90 {lab=IN}
N -90 150 -90 210 {lab=0}
N 160 80 160 130 {lab=VCP}
N 160 80 280 80 {lab=VCP}
N 280 80 280 120 {lab=VCP}
N 160 190 280 190 {lab=0}
N 280 180 280 190 {lab=0}
N 320 150 380 150 {lab=#net1}
N 220 150 280 150 {lab=0}
N 220 150 220 190 {lab=0}
N 240 -80 240 -70 {lab=VCC}
C {devices/code.sym} -610 -110 0 0 {name=TT_MODELS
only_toplevel=true
format="tcleval( @value )"
value="
** opencircuitdesign pdks install
.lib $::SKYWATER_MODELS/sky130.lib.spice tt

"
spice_ignore=false}
C {devices/code_shown.sym} -600 60 0 0 {name=s1 only_toplevel=false value="

* Simulation Settings
.tran 1n 1u
.options savecurrents
.control
  run 
  plot V(VCP)
  plot I(Vmeas)
.endc
"}
C {devices/lab_pin.sym} -90 60 0 0 {name=p35 lab=IN}
C {devices/vsource.sym} -240 -140 0 0 {name=VPLUS3 value=1.8
spice_ignore=false}
C {devices/lab_pin.sym} -240 -200 0 0 {name=p7 lab=VCC}
C {devices/isource.sym} -90 120 0 0 {name=INP value=1n
spice_ignore=false}
C {devices/lab_pin.sym} -240 -110 0 0 {name=p5 lab=0}
C {sky130_fd_pr/pfet_01v8.sym} -70 -10 0 1 {name=M1
L=0.2
W=1
nf=1
mult=1
ad="'int((nf+1)/2) * W/nf * 0.29'" 
pd="'2*int((nf+1)/2) * (W/nf + 0.29)'"
as="'int((nf+2)/2) * W/nf * 0.29'" 
ps="'2*int((nf+2)/2) * (W/nf + 0.29)'"
nrd="'0.29 / W'" nrs="'0.29 / W'"
sa=0 sb=0 sd=0
model=pfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8.sym} 140 -10 0 0 {name=M2
L=0.2
W=1
nf=1
mult=1
ad="'int((nf+1)/2) * W/nf * 0.29'" 
pd="'2*int((nf+1)/2) * (W/nf + 0.29)'"
as="'int((nf+2)/2) * W/nf * 0.29'" 
ps="'2*int((nf+2)/2) * (W/nf + 0.29)'"
nrd="'0.29 / W'" nrs="'0.29 / W'"
sa=0 sb=0 sd=0
model=pfet_01v8
spiceprefix=X
}
C {devices/lab_pin.sym} -90 -80 0 0 {name=p1 lab=VCC}
C {devices/lab_pin.sym} 160 -80 0 0 {name=p2 lab=VCC}
C {devices/lab_pin.sym} -90 210 0 0 {name=p6 lab=0}
C {devices/ammeter.sym} 160 50 0 0 {name=Vmeas savecurrent=true spice_ignore=0}
C {devices/capa.sym} 160 160 0 0 {name=C1
m=1
value=1p
footprint=1206
device="ceramic capacitor"}
C {devices/lab_pin.sym} 160 190 0 0 {name=p4 lab=0}
C {sky130_fd_pr/nfet_01v8.sym} 300 150 0 1 {name=M3
L=0.15
W=1
nf=1 
mult=1
ad="'int((nf+1)/2) * W/nf * 0.29'" 
pd="'2*int((nf+1)/2) * (W/nf + 0.29)'"
as="'int((nf+2)/2) * W/nf * 0.29'" 
ps="'2*int((nf+2)/2) * (W/nf + 0.29)'"
nrd="'0.29 / W'" nrs="'0.29 / W'"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
C {devices/vsource.sym} 380 180 0 0 {name=VPLUS1 value=0.2
spice_ignore=false}
C {devices/lab_pin.sym} 380 210 0 0 {name=p8 lab=0}
C {devices/lab_pin.sym} 160 130 0 0 {name=p3 lab=VCP}

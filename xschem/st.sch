v {xschem version=3.4.6RC file_version=1.2
}
G {}
K {}
V {}
S {}
E {}
N -190 -390 -190 -260 {lab=#net1}
N -380 -390 -380 -260 {lab=OUT}
N -380 -200 -190 -200 {lab=#net2}
N -280 -200 -280 -140 {lab=#net2}
N -380 -450 -190 -450 {lab=VCC}
N -270 -420 -230 -420 {lab=OUT}
N -270 -420 -270 -230 {lab=OUT}
N -270 -230 -230 -230 {lab=OUT}
N -460 -420 -420 -420 {lab=IN}
N -460 -420 -460 -230 {lab=IN}
N -240 -110 -110 -110 {lab=#net1}
N -190 -320 -110 -320 {lab=#net1}
N -190 -420 -120 -420 {lab=VCC}
N -120 -450 -120 -420 {lab=VCC}
N -190 -450 -120 -450 {lab=VCC}
N -380 -420 -310 -420 {lab=VCC}
N -310 -450 -310 -420 {lab=VCC}
N -360 -110 -280 -110 {lab=VSS}
N -360 -110 -360 -80 {lab=VSS}
N -360 -80 -280 -80 {lab=VSS}
N -110 -320 -60 -320 {lab=#net1}
N -110 -110 -60 -110 {lab=#net1}
N -380 -230 -330 -230 {lab=VSS}
N -190 -230 -120 -230 {lab=VSS}
N -380 -270 -270 -270 {lab=OUT}
N -460 -230 -420 -230 {lab=IN}
N -60 -320 -60 -110 {lab=#net1}
C {sky130_fd_pr/pfet_01v8.sym} -400 -420 0 0 {name=M3
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
model=pfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8.sym} -210 -420 0 0 {name=M5
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
model=pfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/nfet_01v8.sym} -400 -230 0 0 {name=M6
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
C {sky130_fd_pr/nfet_01v8.sym} -210 -230 0 0 {name=M7
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
C {sky130_fd_pr/nfet_01v8.sym} -260 -110 0 1 {name=M8
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
C {devices/lab_pin.sym} -280 -450 3 1 {name=p5 sig_type=std_logic lab=VCC}
C {devices/lab_pin.sym} -280 -80 3 0 {name=p11 sig_type=std_logic lab=VSS}
C {devices/lab_pin.sym} -120 -230 0 1 {name=p17 sig_type=std_logic lab=VSS}
C {devices/lab_pin.sym} -330 -230 0 1 {name=p18 sig_type=std_logic lab=VSS}
C {devices/lab_pin.sym} -330 -270 1 0 {name=p24 sig_type=std_logic lab=OUT}
C {devices/lab_pin.sym} -460 -320 0 0 {name=p27 sig_type=std_logic lab=IN}
C {devices/iopin.sym} -790 -370 0 1 {name=p1 lab=VCC}
C {devices/iopin.sym} -790 -350 0 1 {name=p2 lab=VSS}
C {devices/ipin.sym} -790 -330 0 0 {name=p6 lab=IN}
C {devices/opin.sym} -810 -310 0 0 {name=p7 lab=OUT}

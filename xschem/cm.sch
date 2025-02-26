v {xschem version=3.4.6RC file_version=1.2
}
G {}
K {}
V {}
S {}
E {}
N -100 -10 10 -10 {lab=IN}
N -140 20 -50 20 {lab=IN}
N -50 -10 -50 20 {lab=IN}
N -230 40 -140 40 {lab=IN}
N 50 -10 130 -10 {lab=VCC}
N 130 -40 130 -10 {lab=VCC}
N 50 -40 130 -40 {lab=VCC}
N -210 -10 -140 -10 {lab=VCC}
N -210 -40 -210 -10 {lab=VCC}
N -210 -40 -140 -40 {lab=VCC}
N -140 20 -140 40 {lab=IN}
N 50 20 50 60 {lab=OUT}
C {sky130_fd_pr/pfet_01v8.sym} -120 -10 0 1 {name=M1
L=0.15
W=0.25
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
C {sky130_fd_pr/pfet_01v8.sym} 30 -10 0 0 {name=M2
L=0.15
W=0.25
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
C {devices/lab_pin.sym} -230 40 2 1 {name=p8 sig_type=std_logic lab=IN}
C {devices/lab_pin.sym} -140 -40 3 1 {name=p3 sig_type=std_logic lab=VCC}
C {devices/lab_pin.sym} 50 -40 3 1 {name=p4 sig_type=std_logic lab=VCC}
C {devices/iopin.sym} -440 -130 0 1 {name=p1 lab=VCC}
C {devices/ipin.sym} -440 -110 0 0 {name=p6 lab=IN}
C {devices/opin.sym} -470 -90 0 0 {name=p7 lab=OUT}
C {devices/lab_pin.sym} 50 60 2 1 {name=p5 sig_type=std_logic lab=OUT}

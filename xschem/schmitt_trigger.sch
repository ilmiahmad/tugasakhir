v {xschem version=3.4.6RC file_version=1.2
}
G {}
K {}
V {}
S {}
E {}
N -730 -1060 -730 -880 {lab=IN}
N -690 -910 -540 -910 {lab=#net1}
N -690 -1030 -540 -1030 {lab=#net2}
N -690 -970 -510 -970 {lab=#net3}
N -510 -990 -510 -970 {lab=#net3}
N -510 -970 -510 -950 {lab=#net3}
N -510 -970 -470 -970 {lab=#net3}
N -690 -1110 -690 -1090 {lab=VCC}
N -690 -1090 -600 -1090 {lab=VCC}
N -600 -1090 -600 -1060 {lab=VCC}
N -690 -1060 -600 -1060 {lab=VCC}
N -690 -1000 -600 -1000 {lab=VCC}
N -600 -1060 -600 -1000 {lab=VCC}
N -690 -850 -690 -810 {lab=VSS}
N -690 -940 -600 -940 {lab=VSS}
N -600 -940 -600 -880 {lab=VSS}
N -690 -880 -600 -880 {lab=VSS}
N -690 -850 -600 -850 {lab=VSS}
N -600 -880 -600 -850 {lab=VSS}
N -510 -1110 -510 -1030 {lab=VCC}
N -510 -910 -510 -810 {lab=VSS}
N -360 -1000 -360 -940 {lab=#net3}
N -470 -970 -440 -970 {lab=#net3}
N -320 -910 -320 -880 {lab=VSS}
N -320 -940 -250 -940 {lab=VSS}
N -250 -940 -250 -910 {lab=VSS}
N -320 -910 -250 -910 {lab=VSS}
N -320 -1000 -250 -1000 {lab=VCC}
N -250 -1030 -250 -1000 {lab=VCC}
N -320 -1030 -250 -1030 {lab=VCC}
N -440 -970 -360 -970 {lab=#net3}
N -320 -970 -240 -970 {lab=OUT}
C {sky130_fd_pr/pfet_01v8.sym} -710 -1060 0 0 {name=M1
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
C {sky130_fd_pr/pfet_01v8.sym} -710 -1000 0 0 {name=M2
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
C {sky130_fd_pr/nfet_01v8.sym} -710 -940 0 0 {name=M3
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
C {sky130_fd_pr/nfet_01v8.sym} -710 -880 0 0 {name=M4
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
C {sky130_fd_pr/pfet_01v8.sym} -510 -1010 3 0 {name=M5
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
C {sky130_fd_pr/nfet_01v8.sym} -510 -930 1 0 {name=M6
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
C {devices/ipin.sym} -730 -970 0 0 {name=p1 lab=IN}
C {devices/opin.sym} -240 -970 0 0 {name=p2 lab=OUT}
C {devices/iopin.sym} -870 -1040 0 1 {name=p3 lab=VCC}
C {devices/iopin.sym} -870 -1020 0 1 {name=p4 lab=VSS}
C {devices/lab_wire.sym} -690 -1110 0 0 {name=p5 sig_type=std_logic lab=VCC}
C {devices/lab_wire.sym} -690 -810 0 0 {name=p6 sig_type=std_logic lab=VSS}
C {devices/lab_wire.sym} -510 -1110 0 0 {name=p7 sig_type=std_logic lab=VCC}
C {devices/lab_wire.sym} -510 -810 0 0 {name=p8 sig_type=std_logic lab=VSS}
C {devices/lab_wire.sym} -480 -910 2 0 {name=p9 sig_type=std_logic lab=VCC}
C {devices/lab_wire.sym} -480 -1030 2 0 {name=p10 sig_type=std_logic lab=VSS}
C {sky130_fd_pr/nfet_01v8.sym} -340 -940 0 0 {name=M7
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
C {sky130_fd_pr/pfet_01v8.sym} -340 -1000 0 0 {name=M8
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
C {devices/lab_wire.sym} -320 -1030 0 0 {name=p11 sig_type=std_logic lab=VCC}
C {devices/lab_wire.sym} -320 -880 0 0 {name=p12 sig_type=std_logic lab=VSS}

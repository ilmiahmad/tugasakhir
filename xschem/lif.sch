v {xschem version=3.4.6RC file_version=1.2
}
G {}
K {}
V {}
S {}
E {}
N -310 -50 -130 -50 {lab=IN}
N -450 -50 -310 -50 {lab=IN}
N -490 -50 -450 -50 {lab=IN}
N -490 -20 -420 -20 {lab=VSS}
N -260 -20 -190 -20 {lab=VSS}
N -490 -90 -490 -50 {lab=IN}
N -260 -20 -260 20 {lab=VSS}
N -490 10 -490 40 {lab=VSS}
N -490 40 -260 40 {lab=VSS}
N -260 20 -260 40 {lab=VSS}
N -350 10 -350 40 {lab=VSS}
N -420 -20 -420 40 {lab=VSS}
N -380 40 -380 80 {lab=VSS}
N -130 -50 -90 -50 {lab=IN}
N 210 -10 210 40 {lab=OUT}
N -150 40 210 40 {lab=OUT}
N -150 -20 -150 40 {lab=OUT}
C {devices/iopin.sym} -660 -80 0 1 {name=p1 lab=VCC}
C {devices/iopin.sym} -660 -60 0 1 {name=p2 lab=VSS}
C {devices/ipin.sym} -660 -40 0 0 {name=p6 lab=IN}
C {devices/opin.sym} -680 -20 0 0 {name=p7 lab=OUT}
C {devices/ipin.sym} -660 0 0 0 {name=p10 lab=VLKG}
C {devices/ipin.sym} -660 20 0 0 {name=p11 lab=VRESET
}
C {sky130_fd_pr/nfet_01v8.sym} -510 -20 0 0 {name=M1
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
C {sky130_fd_pr/nfet_01v8.sym} -170 -20 0 1 {name=M2
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
C {devices/lab_pin.sym} -380 80 1 1 {name=p5 sig_type=std_logic lab=VSS}
C {devices/lab_pin.sym} -490 -90 2 1 {name=p8 sig_type=std_logic lab=IN}
C {devices/lab_pin.sym} -530 -20 2 1 {name=p12 sig_type=std_logic lab=VLKG}
C {devices/lab_pin.sym} -190 10 3 0 {name=p13 sig_type=std_logic lab=VRESET}
C {sky130_fd_pr/cap_mim_m3_1.sym} -350 -20 0 0 {name=C1 model=cap_mim_m3_1 W=1 L=1 MF=12 spiceprefix=X}
C {devices/lab_pin.sym} 210 -50 0 1 {name=p3 lab=VCC}
C {devices/lab_pin.sym} 210 -30 0 1 {name=p4 lab=VSS}
C {devices/lab_pin.sym} 210 -10 0 1 {name=p9 lab=OUT}
C {/home/ahmadjabar/tugasakhir/xschem/schmitt_trigger.sym} 60 -30 0 0 {name=x1}

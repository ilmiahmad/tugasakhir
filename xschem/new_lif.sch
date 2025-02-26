v {xschem version=3.4.6RC file_version=1.2
}
G {}
K {}
V {}
S {}
E {}
N -230 -130 -120 -130 {lab=IN}
N 830 -70 830 60 {lab=OUT}
N 470 -70 470 60 {lab=#net1}
N 280 -70 280 60 {lab=RST2TRIG2BUF}
N 280 120 470 120 {lab=#net2}
N 380 120 380 180 {lab=#net2}
N -270 -100 -180 -100 {lab=IN}
N -180 -130 -180 -100 {lab=IN}
N -460 120 -460 180 {lab=RST2DIS}
N -460 150 -420 150 {lab=RST2DIS}
N -160 190 -20 190 {lab=VSS}
N -20 130 130 130 {lab=CUR2DIS2TRIG}
N -20 190 130 190 {lab=VSS}
N 280 -130 470 -130 {lab=VCC}
N 390 -100 430 -100 {lab=RST2TRIG2BUF}
N 390 -100 390 90 {lab=RST2TRIG2BUF}
N 390 90 430 90 {lab=RST2TRIG2BUF}
N 200 -100 240 -100 {lab=CUR2DIS2TRIG}
N 200 -100 200 90 {lab=CUR2DIS2TRIG}
N 200 90 240 90 {lab=CUR2DIS2TRIG}
N 760 -100 790 -100 {lab=RST2TRIG2BUF}
N 760 -100 760 90 {lab=RST2TRIG2BUF}
N 760 90 790 90 {lab=RST2TRIG2BUF}
N 420 210 550 210 {lab=#net1}
N 470 -0 550 -0 {lab=#net1}
N -360 -80 -270 -80 {lab=IN}
N -20 190 -20 220 {lab=VSS}
N -420 240 -340 240 {lab=VSS}
N -340 240 -340 270 {lab=VSS}
N -420 270 -340 270 {lab=VSS}
N -420 180 -340 180 {lab=VSS}
N -340 180 -340 240 {lab=VSS}
N -500 30 -420 30 {lab=VCC}
N -500 30 -500 60 {lab=VCC}
N -500 60 -420 60 {lab=VCC}
N -420 120 -350 120 {lab=VCC}
N -80 -130 -0 -130 {lab=VCC}
N -0 -160 -0 -130 {lab=VCC}
N -80 -160 -0 -160 {lab=VCC}
N -340 -130 -270 -130 {lab=VCC}
N -340 -160 -340 -130 {lab=VCC}
N -340 -160 -270 -160 {lab=VCC}
N 470 -100 540 -100 {lab=VCC}
N 540 -130 540 -100 {lab=VCC}
N 470 -130 540 -130 {lab=VCC}
N 280 -100 350 -100 {lab=VCC}
N 350 -130 350 -100 {lab=VCC}
N 300 210 380 210 {lab=VSS}
N 300 210 300 240 {lab=VSS}
N 300 240 380 240 {lab=VSS}
N 550 0 600 0 {lab=#net1}
N 550 210 600 210 {lab=#net1}
N 280 90 330 90 {lab=VSS}
N 470 90 540 90 {lab=VSS}
N 830 90 910 90 {lab=VSS}
N 910 90 910 120 {lab=VSS}
N 830 120 910 120 {lab=VSS}
N 830 -130 910 -130 {lab=VCC}
N 910 -130 910 -100 {lab=VCC}
N 830 -100 910 -100 {lab=VCC}
N -160 160 -90 160 {lab=VSS}
N -90 160 -90 190 {lab=VSS}
N 60 160 130 160 {lab=VSS}
N 60 160 60 190 {lab=VSS}
N 280 50 390 50 {lab=RST2TRIG2BUF}
N 600 -0 600 210 {lab=#net1}
N -20 100 -20 130 {lab=CUR2DIS2TRIG}
N 830 0 870 0 {lab=OUT}
N -160 130 -20 130 {lab=CUR2DIS2TRIG}
N -270 -100 -270 -80 {lab=IN}
C {sky130_fd_pr/pfet_01v8.sym} -250 -130 0 1 {name=M1
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
C {sky130_fd_pr/nfet_01v8.sym} -440 180 0 0 {name=M4
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
C {sky130_fd_pr/pfet_01v8.sym} -100 -130 0 0 {name=M2
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
C {sky130_fd_pr/pfet_01v8.sym} 260 -100 0 0 {name=M3
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
C {sky130_fd_pr/pfet_01v8.sym} 450 -100 0 0 {name=M5
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
C {sky130_fd_pr/nfet_01v8.sym} 260 90 0 0 {name=M6
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
C {sky130_fd_pr/nfet_01v8.sym} 450 90 0 0 {name=M7
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
C {sky130_fd_pr/nfet_01v8.sym} 400 210 0 1 {name=M8
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
C {sky130_fd_pr/pfet_01v8.sym} 810 -100 0 0 {name=M9
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
C {sky130_fd_pr/nfet_01v8.sym} 810 90 0 0 {name=M10
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
C {sky130_fd_pr/pfet_01v8.sym} -400 60 0 1 {name=M11
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
C {sky130_fd_pr/pfet_01v8.sym} -440 120 0 0 {name=M12
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
C {sky130_fd_pr/nfet_01v8.sym} -440 240 0 0 {name=M13
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
C {sky130_fd_pr/nfet_01v8.sym} -180 160 0 0 {name=M14
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
C {sky130_fd_pr/cap_mim_m3_1.sym} -20 160 0 0 {name=C1 model=cap_mim_m3_1 W=1 L=1 MF=12 spiceprefix=X}
C {sky130_fd_pr/nfet_01v8.sym} 150 160 0 1 {name=M15
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
C {devices/iopin.sym} -590 -150 0 1 {name=p1 lab=VCC}
C {devices/iopin.sym} -590 -130 0 1 {name=p2 lab=VSS}
C {devices/ipin.sym} -590 -110 0 0 {name=p6 lab=IN}
C {devices/opin.sym} -610 -90 0 0 {name=p7 lab=OUT}
C {devices/ipin.sym} -590 -70 0 0 {name=p10 lab=VB}
C {devices/lab_pin.sym} -360 -80 2 1 {name=p8 sig_type=std_logic lab=IN}
C {devices/lab_pin.sym} -270 -160 3 1 {name=p3 sig_type=std_logic lab=VCC}
C {devices/lab_pin.sym} -80 -160 3 1 {name=p4 sig_type=std_logic lab=VCC}
C {devices/lab_pin.sym} 380 -130 3 1 {name=p5 sig_type=std_logic lab=VCC}
C {devices/lab_pin.sym} 830 -130 3 1 {name=p9 sig_type=std_logic lab=VCC}
C {devices/lab_pin.sym} 380 240 3 0 {name=p11 sig_type=std_logic lab=VSS}
C {devices/lab_pin.sym} 830 120 3 0 {name=p12 sig_type=std_logic lab=VSS}
C {devices/lab_pin.sym} -20 220 3 0 {name=p13 sig_type=std_logic lab=VSS}
C {devices/lab_pin.sym} -420 270 3 0 {name=p14 sig_type=std_logic lab=VSS}
C {devices/lab_pin.sym} -420 30 3 1 {name=p15 sig_type=std_logic lab=VCC}
C {devices/lab_pin.sym} -350 120 0 1 {name=p16 sig_type=std_logic lab=VCC}
C {devices/lab_pin.sym} 540 90 0 1 {name=p17 sig_type=std_logic lab=VSS}
C {devices/lab_pin.sym} 330 90 0 1 {name=p18 sig_type=std_logic lab=VSS}
C {devices/lab_pin.sym} -460 240 0 0 {name=p19 sig_type=std_logic lab=VB}
C {devices/lab_pin.sym} 170 160 0 1 {name=p20 sig_type=std_logic lab=VB}
C {devices/lab_pin.sym} -200 160 0 0 {name=p21 sig_type=std_logic lab=RST2DIS}
C {devices/lab_pin.sym} -460 150 0 0 {name=p22 sig_type=std_logic lab=RST2DIS}
C {devices/lab_pin.sym} 330 50 1 0 {name=p24 sig_type=std_logic lab=RST2TRIG2BUF}
C {devices/lab_pin.sym} -80 -100 3 0 {name=p29 sig_type=std_logic lab=CUR2DIS2TRIG}
C {devices/lab_pin.sym} 870 0 0 1 {name=p31 sig_type=std_logic lab=OUT}
C {devices/lab_pin.sym} 760 0 2 1 {name=p25 sig_type=std_logic lab=RST2TRIG2BUF}
C {devices/lab_pin.sym} -380 60 2 0 {name=p23 sig_type=std_logic lab=RST2TRIG2BUF}
C {devices/lab_pin.sym} -20 100 1 0 {name=p26 sig_type=std_logic lab=CUR2DIS2TRIG}
C {devices/lab_pin.sym} 200 0 0 0 {name=p27 sig_type=std_logic lab=CUR2DIS2TRIG}
C {devices/opin.sym} -610 -50 0 0 {name=p30 lab=CUR2DIS2TRIG}

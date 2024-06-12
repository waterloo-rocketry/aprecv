REM Program for HC4046A VCO Frequency with & w/o offset
REM Name "PLL.BAS"
REM
Start:
INPUT "Enter center frequency, Fo ", Fo
INPUT "Enter Offset frequency, Fmin, enter 0 if none ", Fmin
INPUT "Enter power supply voltage, Vcc (Vdd) ", Vcc
PRINT "6 pf of stray cap. is assumed, Ctotal = Cstray + C1"
Vramp = (.1*Vcc+.6)-(-.7)
Tpd = EXP (-.434*LOG(Vcc)-17.5)
REM Tpd approx. 12.5 nanoseconds, Vcc=5V
Cs=6E-12 : Rdn=50
IF Fmin > Fo THEN PRINT "bad data, try again"
IF Fmin > Fo THEN GOTO Start
IF Fmin > .9 * Fo THEN PRINT "Offset too close to Fo, Poor choice!"
IF Fmin<>0 THEN GOTO Offset
REM IF Fmin=0 THEN NoOffset
PRINT "Prop Delay, Tpd = ", Tpd
REM
NoOffset:
REM I1 empirical equation,guestimate
I1=EXP(.45*LOG(Fo)-15)
REM MI equation from graph fit
M1=-.04343*LOG(I1/.001)+6
Isum=M1*I1
R1=Vcc/(2*I1)
REM if Ct selected as initial data, est. with this
REM Ct=EXP(-.667*LOG(Fo)-13.196)
REM C1 values less than 40 pF should not be used
REM IF Ct<4.6E-11 THEN Ct=4.6E-11
Tc=((1/Fo)-2*Tpd)/2
Ct=Tc*Isum/(Vramp-(Isum*Rdn))
C1=Ct-Cs
PRINT "RI = ", R1
PRINT "C1 = ", C1
PRINT "I1 = ", I1
PRINT "M1 = ", M1
PRINT "Isum = ", Isum
PRINT
INPUT "Pick preferred numbers for R1,C1 & plot Fvco? y/n? ", Q1$
IF Q1$ = "n" THEN GOTO Quit
RepeatNoOffset:
INPUT "New C1 = ", C1
INPUT "New R1 = ", R1
PRINT "Vcoin(V) "," Fvco(Hz) "
FOR Vcoin=1 TO Vcc-.5 STEP .5
I1=Vcoin/R1
Isum=(-.04343*LOG(I1/.001)+6)*I1
Tc=(C1+Cs)*(Vramp-Isum*Rdn)/Isum
Fvco=1/(2*Tpd+2*Tc)
IF Vcoin=(Vcc/2)-.5 THEN Fl=Fvco
IF Vcoin=(Vcc/2)+.5 THEN Fh=Fvco
Ko=((Fh-Fl)/1)*2*3.14159
PRINT Vcoin, Fvco
NEXT
PRINT
PRINT "Ko = ", Ko , "radians/V"
PRINT
INPUT "Repeat preferred number calc. for R1,C1? y/n? ", Q2$
IF Q2$ = "y" THEN GOTO RepeatNoOffset ELSE GOTO Quit
REM
Offset:
REM empirical guestimate
I2=EXP(.45*LOG(Fmin)-15)
R2=(Vcc-.6)/I2
M2=-.087*LOG(I2)+4.6+.4*Voc
Tcmin=((1/Fmin)-2*Tpd)/2
Ct=Tcmin*M2*I2/(Vramp-M2*I2*Rdn)
C1=Ct-Cs
Tco=((1/Fo)-2*Tpd)/2
Isum=Ct*Vramp/(Tco+Ct*Rdn)
M1I1=Isum-M2*I2
REM empirical equation for I1 based on given M1*I1 vs I1
I1=EXP(1.007113*LOG(M1I1)-1.755368)
M1=M1I1/I1
R1=(Vcc/2)/I1
PRINT "R1 = ", R1
PRINT "R2 = ", R2
PRINT "C1 = ", C1
PRINT "I1 = ", I1
PRINT "I2 = ", I2
PRINT "M1 = ", M1
PRINT "M2 = ", M2
PRINT "Isum = ", Isum
INPUT "Pick preferred numbers for Fvco vs Vcoin plot? y/n? ", Q3$
IF Q3$="n" THEN GOTO Quit
PRINT "Note. IN NO CASE SHOULD R1 OR R2 BE LESS THAN 3000 Ω!!"
RepeatOffset:
INPUT "Enter preferred value of C1 ", C1
INPUT "Enter preferred value of R1 ", R1
INPUT "Enter preferred value of R2 ", R2
PRINT "Vcoin", "Fvco", "Isum"
FOR Vcoin = 1 TO Vcc-.5 STEP .5
I2=(Vcc-.6)/R2
I1=Vcoin/R1
M1=-.04343*LOG(I1/.001)+6
M2=-.087*LOG(I2)+4.6+.4*Vcc
Isum=M1*I1+M2*I2
Tc=((C1+Cs)*(Vramp-Isum*Rdn))/Isum
Fvco=1/(2*Tc+2*Tpd)
IF Vcoin=(Vcc/2)-.5 THEN Fl=Fvco
IF Vcoin=(Vcc/2)+.5 THEN Fh=Fvco
Ko=((Fh-Fl)/1)*2*3.14159
PRINT Vcoin, Fvco, Isum
NEXT
PRINT
PRINT "Ko = ", Ko, " radians/volt "
PRINT
INPUT "Try other preferred values? y/n? ", Q4$
IF Q4$ = "y" THEN GOTO RepeatOffset ELSE GOTO Quit
REM
Quit:
END

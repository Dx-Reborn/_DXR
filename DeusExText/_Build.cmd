cd ..\system\
del deusextext.u
cd ..\system\DX
del deusextext.u
cd ..\
ucc make -debug
move deusextext.u DX\deusextext.u

copy DX\deusextext.u ..\deusextext\
pause
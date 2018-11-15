cd ..\system\
del DXRColors.u
ucc make -debug
move DXRColors.u DX\DXRColors.u

copy \DXRColors.u ..\DXRColors\

:pause

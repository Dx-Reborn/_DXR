cd ..\System\

ren deusexnative.dll deusexnative.dll_

del ut2k4Extra.u
ucc make -debug -nobind


ren deusexnative.dll_ deusexnative.dll

copy ut2k4Extra.u ..\ut2k4Extra\
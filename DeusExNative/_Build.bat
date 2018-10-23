cd..\system\
ren deusexnative.dll deusexnative.dll_
del DeusExNative.u

ucc make -debug -nobind

ren deusexnative.dll_ deusexnative.dll
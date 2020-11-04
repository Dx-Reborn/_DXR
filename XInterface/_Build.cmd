cd ..\System\
del XInterface.u

ren DeusExNative.dll DeusExNative.dll_

ucc make -debug -nobind

copy XInterface.u ..\XInterface\

ren DeusExNative.dll_ DeusExNative.dll
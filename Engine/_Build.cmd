cd ..\system
del engine.u

ren DeusExNative.dll DeusExNative.dll_

ucc make -debug -nobind

ren DeusExNative.dll_ DeusExNative.dll

copy Engine.u ..\Engine\

pause
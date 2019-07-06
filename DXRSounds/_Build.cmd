cd ..\system\

ren deusexnative.dll deusexnative.dll_

del DXRSounds.u
ucc make -debug -nobind

ren deusexnative.dll_ deusexnative.dll

:pause

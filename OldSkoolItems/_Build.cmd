cd ..\system

ren deusexnative.dll deusexnative.dll_

del OldSkoolItems.u
ucc make -debug -nobind

ren deusexnative.dll_ deusexnative.dll

copy OldSkoolItems.u ..\OldSkoolItems\
call _genBuild.cmd
move /Y DXRVersion.uc classes\

cd ..\system\

ren deusexnative.dll deusexnative.dll_

del deusex.u

ucc make -debug -nobind

ren deusexnative.dll_ deusexnative.dll

copy deusex.u ..\DeusEx\

:pause

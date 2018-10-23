/* Weapon Pickups (only weapons !) */

class DXRPickups extends Object
	abstract;

#exec obj load file=effects.utx
#exec obj load file=effects_ex.utx
#exec obj load file=DeusExItems.ukx


//
// GEPGun
//
//#exec TEXTURE IMPORT NAME=GEPGun3rdTex1 FILE=Models\GEPGun3rdTex1.pcx GROUP="Skins" MASKED=1
// pickup version
#exec MESH IMPORT MESH=GEPGunPickup ANIVFILE=Models\GEPGunPickup_a.3d DATAFILE=Models\GEPGunPickup_d.3d ZEROTEX=1
#exec MESH ORIGIN MESH=GEPGunPickup X=-12 Y=34 Z=0 ROLL=-64
#exec MESHMAP SCALE MESHMAP=GEPGunPickup X=0.125 Y=0.125 Z=0.25
#exec MESH SEQUENCE MESH=GEPGunPickup SEQ=All		STARTFRAME=0	NUMFRAMES=1
#exec MESH SEQUENCE MESH=GEPGunPickup SEQ=Still		STARTFRAME=0	NUMFRAMES=1
#exec MESHMAP SETTEXTURE MESHMAP=GEPGunPickup NUM=0 TEXTURE=GEPGun3rdTex1

//
// Glock
//
//#exec TEXTURE IMPORT NAME=Glock3rdTex1 FILE=Models\Glock3rdTex1.pcx GROUP="Skins"
// pickup version
#exec MESH IMPORT MESH=GlockPickup ANIVFILE=Models\GlockPickup_a.3d DATAFILE=Models\GlockPickup_d.3d
#exec MESH ORIGIN MESH=GlockPickup X=8 Y=0 Z=0 ROLL=-64
#exec MESHMAP SCALE MESHMAP=GlockPickup X=0.125 Y=0.125 Z=0.25
#exec MESH SEQUENCE MESH=GlockPickup SEQ=All		STARTFRAME=0	NUMFRAMES=4
#exec MESH SEQUENCE MESH=GlockPickup SEQ=Still		STARTFRAME=0	NUMFRAMES=1
#exec MESH SEQUENCE MESH=GlockPickup SEQ=Shoot		STARTFRAME=1	NUMFRAMES=3	RATE=17

#exec MESHMAP SETTEXTURE MESHMAP=GlockPickup NUM=0 TEXTURE=Glock3rdTex1
#exec MESHMAP SETTEXTURE MESHMAP=GlockPickup NUM=1 TEXTURE=Glock3rdTex1
#exec MESHMAP SETTEXTURE MESHMAP=GlockPickup NUM=2 TEXTURE=BlackMaskTex

//
// SniperRifle
//
//#exec TEXTURE IMPORT NAME=SniperRifle3rdTex1 FILE=Models\SniperRifle3rdTex1.pcx GROUP="Skins" MASKED=1
// pickup version
#exec MESH IMPORT MESH=SniperRiflePickup ANIVFILE=Models\SniperRiflePickup_a.3d DATAFILE=Models\SniperRiflePickup_d.3d ZEROTEX=1
#exec MESH ORIGIN MESH=SniperRiflePickup X=65,75 Y=0 Z=0 ROLL=-64

#exec MESHMAP SCALE MESHMAP=SniperRiflePickup X=0.125 Y=0.125 Z=0.25
#exec MESH SEQUENCE MESH=SniperRiflePickup SEQ=All		STARTFRAME=0	NUMFRAMES=1
#exec MESH SEQUENCE MESH=SniperRiflePickup SEQ=Still	STARTFRAME=0	NUMFRAMES=1

#exec MESHMAP SETTEXTURE MESHMAP=SniperRiflePickup NUM=0 TEXTURE=SniperRifle3rdTex1

//
// CombatKnife
//
//#exec TEXTURE IMPORT NAME=CombatKnife3rdTex1 FILE=Models\CombatKnife3rdTex1.pcx GROUP="Skins"
#exec MESHMAP SETTEXTURE MESHMAP=CombatKnife3rd NUM=0 TEXTURE=CombatKnife3rdTex1

// pickup version
#exec MESH IMPORT MESH=CombatKnifePickup ANIVFILE=Models\CombatKnifePickup_a.3d DATAFILE=Models\CombatKnifePickup_d.3d ZEROTEX=1

#exec MESH ORIGIN MESH=CombatKnifePickup X=1 Y=0 Z=0 ROLL=-64
#exec MESHMAP SCALE MESHMAP=CombatKnifePickup X=0.125 Y=0.125 Z=0.25
#exec MESH SEQUENCE MESH=CombatKnifePickup SEQ=All		STARTFRAME=0	NUMFRAMES=1
#exec MESH SEQUENCE MESH=CombatKnifePickup SEQ=Still	STARTFRAME=0	NUMFRAMES=1

#exec MESHMAP SETTEXTURE MESHMAP=CombatKnifePickup NUM=0 TEXTURE=CombatKnife3rdTex1

//
// Crowbar
//
//#exec TEXTURE IMPORT NAME=Crowbar3rdTex1 FILE=Models\Crowbar3rdTex1.pcx GROUP="Skins"
#exec MESHMAP SETTEXTURE MESHMAP=Crowbar3rd NUM=0 TEXTURE=Crowbar3rdTex1

// pickup version
#exec MESH IMPORT MESH=CrowbarPickup ANIVFILE=Models\CrowbarPickup_a.3d DATAFILE=Models\CrowbarPickup_d.3d ZEROTEX=1

#exec MESH ORIGIN MESH=CrowbarPickup X=16 Y=0 Z=16 ROLL=-64

#exec MESHMAP SCALE MESHMAP=CrowbarPickup X=0.125 Y=0.125 Z=0.25
#exec MESH SEQUENCE MESH=CrowbarPickup SEQ=All		STARTFRAME=0	NUMFRAMES=1
#exec MESH SEQUENCE MESH=CrowbarPickup SEQ=Still	STARTFRAME=0	NUMFRAMES=1

#exec MESHMAP SETTEXTURE MESHMAP=CrowbarPickup NUM=0 TEXTURE=Crowbar3rdTex1

//
// StealthPistol
//
//#exec TEXTURE IMPORT NAME=StealthPistol3rdTex1 FILE=Models\StealthPistol3rdTex1.pcx GROUP="Skins" MASKED=1
#exec MESHMAP SETTEXTURE MESHMAP=StealthPistol3rd NUM=0 TEXTURE=StealthPistol3rdTex1

// pickup version
#exec MESH IMPORT MESH=StealthPistolPickup ANIVFILE=Models\StealthPistolPickup_a.3d DATAFILE=Models\StealthPistolPickup_d.3d ZEROTEX=1

#exec MESH ORIGIN MESH=StealthPistolPickup X=-32 Y=0 Z=0 ROLL=-64

#exec MESHMAP SCALE MESHMAP=StealthPistolPickup X=0.125 Y=0.125 Z=0.25
#exec MESH SEQUENCE MESH=StealthPistolPickup SEQ=All	STARTFRAME=0	NUMFRAMES=1
#exec MESH SEQUENCE MESH=StealthPistolPickup SEQ=Still	STARTFRAME=0	NUMFRAMES=1

#exec MESHMAP SETTEXTURE MESHMAP=StealthPistolPickup NUM=0 TEXTURE=StealthPistol3rdTex1

//
// Prod
//
//#exec TEXTURE IMPORT NAME=Prod3rdTex1 FILE=Models\Prod3rdTex1.pcx GROUP="Skins" MASKED=1
// pickup version
#exec MESH IMPORT MESH=ProdPickup ANIVFILE=Models\ProdPickup_a.3d DATAFILE=Models\ProdPickup_d.3d ZEROTEX=1

#exec MESH ORIGIN MESH=ProdPickup X=-14 Y=0 Z=0 ROLL=-64

#exec MESHMAP SCALE MESHMAP=ProdPickup X=0.125 Y=0.125 Z=0.25
#exec MESH SEQUENCE MESH=ProdPickup SEQ=All		STARTFRAME=0	NUMFRAMES=1
#exec MESH SEQUENCE MESH=ProdPickup SEQ=Still	STARTFRAME=0	NUMFRAMES=1

#exec MESHMAP SETTEXTURE MESHMAP=ProdPickup NUM=0 TEXTURE=Prod3rdTex1

//
// HideAGun
//
//#exec TEXTURE IMPORT NAME=HideAGun3rdTex1 FILE=Models\HideAGun3rdTex1.pcx GROUP="Skins" MASKED=1
// pickup version
#exec MESH IMPORT MESH=HideAGunPickup ANIVFILE=Models\HideAGunPickup_a.3d DATAFILE=Models\HideAGunPickup_d.3d

#exec MESH ORIGIN MESH=HideAGunPickup X=0 Y=0 Z=0 ROLL=-64
#exec MESHMAP SCALE MESHMAP=HideAGunPickup X=0.125 Y=0.125 Z=0.25
#exec MESH SEQUENCE MESH=HideAGunPickup SEQ=All		STARTFRAME=0	NUMFRAMES=1
#exec MESH SEQUENCE MESH=HideAGunPickup SEQ=Still	STARTFRAME=0	NUMFRAMES=1

#exec MESHMAP SETTEXTURE MESHMAP=HideAGunPickup NUM=0 TEXTURE=HideAGun3rdTex1
#exec MESHMAP SETTEXTURE MESHMAP=HideAGunPickup NUM=1 TEXTURE=HideAGun3rdTex1
#exec MESHMAP SETTEXTURE MESHMAP=HideAGunPickup NUM=2 TEXTURE=BlackMaskTex

//
// AssaultGun
//
//#exec TEXTURE IMPORT NAME=AssaultGun3rdTex1 FILE=Models\AssaultGun3rdTex1.pcx GROUP="Skins" MASKED=1
// pickup version
#exec MESH IMPORT MESH=AssaultGunPickup ANIVFILE=Models\AssaultGunPickup_a.3d DATAFILE=Models\AssaultGunPickup_d.3d

#exec MESH ORIGIN MESH=AssaultGunPickup X=-16 Y=0 Z=16 ROLL=-64

#exec MESHMAP SCALE MESHMAP=AssaultGunPickup X=0.125 Y=0.125 Z=0.25
#exec MESH SEQUENCE MESH=AssaultGunPickup SEQ=All	STARTFRAME=0	NUMFRAMES=1
#exec MESH SEQUENCE MESH=AssaultGunPickup SEQ=Still	STARTFRAME=0	NUMFRAMES=1

#exec MESHMAP SETTEXTURE MESHMAP=AssaultGunPickup NUM=0 TEXTURE=AssaultGun3rdTex1
#exec MESHMAP SETTEXTURE MESHMAP=AssaultGunPickup NUM=1 TEXTURE=AssaultGun3rdTex1
#exec MESHMAP SETTEXTURE MESHMAP=AssaultGunPickup NUM=2 TEXTURE=BlackMaskTex

//
// LAW
//
//#exec TEXTURE IMPORT NAME=LAW3rdTex1 FILE=Models\LAW3rdTex1.pcx GROUP="Skins" MASKED=1
// pickup version
#exec MESH IMPORT MESH=LAWPickup ANIVFILE=Models\LAWPickup_a.3d DATAFILE=Models\LAWPickup_d.3d ZEROTEX=1

#exec MESH ORIGIN MESH=LAWPickup X=-93,75 Y=-16 Z=16 ROLL=-64
#exec MESHMAP SCALE MESHMAP=LAWPickup X=0.125 Y=0.125 Z=0.25
#exec MESH SEQUENCE MESH=LAWPickup SEQ=All		STARTFRAME=0	NUMFRAMES=1
#exec MESH SEQUENCE MESH=LAWPickup SEQ=Still	STARTFRAME=0	NUMFRAMES=1

#exec MESHMAP SETTEXTURE MESHMAP=LAWPickup NUM=0 TEXTURE=LAW3rdTex1

//
// LAM
//
//#exec TEXTURE IMPORT NAME=LAM3rdTex1 FILE=Models\LAM3rdTex1.pcx GROUP="Skins"
// pickup version
#exec MESH IMPORT MESH=LAMPickup ANIVFILE=Models\LAMPickup_a.3d DATAFILE=Models\LAMPickup_d.3d

#exec MESH ORIGIN MESH=LAMPickup X=0 Y=0 Z=-2 YAW=64

#exec MESHMAP SCALE MESHMAP=LAMPickup X=0.125 Y=0.125 Z=0.25
#exec MESH SEQUENCE MESH=LAMPickup SEQ=All		STARTFRAME=0	NUMFRAMES=1
#exec MESH SEQUENCE MESH=LAMPickup SEQ=Still	STARTFRAME=0	NUMFRAMES=1
#exec MESH SEQUENCE MESH=LAMPickup SEQ=Open		STARTFRAME=0	NUMFRAMES=1

#exec MESHMAP SETTEXTURE MESHMAP=LAMPickup NUM=0 TEXTURE=BlackMaskTex
#exec MESHMAP SETTEXTURE MESHMAP=LAMPickup NUM=1 TEXTURE=LAM3rdTex1

//
// PepperGun
//
//#exec TEXTURE IMPORT NAME=PepperGun3rdTex1 FILE=Models\PepperGun3rdTex1.pcx GROUP="Skins" MASKED=1
// pickup version
#exec MESH IMPORT MESH=PepperGunPickup ANIVFILE=Models\PepperGunPickup_a.3d DATAFILE=Models\PepperGunPickup_d.3d ZEROTEX=1
#exec MESH ORIGIN MESH=PepperGunPickup X=8 Y=0 Z=0 ROLL=-64

#exec MESHMAP SCALE MESHMAP=PepperGunPickup X=0.125 Y=0.125 Z=0.25
#exec MESH SEQUENCE MESH=PepperGunPickup SEQ=All	STARTFRAME=0	NUMFRAMES=1
#exec MESH SEQUENCE MESH=PepperGunPickup SEQ=Still	STARTFRAME=0	NUMFRAMES=1

#exec MESHMAP SETTEXTURE MESHMAP=PepperGunPickup NUM=0 TEXTURE=PepperGun3rdTex1

//
// Flamethrower
//
//#exec TEXTURE IMPORT NAME=Flamethrower3rdTex1 FILE=Models\Flamethrower3rdTex1.pcx GROUP="Skins" MASKED=1
// pickup version
#exec MESH IMPORT MESH=FlamethrowerPickup ANIVFILE=Models\FlamethrowerPickup_a.3d DATAFILE=Models\FlamethrowerPickup_d.3d ZEROTEX=1

#exec MESH ORIGIN MESH=FlamethrowerPickup X=8 Y= Z=-32 ROLL=-64

#exec MESHMAP SCALE MESHMAP=FlamethrowerPickup X=0.125 Y=0.125 Z=0.25
#exec MESH SEQUENCE MESH=FlamethrowerPickup SEQ=All		STARTFRAME=0	NUMFRAMES=1
#exec MESH SEQUENCE MESH=FlamethrowerPickup SEQ=Still	STARTFRAME=0	NUMFRAMES=1

#exec MESHMAP SETTEXTURE MESHMAP=FlamethrowerPickup NUM=0 TEXTURE=Flamethrower3rdTex1

//
// MiniCrossbow
//
//#exec TEXTURE IMPORT NAME=MiniCrossbow3rdTex1 FILE=Models\MiniCrossbow3rdTex1.pcx GROUP="Skins" MASKED=1
// pickup version
#exec MESH IMPORT MESH=MiniCrossbowPickup ANIVFILE=Models\MiniCrossbowPickup_a.3d DATAFILE=Models\MiniCrossbowPickup_d.3d ZEROTEX=1

#exec MESH ORIGIN MESH=MiniCrossbowPickup X=-68 Y=0 Z=8

#exec MESHMAP SCALE MESHMAP=MiniCrossbowPickup X=0.125 Y=0.125 Z=0.25
#exec MESH SEQUENCE MESH=MiniCrossbowPickup SEQ=All		STARTFRAME=0	NUMFRAMES=1
#exec MESH SEQUENCE MESH=MiniCrossbowPickup SEQ=Still	STARTFRAME=0	NUMFRAMES=1

#exec MESHMAP SETTEXTURE MESHMAP=MiniCrossbowPickup NUM=0 TEXTURE=MiniCrossbow3rdTex1

//
// Shotgun
//
//#exec TEXTURE IMPORT NAME=Shotgun3rdTex1 FILE=Models\Shotgun3rdTex1.pcx GROUP="Skins" MASKED=1
// pickup version
#exec MESH IMPORT MESH=ShotgunPickup ANIVFILE=Models\ShotgunPickup_a.3d DATAFILE=Models\ShotgunPickup_d.3d

#exec MESH ORIGIN MESH=ShotgunPickup X=-24 Y=0 Z=8 ROLL=-64

#exec MESHMAP SCALE MESHMAP=ShotgunPickup X=0.125 Y=0.125 Z=0.25
#exec MESH SEQUENCE MESH=ShotgunPickup SEQ=All		STARTFRAME=0	NUMFRAMES=1
#exec MESH SEQUENCE MESH=ShotgunPickup SEQ=Still	STARTFRAME=0	NUMFRAMES=1

#exec MESHMAP SETTEXTURE MESHMAP=ShotgunPickup NUM=0 TEXTURE=Shotgun3rdTex1
#exec MESHMAP SETTEXTURE MESHMAP=ShotgunPickup NUM=1 TEXTURE=Shotgun3rdTex1
#exec MESHMAP SETTEXTURE MESHMAP=ShotgunPickup NUM=2 TEXTURE=BlackMaskTex

//
// AssaultShotgun
//
//#exec TEXTURE IMPORT NAME=AssaultShotgun3rdTex1 FILE=Models\AssaultShotgun3rdTex1.pcx GROUP="Skins" MASKED=1
// pickup version
#exec MESH IMPORT MESH=AssaultShotgunPickup ANIVFILE=Models\AssaultShotgunPickup_a.3d DATAFILE=Models\AssaultShotgunPickup_d.3d

#exec MESH ORIGIN MESH=AssaultShotgunPickup X=-40 Y=0 Z=8 ROLL=-64

#exec MESHMAP SCALE MESHMAP=AssaultShotgunPickup X=0.125 Y=0.125 Z=0.25
#exec MESH SEQUENCE MESH=AssaultShotgunPickup SEQ=All	STARTFRAME=0	NUMFRAMES=1
#exec MESH SEQUENCE MESH=AssaultShotgunPickup SEQ=Still	STARTFRAME=0	NUMFRAMES=1

#exec MESHMAP SETTEXTURE MESHMAP=AssaultShotgunPickup NUM=0 TEXTURE=AssaultShotgun3rdTex1
#exec MESHMAP SETTEXTURE MESHMAP=AssaultShotgunPickup NUM=1 TEXTURE=AssaultShotgun3rdTex1
#exec MESHMAP SETTEXTURE MESHMAP=AssaultShotgunPickup NUM=2 TEXTURE=BlackMaskTex

//
// PlasmaRifle
//
//#exec TEXTURE IMPORT NAME=PlasmaRifle3rdTex1 FILE=Models\PlasmaRifle3rdTex1.pcx GROUP="Skins" MASKED=1
// pickup version
#exec MESH IMPORT MESH=PlasmaRiflePickup ANIVFILE=Models\PlasmaRiflePickup_a.3d DATAFILE=Models\PlasmaRiflePickup_d.3d ZEROTEX=1

#exec MESH ORIGIN MESH=PlasmaRiflePickup X=29,375 Y=9,375 Z=-4 ROLL=-64

#exec MESHMAP SCALE MESHMAP=PlasmaRiflePickup X=0.125 Y=0.125 Z=0.25
#exec MESH SEQUENCE MESH=PlasmaRiflePickup SEQ=All		STARTFRAME=0	NUMFRAMES=1
#exec MESH SEQUENCE MESH=PlasmaRiflePickup SEQ=Still	STARTFRAME=0	NUMFRAMES=1
#exec MESH SEQUENCE MESH=PlasmaRiflePickup SEQ=Shoot	STARTFRAME=1	NUMFRAMES=2 RATE=7

#exec MESHMAP SETTEXTURE MESHMAP=PlasmaRiflePickup NUM=0 TEXTURE=PlasmaRifle3rdTex1

//
// Sword
//
//#exec TEXTURE IMPORT NAME=Sword3rdTex1 FILE=Models\Sword3rdTex1.pcx GROUP="Skins"
// pickup version
#exec MESH IMPORT MESH=SwordPickup ANIVFILE=Models\SwordPickup_a.3d DATAFILE=Models\SwordPickup_d.3d ZEROTEX=1

#exec MESH ORIGIN MESH=SwordPickup X=32 Y=0 Z=64 ROLL=-64

#exec MESHMAP SCALE MESHMAP=SwordPickup X=0.125 Y=0.125 Z=0.25
#exec MESH SEQUENCE MESH=SwordPickup SEQ=All	STARTFRAME=0	NUMFRAMES=3
#exec MESH SEQUENCE MESH=SwordPickup SEQ=Still	STARTFRAME=0	NUMFRAMES=1
#exec MESH SEQUENCE MESH=SwordPickup SEQ=On		STARTFRAME=1	NUMFRAMES=1
#exec MESH SEQUENCE MESH=SwordPickup SEQ=Off	STARTFRAME=2	NUMFRAMES=1

#exec MESHMAP SETTEXTURE MESHMAP=SwordPickup NUM=0 TEXTURE=Sword3rdTex1

//
// NanoSword
//
//#exec TEXTURE IMPORT NAME=NanoSword3rdTex1 FILE=Models\NanoSword3rdTex1.pcx GROUP="Skins"
// pickup version
#exec MESH IMPORT MESH=NanoSwordPickup ANIVFILE=Models\NanoSwordPickup_a.3d DATAFILE=Models\NanoSwordPickup_d.3d

#exec MESH ORIGIN MESH=NanoSwordPickup X=32 Y=0 Z=64 ROLL=-64

#exec MESHMAP SCALE MESHMAP=NanoSwordPickup X=0.125 Y=0.125 Z=0.25
#exec MESH SEQUENCE MESH=NanoSwordPickup SEQ=All	STARTFRAME=0	NUMFRAMES=1
#exec MESH SEQUENCE MESH=NanoSwordPickup SEQ=Still	STARTFRAME=0	NUMFRAMES=1

#exec MESHMAP SETTEXTURE MESHMAP=NanoSwordPickup NUM=0 TEXTURE=NanoSword3rdTex1
#exec MESHMAP SETTEXTURE MESHMAP=NanoSwordPickup NUM=1 TEXTURE=Effects.Electricity.WavyBlade
#exec MESHMAP SETTEXTURE MESHMAP=NanoSwordPickup NUM=2 TEXTURE=NanoSword3rdTex1
#exec MESHMAP SETTEXTURE MESHMAP=NanoSwordPickup NUM=3 TEXTURE=NanoSword3rdTex1
#exec MESHMAP SETTEXTURE MESHMAP=NanoSwordPickup NUM=4 TEXTURE=Effects.Electricity.WEPN_NESword_SFX
#exec MESHMAP SETTEXTURE MESHMAP=NanoSwordPickup NUM=5 TEXTURE=Effects.Electricity.Nano_SFX_A

//
// Shuriken
//
//#exec TEXTURE IMPORT NAME=Shuriken3rdTex1 FILE=Models\Shuriken3rdTex1.pcx GROUP="Skins"
// pickup version
#exec MESH IMPORT MESH=ShurikenPickup ANIVFILE=Models\ShurikenPickup_a.3d DATAFILE=Models\ShurikenPickup_d.3d ZEROTEX=1

#exec MESH ORIGIN MESH=ShurikenPickup X=0 Y=0 Z=20 ROLL=64

#exec MESHMAP SCALE MESHMAP=ShurikenPickup X=0.125 Y=0.125 Z=0.25
#exec MESH SEQUENCE MESH=ShurikenPickup SEQ=All		STARTFRAME=0	NUMFRAMES=1
#exec MESH SEQUENCE MESH=ShurikenPickup SEQ=Still	STARTFRAME=0	NUMFRAMES=1

#exec MESHMAP SETTEXTURE MESHMAP=ShurikenPickup NUM=0 TEXTURE=Shuriken3rdTex1

//
// EMPGrenade
//
//#exec TEXTURE IMPORT NAME=EMPGrenade3rdTex1 FILE=Models\EMPGrenade3rdTex1.pcx GROUP="Skins"
// pickup version
#exec MESH IMPORT MESH=EMPGrenadePickup ANIVFILE=Models\EMPGrenadePickup_a.3d DATAFILE=Models\EMPGrenadePickup_d.3d

#exec MESH ORIGIN MESH=EMPGrenadePickup X=0 Y=0 Z=2 YAW=64

#exec MESHMAP SCALE MESHMAP=EMPGrenadePickup X=0.125 Y=0.125 Z=0.25
#exec MESH SEQUENCE MESH=EMPGrenadePickup SEQ=All		STARTFRAME=0	NUMFRAMES=2
#exec MESH SEQUENCE MESH=EMPGrenadePickup SEQ=Still		STARTFRAME=0	NUMFRAMES=1
#exec MESH SEQUENCE MESH=EMPGrenadePickup SEQ=Open		STARTFRAME=1	NUMFRAMES=1

#exec MESHMAP SETTEXTURE MESHMAP=EMPGrenadePickup NUM=0 TEXTURE=Effects.Electricity.WEPN_EMPG_SFX
#exec MESHMAP SETTEXTURE MESHMAP=EMPGrenadePickup NUM=1 TEXTURE=EMPGrenade3rdTex1

//
// GasGrenade
//
//#exec TEXTURE IMPORT NAME=GasGrenade3rdTex1 FILE=Models\GasGrenade3rdTex1.pcx GROUP="Skins"
// pickup version
#exec MESH IMPORT MESH=GasGrenadePickup ANIVFILE=Models\GasGrenadePickup_a.3d DATAFILE=Models\GasGrenadePickup_d.3d ZEROTEX=1

#exec MESH ORIGIN MESH=GasGrenadePickup X=0 Y=0 Z=-2 YAW=64

#exec MESHMAP SCALE MESHMAP=GasGrenadePickup X=0.125 Y=0.125 Z=0.25
#exec MESH SEQUENCE MESH=GasGrenadePickup SEQ=All	STARTFRAME=0	NUMFRAMES=1
#exec MESH SEQUENCE MESH=GasGrenadePickup SEQ=Still	STARTFRAME=0	NUMFRAMES=1
#exec MESH SEQUENCE MESH=GasGrenadePickup SEQ=Open	STARTFRAME=0	NUMFRAMES=1

#exec MESHMAP SETTEXTURE MESHMAP=GasGrenadePickup NUM=0 TEXTURE=GasGrenade3rdTex1

//
// NanoVirusGrenade
//
//#exec TEXTURE IMPORT NAME=NanoVirusGrenade3rdTex1 FILE=Models\NanoVirusGrenade3rdTex1.pcx GROUP="Skins" MASKED=1
// pickup version
#exec MESH IMPORT MESH=NanoVirusGrenadePickup ANIVFILE=Models\NanoVirusGrenadePickup_a.3d DATAFILE=Models\NanoVirusGrenadePickup_d.3d

#exec MESH ORIGIN MESH=NanoVirusGrenadePickup X=0 Y=0 Z=2 YAW=64

#exec MESHMAP SCALE MESHMAP=NanoVirusGrenadePickup X=0.125 Y=0.125 Z=0.25
#exec MESH SEQUENCE MESH=NanoVirusGrenadePickup SEQ=All		STARTFRAME=0	NUMFRAMES=3
#exec MESH SEQUENCE MESH=NanoVirusGrenadePickup SEQ=Still	STARTFRAME=0	NUMFRAMES=1
#exec MESH SEQUENCE MESH=NanoVirusGrenadePickup SEQ=Open	STARTFRAME=1	NUMFRAMES=1
#exec MESH SEQUENCE MESH=NanoVirusGrenadePickup SEQ=Closed	STARTFRAME=2	NUMFRAMES=1

#exec MESHMAP SETTEXTURE MESHMAP=NanoVirusGrenadePickup NUM=0 TEXTURE=NanoVirusGrenade3rdTex1
#exec MESHMAP SETTEXTURE MESHMAP=NanoVirusGrenadePickup NUM=1 TEXTURE=Effects.Electricity.Nano_SFX

//
// Baton
//
//#exec TEXTURE IMPORT NAME=Baton3rdTex1 FILE=Models\Baton3rdTex1.pcx GROUP="Skins"
// pickup version
#exec MESH IMPORT MESH=BatonPickup ANIVFILE=Models\BatonPickup_a.3d DATAFILE=Models\BatonPickup_d.3d ZEROTEX=1

#exec MESH ORIGIN MESH=BatonPickup X=0 Y=0 Z=40 ROLL=-64

#exec MESHMAP SCALE MESHMAP=BatonPickup X=0.125 Y=0.125 Z=0.25
#exec MESH SEQUENCE MESH=BatonPickup SEQ=All	STARTFRAME=0	NUMFRAMES=1
#exec MESH SEQUENCE MESH=BatonPickup SEQ=Still	STARTFRAME=0	NUMFRAMES=1

#exec MESHMAP SETTEXTURE MESHMAP=BatonPickup NUM=0 TEXTURE=Baton3rdTex1


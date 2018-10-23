//=============================================================================
// GuntherHermann.
//=============================================================================
class GuntherHermann extends HumanMilitary;

//
// Damage type table for Gunther Hermann:
//
// Shot			- 100%
// Sabot		- 100%
// Exploded		- 100%
// TearGas		- 10%
// PoisonGas	- 10%
// Poison		- 10%
// HalonGas		- 10%
// Radiation	- 10%
// Shocked		- 10%
// Stunned		- 0%
// KnockedOut   - 0%
// Flamed		- 0%
// Burned		- 0%
// NanoVirus	- 0%
// EMP			- 0%
//


// ----------------------------------------------------------------------
// SpawnCarcass()
//
// Blow up instead of spawning a carcass
// ----------------------------------------------------------------------




//
// special Gunther killswitch animation state
//

defaultproperties
{
     HealthHead=600
     HealthTorso=400
     HealthLegLeft=400
     HealthLegRight=400
     HealthArmLeft=400
     HealthArmRight=400
     BindName="GuntherHermann"
     FamiliarName="Gunther Hermann"
     UnfamiliarName="Gunther Hermann"
     CarcassType=Class'DeusEx.GuntherHermannCarcass'
     WalkingSpeed=0.350000
     bImportant=True
     bInvincible=True
     CloseCombatMult=0.500000
     InitialInventory(0)=(Inventory=Class'DeusEx.WeaponAssaultGun')
     InitialInventory(1)=(Inventory=Class'DeusEx.Ammo762mm',Count=12)
     InitialInventory(2)=(Inventory=Class'DeusEx.WeaponCombatKnife')
     InitialInventory(3)=(Inventory=Class'DeusEx.WeaponFlamethrower')
     InitialInventory(4)=(Inventory=Class'DeusEx.AmmoNapalm',Count=2)
     BurnPeriod=0.000000
     walkAnimMult=0.750000
     GroundSpeed=210.000000
     BaseEyeHeight=44.000000
     Health=400
     Mesh=mesh'DeusExCharacters.GM_DressShirt_B'
     DrawScale=1.100000
     skins(0)=Texture'DeusExCharacters.Skins.GuntherHermannTex1'
     skins(1)=Texture'DeusExCharacters.Skins.PantsTex9'
     skins(2)=Texture'DeusExCharacters.Skins.GuntherHermannTex0'
     skins(3)=Texture'DeusExCharacters.Skins.GuntherHermannTex0'
     skins(4)=Texture'DeusExItems.Skins.PinkMaskTex'
     skins(5)=Texture'DeusExItems.Skins.GrayMaskTex'
     skins(6)=Texture'DeusExItems.Skins.BlackMaskTex'
     skins(7)=Texture'DeusExItems.Skins.BlackMaskTex'
     CollisionRadius=24.200001
     CollisionHeight=55.660000
}

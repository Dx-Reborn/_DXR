//=============================================================================
// WaltonSimons.
//=============================================================================
class WaltonSimons extends HumanMilitary;

//
// Damage type table for Walton Simons:
//
// Shot			- 100%
// Sabot		- 100%
// Exploded		- 100%
// TearGas		- 10%
// PoisonGas	- 10%
// Poison		- 10%
// PoisonEffect	- 10%
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

defaultproperties
{
     HealthHead=900
     HealthTorso=600
     HealthLegLeft=600
     HealthLegRight=600
     HealthArmLeft=600
     HealthArmRight=600
     BindName="WaltonSimons"
     FamiliarName="Walton Simons"
     UnfamiliarName="Walton Simons"
     CarcassType=Class'DeusEx.WaltonSimonsCarcass'
     WalkingSpeed=0.333333
     bImportant=True
     bInvincible=True
     CloseCombatMult=0.500000
     BaseAssHeight=-23.000000
     BurnPeriod=0.000000
     bHasCloak=True
     CloakThreshold=150
     walkAnimMult=1.400000
     GroundSpeed=240.000000
     Health=600
     Mesh=mesh'DeusExCharacters.GM_Trench'
     skins(0)=Texture'DeusExCharacters.Skins.WaltonSimonsTex0'
     skins(1)=Texture'DeusExCharacters.Skins.WaltonSimonsTex2'
     skins(2)=Texture'DeusExCharacters.Skins.PantsTex5'
     skins(3)=Texture'DeusExCharacters.Skins.WaltonSimonsTex0'
     skins(4)=Texture'DeusExCharacters.Skins.WaltonSimonsTex1'
     skins(5)=Texture'DeusExCharacters.Skins.WaltonSimonsTex2'
     skins(6)=Texture'DeusExItems.Skins.GrayMaskTex'
     skins(7)=Texture'DeusExItems.Skins.BlackMaskTex'
     CollisionRadius=20.000000
     CollisionHeight=47.500000
}

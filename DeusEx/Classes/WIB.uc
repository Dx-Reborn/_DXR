//=============================================================================
// WIB.
//=============================================================================
class WIB extends HumanMilitary;

// ----------------------------------------------------------------------
// SpawnCarcass()
//
// Blow up instead of spawning a carcass
// ----------------------------------------------------------------------

defaultproperties
{
     HealthHead=300
     HealthTorso=300
     HealthLegLeft=300
     HealthLegRight=300
     HealthArmLeft=300
     HealthArmRight=300
     BindName="WIB"
     FamiliarName="Woman In Black"
     UnfamiliarName="Woman In Black"
     MinHealth=0.000000
     CarcassType=Class'DeusEx.WIBCarcass'
     WalkingSpeed=0.296000
     CloseCombatMult=0.500000
     BaseAssHeight=-18.000000
     walkAnimMult=0.870000
     bIsFemale=True
     GroundSpeed=200.000000
     Health=300
     Mesh=mesh'DeusExCharacters.GFM_SuitSkirt'
     DrawScale=1.100000
     skins(0)=Texture'DeusExCharacters.Skins.WIBTex0'
     skins(1)=Texture'DeusExItems.Skins.PinkMaskTex'
     skins(2)=Texture'DeusExCharacters.Skins.WIBTex0'
     skins(3)=Texture'DeusExCharacters.Skins.LegsTex2'
     skins(4)=Texture'DeusExCharacters.Skins.WIBTex1'
     skins(5)=Texture'DeusExCharacters.Skins.WIBTex1'
     skins(6)=Material'DeusExCharacters.Skins.SH_FramesTex2'
     skins(7)=Material'DeusExCharacters.Skins.FB_LensesTex3'

//     skins(6)=Texture'DeusExCharacters.Skins.FramesTex2'
//     skins(7)=Texture'DeusExCharacters.Skins.LensesTex3'

     CollisionHeight=47.299999
			CollisionRadius=22.0
}

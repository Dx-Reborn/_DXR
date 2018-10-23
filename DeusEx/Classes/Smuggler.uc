//=============================================================================
// Smuggler.
//=============================================================================
class Smuggler extends HumanThug;

defaultproperties
{
     BindName="Smuggler"
     FamiliarName="Smuggler"
     UnfamiliarName="Smuggler"
     CarcassType=Class'DeusEx.SmugglerCarcass'
     WalkingSpeed=0.213333
     BaseAssHeight=-23.000000
     InitialInventory(0)=(Inventory=Class'DeusEx.WeaponPistol')
     InitialInventory(1)=(Inventory=Class'DeusEx.Ammo10mm',Count=12)
     InitialInventory(2)=(Inventory=Class'DeusEx.WeaponCrowbar')
     GroundSpeed=180.000000
     Mesh=mesh'DeusExCharacters.GM_Trench'
     skins(0)=Texture'DeusExCharacters.Skins.SmugglerTex0'
     skins(1)=Texture'DeusExCharacters.Skins.SmugglerTex2'
     skins(2)=Texture'DeusExCharacters.Skins.PantsTex5'
     skins(3)=Texture'DeusExCharacters.Skins.SmugglerTex0'
     skins(4)=Texture'DeusExCharacters.Skins.SmugglerTex1'
     skins(5)=Texture'DeusExCharacters.Skins.SmugglerTex2'
     skins(6)=Material'DeusExCharacters.Skins.SH_FramesTex1'
     skins(7)=Material'DeusExCharacters.Skins.FB_LensesTex1'

//     skins(6)=Texture'DeusExCharacters.Skins.FramesTex1'
//     skins(7)=Texture'DeusExCharacters.Skins.LensesTex1'

     CollisionRadius=20.000000
     CollisionHeight=47.500000
}

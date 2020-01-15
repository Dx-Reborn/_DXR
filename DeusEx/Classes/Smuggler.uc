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
     InitialInventory(0)=(Inventory=Class'DeusEx.WeaponPistolInv')
     InitialInventory(1)=(Inventory=Class'DeusEx.Ammo10mmInv',Count=12)
     InitialInventory(2)=(Inventory=Class'DeusEx.WeaponCrowbarInv')
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

     CollisionRadius=20.000000
     CollisionHeight=43.000000
//     CollisionHeight=47.500000
}

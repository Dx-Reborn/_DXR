//=============================================================================
// ThugMale.
//=============================================================================
class ThugMale extends HumanThug;

defaultproperties
{
     BindName="Thug"
     FamiliarName="Thug"
     UnfamiliarName="Thug"
     CarcassType=Class'DeusEx.ThugMaleCarcass'
     WalkingSpeed=0.213333
     BaseAssHeight=-23.000000
     InitialInventory(0)=(Inventory=Class'DeusEx.WeaponPistol')
     InitialInventory(1)=(Inventory=Class'DeusEx.Ammo10mm',Count=6)
     InitialInventory(2)=(Inventory=Class'DeusEx.WeaponCrowbar')
     GroundSpeed=180.000000
     Mesh=mesh'DeusExCharacters.GM_Trench'
     skins(0)=Texture'DeusExCharacters.Skins.ThugMaleTex0'
     skins(1)=Texture'DeusExCharacters.Skins.ThugMaleTex2'
     skins(2)=Texture'DeusExCharacters.Skins.ThugMaleTex3'
     skins(3)=Texture'DeusExCharacters.Skins.ThugMaleTex0'
     skins(4)=Texture'DeusExCharacters.Skins.ThugMaleTex1'
     skins(5)=Texture'DeusExItems.Skins.PinkMaskTex'
     skins(6)=Texture'DeusExItems.Skins.GrayMaskTex'
     skins(7)=Texture'DeusExItems.Skins.BlackMaskTex'
     CollisionRadius=20.000000
     CollisionHeight=43.000000
//     CollisionHeight=47.500000
}

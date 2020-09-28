//=============================================================================
// TriadLumPath.
//=============================================================================
class TriadLumPath extends HumanThug;

defaultproperties
{
     BindName="TriadLuminousPathMember"
     FamiliarName="Gang Member"
     UnfamiliarName="Gang Member"
     CarcassType=Class'DeusEx.TriadLumPathCarcass'
     WalkingPct=0.300000
     InitialInventory(0)=(Inventory=Class'DeusEx.WeaponPistol')
     InitialInventory(1)=(Inventory=Class'DeusEx.Ammo10mm',Count=2)
     InitialInventory(2)=(Inventory=Class'DeusEx.WeaponSword')
     walkAnimMult=1.200000
     GroundSpeed=200.000000
     WaterSpeed=240.000000
     AirSpeed=144.000000
     BaseEyeHeight=32.000000
     Mesh=mesh'DeusExCharacters.GM_Suit'
     skins(0)=Texture'DeusExCharacters.Skins.TriadLumPathTex0'
     skins(1)=Texture'DeusExCharacters.Skins.PantsTex10'
     skins(2)=Texture'DeusExCharacters.Skins.TriadLumPathTex0'
     skins(3)=Texture'DeusExCharacters.Skins.TriadLumPathTex1'
     skins(4)=Texture'DeusExCharacters.Skins.TriadLumPathTex1'
     skins(5)=Texture'DeusExItems.Skins.GrayMaskTex'
     skins(6)=Texture'DeusExItems.Skins.BlackMaskTex'
     skins(7)=Texture'DeusExItems.Skins.PinkMaskTex'
     CollisionRadius=16.000000
     CollisionHeight=42.000000
   //  CollisionHeight=46.500000
     Buoyancy=97.000000
}

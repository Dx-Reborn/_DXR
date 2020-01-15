//=============================================================================
// SamCarter.
//=============================================================================
class SamCarter extends HumanMilitary;

defaultproperties
{
     BindName="SamCarter"
     FamiliarName="Sam Carter"
     UnfamiliarName="Sam Carter"
     CarcassType=Class'DeusEx.SamCarterCarcass'
     WalkingSpeed=0.296000
     bImportant=True
     bInvincible=True
     InitialInventory(0)=(Inventory=Class'DeusEx.WeaponAssaultShotgunInv')
     InitialInventory(1)=(Inventory=Class'DeusEx.Ammo762mmInv',Count=12)
     InitialInventory(2)=(Inventory=Class'DeusEx.WeaponCombatKnifeInv')
     walkAnimMult=0.780000
     GroundSpeed=200.000000
     Mesh=mesh'DeusExCharacters.GM_Jumpsuit'
     skins(0)=Texture'DeusExCharacters.Skins.SamCarterTex0'
     skins(1)=Texture'DeusExCharacters.Skins.SamCarterTex2'
     skins(2)=Texture'DeusExCharacters.Skins.SamCarterTex1'
     skins(3)=Texture'DeusExCharacters.Skins.SamCarterTex0'
     skins(4)=Texture'DeusExItems.Skins.PinkMaskTex'
     skins(5)=Texture'DeusExItems.Skins.GrayMaskTex'
     skins(6)=Texture'DeusExItems.Skins.PinkMaskTex'
     skins(7)=Texture'DeusExItems.Skins.PinkMaskTex'
     CollisionRadius=20.000000
     CollisionHeight=43.000000
//     CollisionHeight=47.500000
}

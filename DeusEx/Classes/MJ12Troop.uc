//=============================================================================
// MJ12Troop.
//=============================================================================
class MJ12Troop extends HumanMilitary;

defaultproperties
{
     BindName="MJ12Troop"
     FamiliarName="MJ12 Troop"
     UnfamiliarName="MJ12 Troop"
     CarcassType=Class'DeusEx.MJ12TroopCarcass'
     WalkingSpeed=0.296000
     InitialInventory(0)=(Inventory=Class'DeusEx.WeaponAssaultGun')
     InitialInventory(1)=(Inventory=Class'DeusEx.Ammo762mm',Count=12)
     InitialInventory(2)=(Inventory=Class'DeusEx.WeaponCombatKnife')
     walkAnimMult=0.780000
     GroundSpeed=200.000000
     Mesh=mesh'DeusExCharacters.GM_Jumpsuit'
     skins(0)=Texture'DeusExCharacters.Skins.SkinTex1'
     skins(1)=Texture'DeusExCharacters.Skins.MJ12TroopTex1'
     skins(2)=Texture'DeusExCharacters.Skins.MJ12TroopTex2'
     skins(3)=Texture'DeusExCharacters.Skins.SkinTex1'
     skins(4)=Texture'DeusExItems.Skins.PinkMaskTex'
     skins(5)=Texture'DeusExCharacters.Skins.MJ12TroopTex3'
     skins(6)=Texture'DeusExCharacters.Skins.MJ12TroopTex4'
     skins(7)=Texture'DeusExItems.Skins.PinkMaskTex'
     CollisionRadius=20.000000
     CollisionHeight=47.500000
}

//=============================================================================
// UNATCOTroop.
//=============================================================================
class UNATCOTroop extends HumanMilitary;

defaultproperties
{
     BindName="UNATCOTroop"
     FamiliarName="UNATCO Troop"
     UnfamiliarName="UNATCO Troop"
     CarcassType=Class'DeusEx.UNATCOTroopCarcass'
     WalkingSpeed=0.296000
     InitialInventory(0)=(Inventory=Class'DeusEx.WeaponAssaultGun')
     InitialInventory(1)=(Inventory=Class'DeusEx.Ammo762mm',Count=12)
     InitialInventory(2)=(Inventory=Class'DeusEx.WeaponCombatKnife')
     walkAnimMult=0.780000
     GroundSpeed=200.000000
     Mesh=mesh'DeusExCharacters.GM_Jumpsuit'
     skins(0)=Texture'DeusExCharacters.Skins.MiscTex1'
     skins(1)=Texture'DeusExCharacters.Skins.UNATCOTroopTex1'
     skins(2)=Texture'DeusExCharacters.Skins.UNATCOTroopTex2'
     skins(3)=Texture'DeusExCharacters.Skins.MiscTex1'
     skins(4)=Texture'DeusExCharacters.Skins.MiscTex1'
     skins(5)=Texture'DeusExItems.Skins.GrayMaskTex'
     skins(6)=Texture'DeusExCharacters.Skins.UNATCOTroopTex3'
     skins(7)=Texture'DeusExItems.Skins.PinkMaskTex'
     CollisionRadius=20.000000
     CollisionHeight=43.000000
     //CollisionHeight=47.500000
}
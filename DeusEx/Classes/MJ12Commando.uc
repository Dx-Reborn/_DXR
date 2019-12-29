//=============================================================================
// MJ12Commando.
//=============================================================================
class MJ12Commando extends HumanMilitary;

defaultproperties
{
     HealthHead=250
     HealthTorso=250
     HealthLegLeft=250
     HealthLegRight=250
     HealthArmLeft=250
     HealthArmRight=250
     BindName="MJ12Commando"
     FamiliarName="MJ12 Commando"
     UnfamiliarName="MJ12 Commando"
     MinHealth=0.000000
     CarcassType=Class'DeusEx.MJ12CommandoCarcass'
     WalkingSpeed=0.296000
     bCanCrouch=False
     CloseCombatMult=0.500000
     InitialInventory(0)=(Inventory=Class'DeusEx.WeaponMJ12Commando')
     InitialInventory(1)=(Inventory=Class'DeusEx.Ammo762mmInv',Count=24)
     InitialInventory(2)=(Inventory=Class'DeusEx.WeaponMJ12Rocket')
     InitialInventory(3)=(Inventory=Class'DeusEx.AmmoRocketMiniInv',Count=10)
     BurnPeriod=0.000000
     GroundSpeed=200.000000
     Mesh=mesh'DeusExCharacters.GM_ScaryTroop'
     skins(0)=Texture'DeusExCharacters.Skins.MJ12CommandoTex1'
     skins(1)=Texture'DeusExCharacters.Skins.MJ12CommandoTex1'
     skins(2)=Texture'DeusExCharacters.Skins.MJ12CommandoTex0'
     skins(3)=Texture'DeusExCharacters.Skins.MJ12CommandoTex1'

     CollisionRadius=22.0//28.000000
     CollisionHeight=44.0//45.38
//     CollisionHeight=49.880001
}

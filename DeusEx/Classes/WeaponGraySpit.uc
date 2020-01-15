//=============================================================================
// WeaponGraySpit.
//=============================================================================
class WeaponGraySpit extends WeaponNPCRanged;

defaultproperties
{
     HitDamage=8
     maxRange=450
     AccurateRange=300
     AreaOfEffect=AOE_Cone
     bHandToHand=True
     AmmoName=Class'DeusEx.AmmoGraySpitInv'
     PickupAmmoCount=4
     ProjectileClass=Class'DeusEx.GraySpit'
}

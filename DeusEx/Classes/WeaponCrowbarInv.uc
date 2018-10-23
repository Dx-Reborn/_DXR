//=============================================================================
// WeaponCrowbar.
//=============================================================================
class WeaponCrowbarInv extends coldarmsInv;


defaultproperties
{
     DrawScale=1.0
 	   PickupClass=class'WeaponCrowbar'
 	   AttachmentClass=class'WeaponCrowbarAtt'
     PickupViewMesh=VertMesh'DXRPickups.CrowbarPickup'
		 FirstPersonViewMesh=Mesh'DeusExItems.Crowbar'
     Mesh=VertMesh'DXRPickups.CrowbarPickup'

     largeIcon=Texture'DeusExUI.Icons.LargeIconCrowbar'
     largeIconWidth=101
     largeIconHeight=43
     invSlotsX=2
     Description="A crowbar. Hit someone or something with it. Repeat.|n|n<UNATCO OPS FILE NOTE GH010-BLUE> Many crowbars we call 'murder of crowbars.'  Always have one for kombat. Ha. -- Gunther Hermann <END NOTE>"
     beltDescription="CROWBAR"
     LowAmmoWaterMark=0
     GoverningSkill=Class'DeusEx.SkillWeaponLowTech'
     NoiseLevel=0.050000
     ReloadTime=0.000000
     HitDamage=6
     MaxRange=80
     AccurateRange=80
     BaseAccuracy=1.000000
     bPenetrating=False
     bHasMuzzleFlash=False
     bHandToHand=True
     bFallbackWeapon=True
     bEmitWeaponDrawn=False
     AmmoName=Class'DeusEx.AmmoNoneInv'
//     skins(0)=texture'DeusExItems.WeaponHandsTex'
     ReloadCount=0
     PickupAmmoCount=0
     bInstantHit=True
     FireOffset=(X=-40.000000,Y=15.000000,Z=8.000000)

     FireSound=Sound'DeusExSounds.Weapons.CrowbarFire'
     SelectSound=Sound'DeusExSounds.Weapons.CrowbarSelect'
     Misc1Sound=Sound'DeusExSounds.Weapons.CrowbarHitFlesh'
     Misc2Sound=Sound'DeusExSounds.Weapons.CrowbarHitHard'
     Misc3Sound=Sound'DeusExSounds.Weapons.CrowbarHitSoft'
     LandSound=Sound'DeusExSounds.Generic.DropMediumWeapon'

     InventoryGroup=10
     ItemName="Crowbar"
		 PlayerViewPivot=(Pitch=0,Roll=0,Yaw=-32768) // Развернуть модель
     PlayerViewOffset=(X=40.000000,Y=15.000000,Z=-8.000000)

     Icon=Texture'DeusExUI.Icons.BeltIconCrowbar'
     CollisionRadius=19.000000
     CollisionHeight=1.050000
     Mass=15.000000
}

/*
   From Smoke39 mod.
*/

class WeaponSawedOffShotGun_Ext extends DeusExWeapon;

var() sound LoadShellSound;

// Smoke39 - this prevents us from switching ammo at the last second and ending up with an empty magazine
function CycleAmmo()
{
    if (!IsAnimating() || GetAnimSequence() != 'ReloadEnd')
        Super.CycleAmmo();
}

// Smoke39 - load each shell individually
state Reload
{
    // Smoke39 - let the player interrupt reload
    function Fire(float Value)
    {
        if (ScriptedPawn(Owner) == None && ClipCount < ReloadCount)
        {
            if (GetAnimSequence() == 'ReloadBegin') // GetAnimSequence() from channel 0 replaces AnimSequence
                GotoState('Reload','WaitInterrupt');
            else if (GetAnimSequence() == 'Reload')
                GotoState('Reload','Interrupt');
        }
    }

Begin:
    // only reload if relevant
    if (ClipCount > 0 && AmmoType.AmmoAmount > ReloadCount-ClipCount)
    {
        TweenAnim('Still', 0.1);
        FinishAnim();

        bWasZoomed = bZoomed;
        if (bWasZoomed)
            ScopeOff();

        // turn off the laser; the gun won't be pointed forward, so it shouldn't appear
        //  where you're aiming anymore, right?
        if (bLasing)
            LaserOff();

        PlayAnim('ReloadBegin');
        NotifyOwner(True);
        FinishAnim();
        LoopAnim('Reload');

        // load each shell individually until full or out of shells to load
        while (ClipCount > 0 && AmmoType.AmmoAmount > ReloadCount-ClipCount)
        {
            Owner.PlaySound(LoadShellSound, SLOT_None,,, 1024, 1 - FRand()/10);
            ClipCount--;
            Sleep(GetReloadTime() / default.ReloadCount + 0.4);
        }

        PlayAnim('ReloadEnd');
        FinishAnim();

        // turn laser back on once w're pointing the gun forward again
        if (bHasLaser)
            LaserOn();

        NotifyOwner(False);

        if (bWasZoomed)
            ScopeOn();
    }

    GotoState('Idle');

WaitInterrupt:
    FinishAnim();
Interrupt:
    PlayAnim('ReloadEnd');
    FinishAnim();

    // turn laser back on once w're pointing the gun forward again
    if (bHasLaser)
        LaserOn();

    NotifyOwner(False);

    if (bWasZoomed)
        ScopeOn();

    GotoState('Idle');
}

function SawedOffSelect();

function SawedOffCockSound()
{
   PlaySound(SelectSound, SLOT_Misc, Pawn(Owner).SoundDampening);
}

// Smoke39 - play the cocking sound with a higher pitch with skill
/*function PlaySelect()
{
    PlayAnim('Select', SelectRate(), 0.0);
    Owner.PlaySound(SelectSound, SLOT_Misc, Pawn(Owner).SoundDampening,,, 1-RawWeaponSkill()/4);
}*/

defaultproperties
{
    AttachmentClass=class'WeaponSawedOffShotgunAtt'
    PickupViewMesh=Mesh'DeusExItems.ShotgunPickup'
    FirstPersonViewMesh=Mesh'DeusExItems.Shotgun'
    Mesh=Mesh'DeusExItems.ShotgunPickup'

    LowAmmoWaterMark=5
    GoverningSkill=Class'SkillWeaponRifle'
    EnviroEffective=ENVEFF_Air
    Concealability=CONC_Visual
    ShotTime=0.30
    reloadTime=3.00
    HitDamage=8
    maxRange=2400
    AccurateRange=1200
    BaseAccuracy=0.60

    bCanHaveLaser=True
    AmmoNames(0)=Class'AmmoShell'
    AmmoNames(1)=Class'AmmoSabot'
    AreaOfEffect=AOE_Cone
    recoilStrength=0.50
    bCanHaveModReloadCount=True
    bCanHaveModReloadTime=True
    bCanHaveModRecoilStrength=True
    AmmoName=Class'AmmoShell'
    ReloadCount=5
    PickupAmmoCount=5
    bInstantHit=True
    FireOffset=(X=-11.00,Y=4.00,Z=13.00)
//  shakemag=50.00

    FireSound=Sound'STALKER_Sounds.Weapons.shotgun_Fire'
    ReloadEndSound=Sound'DeusExSounds.Weapons.SawedOffShotgunReloadEnd'
    LoadShellSound=Sound'STALKER_Sounds.Weapons.shotgun_AddShell'
    CockingSound=Sound'DeusExSounds.Generic.KeyboardClick2'
    SelectSound=Sound'STALKER_Sounds.Weapons.shotgun_Reload'

    InventoryGroup=6
    ItemName="Sawed-off Shotgun"
    PlayerViewOffset=(X=5.500000,Y=4.000000,Z=-13.000000)

    LandSound=Sound'DeusExSounds.Generic.DropMediumWeapon'
    Icon=Texture'DeusExUI.Icons.BeltIconShotgun'
    largeIcon=Texture'DeusExUI.Icons.LargeIconShotgun'
    largeIconWidth=131
    largeIconHeight=45
    invSlotsX=3
    Description="The sawed-off, pump-action shotgun features a truncated barrel resulting in a wide spread at close range and will accept either buckshot or sabot shells."
    beltDescription="SAWED-OFF"
    CollisionRadius=12.00
    CollisionHeight=3.00
//    CollisionHeight=0.90
    Mass=15.00
}

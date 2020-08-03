//=============================================================================
// MilitaryBot.
//=============================================================================
class MilitaryBot extends Robot;

enum ESkinColor
{
    SC_UNATCO,
    SC_Chinese
};

var() ESkinColor SkinColor;

event BeginPlay()
{
    Super.BeginPlay();

    switch (SkinColor)
    {
        case SC_UNATCO:     Skins[0] = Texture'MilitaryBotTex1'; break;
        case SC_Chinese:    Skins[0] = Texture'MilitaryBotTex2'; break;
    }
}

function PlayDisabled()
{
    local int rnd;

    rnd = Rand(3);
    if (rnd == 0)
        TweenAnimPivot('Disabled1', 0.2);
    else if (rnd == 1)
        TweenAnimPivot('Disabled2', 0.2);
    else
        TweenAnimPivot('Still', 0.2);
}


defaultproperties
{
     SearchingSound=Sound'DeusExSounds.Robot.MilitaryBotSearching'
     SpeechTargetAcquired=Sound'DeusExSounds.Robot.MilitaryBotTargetAcquired'
     SpeechTargetLost=Sound'DeusExSounds.Robot.MilitaryBotTargetLost'
     SpeechOutOfAmmo=Sound'DeusExSounds.Robot.MilitaryBotOutOfAmmo'
     SpeechCriticalDamage=Sound'DeusExSounds.Robot.MilitaryBotCriticalDamage'
     SpeechScanning=Sound'DeusExSounds.Robot.MilitaryBotScanning'
     EMPHitPoints=200
     explosionSound=Sound'DeusExSounds.Robot.MilitaryBotExplode'
     BindName="MilitaryBot"
     FamiliarName="Military Bot"
     UnfamiliarName="Military Bot"
     WalkingSpeed=1.000000
     bEmitDistress=True
     InitialInventory(0)=(Inventory=Class'DeusEx.WeaponRobotMachinegun')
     InitialInventory(1)=(Inventory=Class'DeusEx.Ammo762mm',Count=24)
     InitialInventory(2)=(Inventory=Class'DeusEx.WeaponRobotRocket')
     InitialInventory(3)=(Inventory=Class'DeusEx.AmmoRocketRobot',Count=10)
     WalkSound=Sound'DeusExSounds.Robot.MilitaryBotWalk'
     GroundSpeed=44.000000
     WaterSpeed=50.000000
     AirSpeed=144.000000
     AccelRate=500.000000
     Health=600
     UnderWaterTime=20.000000
     Mesh=mesh'DeusExCharacters.MilitaryBot'
//     CollisionRadius=80.000000
     CollisionRadius=72.0
     CollisionHeight=74.5

     CrouchRadius=72.0
     CrouchHeight=74.5

//     CollisionHeight=79.000000
     Mass=2000.000000
     Buoyancy=100.000000
     RotationRate=(Yaw=10000)
}

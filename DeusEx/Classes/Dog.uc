//=============================================================================
// Dog.
//=============================================================================
class Dog extends Animal
    abstract;

var float time;

function PlayDogBark()
{
    // overridden in subclasses
}

event Tick(float deltaTime)
{
    Super.Tick(deltaTime);

    time += deltaTime;

    // check for random noises
    if (time > 1.0)
    {
        time = 0;
        if (FRand() < 0.05)
            PlayDogBark();
    }
}

function PlayTakingHit(EHitLocation hitPos)
{
    // nil
}

function PlayAttack()
{
    PlayAnimPivot('Attack');
}

function TweenToAttack(float tweentime)
{
    TweenAnimPivot('Attack', tweentime);
}

function PlayBarking()
{
    PlayAnimPivot('Bark');
}

// DXR: From Revision mod.
// fake a charge attack using bump
function Bump(actor Other)
{
    local DeusExWeapon dxWeapon;
//    local DeusExPlayer dxPlayer;
    local float        damage;

    Super.Bump(Other);

    if (Controller.IsInState('Attacking') && (Other != None) && (Other == Controller.Enemy))
    {
        // damage both of the player's legs if the karkian "charges"
        // just use Shot damage since we don't have a special damage type for charged
        // impart a lot of momentum, also
        if (VSize(Velocity) > 100)
        {
            dxWeapon = DeusExWeapon(Weapon);
            if ((dxWeapon != None) && dxWeapon.IsA('WeaponDogJump') && (FireTimer <= 0))
            {
                FireTimer = DeusExWeapon(Weapon).AIFireDelay + 1;
                damage = VSize(Velocity) / 100;
                Other.TakeDamage(damage, Self, Other.Location+vect(1,1,-1), 100*Velocity, class'DM_Shot');
                Other.TakeDamage(damage, Self, Other.Location+vect(-1,-1,-1), 100*Velocity, class'DM_Shot');
                /*dxPlayer = DeusExPlayer(Other);
                if (dxPlayer != None)
                    dxPlayer.ShakeView(0.05 + 0.002*damage*2, damage*30*2, 0.3*damage*2);*/
            }
        }
    }
}

function bool PlayBeginAttack()
{
    return PlayBarkingAnim();
}

function bool PlayBarkingAnim()
{
    local human Playerpawn;
    
    Playerpawn = Human(Level.GetLocalPlayerController().pawn);
    
    PlayAnimPivot('Bark');
    PlayDogBark();
    Instigator = Controller.Enemy;
    AISendEvent('LoudNoise', EAITYPE_Audio, 2, Playerpawn.CombatDifficulty*128);
    AISendEvent('Distress', EAITYPE_Audio, 2, Playerpawn.CombatDifficulty*128);
    return true;
}

// DXR: End of part from Revision.




defaultproperties
{
    bPlayDying=True
    Alliance=Dog
    MinHealth=2.000000
    InitialAlliances(7)=(AllianceName=Cat,AllianceLevel=-1.000000)

    InitialInventory(0)=(Inventory=Class'WeaponDogBite',Count=1)
    InitialInventory(1)=(Inventory=Class'WeaponDogJump',Count=1) // DXR: New
    InitialInventory(2)=(Inventory=Class'AmmoDogJump',Count=159) // same

    BaseEyeHeight=12.500000
    Buoyancy=97.000000
}

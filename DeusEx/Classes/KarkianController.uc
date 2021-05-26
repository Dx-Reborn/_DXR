/*

*/
class KarkianController extends AnimalController;

// fake a charge attack using bump
event bool NotifyBump(actor Other)
{
    local DeusExWeapon dxWeapon;
    local DeusExPlayer    dxPlayer;
    local float           damage;

    Super.NotifyBump(Other);

    if (IsInState('Attacking') && (Other != None) && (Other == Enemy))
    {
        // damage both of the player's legs if the karkian "charges"
        // just use Shot damage since we don't have a special damage type for charged
        // impart a lot of momentum, also
        if (VSize(pawn.Velocity) > 100)
        {
            dxWeapon = DeusExWeapon(pawn.Weapon);
            if ((dxWeapon != None) && dxWeapon.IsA('WeaponKarkianBump') && (Karkian(pawn).FireTimer <= 0))
            {
                Karkian(pawn).FireTimer = DeusExWeapon(pawn.Weapon).AIFireDelay;
                damage = VSize(pawn.Velocity) / 5;
                Other.TakeDamage(damage, pawn, Other.Location+vect(1,1,-1), 100 * pawn.Velocity, class'DM_Shot');
                Other.TakeDamage(damage, pawn, Other.Location+vect(-1,-1,-1), 100 * pawn.Velocity, class'DM_Shot');
                dxPlayer = DeusExPlayer(Other);
                if (dxPlayer != None)
                    dxPlayer.Controller.ShakeView(vect(0,0,0),vect(0,0,0),2 * damage,vect(-20,-20,-20), vect(-1000, -1000, 1000), 2 * damage);

                    log(pawn@"Shake player ?");
                    //(0.15 + 0.002*damage*2, damage*30*2, 0.3*damage*2);

/*    ShakeOffsetMag=(X=-20.0,Y=0.00,Z=0.00) // 4
    ShakeOffsetRate=(X=-1000.0,Y=0.0,Z=0.0) // 5
    ShakeOffsetTime=2
    ShakeRotMag=(X=0.0,Y=0.0,Z=0.0) // 1
    ShakeRotRate=(X=0.0,Y=0.0,Z=0.0) // 2
    ShakeRotTime=2*/ // 3
            }
        }
    }
return true;
}


function ReactToInjury(Pawn instigatedBy, class<DamageType> damageType, ScriptedPawn.EHitLocation hitPos)
{
    Super.ReactToInjury(instigatedBy, damageType, hitPos);
    Karkian(pawn).aggressiveTimer = 10;
}

function GotoDisabledState(class<DamageType> damageType, ScriptedPawn.EHitLocation hitPos)
{
    if (!pawn.bCollideActors && !pawn.bBlockActors && !pawn.bBlockPlayers)
        return;
    else if ((damageType == class'DM_TearGas') || (damageType == class'DM_HalonGas'))
        GotoNextState();
    else if (damageType == class'DM_Stunned')
        GotoNextState();
    else if (Karkian(pawn).CanShowPain())
        Karkian(pawn).TakeHit(hitPos);
    else
        GotoNextState();
}

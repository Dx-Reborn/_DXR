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
//              if (dxPlayer != None)
//                  dxPlayer.ShakeView(0.15 + 0.002*damage*2, damage*30*2, 0.3*damage*2);
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

//=============================================================================
// GreaselSpit.
//=============================================================================
class GreaselSpit extends DeusExProjectile;

#exec OBJ LOAD FILE=Effects

event Tick(float DeltaTime)
{
    local SmokeTrail s;

    Super.Tick(DeltaTime);

    time += DeltaTime;
    if ((time > FRand() * 0.02) && (Level.NetMode != NM_DedicatedServer))
    {
        time = 0;

        // spawn some trails
        s = Spawn(class'SmokeTrail',,, Location);
        if (s != None)
        {
            s.SetDrawScale(FRand() * 0.05);
            s.OrigScale = s.DrawScale;
            s.Texture = Texture'Effects.Smoke.Gas_Poison_A';
            s.Velocity = VRand() * 50;
            s.OrigVel = s.Velocity;
        }
    }
}


defaultproperties
{
     DamageType=class'DM_Poison'
     AccurateRange=300
     MaxRange=450
     bIgnoresNanoDefense=True
     speed=600.000000
     MaxSpeed=800.000000
     Damage=8.000000
     MomentumTransfer=400
     SpawnSound=Sound'DeusExSounds.Animal.GreaselShoot'
     Style=STY_Translucent
     Mesh=Mesh'DeusExItems.GreaselSpit'
}

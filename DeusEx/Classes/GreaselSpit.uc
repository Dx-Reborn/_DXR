//=============================================================================
// GreaselSpit.
//=============================================================================
class GreaselSpit extends DeusExProjectile;

#exec OBJ LOAD FILE=Effects

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

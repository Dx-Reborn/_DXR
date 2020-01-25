//=============================================================================
// GeneratorScout.
//=============================================================================
class GeneratorScout extends DeusExPawn;

auto state StartUpScout
{
    // nil
}

defaultproperties
{
     bHidden=true
     CollisionRadius=52.000000
     CollisionHeight=50.000000
     bCollideActors=False
//     bCollideWorld=False
     bCollideWorld=true // So engine will kill it, if spawned outside of the world.
     bBlockActors=False
     bBlockPlayers=False
     bProjTarget=False
     Mass=0.000000
}

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
//     bIgnoreOutOfWorld=true

//     bHidden=True
DrawType=DT_Sprite
Texture=texture'Engine.S_FlyingPath'
     bHidden=False
     bDetectable=False
     CollisionRadius=52.000000
     CollisionHeight=50.000000
     bCollideActors=False
     bCollideWorld=False
     bBlockActors=False
     bBlockPlayers=False
     bProjTarget=False
     Mass=0.000000
     Controllerclass=None
}

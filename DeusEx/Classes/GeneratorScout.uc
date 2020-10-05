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

     CollisionRadius=20.0
     CollisionHeight=20.0

//     CollisionRadius=52.000000
//     CollisionHeight=50.000000

     CrouchRadius=52.0
     CrouchHeight=50.0
     bCanCrouch=false

     bCollideActors=False
     bCollideWorld=False
     bBlockActors=False
     bBlockPlayers=False
     bProjTarget=False
     Mass=0.0
     Controllerclass=None
}

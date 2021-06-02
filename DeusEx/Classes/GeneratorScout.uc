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
    DrawType=DT_Sprite
    Texture=texture'Engine.S_FlyingPath'
    DrawScale=0.50

//    bHidden=True
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
    bCanFly=true
    bCanSwim=true
    bCanCrouch=false
    AccelRate=0.0
    buoyancy=40

    controllerclass=class'AIController'
}

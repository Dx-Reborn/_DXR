/*
   Для проверки моделей с анимацией.

*/

class LolaAnimTestActor extends DeusExDecoration; //ScaledSprite;

var mesh m;
var float BarrelRotation;

event BeginPlay()
{
    FindMesh();

    if (m != None)
    {
        LinkMesh(m);
        SetDrawType(DT_Mesh);
    }

//    if (mesh != None)
//        LoopAnim('Death');
}

function FindMesh()
{
    m = Mesh(DynamicLoadObject("Package.Model", class'Mesh', True));
}

event Tick(float dt)
{
    local Rotator R;

    if (mesh != None)
    {
       BarrelRotation += dt * 65535.0 * 8.0 / 8;

       R.Roll = BarrelRotation;
       SetBoneRotation('Bone002', R, 0);
    }
}

defaultproperties
{
    DrawType=DT_Sprite
/*    bStatic=false
    bLightingVisibility=false
    bCollideActors=true
    bBlockActors=true
    bAcceptsProjectors=true*/
}


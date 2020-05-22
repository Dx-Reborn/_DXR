class LolaAnimTestActor extends ScaledSprite;

var mesh m;

event BeginPlay()
{
    FindMesh();

    if (m != None)
    {
        LinkMesh(m);
        SetDrawType(DT_Mesh);
    }

    if (mesh != None)
        LoopAnim('Death');
}

function FindMesh()
{
    m = Mesh(DynamicLoadObject("P_TestChar.TestChar", class'Mesh', True));      
}

defaultproperties
{
    bStatic=false
}
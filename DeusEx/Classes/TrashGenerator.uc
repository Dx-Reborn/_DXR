//=============================================================================
// TrashGenerator.
//=============================================================================
class TrashGenerator extends Effects;

// spawns some random trash every so often

enum ETrashType
{
    TT_Paper,
    TT_Tumbleweed
};

var() float Frequency;      // use very small numbers (~0.001)
var() float WindSpeed;      // wind speed in ft/sec
var() ETrashType TrashType;
var float mytimer;

event Tick(float deltaTime)
{
    local Trash trash;

    if (mytimer > 0.1)
    {
        mytimer = 0;

        if (FRand() < Frequency)
        {
            if (TrashType == TT_Paper)
                trash = Spawn(class'TrashPaper');
            else if (TrashType == TT_Tumbleweed)
                trash = Spawn(class'Tumbleweed');

            if (trash != None)
            {
                trash.SetPhysics(PHYS_Walking);
                trash.rot = RotRand(True);
                trash.rot.Yaw = 0;
                trash.dir = Vector(Rotation) * WindSpeed;
                trash.dir.x += 5 * FRand();
                trash.dir.y += 5 * FRand();
                trash.dir.z = -2 * FRand();
            }
        }
    }

    mytimer += deltaTime;

    Super.Tick(deltaTime);
}


defaultproperties
{
     Frequency=0.001000
     WindSpeed=100.000000
     bHidden=True
     bDirectional=True
     Texture=Texture'Engine.S_Inventory'
}

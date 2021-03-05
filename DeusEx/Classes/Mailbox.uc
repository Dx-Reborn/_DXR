//=============================================================================
// Mailbox.
//=============================================================================
class Mailbox extends BoxesWithStuff;

var() bool bSpawnLetters;

event Destroyed()
{
    local int i, rnd;
    local EM_FlyingLetters Letters;

    Super.Destroyed();

    if (bSpawnLetters)
    {
       rnd = 1 + rand(2);

       for (i=0;i<rnd;i++)
       {
           Letters = spawn(class'EM_FlyingLetters', , , Location + VRand(),);
       }
    }
}

defaultproperties
{
     ItemName="Mailbox"
     bPushable=False
     Physics=PHYS_None
//     mesh=mesh'DeusExDeco.Mailbox'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DeusExStaticMeshes0.MailBox_HD'
     CollisionHeight=36.500000
     Mass=400.000000
     Buoyancy=200.000000
     bSpawnLetters=true
}

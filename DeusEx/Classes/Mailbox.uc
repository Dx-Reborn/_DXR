//=============================================================================
// Mailbox.
//=============================================================================
class Mailbox extends BoxesWithStuff;

var() bool bSpawnLetters;

event Destroyed()
{
    local MailLetter L;
    local int i;
    local int rnd;

    Super.Destroyed();

    if (bSpawnLetters)
    {
       rnd = 5 + rand(10);

       for (i=0;i<rnd;i++)
       {
           L = spawn(class'MailLetter', , , Location,);
           if (L != None)
           {
              L.Velocity = vRand() * 15;
              L.velocity.Z = -200 * fRand();
              L.Lifespan = 10.0 + Rand(30);
              L.SetPhysics(PHYS_Flying);
           }
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

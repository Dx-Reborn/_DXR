//=============================================================================
// Flare.
//=============================================================================
class Flare extends DeusExPickup;

state Activated
{
/*    function PhysicsVolumeChange(PhysicsVolume NewZone)
    {
      if (NewZone.bWaterVolume)
          ExtinguishFlare();

        Super.PhysicsVolumeChange(NewZone);
    }*/

    function Activate()
    {
        // can't turn it off
    }

    function BeginState()
    {
        local flareActual flare;

        Super.BeginState();

        // Create a Flare and throw it
        flare = Spawn(class'FlareActual',owner);
        LightFlare(flare);
        UseOnce();
    }
Begin:
}

function LightFlare(FlareActual pk)
{
    local Vector X, Y, Z, dropVect;
    local Pawn P;

    if (pk.gen == None)
    {   
        pk.LifeSpan = 30;
//        pk.bUnlit = true;
        pk.LightType = LT_Steady;
        pk.AmbientSound = Sound'Flare';

        P = Pawn(Owner);
        if (P != None)
        {
            GetAxes(P.GetViewRotation(), X, Y, Z);
            dropVect = P.Location + 0.8 * P.CollisionRadius * X;
            dropVect.Z += P.BaseEyeHeight;
            pk.Velocity = Vector(P.GetViewRotation()) * 500 + vect(0,0,220);
            pk.bFixedRotationDir = True;
            pk.RotationRate = RotRand(False);

            // increase our collision height so we light up the ground better
            pk.SetCollisionSize(CollisionRadius, CollisionHeight*2);
        }

        pk.gen = Spawn(class'EM_FlareSmoke', pk,, pk.Location, rot(16384,0,0));
        if (pk.gen != None)
        {
            //pk.gen.attachTag = pk.Name;
            pk.gen.SetBase(pk);
        }
    }
}


defaultproperties
{
     maxCopies=50
     Description="A flare."
     ItemName="Flare"

     Mesh=Mesh'DeusExItems.Flare'
     PickupViewMesh=Mesh'DeusExItems.Flare'
     FirstPersonViewMesh=Mesh'DeusExItems.Flare'

     PlayerViewOffset=(X=30.00,Y=0.00,Z=-12.00)
     beltDescription="FLARE"
     Icon=Texture'DeusExUI.Icons.BeltIconFlare'
     largeIcon=Texture'DeusExUI.Icons.LargeIconFlare'
     largeIconWidth=42
     largeIconHeight=43
     CollisionRadius=6.200000
     CollisionHeight=1.200000
     Mass=2.000000
     Buoyancy=1.000000
}

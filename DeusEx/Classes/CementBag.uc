class CementBag extends DeusExDecoration;

var EM_YellowDust postDestroyedDust;

event Destroyed()
{
   local vector Loc;

   loc = Location;
   loc.Z += 15;

   postDestroyedDust = Spawn(class'EM_YellowDust', Self,, Loc, rotation);
   if (postDestroyedDust != None)
   {
       postDestroyedDust.Velocity.X += RandRange(50, -50);
       postDestroyedDust.Velocity.Y += RandRange(50, -50);
       postDestroyedDust.Velocity.Z += RandRange(10, 200);

       postDestroyedDust.Emitters[0].AutomaticInitialSpawning = false;
       postDestroyedDust.Emitters[0].InitialParticlesPerSecond = 5;
       postDestroyedDust.SetTimer(0.4 + fRand(), false);
//       postDestroyedDust.Emitters[0].RespawnDeadParticles = false;
   }

   Super.Destroyed();
}

defaultproperties
{
    ItemName="Cement Bag"
    DrawType=DT_StaticMesh
    StaticMesh=StaticMesh'DeusExStaticMeshes3.CementBag_a'
    PrePivot=(Z=7.000000)
    CollisionRadius=30.000000
    CollisionHeight=7.000000
    Mass=40
    HitPoints=70
    fragType=class'DeusEx.PaperFragment'
}



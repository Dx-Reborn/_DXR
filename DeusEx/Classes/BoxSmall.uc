//=============================================================================
// BoxSmall.
//=============================================================================
class BoxSmall extends Containers;

singular function SupportActor(Actor standingActor)  //CyberP: hack lazy patch
{
   if (HitPoints < 20)
      TakeDamage(20, None, Location, vect(0,0,0), class'DM_Stomped');
   else
      super.SupportActor(standingActor);
}


defaultproperties
{
     bBlockSight=True
     HitPoints=12 //5
     FragType=Class'DeusEx.PaperFragment'
     ItemName="Cardboard Box"
     mesh=mesh'DeusExDeco.BoxSmall'
     CollisionRadius=13.000000
     CollisionHeight=5.180000
     Mass=20.000000
     Buoyancy=30.000000
}

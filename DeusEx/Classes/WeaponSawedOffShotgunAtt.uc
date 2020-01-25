class WeaponSawedOffShotgunAtt extends DXRWeaponAttachment;

event Tick(float dt)
{
   local DeusExPawn own;

   own = DeusExPawn(owner);

   if (own != none)
   {
      if (own.GetAnimSequence() == 'Shoot')
          SetRelativeRotation(ShootRotation);

      else
          SetRelativeRotation(default.relativerotation);
   }
}

defaultproperties
{
     ShootRotation=(roll=20000,pitch=0,yaw=-2200)

     Mesh=Mesh'DeusExItems.ShotgunPickup'
     relativerotation=(roll=20000,pitch=-10000,yaw=-2200)
     relativelocation=(x=0,y=-1,z=-5)
     bHardAttach=true
}

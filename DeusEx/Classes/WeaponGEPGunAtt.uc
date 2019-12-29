class WeaponGEPGunAtt extends DXRWeaponAttachment;

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
     bBlockActors=false
     bBlockPlayers=false
     Mesh=Mesh'DeusExItems.GEPGun3rd'
     relativerotation=(pitch=0,roll=-3333,yaw=32768)
     relativelocation=(x=5,y=0,z=-4)
     bHardAttach=false
}
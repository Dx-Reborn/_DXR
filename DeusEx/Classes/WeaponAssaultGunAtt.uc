class WeaponAssaultGunAtt extends DXRWeaponAttachment;

event Tick(float DT)
{
   local Name Anim;

   if (Instigator != None)
   {
       Anim = Instigator.GetAnimSequence();

       if (Anim == 'Shoot' || Anim == 'CrouchShoot' || Anim == 'RunShoot' || Anim == 'Strafe' ||
           Anim == 'Shoot2H' || Anim == 'RunShoot2H' || Anim == 'Strafe2H')
           SetRelativeRotation(ShootRotation);
       else
           SetRelativeRotation(default.relativerotation);
   }
}

function FixRelativeRotation(Pawn Inst)
{
//   log("I'm:"@self@"and Instigator is:"$Inst@" Instigator amimSeq:"@Inst.GetAnimSequence());


}

defaultproperties
{
     bBlockActors=false
     bBlockPlayers=false
     Mesh=Mesh'DeusExItems.AssaultGunPickup'
     relativerotation=(pitch=3333,roll=16384,yaw=-16000)
     relativelocation=(x=-1,y=-4,z=0)

     ShootRotation=(pitch=3333,roll=16384,yaw=0)

     bHardAttach=false
}
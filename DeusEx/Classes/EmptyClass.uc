// Заглушка для корректного держания переносимых предметов.
class EmptyClass extends Effects;

function PlayWoodHitSounds(float vol)
{
   if (FRand() > 0.75)
       PlaySound(sound'wood01gr', SLOT_Ambient,vol,, 1024, 1.1 - 0.2*FRand());
   else if (FRand() > 0.5)
       PlaySound(sound'wood02gr', SLOT_Ambient,vol,, 1024, 1.1 - 0.2*FRand());
   else if (FRand() > 0.25)
       PlaySound(sound'wood03gr', SLOT_Ambient,vol,, 1024, 1.1 - 0.2*FRand());
   else
       PlaySound(sound'wood04gr', SLOT_Ambient,vol,, 1024, 1.1 - 0.2*FRand());
}

defaultproperties
{
   DrawType=DT_None
   CollisionHeight=0.0
   CollisionRadius=0.0
   bFullVolume=false
}
//
// Вариант для NPC и режима BehindView
//

class WeaponCombatKnifeAtt extends WeaponAttachment;

defaultproperties
{
    Mesh=Mesh'DeusExItems.CombatKnifePickup'
//updaterelative(int pitch, int yaw, int roll)
                   // -10000 -2200 20000
    relativerotation=(roll=20000,pitch=-10000,yaw=-2200)
    relativelocation=(x=-1.9,y=0,z=0)
bHardAttach=true

//    RelativeLocation=(X=-20.0,Y=-5.0,Z=0.0)
//    RelativeRotation=(Pitch=32768)

}
//
// Скрытый воспламенитель 0_o
//

class invisibleFireball extends Fireball;

function SpawnEffects(vector HitLocation, vector HitNormal, Actor Other)
{
   Super.SpawnEffects(HitLocation, HitNormal, Other);
   if (Other.bWorldGeometry || Other == Level)
       spawn(class'EM_StickyFire',,,HitLocation);

}

defaultproperties
{
   drawtype=DT_none
   ExplosionDecal=class'DeusEx.FlameThrowerMark'
}
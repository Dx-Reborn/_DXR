/*
  For new iterator testing 
*/


class traceTextureWeapon extends weaponCombatKnife;

//      foreach class'ActorManager'.static.TraceTexture(self,class'Actor', target, texName, texGroup, texFlags, HitLocation, HitNormal, EndTrace, StartTrace)

function name GetWallMaterial(vector HitLocation, vector HitNormal)
{
    local vector EndTrace, StartTrace;
    local actor targ;
    local int texFlags;
    local name texName, texGroup;

    StartTrace = HitLocation + HitNormal*16;        // make sure we start far enough out
    EndTrace = HitLocation - HitNormal;

    foreach class'ActorManager'.static.TraceTexture(self,class'Actor', targ, texName, texGroup, texFlags, StartTrace, HitNormal, EndTrace)
    {
        log(targ@"has been detected !");

        if (targ == Level)
        {
          DeusExPlayer(owner).ClientMessage("Target="$targ $ " textureName="$texName$ " texGroup="$texGroup $" texFlags="$texFlags);
          log("Target="$targ $ " textureName="$texName$ " texGroup="$texGroup $" texFlags="$texFlags);
          break;
        }
    }
    return texGroup;
}


defaultproperties
{
    AmmoName=Class'DeusEx.AmmoNone'
}
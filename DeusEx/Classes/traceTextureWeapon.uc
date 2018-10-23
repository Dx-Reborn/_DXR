/*
  For new iterator testing 
*/


class traceTextureWeapon extends weaponCombatKnifeInv;


//		foreach class'ActorManager'.static.TraceTexture(self,class'Actor', target, texName, texGroup, texFlags, HitLocation, HitNormal, EndTrace, StartTrace)

function name GetWallMaterial(vector HitLocation, vector HitNormal)
{
	local vector EndTrace, StartTrace;
	local actor t;
	local int texFlags;
	local name texName, texGroup;

	StartTrace = HitLocation + HitNormal*16;		// make sure we start far enough out
	EndTrace = HitLocation - HitNormal;

	foreach class'ActorManager'.static.TraceTexture(self,class'Actor', t, texName, texGroup, texFlags, StartTrace, HitNormal, EndTrace)
		if ((t == Level) || t.IsA('Mover'))
		{
		  DeusExPlayer(owner).ClientMessage("Target="$t $ " textureName="$texName$ " texGroup="$texGroup $" texFlags="$texFlags);
		  log("Target="$t $ " textureName="$texName$ " texGroup="$texGroup $" texFlags="$texFlags);
			break;
		}

	return texGroup;
}


defaultproperties
{
    AmmoName=Class'DeusEx.AmmoNoneInv'
}
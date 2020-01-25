//=============================================================================
// BobPageAugmented.
//=============================================================================
class BobPageAugmented extends DeusExDecoration;

function PostBeginPlay()
{
	Super.PostBeginPlay();

	LoopAnim('Idle');
}

defaultproperties
{
     bBlockSight=True
     BaseEyeHeight=38.000000
     bInvincible=True
     bHighlight=False
     ItemName="Augmented Bob Page"
     bPushable=False
     Physics=PHYS_None
     mesh=mesh'DeusExDeco.BobPageAugmented'
     CollisionRadius=21.600000
     CollisionHeight=54.209999
     Mass=200.000000
     Buoyancy=100.000000
}

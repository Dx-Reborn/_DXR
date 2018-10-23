//=============================================================================
// HidePoint.
//=============================================================================
class HidePoint extends NavigationPoint
	placeable;

var vector faceDirection;

function PreBeginPlay()
{
	Super.PreBeginPlay();

	faceDirection = 200 * vector(Rotation);
}

defaultproperties
{
    bDirectional=True
    CollisionRadius=12.00
    CollisionHeight=15.00
}

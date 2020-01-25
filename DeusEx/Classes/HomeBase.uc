//=============================================================================
// HomeBase.
//=============================================================================
class HomeBase extends NavigationPoint
	placeable;

var() float extent; //how far the base extends from central point (in line of sight)
var	 vector lookdir; //direction to look while stopped

function PreBeginPlay()
{
	lookdir = 200 * vector(Rotation);
	Super.PreBeginPlay();
}

defaultproperties
{
    Extent=700.00
    Texture=HomeBase //Texture'S_Flag'
    SoundVolume=128
}
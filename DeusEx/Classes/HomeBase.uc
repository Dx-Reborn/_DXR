//=============================================================================
// HomeBase.
//=============================================================================
class HomeBase extends NavigationPoint
	placeable;

//#exec Texture Import File=Textures\S_Flag.pcx Name=S_Flag Mips=Off Flags=2

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
    Texture=Texture'S_Flag'
    SoundVolume=128
//    CollisionRadius=12.00
//    CollisionHeight=15.00
}

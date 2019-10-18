//=============================================================================
// RoadPathNode
// Useful for vehicles, particularly on terrain
//=============================================================================

#exec Texture Import File=Textures\S_RoadPath.tga Name=S_RoadPath Mips=Off MASKED=true ALPHA=true

class RoadPathNode extends PathNode
	native;

var() float MaxRoadDist;

cpptext
{
	INT ProscribedPathTo(ANavigationPoint *Nav);
	UBOOL ReviewPath(APawn* Scout);
}

defaultproperties
{
     Texture=S_RoadPath
     SoundVolume=128
     DrawScale=+0.4
     bVehicleDestination=true
     MaxRoadDist=+10000.0
}

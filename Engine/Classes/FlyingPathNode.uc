//=============================================================================
// FlyingPathNode
// Useful for flying or swimming
//=============================================================================

#exec Texture Import File=Textures\S_FlyingPath.tga Name=S_FlyingPath Mips=Off MASKED=true ALPHA=true

class FlyingPathNode extends PathNode
	native;

cpptext
{
	INT ProscribedPathTo(ANavigationPoint *Nav);
	virtual UBOOL ReachedBy( APawn * P, FVector Loc );
	virtual UBOOL NoReachDistance();
	virtual UBOOL BigAnchor(APawn * P, FVector Loc);
	virtual void addReachSpecs(APawn * Scout, UBOOL bOnlyChanged);
	virtual UBOOL ShouldBeBased();
	virtual void InitForPathFinding();
	UBOOL ReviewPath(APawn* Scout);
}

defaultproperties
{
     Texture=S_FlyingPath
     SoundVolume=128
     bNoAutoConnect=true
     DrawScale=+0.4
     bFlyingPreferred=true
     bVehicleDestination=true
}

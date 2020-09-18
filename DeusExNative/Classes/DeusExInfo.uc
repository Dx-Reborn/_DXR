class DeusExInfo extends Info placeable native;


var const DeusExEventManager EventManager;


native final function InitEventManager();

// Note: bNoCollisionFail is true by default
native final function actor SpawnEx(class<actor> SpawnClass,optional actor SpawnOwner,
                                    optional name SpawnTag,optional vector SpawnLocation,
                                    optional rotator SpawnRotation, optional bool bNoCollisionFail);


cpptext
{
	virtual UBOOL Tick(FLOAT deltaTime, enum ELevelTick tickType);
}

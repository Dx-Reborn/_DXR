class DeusExWeaponBase extends Weapon native;


native final function actor SpawnEx(class<Actor> Class, optional Actor Owner, optional name Tag, optional vector Location, optional rotator Rotation, optional bool bNoCollisionFail);


cpptext
{
	virtual AActor* GetProjectorBase();
}


defaultproperties
{
     ItemName = "DEFAULT WEAPON NAME - REPORT THIS AS A BUG"
     DrawType = DT_Mesh
     Mass = 10.000000
     Buoyancy = 5.000000
     bHidden = false
     bCollideActors = true
     bBlockActors = false
     Physics = PHYS_Falling
}

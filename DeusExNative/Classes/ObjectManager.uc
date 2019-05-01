class ObjectManager extends Object abstract native transient;


// Convert String to Name (FName)
native static function Name StringToName(coerce string String);

// Similar to one used in DeusEx. Works with all meshes (VertMesh/StaticMesh/SketelalMesh)
native static function Material GetMeshTexture(Actor Actor, optional int MaterialIndex);

// See Core\Object.uc for flags.
native static function int GetObjectFlags(Object Object);

// Sets object or actor flags, RF_Transient for example. Can be used to exclude some object from SaveGame.
native static function SetObjectFlags(Object Object, int NewFlags);

// Kill an object.
native static function Destroy(Object Object);

// Advanced version.
native static function CollectGarbage(int KeepFlags);

class ObjectManager extends Object abstract native transient;


native static function Name StringToName(coerce string String);

native static function Material GetMeshTexture(Actor Actor, optional int MaterialIndex);
native static function SetActorFlags(Actor Actor, int NewFlags);
native static function SetObjectFlags(Object Obj, int NewFlags); // New

native static function Destroy(Object Object);
native static function CollectGarbage(int KeepFlags);

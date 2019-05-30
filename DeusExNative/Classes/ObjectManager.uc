class ObjectManager extends Object abstract native transient;


native static function Name StringToName(coerce string String);

native static function CollectGarbage(int KeepFlags);

// See DeusEx\DeusExMover.uc for examples.
native static function Box GetActorBoundingBox(Actor Actor);

native static function Material GetActorMeshTexture(Actor Actor, optional int MaterialIndex);

// See DeusEx\DeusExMover.uc for examples.
native static function Box GetMoverBoundingBox(Mover Mover);

// Set/get object/Actor flags, like RF_Transient.
native static function int GetObjectFlags(Object Object);
native static function SetObjectFlags(Object Object, int NewFlags);

native static function DestroyObject(Object Object);

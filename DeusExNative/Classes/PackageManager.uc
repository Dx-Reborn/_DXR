class PackageManager extends Object abstract native transient;


native static function Object LoadUnrealPackage(string Path, int Flags);
native static function UnloadUnrealPackage(Object Package);

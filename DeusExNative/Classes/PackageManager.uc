class PackageManager extends Object abstract native transient;

// Loads a package. Returns a pointer to Object, which can be used to unload that package.
native static function Object LoadUnrealPackage(string Path, int Flags);
native static function UnloadUnrealPackage(Object Package);

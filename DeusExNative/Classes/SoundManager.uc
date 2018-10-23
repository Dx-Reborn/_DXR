class SoundManager extends Object abstract native transient;


native static function bool LoadSound(string Path, out Sound Sound, optional Object Outer);

native static function bool StopSound(Actor Actor, Sound Sound);

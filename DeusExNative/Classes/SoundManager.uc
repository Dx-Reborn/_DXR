class SoundManager extends Object abstract native transient;


// Load .MP3 and convert it to USound. Used for conversations audio.
native static function bool LoadSound(string Path, out Sound Sound, optional Object Outer);

// Use to stop a USound. 
native static function bool StopSound(Actor Actor, Sound Sound);

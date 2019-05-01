class DeusExGameEngine extends GameEngine native transient;

// Get a pointer to GameEngine.
native static function DeusExGameEngine GetEngine();


cpptext
{
	virtual void Init();
}

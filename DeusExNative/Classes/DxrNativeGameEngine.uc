class DxrNativeGameEngine extends GameEngine native transient;


cpptext
{
	virtual void Init();
}


native static function DxrNativeGameEngine GetEngine();

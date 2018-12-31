class GraphicsManager extends Object abstract native transient;


enum ScaleMode {
	ScaleStretch, ScaleKeepRatio, ScaleKeepRatioCentered
};


struct native Resolution {
	var int Width;
	var int Height;
};


native static function bool GetResolutionList(out Array<Resolution> ResolutionList, int ColorBits);

native static function bool TakeScreenShot(Level Level, out Texture Texture, optional Object Outer);

native static function bool ScaleTexture(Texture Texture, int NewWidth, int NewHeight, ScaleMode ScaleMode, optional int BackgroundColor);
native static function bool FlipTexture(Texture Texture);

native static function bool SaveTexture(string Path, Texture Texture, optional int Quality);
native static function bool LoadTexture(string Path, out Texture Texture, optional Object Outer);

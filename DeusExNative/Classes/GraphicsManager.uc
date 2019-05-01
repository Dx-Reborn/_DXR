class GraphicsManager extends Object abstract native transient;


enum ScaleMode {
	ScaleStretch, ScaleKeepRatio, ScaleKeepRatioCentered
};


struct native Resolution {
	var int Width;
	var int Height;
};

// Return list of all screen resolutions in RESxRES format (800x600, 1920x1080, etc.)
native static function bool GetResolutionList(out Array<Resolution> ResolutionList, int ColorBits);

native static function bool TakeScreenShot(Level Level, out Texture Texture, optional Object Outer);

native static function bool ScaleTexture(Texture Texture, int NewWidth, int NewHeight, ScaleMode ScaleMode, optional int BackgroundColor);

// Can be used to flip a texture in very rare cases.
native static function bool FlipTexture(Texture Texture);

// Save texture as .JPG file. For saved games. See DeusEx\DxUtil.uc for examples.
native static function bool SaveTexture(string Path, Texture Texture, optional int Quality);

// Convert .JPG file to Texture. 
native static function bool LoadTexture(string Path, out Texture Texture, optional Object Outer);

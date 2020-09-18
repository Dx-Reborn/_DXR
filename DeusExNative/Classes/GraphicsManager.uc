class GraphicsManager extends Object abstract native transient;


enum RotateFlipMode {
	RotateNoneFlipNone, Rotate90FlipNone, Rotate180FlipNone, Rotate270FlipNone,
	RotateNoneFlipX, Rotate90FlipX, Rotate180FlipX, Rotate270FlipX
};

enum ScaleMode {
	ScaleStretch, ScaleKeepRatio, ScaleKeepRatioCentered
};


struct native Resolution {
	var int Width;
	var int Height;
};


native static function bool GetResolutionList(out Array<Resolution> ResolutionList, int ColorBits);

native static function bool TakeScreenShot(Level Level, out Texture Texture, optional Object Outer);

native static function bool FlipTexture(Texture Texture);
native static function bool RotateFlipTexture(Texture Texture, RotateFlipMode RotateFlipMode);
native static function bool ScaleTexture(Texture Texture, int NewWidth, int NewHeight, ScaleMode ScaleMode, optional int BackgroundColor);

native static function bool SaveTextureBmp(string Path, Texture Texture);
native static function bool SaveTextureJpeg(string Path, Texture Texture, optional int Quality);
native static function bool LoadTexture(string Path, out Texture Texture, optional Object Outer);

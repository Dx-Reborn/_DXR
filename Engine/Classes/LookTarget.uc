//=============================================================================
// LookTarget
//
// A convenience actor that you can point a matinee camera at.
//
// Isn't bStatic so you can attach these to movers and such.
//
//=============================================================================
class LookTarget extends KeyPoint
	native;

// Sprite.
#exec Texture Import File=Textures\S_LookTarget.tga Name=S_LookTarget Mips=Off MASKED=true ALPHA=true

defaultproperties
{
	bStasis=true
     bStatic=false
	 bNoDelete=true
     bHidden=True
     SoundVolume=0
	 Texture=S_LookTarget
}

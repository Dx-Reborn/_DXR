//=============================================================================
// InterpolationPoint.
// Used as destinations to move the camera to in Matinee scenes.
//=============================================================================
class InterpolationPoint extends Keypoint
	native;

#exec Texture Import File=Textures\S_Interp.tga Name=S_Interp Mips=Off MASKED=true ALPHA=true

defaultproperties
{
	DrawScale=+0.35
     bDirectional=True
	 Texture=S_Interp
}

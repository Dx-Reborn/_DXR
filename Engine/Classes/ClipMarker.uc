//=============================================================================
// ClipMarker.
//
// These are markers for the brush clip mode.  You place 2 or 3 of these in
// the level and that defines your clipping plane.
//
// These should NOT be manually added to the level.  The editor adds and
// deletes them on it's own.
//
//=============================================================================
class ClipMarker extends Keypoint
	placeable
	native;

#exec Texture Import File=Textures\S_ClipMarker.tga Name=S_ClipMarker Mips=Off MASKED=true ALPHA=true
#exec Texture Import File=Textures\S_ClipMarker1.tga Name=S_ClipMarker1 Mips=Off MASKED=true ALPHA=true
#exec Texture Import File=Textures\S_ClipMarker2.tga Name=S_ClipMarker2 Mips=Off MASKED=true ALPHA=true
#exec Texture Import File=Textures\S_ClipMarker3.tga Name=S_ClipMarker3 Mips=Off MASKED=true ALPHA=true

defaultproperties
{
     bEdShouldSnap=True
     Texture=Texture'Engine.S_ClipMarker'
	 bStatic=True
}

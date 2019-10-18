//=============================================================================
// DecorationList:  Defines a list of decorations which can be attached to volumes
//=============================================================================

class DecorationList extends KeyPoint
	placeable
	native;

#exec Texture Import File=Textures\S_DecorationList.tga Name=S_DecorationList Mips=Off MASKED=true ALPHA=true

struct DecorationType
{
	var() StaticMesh	StaticMesh;
	var() range			Count;
	var() range			DrawScale;
	var() int			bAlign;
	var() int			bRandomPitch;
	var() int			bRandomYaw;
	var() int			bRandomRoll;
};

var(List) array<DecorationType> Decorations;

defaultproperties
{
	 Texture=S_DecorationList
}

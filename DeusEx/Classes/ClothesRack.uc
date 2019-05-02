//=============================================================================
// ClothesRack.
//=============================================================================
class ClothesRack extends HangingDecoration;

enum ESkinColor
{
	SC_Blue,
	SC_Yellow,
	SC_Green,
	SC_Black
};

var() ESkinColor SkinColor;

function BeginPlay()
{
	Super.BeginPlay();

	switch (SkinColor)
	{
		case SC_Blue:		Skins[0] = Texture'ClothesRackTex1'; break;
		case SC_Yellow:	Skins[0] = Texture'ClothesRackTex2'; break;
		case SC_Green:	Skins[0] = Texture'ClothesRackTex3'; break;
		case SC_Black:	Skins[0] = Texture'ClothesRackTex4'; break;
	}
}


defaultproperties
{
     FragType=Class'DeusEx.PaperFragment'
     ItemName="Hanging Clothes"
     mesh=mesh'DeusExDeco.ClothesRack'
//     PrePivot=(Z=24.750000)
     CollisionRadius=13.000000
     CollisionHeight=24.750000
     Mass=60.000000
     Buoyancy=70.000000
}

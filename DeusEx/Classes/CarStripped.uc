//=============================================================================
// CarStripped.
//=============================================================================
class CarStripped extends OutdoorThings;

enum ESkinColor
{
	SC_LightBlue,
	SC_DarkBlue,
	SC_Gray,
	SC_Black
};

var() ESkinColor SkinColor;

function BeginPlay()
{
	Super.BeginPlay();

	switch (SkinColor)
	{
		case SC_LightBlue:	Skins[0] = Texture'CarStrippedTex1'; break;
		case SC_DarkBlue:		Skins[0] = Texture'CarStrippedTex2'; break;
		case SC_Gray:				Skins[0] = Texture'CarStrippedTex3'; break;
		case SC_Black:			Skins[0] = Texture'CarStrippedTex4'; break;
	}
}


defaultproperties
{
     bCanBeBase=True
     mesh=mesh'DeusExDeco.CarStripped'
     CollisionRadius=115.000000
     CollisionHeight=23.860001
     Mass=2000.000000
     Buoyancy=1500.000000
}

//=============================================================================
// Bushes3.
//=============================================================================
class Bushes3 extends OutdoorThings;

enum ESkinColor
{
	SC_Bushes1,
	SC_Bushes2,
	SC_Bushes3,
	SC_Bushes4
};

var() ESkinColor SkinColor;

function BeginPlay()
{
	Super.BeginPlay();

	switch (SkinColor)
	{
		case SC_Bushes1:	Skins[0] = Texture'Bushes3Tex1'; break;
		case SC_Bushes2:	Skins[0] = Texture'Bushes3Tex2'; break;
		case SC_Bushes3:	Skins[0] = Texture'Bushes3Tex3'; break;
		case SC_Bushes4:	Skins[0] = Texture'Bushes3Tex4'; break;
	}
}


defaultproperties
{
     mesh=mesh'DeusExDeco.Bushes3'
     CollisionRadius=10.000000
     CollisionHeight=30.000000
     Mass=40.000000
     Buoyancy=20.000000
}

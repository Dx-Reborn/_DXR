//=============================================================================
// Liquor40oz.
//=============================================================================
class Liquor40oz extends DeusExPickup;

enum ESkinColor
{
	SC_Super45,
	SC_Bottle2,
	SC_Bottle3,
	SC_Bottle4
};

var() ESkinColor SkinColor;

function BeginPlay()
{
	Super.BeginPlay();

	switch (SkinColor)
	{
		case SC_Super45:		Skins[0] = Texture'Liquor40ozTex1'; break;
		case SC_Bottle2:		Skins[0] = Texture'Liquor40ozTex2'; break;
		case SC_Bottle3:		Skins[0] = Texture'Liquor40ozTex3'; break;
		case SC_Bottle4:		Skins[0] = Texture'Liquor40ozTex4'; break;
	}
}

defaultproperties
{
    InventoryType=class'Liquor40ozInv'
    ItemName="Forty"
    Mesh=Mesh'DeusExItems.Liquor40oz'
    CollisionRadius=3.000000
    CollisionHeight=9.140000
    Mass=10.000000
    Buoyancy=8.000000
}

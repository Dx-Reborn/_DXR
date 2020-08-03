//=============================================================================
// CoffeeTable.
//=============================================================================
class CoffeeTable extends Furniture;

enum ESkinColor
{
    SC_WhiteMarble,
    SC_BlackMarble,
    SC_GrayMarble
};

var() ESkinColor SkinColor;

event BeginPlay()
{
    Super.BeginPlay();

    switch (SkinColor)
    {
        case SC_WhiteMarble:    Skins[0] = Texture'CoffeeTableTex1'; break;
        case SC_BlackMarble:    Skins[0] = Texture'CoffeeTableTex2'; break;
        case SC_GrayMarble:     Skins[0] = Texture'CoffeeTableTex3'; break;
    }
}

defaultproperties
{
     bCanBeBase=True
     ItemName="Coffee Table"
     mesh=mesh'DeusExDeco.CoffeeTable'
     CollisionRadius=34.750000
     CollisionHeight=13.680000
     Mass=80.000000
     Buoyancy=25.000000
}

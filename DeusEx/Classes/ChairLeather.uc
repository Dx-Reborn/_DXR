//=============================================================================
// ChairLeather.
//=============================================================================
class ChairLeather extends Seat;

enum ESkinColor
{
    SC_Black,
    SC_Blue,
    SC_Brown,
    SC_LitGray,
    SC_Tan
};

var() ESkinColor SkinColor;

function BeginPlay()
{
    Super.BeginPlay();

    switch (SkinColor)
    {
        case SC_Black:      Skins[0] = Texture'ChairLeatherTex1'; break;
        case SC_Blue:       Skins[0] = Texture'ChairLeatherTex2'; break;
        case SC_Brown:      Skins[0] = Texture'ChairLeatherTex3'; break;
        case SC_LitGray:    Skins[0] = Texture'ChairLeatherTex4'; break;
        case SC_Tan:        Skins[0] = Texture'ChairLeatherTex5'; break;
    }
}


defaultproperties
{
     sitPoint(0)=(X=0.000000,Y=-8.000000,Z=0.000000)
     ItemName="Comfy Chair"
     mesh=mesh'DeusExDeco.ChairLeather'
     CollisionRadius=33.500000
     CollisionHeight=23.250000
     Mass=100.000000
     Buoyancy=110.000000
}

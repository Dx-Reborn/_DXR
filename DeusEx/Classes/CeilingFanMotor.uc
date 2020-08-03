//=============================================================================
// CeilingFanMotor.
//=============================================================================
class CeilingFanMotor extends DeusExDecoration;

enum ESkinColor
{
    SC_WoodBrass,
    SC_DarkWoodIron,
    SC_White,
    SC_WoodBrassFancy,
    SC_WoodPlastic
};

var() ESkinColor SkinColor;

event BeginPlay()
{
    Super.BeginPlay();

    switch (SkinColor)
    {
        case SC_WoodBrass:      Skins[0] = Texture'CeilingFanTex1'; break;
        case SC_DarkWoodIron:   Skins[0] = Texture'CeilingFanTex2'; break;
        case SC_White:          Skins[0] = Texture'CeilingFanTex3'; break;
        case SC_WoodBrassFancy: Skins[0] = Texture'CeilingFanTex4'; break;
        case SC_WoodPlastic:    Skins[0] = Texture'CeilingFanTex5'; break;
    }
}


defaultproperties
{
     SkinColor=SC_DarkWoodIron
     bInvincible=True
     bHighlight=False
     bCanBeBase=True
     ItemName="Ceiling Fan Motor"
     bPushable=False
     Physics=PHYS_None
     AmbientSound=Sound'DeusExSounds.Generic.MotorHum'
     mesh=mesh'DeusExDeco.CeilingFanMotor'
     SoundRadius=12
     SoundVolume=160
     CollisionRadius=12.000000
     CollisionHeight=4.420000
     bCollideWorld=False
     Mass=50.000000
     Buoyancy=30.000000
}

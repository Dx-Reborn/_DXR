//=============================================================================
// ShockRing.
//=============================================================================
class ShockRing extends Effects;

#Exec obj load file=DeusExItemsEX

var float size;

event Tick(float deltaTime)
{
    SetDrawScale(size * (Default.LifeSpan - LifeSpan) / Default.LifeSpan);
    ScaleGlow = LifeSpan / Default.LifeSpan;
}

function PostBeginPlay()
{
    Super.PostBeginPlay();

    if (size > 5)
        Skins[0] = Shader'FlatFX43_SH';
}

defaultproperties
{
     drawType=DT_Mesh
     size=5.000000
     LifeSpan=0.500000
     Style=STY_Translucent // Задается в материале
     Skins[0]=Shader'DeusExItemsEX.ExSkins.FlatFX41_SH'
     Mesh=Mesh'DeusExItems.FlatFX'
     bUnlit=True
}

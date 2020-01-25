//=============================================================================
// SphereEffect.
//=============================================================================
class SphereEffect extends Effects;

var float size;

simulated function Tick(float deltaTime)
{
	SetDrawScale(3.0 * size * (Default.LifeSpan - LifeSpan) / Default.LifeSpan);
	ScaleGlow = 2.0 * (LifeSpan / Default.LifeSpan);
}


defaultproperties
{
     size=5.000000
     LifeSpan=0.500000
     Style=STY_Translucent
     DrawType=DT_Mesh
     Mesh=Mesh'DeusExItems.SphereEffect'
     Skins(0)=material'Effects_EX.SH_WepnProd_FX'
     bUnlit=True
}

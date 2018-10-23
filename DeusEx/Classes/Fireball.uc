//=============================================================================
// Fireball.
//=============================================================================
class Fireball extends DeusExProjectile;

#exec OBJ LOAD FILE=Effects

function Tick(float deltaTime)
{
	local float value;
	local float sizeMult;

	// don't Super.Tick() becuase we don't want gravity to affect the stream
	time += deltaTime;

	value = 1.0+time;
	if (MinDrawScale > 0)
		sizeMult = MaxDrawScale/MinDrawScale;
	else
		sizeMult = 1;

	SetDrawScale(MinDrawScale * (-sizeMult/(value*value) + (sizeMult+1)));          // = (-sizeMult/(value*value) + (sizeMult+1))*MinDrawScale;
	ScaleGlow = Default.ScaleGlow/(value*value*value);
}
/*
function ZoneChange(ZoneInfo NewZone)
{
	Super.ZoneChange(NewZone);

	// If the fireball enters water, extingish it
	if (NewZone.bWaterZone)
		Destroy();
}*/



defaultproperties
{
     blastRadius=1.000000
     DamageType=class'DM_Flamed'
     AccurateRange=320
     MaxRange=320
     bIgnoresNanoDefense=True
     ItemName="Fireball"
     //  ItemArticle="a"
     speed=800.000000
     MaxSpeed=800.000000
     Damage=5.000000
     MomentumTransfer=500
     ExplosionDecal=Class'DeusEx.BurnMark'
     LifeSpan=0.500000
     DrawType=DT_Sprite
     Style=STY_Translucent
     Texture=FireTexture'Effects.Fire.flame_b'
     DrawScale=0.050000
     bUnlit=True
     LightType=LT_Steady
     LightEffect=LE_NonIncidence
     LightBrightness=200
     LightHue=16
     LightSaturation=32
     LightRadius=2
}

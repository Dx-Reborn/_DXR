//=============================================================================
// Spark.
//=============================================================================
class Spark extends Effects;

#exec OBJ LOAD FILE=Effects

var Rotator rot;

auto state Flying
{
	function BeginState()
	{
		Velocity = vect(0,0,0);
		rot = Rotation;
		rot.Roll += FRand() * 65535;
		SetRotation(rot);
	}
}

defaultproperties
{
//     bNetOptional=True
     LifeSpan=0.250000
     Style=STY_Translucent
     DrawType=DT_Sprite//Mesh
     Texture=FireTexture'Effects.Fire.SparkFX1'
     Mesh=Mesh'DeusExItems.FlatFX'
     DrawScale=0.100000
     bUnlit=True
     bCollideWorld=True
     bBounce=True
     bFixedRotationDir=True
}

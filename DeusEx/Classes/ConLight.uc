//=============================================================================
// The ConLight class.
//=============================================================================
class ConLight extends Light;

var Int actorDistance;

// ----------------------------------------------------------------------
// TurnOn()
// ----------------------------------------------------------------------

function TurnOn()
{
	LightType = LT_Steady;
}

// ----------------------------------------------------------------------
// TurnOff()
// ----------------------------------------------------------------------

function TurnOff()
{
	LightType = LT_None;
}

// ----------------------------------------------------------------------
// UpdateLocation()
// ----------------------------------------------------------------------

function UpdateLocation(Actor lightActor)
{
	local Vector dirVect;
	local Vector eyeVect;
	local Float eyeHeight;

	if (lightActor == None)
	{
		TurnOff();
	}
	else
	{
		TurnOn();

		dirVect = Vector(lightActor.Rotation) * actorDistance;

		if (lightActor.IsA('Pawn'))
			eyeHeight = Pawn(lightActor).baseEyeHeight;
		else if (lightActor.IsA('Decoration'))
			eyeHeight = Decoration(lightActor).GetbaseEyeHeight();
		else
			eyeHeight = 0;

		eyeVect = Vect(0, 0, 1) * eyeHeight + lightActor.location;
		dirVect += eyeVect; 

		SetLocation(dirVect);
		SetRotation(Rotator(eyeVect - dirVect));
	}
}

// ----------------------------------------------------------------------
// if bMovable = False, then the light causes actors to flash for some fucked up reason
// ----------------------------------------------------------------------
defaultproperties
{
    actorDistance=50
    bStatic=False
    bNoDelete=False
    bMovable=True
    LightType=LT_None
    LightEffect=LE_NonIncidence
    LightBrightness=255
    LightRadius=3
    LightCone=32
    bDynamicLight=true
}

//=============================================================================
// PickupDistributor.
//=============================================================================
class PickupDistributor extends Keypoint;

//
// Distributes NanoKeys at the start of a level, then destroys itself
//

// copied from NanoKey
enum ESkinColor
{
	SC_Level1,
	SC_Level2,
	SC_Level3,
	SC_Level4
};

struct SNanoKeyInitStruct
{
	var() name					ScriptedPawnTag;
	var() name					KeyID;
	var() localized String		Description;
	var() ESkinColor			SkinColor;
};

var() SNanoKeyInitStruct NanoKeyData[8];

function SetInitialState() // was PostPostBeginPlay(), but UT2k4 does not have such event
{
	local int i;
	local ScriptedPawn P;
//	local NanoKey key;
 	local NanoKeyInv key;

	Super.SetInitialState();

	for(i=0; i<ArrayCount(NanoKeyData); i++)
	{
		if (NanoKeyData[i].ScriptedPawnTag != '')
		{
			foreach AllActors(class'ScriptedPawn', P, NanoKeyData[i].ScriptedPawnTag)
			{
				key = spawn(class'NanoKeyInv', P); //spawn(class'NanoKey', P);
				if (key != None)
				{
					key.KeyID = NanoKeyData[i].KeyID;
					key.Description = NanoKeyData[i].Description;
//					key.SkinColor = NanoKeyData[i].SkinColor;
					key.InitialState = 'Idle2';
					key.GiveTo(P);
					key.SetBase(P);
				}
			}
		}
	}

	Destroy();
}


defaultproperties
{
     bStatic=False
}

/*
  MenuChoice_PhysicsDetail
*/

class MenuChoice_PhysicsDetail extends DXREnumButton;
                                       

var String englishEnumText[3];

function LoadSetting()
{
	local byte detail;
	local int enumIndex;
	local int detailChoice;

	detail = class'LevelInfo'.default.PhysicsDetailLevel;
	detailChoice = 0;

	for (enumIndex=0; enumIndex<arrayCount(enumText); enumIndex++)
	{
		if (enumIndex == detail)
		{
			detailChoice = enumIndex;
			break;
		}	
	}
	SetValue(detailChoice);
}

function SaveSetting()
{
  local byte pdl;

  pdl = GetValue();

    switch (pdl)
    {
      case 0:
				class'LevelInfo'.default.PhysicsDetailLevel = PDL_Low;
				playerOwner().Level.PhysicsDetailLevel = PDL_Low;
      break;

      case 1:
				class'LevelInfo'.default.PhysicsDetailLevel = PDL_Medium;
				playerOwner().Level.PhysicsDetailLevel = PDL_Medium;
      break;

      case 2:
				class'LevelInfo'.default.PhysicsDetailLevel = PDL_High;
				playerOwner().Level.PhysicsDetailLevel = PDL_High;
      break;
    }

   if (PlayerOwner().Level != None)
       PlayerOwner().Level.SaveConfig();
          else class'LevelInfo'.static.StaticSaveConfig();
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
defaultproperties
{
  Hint="Changes the physics simulation level of detail. May affect ragdolls, KARMA objects on levels, etc."
  actionText="Physics detail. Yeah, this menu looks almost empty ))"

	EnumText(0)="Low"
	EnumText(1)="Medium"
	EnumText(2)="High"

	englishEnumText(0)="PDL_Low"
	englishEnumText(1)="PDL_Medium"
	englishEnumText(2)="PDL_High"
}

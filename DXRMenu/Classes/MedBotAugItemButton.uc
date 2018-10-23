//=============================================================================
// HUDMedBotAugItemButton
// Кнопка внутри панели
//=============================================================================

class MedBotAugItemButton extends PersonaItemButton;

var AugmentationCannisterInv augCan;

var bool bSlotFull;
var bool bHasIt;

//var Color colBorder;
var Color colIconDisabled;
var Color colIconNormal;

// ----------------------------------------------------------------------
// DrawWindow()
// ----------------------------------------------------------------------

function InternalOnRendered(canvas u)
{
  local int x,y;

  x = ActualLeft(); y = ActualTop();
  u.SetPos(x,y);
  //u.SetDrawColor(0,255,0,255);
  u.DrawColor = class'DXR_Menu'.static.GetPlayerInterfaceButton(gl.MenuThemeIndex);
  u.DrawTileStretched(texture'WhiteBorderT', ActualWidth(), ActualHeight());

	if ((bSlotFull) || (bHasIt))	
		colIcon = colIconDisabled;
	else
		colIcon = colIconNormal;

	Super.InternalOnRendered(u);

	// Draw selection border
	if (!bSelected)
	{
		u.drawcolor = class'DXR_Menu'.static.GetAugButtonBorder(gl.MenuThemeIndex); //colBorder; //gc.SetTileColor(colBorder);
		//gc.SetStyle(DSTY_Masked);
		//gc.DrawBorders(0, 0, borderWidth, borderHeight, 0, 0, 0, 0, texBorders);
	}
}

// ----------------------------------------------------------------------
// SetAugmentation()
// ----------------------------------------------------------------------

function SetAugmentation(Augmentation newAug)
{
	SetClientObject(newAug);
	SetIcon(newAug.smallIcon);

	// First check to see if the player already has this augmentation
	bHasIt = newAug.bHasIt;

	// Now check to see if this augmentation slot is full
	bSlotFull = player.AugmentationSystem.AreSlotsFull(newAug);
}

// ----------------------------------------------------------------------
// SetAugCan()
// ----------------------------------------------------------------------

function SetAugCan(AugmentationCannisterInv newAugCan)
{
	augCan = newAugCan;
}

// ----------------------------------------------------------------------
// GetAugCan()
// ----------------------------------------------------------------------

function AugmentationCannisterInv GetAugCan()
{
	return augCan;
}

// ----------------------------------------------------------------------
// GetAugmentation()
// ----------------------------------------------------------------------

function Augmentation GetAugmentation()
{
	return Augmentation(GetClientObject());
}

// ----------------------------------------------------------------------
// GetAugDesc()
// ----------------------------------------------------------------------

function String GetAugDesc()
{
	if (GetClientObject() != None)
		return Augmentation(GetClientObject()).augmentationName;
	else
		return "";
}

// ----------------------------------------------------------------------
// StyleChanged()
// ----------------------------------------------------------------------

/*event StyleChanged()
{
	local ColorTheme theme;

	Super.StyleChanged();

	colBorder.r = Int(Float(colBackground.r) * 0.75);
	colBorder.g = Int(Float(colBackground.g) * 0.75);
	colBorder.b = Int(Float(colBackground.b) * 0.75);
}*/

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
defaultproperties
{
    colIconDisabled=(R=64,G=64,B=64,A=255)
    colIconNormal=(R=255,G=255,B=0,A=255)
    iconPosWidth=32
    iconPosHeight=32
    buttonWidth=34
    buttonHeight=34
    borderWidth=34
    borderHeight=34
   bNeverScale=true
}

//=============================================================================
// HUDObjectSlot
//=============================================================================
class HUDObjectSlot extends InventoryButton;//ToggleWindow;

var DeusExPlayer player;

var int			objectNum;
var Inventory	item;
var Color		colObjectNum;
var Color		colObjectDesc;
var Color		colOutline;
var Color		fillColor;
var Color		colDropGood;
var Color		colDropBad;
var Color		colNone;
var Color		colSelected;
var Color       colSelectionBorder;
var int			slotFillWidth;
var int			slotFillHeight;
var int         borderWidth;
var int         borderHeight;

// Stuff to optimize DrawWindow()
var String      itemText;

// Drag/Drop Stuff
var gui_Inventory winInv;		// Pointer back to the inventory window
var Int  clickX;
var Int  clickY;
var bool bDragStart;
var bool bDimIcon;	
var bool bAllowDragging;
var bool bDragging;					// Set to True when we're dragging

enum FillModes
{
	FM_Selected,
	FM_DropGood,
	FM_DropBad,
	FM_None
};

var() FillModes fillMode;

// Variables used to draw belt
var Texture		slotTextures;
var int			slotIconX;
var int			slotIconY;
var int			slotNumberX;
var int			slotNumberY;

// Used by DrawWindow()
var int itemTextPosY;

// Defaults
//var EDrawStyle backgroundDrawStyle;
var Texture texBackground;
var Color colBackground;

var localized String RoundLabel,RoundsLabel,CountLabel;

var bool bChecked;
var bool bButtonPressed;


function ChangeToggle()
{
  bChecked = !bChecked;
}

function SetToggle(bool bNewToggle)
{
  bChecked = bNewToggle;
}

function bool GetToggle()
{
  return bChecked;
}

function SetSize(float width, float height)
{
  winWidth = width; winHeight = height;
}

// ----------------------------------------------------------------------
// InitWindow()
// ----------------------------------------------------------------------
event InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	Super.Initcomponent(MyController, MyOwner);

	objectNum	= -1;
	item = None;

//	SetSelectability(false);
	SetSize(51, 54);

	// Get a pointer to the player
	player = DeusExPlayer(PlayerOwner().Pawn);

	// Position where we'll be drawing the item-dependent text
	itemTextPosY = slotFillHeight - 8 + slotIconY;

//	StyleChanged();
}

// ----------------------------------------------------------------------
// ToggleChanged()
// ----------------------------------------------------------------------

/*event bool ToggleChanged(Window button, bool bNewToggle)
{
	if ((item == None) && (bNewToggle))
	{
		SetToggle(False);
		return True;
	}
	else
	{
		return False;
	}
}*/

// ----------------------------------------------------------------------
// SetObjectNumber()
// ----------------------------------------------------------------------

function SetObjectNumber(int newNumber)
{
	objectNum = newNumber;
}

// ----------------------------------------------------------------------
// SetItem()
// ----------------------------------------------------------------------

function SetItem(Inventory newItem)
{
	item = newItem;
	if ( newItem != None )
	{
		newItem.SetToObjectBelt();//bInObjectBelt = True;
		newItem.SetbeltPos(objectNum);
	}
	else
	{
		HighlightSelect(False);
		SetToggle(False);
	}

	// Update the text that will be displayed above the icon (if any)
	UpdateItemText();
}

// ----------------------------------------------------------------------
// UpdateItemText()
// ----------------------------------------------------------------------

function UpdateItemText()
{
	local DeusExWeaponInv weapon;

	itemText = "";

	if (item != None)
	{
		if (item.IsA('DeusExWeaponInv'))
		{
			// If this is a weapon, show the number of remaining rounds 
			weapon = DeusExWeaponInv(item);

			// Ammo loaded
			if ((weapon.AmmoName != class'AmmoNoneInv') && (!weapon.bHandToHand) && (weapon.ReloadCount != 0) && (weapon.AmmoType != None))
				itemText = weapon.AmmoType.GetbeltDescription();

			// If this is a grenade
			if (weapon.IsA('WeaponNanoVirusGrenadeInv') || weapon.IsA('WeaponGasGrenadeInv') || weapon.IsA('WeaponEMPGrenadeInv') || weapon.IsA('WeaponLAMInv'))
			{
				if (weapon.AmmoType.AmmoAmount > 1)
					itemText = CountLabel @ weapon.AmmoType.AmmoAmount;
			}

		}
		else if (item.IsA('DeusExPickupInv') && (!item.IsA('NanoKeyRingInv')))
		{
			// If the object is a SkilledTool (but not the NanoKeyRing) then show the 
			// number of uses
			if (DeusExPickupInv(item).NumCopies > 1)
				itemText = DeusExPickupInv(item).CountLabel @ String(DeusExPickupInv(item).NumCopies);
		}
	}
}

// ----------------------------------------------------------------------
// GetItem()
// ----------------------------------------------------------------------

function Inventory GetItem()
{
	return (item);
}

/*native(1284) final function DrawTexture(float destX, float destY,
                                        float destWidth, float destHeight,
                                        float srcX, float srcY,
                                        texture tx);
native(1285) final function DrawPattern(float destX, float destY,
                                        float destWidth, float destHeight,
                                        float orgX, float orgY,
                                        texture tx);
*/
// ----------------------------------------------------------------------
// DrawWindow()
// ----------------------------------------------------------------------
event DrawWindow(canvas u)
{
	// First draw the background
  u.Style = EMenuRenderStyle.MSTY_Normal;
//	u.DrawColor = colBackground;
  u.DrawColor=class'DXR_Menu'.static.GetPlayerInterfaceTabsBackground(gl.MenuThemeIndex);
	u.SetPos(ActualLeft(), ActualTop());
	u.DrawIcon(texBackground,1);
//	u.DrawTileStretched(texBackground, ActualWidth(), ActualHeight());
//	gc.DrawTexture(0, 0, width, height, 0, 0, texBackground);

	// Now fill the area under the icon, which can be different 
	// colors based on the state of the item.
	//
	// Don't waste time drawing the fill if the fillMode is set
	// to None

	if (fillMode != FM_None)
	{
		SetFillColor();
		u.Style = EMenuRenderStyle.MSTY_Translucent;
		u.DrawColor = fillColor;
    u.SetPos(ActualLeft(), ActualTop());
    u.DrawTileStretched(texture'solid', ActualWidth(), ActualHeight());
//		gc.DrawPattern( slotIconX, slotIconY, slotFillWidth, slotFillHeight, 0, 0, Texture'Solid' );
	}

	// Don't draw any of this if we're dragging
	if ((item != None) && (item.GetIcon() != None) && (!bDragging))
	{
		// Draw the icon
		u.Style = EMenuRenderStyle.MSTY_Masked;
		u.SetDrawColor(255, 255, 255, 255);

    u.SetPos(ActualLeft() + slotIconX, ActualTop() + slotIconY);
    u.DrawIcon(item.GetIcon(), 1);
//		gc.DrawTexture(slotIconX, slotIconY, slotFillWidth, slotFillHeight, 0, 0, item.GetIcon());

		// Text defaults
//		gc.SetAlignments(HALIGN_Center, VALIGN_Center);
	//	gc.EnableWordWrap(false);
		u.DrawColor = colObjectNum;// gc.SetTextColor(colObjectNum);

		// Draw the item description at the bottom
		u.SetPos(ActualLeft() + 1, ActualTop() + 42);
		u.DrawText(item.GetBeltDescription());
//		gc.DrawText(1, 42, 42, 7, item.BeltDescription);

		// If there's any additional text (say, for an ammo or weapon), draw it
		if (itemText != "")
		{
      u.SetPos(ActualLeft() + slotIconX, ActualTop() + slotIconY);
      u.DrawText(itemText);
			//gc.DrawText(slotIconX, itemTextPosY, slotFillWidth, 8, itemText);
		}

		// Draw selection border
		if (bButtonPressed)
		{
		  u.DrawColor=colSelectionBorder;
		  u.SetPos(ActualLeft() + slotIconX - 1, ActualTop() + slotIconY - 1);
      u.DrawTileStretched(texture'WhiteBorderT', ActualWidth(), ActualHeight());
/*			gc.SetTileColor(colSelectionBorder);
			gc.SetStyle(DSTY_Masked);
			gc.DrawBorders(slotIconX - 1, slotIconY - 1, borderWidth, borderHeight, 0, 0, 0, 0, texBorders);*/
		}
	}
	
	// Draw the Object Slot Number in upper-right corner
//	gc.SetAlignments(HALIGN_Right, VALIGN_Center);
  u.DrawColor = colObjectNum;
  u.SetPos(ActualLeft() + slotNumberX - 1, ActualTop() + slotNumberY);
  u.DrawText(string(objectNum));

//	gc.SetTextColor(colObjectNum);
//	gc.DrawText(slotNumberX - 1, slotNumberY, 6, 7, objectNum);
}

// ----------------------------------------------------------------------
// SetDropFill()
// ----------------------------------------------------------------------

function SetDropFill(bool bGoodDrop)
{
	if (bGoodDrop)
		fillMode = FM_DropGood;
	else
		fillMode = FM_DropBad;
}

// ----------------------------------------------------------------------
// AllowDragging()
// ----------------------------------------------------------------------

function AllowDragging(bool bNewAllowDragging)
{
	bAllowDragging = bNewAllowDragging;
}

// ----------------------------------------------------------------------
// ResetFill()
// ----------------------------------------------------------------------

function ResetFill()
{
	fillMode = FM_None;
}

// ----------------------------------------------------------------------
// HighlightSelect()
// ----------------------------------------------------------------------

function HighlightSelect(bool bHighlight)
{
	if (bHighlight) 
		fillMode = FM_Selected;
	else
		fillMode = FM_None;
}

// ----------------------------------------------------------------------
// SetFillColor()
// ----------------------------------------------------------------------

function SetFillColor()
{
	switch(fillMode)
	{
		case FM_Selected:
			fillColor = colSelected;
			break;
		case FM_DropBad:
			fillColor = colDropBad;
			break;
		case FM_DropGood:
			fillColor = colDropGood;
			break;
		case FM_None:
			fillColor = colNone;
			break;
	}
}

// ----------------------------------------------------------------------
// MouseButtonPressed()
//
// If the user presses the mouse button, initiate drag mode, 
// but only if this button has an inventory item associated
// with it.
// ----------------------------------------------------------------------
/*
event bool MouseButtonPressed(float pointX, float pointY, EInputKey button,
                              int numClicks)
{
	local Bool bResult;

	bResult = False;

	if ((item != None) && (button == IK_LeftMouse))
	{
		bDragStart = True;
		clickX = pointX;
		clickY = pointY;
		bResult = True;
	}
	return bResult;
} */

// ----------------------------------------------------------------------
// MouseButtonReleased()
//
// If we were in drag mode, then release the mouse button.
// If the player is over a new (and valid) inventory location or 
// object belt location, drop the item here.
// ----------------------------------------------------------------------

/*event bool MouseButtonReleased(float pointX, float pointY, EInputKey button,
                               int numClicks)
{
	if (button == IK_LeftMouse)
	{
		FinishButtonDrag();
		return True;
	}
	else
	{
		return false;  // don't handle
	}
} */

// ----------------------------------------------------------------------
// MouseMoved()
// ----------------------------------------------------------------------

/*event MouseMoved(float newX, float newY)
{
	local Float invX;
	local Float invY;

	if (bAllowDragging)
	{
		if (bDragStart)
		{
			// Only start a drag even if the cursor has moved more than, say,
			// two pixels.  This prevents problems if the user just wants to 
			// click on an item to select it but is a little sloppy.  :)
			if (( Abs(newX - clickX) > 2 ) || ( Abs(newY- clickY) > 2 ))
			{
				StartButtonDrag();
				SetCursorPos(
					slotIconX + slotFillWidth/2, 
					slotIconY + slotFillHeight/2);
			}
		}

		if (bDragging)
		{
			// Call the InventoryWindow::MouseMoved function, with translated
			// coordinates.
			ConvertCoordinates(Self, newX, newY, winInv, invX, invY);
			winInv.UpdateDragMouse(invX, invY);
		}
	}
} */

// ----------------------------------------------------------------------
// CursorRequested()
//
// If we're dragging an inventory item, then set the cursor to that 
// icon.  Otherwise return None, meaning use the default cursor icon.
// ----------------------------------------------------------------------

/*event texture CursorRequested(window win, float pointX, float pointY,
                              out float hotX, out float hotY, out color newColor, 
							  out Texture shadowTexture)
{
    shadowTexture = None;

	hotX = slotFillWidth / 2;
	hotY = slotFillHeight / 2;

	if ((item != None) && (bDragging))
	{
		if (bDimIcon)
		{
			newColor.R = 64;
			newColor.G = 64;
			newColor.B = 64;
		}

		return item.Icon;
	}
	else
	{
		return None;
	}
}*/

// ----------------------------------------------------------------------
// StartButtonDrag()
// ----------------------------------------------------------------------

function StartButtonDrag()
{
	bDragStart = False;
	bDragging  = True;

	winInv.StartButtonDrag(Self);
}

// ----------------------------------------------------------------------
// FinishButtonDrag()
// ----------------------------------------------------------------------

function FinishButtonDrag()
{
//	winInv.FinishButtonDrag();
	
	bDragStart = False;
	bDragging  = False;
}

// ----------------------------------------------------------------------
// AssignWinInv()
// ----------------------------------------------------------------------

function AssignWinInv(gui_Inventory newWinInventory)
{
	winInv = newWinInventory;
}

// ----------------------------------------------------------------------
// GetIconPos()
//
// Returns the location where the icon will be drawn
// ----------------------------------------------------------------------

function GetIconPos(out int iconPosX, out int iconPosY)
{
	iconPosX = slotIconX;
	iconPosY = slotIconY;
}

// ----------------------------------------------------------------------
// StyleChanged()
// ----------------------------------------------------------------------

/*event StyleChanged()
{
	local ColorTheme theme;

	theme = player.ThemeManager.GetCurrentHUDColorTheme();

	colBackground = theme.GetColorFromName('HUDColor_Background');
	colObjectNum  = theme.GetColorFromName('HUDColor_NormalText');

	colSelected.r = Int(Float(colBackground.r) * 0.50);
	colSelected.g = Int(Float(colBackground.g) * 0.50);
	colSelected.b = Int(Float(colBackground.b) * 0.50);

	if (player.GetHUDBackgroundTranslucency())
		backgroundDrawStyle = DSTY_Translucent;
	else
		backgroundDrawStyle = DSTY_Masked;
}
    */
// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
    colObjectNum=(R=0,G=170,B=255,A=255)
    colDropGood=(R=32,G=128,B=32,A=255)
    colDropBad=(R=128,G=32,B=32,A=255)
    colSelected=(R=60,G=60,B=60,A=255)
    colSelectionBorder=(R=255,G=255,B=255,A=255)
    slotFillWidth=42
    slotFillHeight=37
    borderWidth=44
    borderHeight=50
    bAllowDragging=True
    fillMode=3
    slotIconX=1
    slotIconY=3
    slotNumberX=38
    slotNumberY=3
    texBackground=Texture'DeusExUI.UserInterface.HUDObjectBeltBackground_Cell'
    colBackground=(R=128,G=128,B=128,A=255)
    RoundLabel="%d Rd"
    RoundsLabel="%d Rds"
    CountLabel="COUNT:"
    StyleName=""
    OnRendered=DrawWindow
    bDropSource=true
}

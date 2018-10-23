//=============================================================================
// HUDMedBotAddAugsScreen
//=============================================================================

class MedBotAddAugsScreen extends gui_Augmentations;

var MedicalBot medBot;

var GUIButton btnInstall;
var AugButtonsContainer winAugsTile;
var bool bSkipAnimation;
var guilabel DescHeader;

var Localized String AvailableAugsText;
var Localized String InstallButtonLabel;
var Localized String NoCansAvailableText;
var Localized String AlreadyHasItText;
var Localized String SlotFullText;
var Localized String SelectAnotherText;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------
function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	Super.Initcomponent(MyController, MyOwner);

	medBot = gl.lastMedBot;
	CreateControls();
	PopulateAugCanList();
	EnableButtons();
}

function PaintFrames(canvas u)
{
  local float x,y;

  x = ActualLeft(); y = ActualTop();

//  u.SetDrawColor(0,255,0,128);
  u.DrawColor = class'DXR_Menu'.static.GetPlayerInterfaceFrames(gl.MenuThemeIndex);
  u.Style = EMenuRenderStyle.MSTY_Translucent;

  u.SetPos(x + lFrameX, y + lframeY);
  u.drawtileStretched(texture'HUDMedBotAugmentationsBorder_1', lfSizeX, lfSizeY);

  u.SetPos(x + mFrameX, y + mframeY);
  u.drawtileStretched(texture'HUDMedBotAugmentationsBorder_2', mfSizeX, mfSizeY);

  u.SetPos(x + rFrameX, y + rframeY);
  u.drawtileStretched(texture'HUDMedBotAugmentationsBorder_3', rfSizeX, rfSizeY);
/*-----------------*/
  u.SetPos(x + lFrameXb, y + lframeYb);
  u.drawtileStretched(texture'HUDMedBotAugmentationsBorder_4', lfSizeXb, lfSizeYb);

  u.SetPos(x + mFrameXb, y + mframeYb); 
  u.drawtileStretched(texture'HUDMedBotAugmentationsBorder_5', mfSizeXb, mfSizeYb); 

  u.SetPos(x + rFrameXb, y + rframeYb);
  u.drawtileStretched(texture'HUDMedBotAugmentationsBorder_6', rfSizeXb, rfSizeYb);
}


/*
   panel:
   winHeight = 116
   WinWidth = 268

   WinLeft = 422
   WinTop = 66

*/

// ----------------------------------------------------------------------
// CreateControls()
// ----------------------------------------------------------------------

function CreateControls()
{
  btnInstall = new class'GUIButton';
  btnInstall.FontScale = FNS_Small;
  btnInstall.Hint = "";
  btnInstall.StyleName="STY_DXR_ButtonNavbar";
  btnInstall.bBoundToParent = true;
  btnInstall.WinHeight = 22;
  btnInstall.WinWidth = 99;
  btnInstall.WinLeft = 421;
  btnInstall.WinTop = 397;
	btnInstall.Caption = InstallButtonLabel;
	btnInstall.OnClick = InternalOnClick;
	AppendComponent(btnInstall, true);

	DescHeader = new class'GUILabel';
	DescHeader.Caption = AvailableAugsText;//"DescHeader";
	DescHeader.WinLeft = 423;
	DescHeader.WinTop = 43;
	DescHeader.WinHeight = 20;
	DescHeader.WinWidth = 267;
/*	DescHeader.WinLeft = 422;
	DescHeader.WinTop = 190;
	DescHeader.WinHeight = 20;
	DescHeader.WinWidth = 252;*/
	DescHeader.bBoundToParent = true;
	DescHeader.TextColor = class'DXR_Menu'.static.GetPlayerInterfaceTextLabels(gl.MenuThemeIndex);
	DescHeader.TextFont="UT2HeaderFont";
	DescHeader.bMultiLine = true;
	DescHeader.TextAlign = TXTA_Center;
	DescHeader.VertAlign = TXTA_Center;
	DescHeader.FontScale = FNS_Small;
	AppendComponent(DescHeader, true);

	if (iAugsBG != none)
  iAugsBG.image = texture'DXR_MedbotAugsBackground';

  if (augDescArea != none)
  {
  augDescArea.winHeight = 182;
  augDescArea.winWidth = 266;
  augDescArea.WinLeft = 423;
  augDescArea.WinTop = 211;
  }

  if (lTitle2 != none)
  {
	lTitle2.WinLeft = 422;
	lTitle2.WinTop = 190;
	lTitle2.WinHeight = 20;
	lTitle2.WinWidth = 252;
  }
}

function WhyContainIt()
{
  winAugsTile = new class'AugButtonsContainer';
  winAugsTile.winHeight = 116;
  winAugsTile.WinWidth = 268;
  winAugsTile.WinLeft = 422;
  winAugsTile.WinTop = 66;
  winAugsTile.bBoundToParent = true;
  AppendComponent(winAugsTile, true);
}

// ----------------------------------------------------------------------
// PopulateAugCanList()
// ----------------------------------------------------------------------

function PopulateAugCanList()
{
	local Inventory item;
	local int canCount;
	local MedBotAugCanWindow augCanWindow;
	local GUILabel txtNoCans;

	// Loop through all the Augmentation Cannisters in the player's 
	// inventory, adding one row for each can.
	item = player.Inventory;
  WhyContainIt();

	while(item != None)
	{
		if (item.IsA('AugmentationCannisterInv'))
		{
			augCanWindow = new class'MedBotAugCanWindow';
//      augCanWindow.bBoundToParent = true;
			winAugsTile.AppendComponent(augCanWindow, true);//
			winAugsTile.funcA();
			augCanWindow.SetCannister(AugmentationCannisterInv(item));
			augCanWindow.btnAug[0].OnClick=InternalOnClick;
			augCanWindow.btnAug[1].OnClick=InternalOnClick;
      alignButtons();
			canCount++;
		}
		item = item.Inventory;
	}

	// If we didn't add any cans, then display "No Aug Cannisters Available!"
	if (canCount == 0)
	{
		txtNoCans = new class'GUILabel';
		txtNoCans.Caption = NoCansAvailableText;
		txtNoCans.WinLeft = 422;
		txtNoCans.WinTop = 66;
		txtNoCans.WinHeight = 42;
		txtNoCans.WinWidth = 268;
	  txtNoCans.bBoundToParent = true;
	  txtNoCans.TextColor = class'DXR_Menu'.static.GetPlayerInterfaceTextLabels(gl.MenuThemeIndex);
	  txtNoCans.TextFont="UT2SmallFont";
	  txtNoCans.bMultiLine = true;
	  txtNoCans.TextAlign = TXTA_Center;
	  txtNoCans.VertAlign = TXTA_Center;
	  txtNoCans.FontScale = FNS_Small;
		AppendComponent(txtNoCans, true);
	}
}

// ----------------------------------------------------------------------
// ButtonActivated()
// ----------------------------------------------------------------------

function bool InternalOnClick(GUIComponent Sender)
{
	if (Sender==btnInstall)
			InstallAugmentation();
	else if (Sender.IsA('MedBotAugItemButton'))
      SelectAugmentation(MedBotAugItemButton(Sender));
	else if (Sender.IsA('PersonaAugmentationItemButton'))
      Super.SelectAugmentation(PersonaAugmentationItemButton(Sender));

	return true;
}

// ----------------------------------------------------------------------
// SelectAugmentation()
// ----------------------------------------------------------------------

function SelectAugmentation(PersonaItemButton buttonPressed)
{
//  log("buttonPressed="$buttonPressed);
	// Don't do extra work.
	if (selectedAugButton != buttonPressed)
	{
		// Deselect current button
		if (selectedAugButton != None)
			selectedAugButton.SelectButton(False);

		selectedAugButton = buttonPressed;
		selectedAug       = Augmentation(selectedAugButton.GetClientObject());

		// Check to see if this augmentation has already been installed
		if (MedBotAugItemButton(buttonPressed).bHasIt)
		{
			augDescArea.SetContent("");
			lTitle2.Caption = selectedAug.AugmentationName;
			augDescArea.SetContent(AlreadyHasItText);
			augDescArea.AddText(SelectAnotherText);
			selectedAug = None;
			selectedAugButton = None;
		}
		else if (MedBotAugItemButton(buttonPressed).bSlotFull) 
		{
			augDescArea.SetContent("");
			lTitle2.Caption = selectedAug.AugmentationName;
			augDescArea.SetContent(SlotFullText);
			augDescArea.AddText(SelectAnotherText);
			selectedAug = None;
			selectedAugButton = None;
		}
		else
		{
			selectedAug.UsingMedBot(True);
			lTitle2.Caption = selectedAug.AugmentationName;
			selectedAug.UpdateInfo(augDescArea);
			selectedAugButton.SelectButton(True);
		}
		EnableButtons();
	}
}

// ----------------------------------------------------------------------
// InstallAugmentation()
// ----------------------------------------------------------------------

function InstallAugmentation()
{
	local AugmentationCannisterInv augCan;
	local Augmentation aug;

	if (MedBotAugItemButton(selectedAugButton) == None)
		return;
		
	// Get pointers to the AugmentationCannister and the 
	// Augmentation Class

	augCan = MedBotAugItemButton(selectedAugButton).GetAugCan();
	aug    = MedBotAugItemButton(selectedAugButton).GetAugmentation();

	// Add this augmentation (if we can get this far, then the augmentation
	// to be added is a valid one, as the checks to see if we already have
	// the augmentation and that there's enough space were done when the 
	// AugmentationAddButtons were created)

	player.AugmentationSystem.GivePlayerAugmentation(aug.class);

	// play a cool animation
	medBot.PlayAnim('Scan');

	// Now Destroy the Augmentation cannister
	player.DeleteInventory(augCan);

	// Now remove the cannister from our list
	selectedAugButton.free();//GetParent().Destroy();
	selectedAugButton = None;
	selectedAug       = None;

	// Update the Installed Augmentation Icons
	DestroyAugmentationButtons();
	CreateAugmentationButtons();

	// Need to update the aug list
	PopulateAugCanList();

	EnableButtons();
}

// ----------------------------------------------------------------------
// DestroyAugmentationButtons()
// ----------------------------------------------------------------------

function DestroyAugmentationButtons()
{
	local int i;

	for (i=0; i<winAugsTile.controls.length; i++)
	{
//	  if (winAugsTile.controls[i].IsA('MedBotAugCanWindow'))
//	  {
	    winAugsTile.controls[i].free();
      RemoveComponent(winAugsTile.controls[i], false);
//	  }
	}
	if (winAugsTile != none)
	    winAugsTile.free();
}

// ----------------------------------------------------------------------
// EnableButtons()
// ----------------------------------------------------------------------

function EnableButtons()
{
	// Only enable the Install button if the player has an
	// Augmentation Cannister aug button selected
	if (MedBotAugItemButton(selectedAugButton) != None)
	{
		btnInstall.EnableMe();
	}
	else
	{
		btnInstall.DisableMe();
	}
}

function alignButtons()
{
	local int i, aY;

	aY = -40;

	for (i=0; i<winAugsTile.controls.length; i++)
	{
	  if (winAugsTile.controls[i].IsA('MedBotAugCanWindow'))
	  {
      MedBotAugCanWindow(winAugsTile.controls[i]).winTop = 0;
	    MedBotAugCanWindow(winAugsTile.controls[i]).winTop = aY += 40;
	  }
	}
}

// ----------------------------------------------------------------------
// SkipAnimation()
// ----------------------------------------------------------------------

function SkipAnimation(bool bNewSkipAnimation)
{
	bSkipAnimation = bNewSkipAnimation;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
defaultproperties
{
    lfSizeYb=257
    rfSizeYb=240
    mfSizeYb=240

    bMedBotMode=true
    AvailableAugsText="Available Augmentations"
    InstallButtonLabel="Install"
    NoCansAvailableText="No Augmentation Cannisters Available!"
    AlreadyHasItText="You already have this augmentation, therefore you cannot install it a second time."
    SlotFullText="The slot that this augmentation occupies is already full, therefore you cannot install it."
    SelectAnotherText="Please select another augmentation to install."
}

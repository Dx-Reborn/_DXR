/* ... */

class gui_Augmentations extends PlayerInterfacePanel;

var localized String AugmentationsTitleText;
var localized String UpgradeButtonLabel;
var localized String ActivateButtonLabel;
var localized String DeactivateButtonLabel;
var localized String UseCellButtonLabel;
var localized String AugCanUseText;
var localized String BioCellUseText;

var Localized string AugLocationDefault;
var Localized string AugLocationCranial;
var Localized string AugLocationEyes;
var Localized string AugLocationArms;
var Localized string AugLocationLegs;
var Localized string AugLocationTorso;
var Localized string AugLocationSubdermal;

var int augSlotSpacingX;
var int augSlotSpacingY;

struct AugLoc_S
{
	var() int x;
	var() int y;
};
var() AugLoc_S augLocs[7];

var GUIButton btnUpgrade, btnActivate, btnUseCell;
var GUIImage iAugsBG, iAugsOVR, iAugsBody;
var GUIImage iconCells, iconUpgrades;
var GUILabel lCountBiocells, lCountUpgrades;
var GUILabel lmsg, lTitle, lTitle2;
var GUILabel lUseUpg, lUseCell;

var() GUIProgressBar prEnergy;
var() Augmentation selectedAug;
var() GUIScrollTextBox AugDescArea;
var() /*PersonaAugmentationItemButton*/ PersonaItemButton augItems[12];
var() /*PersonaAugmentationItemButton*/ PersonaItemButton selectedAugButton;

/* Frames positioning */
var(leftPart) float lFrameX, lframeY, lfSizeX, lfSizeY;
var(midPart) float mFrameX, mframeY, mfSizeX, mfSizeY;
var(rightPart) float rFrameX, rframeY, rfSizeX, rfSizeY;

var(BleftPart) float lFrameXb, lframeYb, lfSizeXb, lfSizeYb;
var(BmidPart) float mFrameXb, mframeYb, mfSizeXb, mfSizeYb;
var(BrightPart) float rFrameXb, rframeYb, rfSizeXb, rfSizeYb;

var bool bMedBotMode;



function ShowPanel(bool bShow)
{
  super.ShowPanel(bShow);
  if (bShow) 
    {
     PlayerOwner().pawn.PlaySound(Sound'Menu_OK');
     EnableButtons();
     UpdateAugCans();
     UpdateBioCells();
    }
}

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	Super.Initcomponent(MyController, MyOwner);
	CreateMyControls();
}

function CreateMyControls()
{
  iAugsBG = new(none) class'GUIImage'; 
  iAugsBG.Image=texture'DXR_AugmentationsBackground';
  iAugsBG.bBoundToParent = true;
  iAugsBG.tag = 75;
	iAugsBG.WinHeight = 448;
  iAugsBG.WinWidth = 640;
  iAugsBG.WinLeft = 74;
  iAugsBG.WinTop = 32;
	AppendComponent(iAugsBG, true);

	iAugsBody = new(none) class'GUIImage';
	iAugsBody.Image = texture'DXR_AugmentationsBody';
  iAugsBody.bBoundToParent = true;
	iAugsBody.WinHeight = 384;
  iAugsBody.WinWidth = 256;
  iAugsBody.WinLeft = 146;
  iAugsBody.WinTop = 60;
	AppendComponent(iAugsBody, true);

	iAugsOVR = new(none) class'GUIImage';
	iAugsOVR.Image=texture'DXR_AugmentationsOverlays';
  iAugsOVR.bBoundToParent = true;
  iAugsOVR.tag = 75;
	iAugsOVR.WinHeight = 384;
  iAugsOVR.WinWidth = 256;
  iAugsOVR.WinLeft = 146;
  iAugsOVR.WinTop = 60;
	AppendComponent(iAugsOVR, true);

	AugDescArea = new(none) class'GUIScrollTextBox';
  AugDescArea.StyleName="STY_DXR_DeusExScrollTextBox";
  AugDescArea.FontScale=FNS_Small;
  AugDescArea.bBoundToParent = true;
	AugDescArea.WinHeight = 216;
  AugDescArea.WinWidth = 267;
  AugDescArea.WinLeft = 423;
  AugDescArea.WinTop = 66;
  AugDescArea.bRepeat = false;//true;
  AugDescArea.bNoTeletype = true;
  AugDescArea.EOLDelay = 0.1;//75;
  AugDescArea.CharDelay = 0.005;
  AugDescArea.RepeatDelay = 3.0;
  AugDescArea.MyScrollBar.WinWidth = 16;
	AppendComponent(AugDescArea, true);

	if (!bMedBotMode) // когда это окно использует МедБот, некоторые элементы не создаются.
	{
	btnUpgrade = new(none) class'GUIButton';
  btnUpgrade.FontScale = FNS_Small;
  btnUpgrade.Caption = UpgradeButtonLabel;
  btnUpgrade.Hint = "";
  btnUpgrade.StyleName="STY_DXR_ButtonNavbar";
  btnUpgrade.bBoundToParent = true;
  btnUpgrade.OnClick = InternalOnClick;
  btnUpgrade.WinHeight = 22;
  btnUpgrade.WinWidth = 87;
  btnUpgrade.WinLeft = 187;
  btnUpgrade.WinTop = 439;
	AppendComponent(btnUpgrade, true);

	btnActivate = new(none) class'GUIButton';
  btnActivate.FontScale = FNS_Small;
  btnActivate.Caption = ActivateButtonLabel;
  btnActivate.Hint = "";
  btnActivate.StyleName="STY_DXR_ButtonNavbar";
  btnActivate.bBoundToParent = true;
  btnActivate.OnClick = InternalOnClick;
  btnActivate.WinHeight = 22;
  btnActivate.WinWidth = 99;
  btnActivate.WinLeft = 87;
  btnActivate.WinTop = 439;
	AppendComponent(btnActivate, true);

	btnUseCell = new(none) class'GUIButton';
  btnUseCell.FontScale = FNS_Small;
  btnUseCell.Caption = UseCellButtonLabel;
  btnUseCell.Hint = "";
  btnUseCell.StyleName="STY_DXR_ButtonNavbar";
  btnUseCell.bBoundToParent = true;
  btnUseCell.OnClick = InternalOnClick;
  btnUseCell.WinHeight = 22;
  btnUseCell.WinWidth = 97;
  btnUseCell.WinLeft = 420;
  btnUseCell.WinTop = 437;
	AppendComponent(btnUseCell, true);

	iconCells = new(none) class'GUIImage';
	iconCells.Image = texture'LargeIconBioCell';
  iconCells.bBoundToParent = true;
	iconCells.WinHeight = 48;
  iconCells.WinWidth = 48;
  iconCells.WinLeft = 425;
  iconCells.WinTop = 390;
	AppendComponent(iconCells, true);

  iconUpgrades = new(none) class'GUIImage';
	iconUpgrades.Image = texture'LargeIconAugmentationUpgrade';
  iconUpgrades.bBoundToParent = true;
	iconUpgrades.WinHeight = 48;
  iconUpgrades.WinWidth = 48;
  iconUpgrades.WinLeft = 434;
  iconUpgrades.WinTop = 329;
	AppendComponent(iconUpgrades, true);

	lCountBiocells = new(none) class'GUILabel';
	lCountBiocells.WinLeft = 421;
	lCountBiocells.WinTop = 415;
	lCountBiocells.WinHeight = 20;
	lCountBiocells.WinWidth = 52;
	lCountBiocells.caption = "cells";
  lCountBiocells.bBoundToParent = true;
  lCountBiocells.TextColor = class'DXR_Menu'.static.GetPlayerInterfaceTextLabels(gl.MenuThemeIndex);
  lCountBiocells.TextFont="UT2HeaderFont";
  lCountBiocells.bMultiLine = false;
  lCountBiocells.TextAlign = TXTA_Center;
  lCountBiocells.VertAlign = TXTA_Center;
  lCountBiocells.FontScale = FNS_Small;
  AppendComponent(lCountBiocells, true);

	lCountUpgrades = new(none) class'GUILabel';
	lCountUpgrades.WinLeft = 421;
	lCountUpgrades.WinTop = 358;
	lCountUpgrades.WinHeight = 20;
	lCountUpgrades.WinWidth = 52;
	lCountUpgrades.caption = "upgrades";
  lCountUpgrades.bBoundToParent = true;
  lCountUpgrades.TextColor = class'DXR_Menu'.static.GetPlayerInterfaceTextLabels(gl.MenuThemeIndex);
  lCountUpgrades.TextFont="UT2HeaderFont";
  lCountUpgrades.bMultiLine = false;
  lCountUpgrades.TextAlign = TXTA_Center;
  lCountUpgrades.VertAlign = TXTA_Center;
  lCountUpgrades.FontScale = FNS_Small;
  AppendComponent(lCountUpgrades, true);

	prEnergy = new(none) class'GUIProgressBar';
  prEnergy.FontName="UT2HeaderFont";
 	prEnergy.WinHeight = 20;
  prEnergy.WinWidth = 172;
  prEnergy.WinLeft = 519;
  prEnergy.WinTop = 438;
  prEnergy.High = DeusExPlayer(PlayerOwner().pawn).EnergyMax;
	prEnergy.CaptionWidth = 0.0; //0.45;
  prEnergy.bBoundToParent = true;
  prEnergy.bShowLow = true;
  prEnergy.bShowHigh = true;
  prEnergy.ValueRightWidth = 0.0;
  prEnergy.Caption = "test";
  prEnergy.BarBack = Material'MenuTitleBubble_Center'; // The unselected portion of the bar
  prEnergy.BarTop = Material'Solid'; // The selected portion of the bar
  prEnergy.OnRendered = pr_OnRendered; // Delegate assign
	AppendComponent(prEnergy, true);
	}

	lmsg = new(none) class'GUILabel';
	lmsg.WinLeft = 423;
	lmsg.WinTop = 286;
	lmsg.WinHeight = 20;
	lmsg.WinWidth = 267;
//	lmsg.caption = "message";
  lmsg.bBoundToParent = true;
  lmsg.TextColor = class'DXR_Menu'.static.GetPlayerInterfaceTextLabels(gl.MenuThemeIndex);
  lmsg.TextFont="UT2SmallFont";
  lmsg.bMultiLine = false;
  lmsg.TextAlign = TXTA_Left;
  lmsg.VertAlign = TXTA_Center;
  lmsg.FontScale = FNS_Small;
	AppendComponent(lmsg, true);

	lTitle = new(none) class'GUILabel';
	lTitle.WinLeft = 85;
	lTitle.WinTop = 33;
	lTitle.WinHeight = 20;
	lTitle.WinWidth = 150;
	lTitle.caption = "Augmentations";
  lTitle.bBoundToParent = true;
  lTitle.TextColor = class'DXR_Menu'.static.GetPlayerInterfaceHDR(gl.MenuThemeIndex);
  lTitle.TextFont="UT2HeaderFont";
  lTitle.bMultiLine = false;
  lTitle.TextAlign = TXTA_Left;
  lTitle.VertAlign = TXTA_Center;
  lTitle.FontScale = FNS_Small;
	AppendComponent(lTitle, true);

	lTitle2 = new(none) class'GUILabel';
	lTitle2.WinLeft = 423;
	lTitle2.WinTop = 43;
	lTitle2.WinHeight = 20;
	lTitle2.WinWidth = 267;
//	lTitle2.caption = "Augmentation title";
  lTitle2.bBoundToParent = true;
  lTitle2.TextColor = class'DXR_Menu'.static.GetPlayerInterfaceTextLabels(gl.MenuThemeIndex);
  lTitle2.TextFont="UT2HeaderFont";
  lTitle2.bMultiLine = false;
  lTitle2.TextAlign = TXTA_Left;
  lTitle2.VertAlign = TXTA_Center;
  lTitle2.FontScale = FNS_Small;
	AppendComponent(lTitle2, true);

	if (!bMedBotMode)
	{
	lUseUpg = new(none) class'GUILabel';
	lUseUpg.WinLeft = 475;
	lUseUpg.WinTop = 327;
	lUseUpg.WinHeight = 49;
	lUseUpg.WinWidth = 215;
	lUseUpg.caption = AugCanUseText;
  lUseUpg.bBoundToParent = true;
  lUseUpg.TextColor = class'DXR_Menu'.static.GetPlayerInterfaceTextLabels(gl.MenuThemeIndex);
  lUseUpg.TextFont="UT2SmallFont";
  lUseUpg.bMultiLine = true;
  lUseUpg.TextAlign = TXTA_Left;
  lUseUpg.VertAlign = TXTA_Center;
  lUseUpg.FontScale = FNS_Small;
	AppendComponent(lUseUpg, true);

  lUseCell = new(none) class'GUILabel';
	lUseCell.WinLeft = 475;
	lUseCell.WinTop = 384;
	lUseCell.WinHeight = 49;
	lUseCell.WinWidth = 215;
	lUseCell.caption = BioCellUseText;
  lUseCell.bBoundToParent = true;
  lUseCell.TextColor = class'DXR_Menu'.static.GetPlayerInterfaceTextLabels(gl.MenuThemeIndex);
  lUseCell.TextFont="UT2SmallFont";
  lUseCell.bMultiLine = true;
  lUseCell.TextAlign = TXTA_Left;
  lUseCell.VertAlign = TXTA_Center;
  lUseCell.FontScale = FNS_Small;
	AppendComponent(lUseCell, true);
	}

  CreateAugmentationButtons();
  CreateAugmentationLabels();

 	ApplyTheme();
}

/* When ProgressBar  is rendered...*/
function pr_OnRendered(canvas C)
{
  if (playerOwner().pawn != none)
  {
   prEnergy.BarColor = class'Actor'.static.GetColorScaled(DeusExPlayer(playerOwner().pawn).Energy * 0.01);
   prEnergy.Value = DeusExPlayer(PlayerOwner().pawn).Energy;
   c.SetPos(prEnergy.ActualLeft() + 20,prEnergy.ActualTop() + 5);
   c.SetDrawColor(220,220,220,255);
   c.font = font'FontMenuHeaders_DS';
   c.DrawText(DeusExPlayer(playerOwner().pawn).Energy$" %");
  }
}

function GetAugInfo()
{
//  local string strOut;

    lTitle2.Caption = selectedAug.AugmentationName;
/*    AugDescArea.SetContent(selectedAug.description$"|");
    strOut = class'Actor'.static.Sprintf(selectedAug.CurrentLevelLabel, selectedAug.CurrentLevel + 1);
	
	// Can Upgrade / Is Active labels
    if (selectedAug.CanBeUpgraded())
        strOut = strOut @ selectedAug.CanUpgradeLabel;

    else if (selectedAug.CurrentLevel == selectedAug.MaxLevel)
        strOut = strOut @ selectedAug.MaximumLabel;

        AugDescArea.AddText(strOut);

	// Always Active?
    if (selectedAug.bAlwaysActive)
        AugDescArea.AddText(selectedAug.AlwaysActiveLabel);*/
}

function bool InternalOnClick(GUIComponent Sender)
{
  if (Sender.IsA('PersonaAugmentationItemButton'))
  {
/*    selectedAugButton = PersonaAugmentationItemButton(Sender);
    selectedAug = PersonaAugmentationItemButton(Sender).aug;
    GetAugInfo();
    EnableButtons();*/
    SelectAugmentation(PersonaAugmentationItemButton(Sender));
  }
  if (Sender==btnActivate)
  {
    ActivateAugmentation();
  }
  if (Sender==btnUpgrade)
  {
    UpgradeAugmentation();
  }
  if (Sender==btnUseCell)
  {
    UseCell();
  }
  return false;
}

function UpdateAugCans()
{
   local AugmentationUpgradeCannisterInv augCan;

   if (bMedBotMode)
   return;

   augCan = AugmentationUpgradeCannisterInv(PlayerOwner().pawn.FindInventoryType(Class'AugmentationUpgradeCannisterInv'));
   if (augCan != none)
   {
     if (augCan.NumCopies == 0)
         augCan.NumCopies = 1;
     lCountUpgrades.caption="x "$augCan.NumCopies;
   }
   else
   lCountUpgrades.caption="x 0";
}

function UpdateBioCells()
{
   local BioelectricCellInv bioCell;

   if (bMedBotMode)
   return;

		bioCell = BioelectricCellInv(PlayerOwner().pawn.FindInventoryType(Class'BioelectricCellInv'));
		if (bioCell != None)
		{
		 if (bioCell.NumCopies == 0)
		     bioCell.NumCopies = 1;
		 lCountBiocells.Caption="x "$bioCell.NumCopies;
		}
		else
		lCountBiocells.Caption="x 0";
}

function SelectAugmentation(PersonaItemButton buttonPressed)
{
	// Don't do extra work.
	if (selectedAugButton != buttonPressed)
	{
		// Deselect current button
		if (selectedAugButton != None)
			selectedAugButton.SelectButton(False);

		selectedAugButton = buttonPressed;
		selectedAug       = Augmentation(selectedAugButton.GetClientObject());

		selectedAug.UpdateInfo(AugDescArea);
		selectedAugButton.SelectButton(True);
		GetAugInfo();//

		EnableButtons();
	}
}

function UpgradeAugmentation()
{
	local AugmentationUpgradeCannisterInv augCan;

  if (bMedBotMode)
  return;

	// First make sure we have a selected Augmentation
	if (selectedAug == None)
		return;

	// Now check to see if we have an upgrade cannister
	augCan = AugmentationUpgradeCannisterInv(playerOwner().pawn.FindInventoryType(class'AugmentationUpgradeCannisterInv'));

	if (augCan != None)
	{
		// Increment the level and remove the aug cannister from
		// the player's inventory
		selectedAug.IncLevel();
    GetAugInfo();
		selectedAug.UpdateInfo(AugDescArea);
		augCan.UseOnce();
    lmsg.Caption = class'Actor'.static.Sprintf(selectedAug.AugNowHave, selectedAug.AugmentationName, selectedAug.CurrentLevel + 1);

		// Update the level icons
//		if (selectedAugButton != None)
//			PersonaAugmentationItemButton(selectedAugButton).SetLevel(selectedAug.GetCurrentLevel());
	}
	UpdateAugCans();
	EnableButtons();
}

function ActivateAugmentation()
{
	if (selectedAug == None)
		return;

  if (bMedBotMode)
  return;
	
	if (selectedAug.IsActive())
	{
		selectedAug.Deactivate();
    lmsg.Caption = class'Actor'.static.Sprintf(selectedAug.AugDeActivated, selectedAug.AugmentationName);
	}
	else
	{
		selectedAug.Activate();
    lmsg.Caption = class'Actor'.static.Sprintf(selectedAug.AugActivated, selectedAug.AugmentationName);
	}

	// If the augmentation activated or deactivated, set the 
	// button appropriately.

	if (selectedAugButton != None)
		selectedAugButton.SetActive(selectedAug.IsActive());

    GetAugInfo();
//		PersonaAugmentationItemButton(selectedAugButton).SetActive(selectedAug.IsActive());
	selectedAug.UpdateInfo(AugDescArea);

	EnableButtons();
}

function UseCell()
{
	local BioelectricCellInv bioCell;

	bioCell = BioelectricCellInv(playerOwner().pawn.FindInventoryType(Class'BioelectricCellInv'));

	if (bioCell != None)
		bioCell.UseOnce();
		
	UpdateBioCells();
	EnableButtons();
}

function EnableButtons()
{
	// Upgrade can only be enabled if the player has an
	// AugmentationUpgradeCannister that allows this augmentation to 
	// be upgraded
  if ((selectedAug != none) && (selectedAug.CanBeUpgraded()))
      btnUpgrade.EnableMe();
      else
      btnUpgrade.DisableMe();

	// Only allow btnActivate to be active if 
  // 1.  We have a selected augmentation 
	// 2.  The player's energy is above 0
	// 3.  This augmentation isn't "AlwaysActive"

	if ((selectedAug != none) && (DeusExPlayer(PlayerOwner().pawn).Energy > 0) && (!selectedAug.IsAlwaysActive()))
	   btnActivate.EnableMe(); else btnActivate.DisableMe();

	if (selectedAug != None)
	{
		if (selectedAug.bIsActive)
			btnActivate.Caption=DeactivateButtonLabel;
		else
			btnActivate.Caption=ActivateButtonLabel;
	}

	// Use Cell button
	// Only active if the player has one or more Energy Cells and 
  // BioElectricEnergy < 100%
	if ((DeusExPlayer(playerOwner().pawn).Energy < DeusExPlayer(playerOwner().pawn).EnergyMax) && (playerOwner().pawn.FindInventoryType(Class'BioelectricCellInv') != None))
	   btnUseCell.EnableMe(); else btnUseCell.DisableMe();

}

function CreateLabel(int posX, int posY, String strLabel)
{
	local GUIlabel winLabel;

	winLabel = new(none) class'GUILabel';
	winLabel.WinLeft = posX;
	winLabel.WinTop = posY;
	winLabel.WinHeight = 20;
	winLabel.WinWidth = 52;
	winLabel.caption = strLabel;

  winLabel.bBoundToParent = true;
  winLabel.TextColor = class'DXR_Menu'.static.GetPlayerInterfaceTextLabels(gl.MenuThemeIndex);
  winLabel.TextFont="UT2SmallFont";
  winLabel.bMultiLine = false;
  winLabel.TextAlign = TXTA_Left;
  winLabel.VertAlign = TXTA_Center;
  winLabel.FontScale = FNS_Small;
  AppendComponent(winLabel, true);
}

function CreateAugmentationLabels()
{
                         //left X 74   Top Y 32
	CreateLabel(131,  56, AugLocationCranial); //	CreateLabel( 57,  27, AugLocationCranial);
	CreateLabel(286,  56, AugLocationEyes);   //	CreateLabel(212,  27, AugLocationEyes);
	CreateLabel(93, 132, AugLocationArms);     //	CreateLabel( 19, 103, AugLocationArms);
	CreateLabel(93, 216, AugLocationSubdermal);  //	CreateLabel( 19, 187, AugLocationSubdermal);
	CreateLabel(321, 138, AugLocationTorso); // 	CreateLabel(247, 109, AugLocationTorso);
	CreateLabel(93, 359, AugLocationDefault); // 	CreateLabel( 19, 330, AugLocationDefault);
	CreateLabel(321, 340, AugLocationLegs); // 	CreateLabel(247, 311, AugLocationLegs);
}

function PersonaAugmentationItemButton CreateAugButton(Augmentation anAug, int augX, int augY, int slotIndex)
{
	local PersonaAugmentationItemButton newButton;

	newButton = new(none) class'PersonaAugmentationItemButton';
	newButton.OnClick = InternalOnClick;
	newButton.WinLeft = augX;
	newButton.WinTop = augY;

	//newButton.aug = anAug;
	newButton.SetClientObject(anAug);

	// set the hotkey number
	if (!anAug.bAlwaysActive)
		newButton.SetHotkeyNumber(anAug.GetHotKey());

	// If the augmentation is currently active, notify the button
	newButton.SetActive(anAug.IsActive());
	newButton.SetLevel(anAug.GetCurrentLevel());
	AppendComponent(newButton, true);

	return newButton;
}

function CreateAugmentationButtons()
{
	local Augmentation anAug;
	local int augX, augY;
	local int torsoCount;
	local int skinCount;
	local int defaultCount;
	local int slotIndex;
	local int augCount;

	augCount   = 0;
	torsoCount = 0;
	skinCount  = 0;
	defaultCount = 0;

	// Iterate through the augmentations, creating a unique button for each
	anAug = DeusExplayer(playerOwner().pawn).AugmentationSystem.FirstAug;
	while(anAug != None)
	{
		if (( anAug.AugmentationName != "" ) && ( anAug.bHasIt ))
		{
			slotIndex = 0;
			augX = augLocs[int(anAug.AugmentationLocation)].x;
			augY = augLocs[int(anAug.AugmentationLocation)].y;

			// Show the highlight graphic for this augmentation slot as long
			// as it's not the Default slot (for which there is no graphic)

//			if (anAug.AugmentationLocation < arrayCount(augHighlightWindows))
//				augHighlightWindows[anAug.AugmentationLocation].Show();

			if (int(anAug.AugmentationLocation) == 2)			// Torso
			{
				slotIndex = torsoCount;
				augY += (torsoCount++ * augSlotSpacingY);
			}

			if (int(anAug.AugmentationLocation) == 5)			// Subdermal
			{
				slotIndex = skinCount;
				augY += (skinCount++ * augSlotSpacingY);
			}

			if (int(anAug.AugmentationLocation) == 6)			// Default
				augX += (defaultCount++ * augSlotSpacingX);

			augItems[augCount] = CreateAugButton(anAug, augX, augY, slotIndex);

			// If the augmentation is active, make sure the button draws it 
			// appropriately
			augItems[augCount].SetActive(anAug.IsActive());
			augCount++;
		}
		anAug = anAug.next;
	}	
}

function PaintFrames(canvas u)
{
  local float x,y;

  x = ActualLeft(); y = ActualTop();

//  u.SetDrawColor(0,255,0,128);
  u.DrawColor = class'DXR_Menu'.static.GetPlayerInterfaceFrames(gl.MenuThemeIndex);
  u.Style = EMenuRenderStyle.MSTY_Translucent;

  u.SetPos(x + lFrameX, y + lframeY);
  u.drawtileStretched(texture'AugmentationsBorder_1', lfSizeX, lfSizeY);

  u.SetPos(x + mFrameX, y + mframeY);
  u.drawtileStretched(texture'AugmentationsBorder_2', mfSizeX, mfSizeY);

  u.SetPos(x + rFrameX, y + rframeY);
  u.drawtileStretched(texture'AugmentationsBorder_3', rfSizeX, rfSizeY);
/*-----------------*/
  u.SetPos(x + lFrameXb, y + lframeYb);
  u.drawtileStretched(texture'AugmentationsBorder_4', lfSizeXb, lfSizeYb);

  u.SetPos(x + mFrameXb, y + mframeYb); 
  u.drawtileStretched(texture'DXR_AugmentationsBorder_5', mfSizeXb, mfSizeYb); 

  u.SetPos(x + rFrameXb, y + rframeYb);
  u.drawtileStretched(texture'AugmentationsBorder_6', rfSizeXb, rfSizeYb);
}



defaultproperties
{
// Top frames (six textures used) //
 lFrameX=48
 lframeY=26
 lfSizeX=257
 lfSizeY=257

 mFrameX=305
 mframeY=26
 mfSizeX=287
 mfSizeY=274

 rFrameX=592
 rframeY=26
 rfSizeX=128
 rfSizeY=274

//bottom//

 lFrameXb=48
 lframeYb=283
 lfSizeXb=257
 lfSizeYb=263//

 mFrameXb=305
 mframeYb=300
 mfSizeXb=351
 mfSizeYb=264

 rFrameXb=656
 rframeYb=300
 rfSizeXb=64
 rfSizeYb=264

 OnRendered=PaintFrames

    AugLocs(0)=(X=130,Y=70) //    AugLocs(0)=(X=56,Y=38),
    AugLocs(1)=(X=284,Y=70) //    AugLocs(1)=(X=211,Y=38),
    AugLocs(2)=(X=320,Y=152) //    AugLocs(2)=(X=246,Y=120),
    AugLocs(3)=(X=91,Y=146)  //    AugLocs(3)=(X=18,Y=114),
    AugLocs(4)=(X=319,Y=354) //    AugLocs(4)=(X=246,Y=322),
                         //left X 74   Top Y 32
    AugLocs(5)=(X=91,Y=230)  //    AugLocs(5)=(X=18,Y=198),
    AugLocs(6)=(X=91,Y=373)  //    AugLocs(6)=(X=18,Y=341),

    augSlotSpacingX=53
    augSlotSpacingY=59

    AugmentationsTitleText="Augmentations"
    UpgradeButtonLabel="Upgrade"
    ActivateButtonLabel="Activate"
    DeactivateButtonLabel="Deactivate"
    UseCellButtonLabel="Use Cell"
    AugCanUseText="To upgrade an Augmentation, click on the Augmentation you wish to upgrade, then on the Upgrade button."
    BioCellUseText="To replenish Bioelectric Energy for your Augmentations, click on the Use Cell button."
    AugLocationDefault="Default"
    AugLocationCranial="Cranial"
    AugLocationEyes="Eyes"
    AugLocationArms="Arms"
    AugLocationLegs="Legs"
    AugLocationTorso="Torso"
    AugLocationSubdermal="Skin"//"Subdermal"
    bMedBotMode=false
}

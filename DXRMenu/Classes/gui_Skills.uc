/* Экран навыков игрока */

class gui_Skills extends PlayerInterfacePanel;

var GUIImage iSkills;
var GUIButton bUpgrade;
var GUIScrollTextBox SkillInfo;
var GUILabel winStatus, winhdr2;
var GUILabel lTitle, lPointsHeader, lPointsNeededHeader, lLevelHeader, lPointsAvailable;
var localized string SkillsTitleText, UpgradeButtonLabel, PointsNeededHeaderText, strAnyText;
var localized string SkillLevelHeaderText, SkillPointsHeaderText, SkillUpgradedLevelLabel;

var() PersonaSkillButtonWindow skillButtons[15];
var() PersonaSkillButtonWindow selectedSkillButton;
var() editconst Skill selectedSkill;

/* Frames positioning */
var(leftPart) float lFrameX, lframeY, lfSizeX, lfSizeY;
var(midPart) float mFrameX, mframeY, mfSizeX, mfSizeY;
var(rightPart) float rFrameX, rframeY, rfSizeX, rfSizeY;

var(BleftPart) float lFrameXb, lframeYb, lfSizeXb, lfSizeYb;
var(BmidPart) float mFrameXb, mframeYb, mfSizeXb, mfSizeYb;
var(BrightPart) float rFrameXb, rframeYb, rfSizeXb, rfSizeYb;


function ShowPanel(bool bShow)
{
  super.ShowPanel(bShow);
  if (bShow) 
     PlayerOwner().pawn.PlaySound(Sound'Menu_OK',SLOT_Interface,0.25);
}

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	Super.Initcomponent(MyController, MyOwner);
	CreateMyControls();
}

function CreateMyControls()
{
  SkillInfo = new(none) class'GUIScrollTextBox'; // описание
  SkillInfo.StyleName="STY_DXR_DeusExScrollTextBox";
  SkillInfo.bBoundToParent = true;
  SkillInfo.FontScale=FNS_Small;
	SkillInfo.WinHeight = 371;
  SkillInfo.WinWidth = 279;
  SkillInfo.WinLeft = 430;
  SkillInfo.WinTop = 75;
  SkillInfo.bRepeat = false;//true; 
  SkillInfo.bNoTeletype = false;//true; Forgive... my vision is augmented ;)
  SkillInfo.EOLDelay = 0.01;//75;
  SkillInfo.CharDelay = 0.001;
  SkillInfo.RepeatDelay = 1.0;
  SkillInfo.MyScrollBar.WinWidth = 16;
	AppendComponent(SkillInfo, true);

  bUpgrade = new(none) class'GUIButton';
  bUpgrade.FontScale = FNS_Small;
  bUpgrade.Caption = UpgradeButtonLabel;
  bUpgrade.Hint = "Clear all current logs";
  bUpgrade.StyleName="STY_DXR_ButtonNavbar";
  bUpgrade.bBoundToParent = true;
  bUpgrade.OnClick = InternalOnClick;
  bUpgrade.WinHeight = 22;
  bUpgrade.WinWidth = 100;
  bUpgrade.WinLeft = 65;
  bUpgrade.WinTop = 460;
	AppendComponent(bUpgrade, true);

  iSkills = new(none) class'GUIImage'; 
  iSkills.Image=texture'DXR_SkillsBackground';
  iSkills.bBoundToParent = true;
	iSkills.WinHeight = 512;
  iSkills.WinWidth = 670;
  iSkills.WinLeft = 55;
  iSkills.WinTop = 32;
  iSkills.tag = 75;
	AppendComponent(iSkills, true);

  lPointsHeader = new(none) class'GUILabel';
  lPointsHeader.bBoundToParent = true;
  lPointsHeader.TextColor = class'DXR_Menu'.static.GetPlayerInterfaceTextLabels(gl.MenuThemeIndex);
  lPointsHeader.caption = SkillPointsHeaderText;
  lPointsHeader.TextFont="UT2HeaderFont";
  lPointsHeader.bMultiLine = true;
  lPointsHeader.TextAlign = TXTA_Right;
  lPointsHeader.VertAlign = TXTA_Center;
  lPointsHeader.FontScale = FNS_Small;
 	lPointsHeader.WinHeight = 26;
  lPointsHeader.WinWidth = 135;
  lPointsHeader.WinLeft = 168;
  lPointsHeader.WinTop = 459;
	AppendComponent(lPointsHeader, true);

	lPointsAvailable = new(none) class'GUILabel';
  lPointsAvailable.bBoundToParent = true;
  lPointsAvailable.TextColor = class'DXR_Menu'.static.GetPlayerInterfaceTextLabels(gl.MenuThemeIndex);
  lPointsAvailable.caption = string(DeusExPlayer(PlayerOwner().pawn).SkillPointsAvail);
  lPointsAvailable.TextFont="UT2HeaderFont";
  lPointsAvailable.bMultiLine = true;
  lPointsAvailable.TextAlign = TXTA_Center;
  lPointsAvailable.VertAlign = TXTA_Center;
  lPointsAvailable.FontScale = FNS_Small;
 	lPointsAvailable.WinHeight = 20;
  lPointsAvailable.WinWidth = 81;
  lPointsAvailable.WinLeft = 306;
  lPointsAvailable.WinTop = 462;
	AppendComponent(lPointsAvailable, true);

  lTitle = new(none) class'GUILabel';
  lTitle.bBoundToParent = true;
  lTitle.TextColor = class'DXR_Menu'.static.GetPlayerInterfaceHDR(gl.MenuThemeIndex);
  lTitle.caption = SkillsTitleText;
  lTitle.TextFont="UT2HeaderFont";
  lTitle.bMultiLine = false;
  lTitle.TextAlign = TXTA_Left;
  lTitle.VertAlign = TXTA_Center;
  lTitle.FontScale = FNS_Small;
 	lTitle.WinHeight = 20;
  lTitle.WinWidth = 120;
  lTitle.WinLeft = 62;
  lTitle.WinTop = 34;
	AppendComponent(lTitle, true);

	lLevelHeader = new(none) class'GUILabel';
  lLevelHeader.bBoundToParent = true;
  lLevelHeader.TextColor = class'DXR_Menu'.static.GetPlayerInterfaceTextLabels(gl.MenuThemeIndex);
  lLevelHeader.caption = "Skill and Level / Points required";
  lLevelHeader.TextFont="UT2HeaderFont";
  lLevelHeader.bMultiLine = true;
  lLevelHeader.TextAlign = TXTA_Center;
  lLevelHeader.VertAlign = TXTA_Center;
  lLevelHeader.FontScale = FNS_Small;
 	lLevelHeader.WinHeight = 20;
  lLevelHeader.WinWidth = 317;
  lLevelHeader.WinLeft = 68;
  lLevelHeader.WinTop = 53;
	AppendComponent(lLevelHeader, true);

	winStatus = new(none) class'GUILabel';
  winStatus.bBoundToParent = true;
  winStatus.TextColor = class'DXR_Menu'.static.GetPlayerInterfaceTextLabels(gl.MenuThemeIndex);
  winStatus.caption = "";
  winStatus.TextFont="UT2HeaderFont";
  winStatus.bMultiLine = true;
  winStatus.TextAlign = TXTA_Left;
  winStatus.VertAlign = TXTA_Center;
  winStatus.FontScale = FNS_Small;
 	winStatus.WinHeight = 20;
  winStatus.WinWidth = 280;
  winStatus.WinLeft = 428;
  winStatus.WinTop = 452;
	AppendComponent(winStatus, true);

	winHdr2 = new(none) class'GUILabel';
  winHdr2.bBoundToParent = true;
  winHdr2.TextColor = class'DXR_Menu'.static.GetPlayerInterfaceTextLabels(gl.MenuThemeIndex);
  winHdr2.caption = "";
  winHdr2.TextFont="UT2HeaderFont";
  winHdr2.bMultiLine = true;
  winHdr2.TextAlign = TXTA_Left;
  winHdr2.VertAlign = TXTA_Center;
  winHdr2.FontScale = FNS_Small;
 	winHdr2.WinHeight = 20;
  winHdr2.WinWidth = 280;
  winHdr2.WinLeft = 428;
  winHdr2.WinTop = 50;
	AppendComponent(winHdr2, true);

	ApplyTheme();

  CreateSkillsList();
}


function bool InternalOnClick(GUIComponent Sender)
{
  if (Sender==bUpgrade)
  {
    UpgradeSkill();
    lPointsAvailable.caption = string(DeusExPlayer(PlayerOwner().pawn).SkillPointsAvail);
  }
  if (Sender.IsA('PersonaSkillButtonWindow'))
  {
    lPointsAvailable.caption = string(DeusExPlayer(PlayerOwner().pawn).SkillPointsAvail);
    selectedSkill = PersonaSkillButtonWindow(Sender).GetSkill();
    SkillInfo.SetContent(selectedSkill.Description);
    winhdr2.caption = selectedSkill.SkillName;
    EnableButtons();
  }
  return false;
}


function UpgradeSkill()
{
	// First make sure we have a skill selected
	if (selectedSkill == None)
		return;

	selectedSkill.IncLevel();
//	selectedSkillButton.RefreshSkillInfo();

	// Send status message
	winStatus.Caption = class'Actor'.static.Sprintf(SkillUpgradedLevelLabel, selectedSkill.SkillName);
	
//	winSkillPoints.SetText(player.SkillPointsAvail);
		
	EnableButtons();
}

function EnableButtons()
{
  local DeusExPlayer p;

  p = DeusExPlayer(PlayerOwner().pawn);
	// Abort if a skill item isn't selected
	if (selectedSkill == None)
	{
    bUpgrade.DisableMe();
	}
	else
	{
		// Upgrade Skill only available if the skill is not at 
		// the maximum -and- the user has enough skill points
		// available to upgrade the skill
		if (!selectedSkill.CanAffordToUpgrade(p.SkillPointsAvail))
        bUpgrade.DisableMe();
         else
        bUpgrade.EnableMe();
	}
}


function CreateSkillsList()
{
  local int x;
	local Skill aSkill;
	local int buttonIndex;
	local PersonaSkillButtonWindow skillButton;
	local PersonaSkillButtonWindow firstButton;

	// Iterate through the skills, adding them to our list
	aSkill = DeusExPlayer(playerOwner().Pawn).SkillSystem.FirstSkill;
	while(aSkill != None)
	{
		if (aSkill.SkillName != "")
		{
		  x+=32;
			skillButton = new class'PersonaSkillButtonWindow';
			skillButton.OnClick=InternalOnClick;
			skillButton.SetSkill(aSkill);
      skillButton.WinTop=x;
			AppendComponent(skillButton, true);
			skillButtons[buttonIndex++] = skillButton;

			if (firstButton == None)
				firstButton = skillButton;
		}
		aSkill = aSkill.next;
	}

	// Select the first skill
	SkillButton.SetFocus(none);

  RealignSkills();
}

// ToDo: upend this "list"?
function RealignSkills()
{
  local int i;

   for (i=0; i<controls.length; i++)
   {
      if (controls[i].IsA('PersonaSkillButtonWindow'))
      {
        controls[i].WinLeft -=133;
        controls[i].WinTop +=39;
      }
   }
}

/*
    This is stub to close last empty slot for skills button.
    To remove it, remove or comment code, excluding PaintFrames().
    Or you can draw sth else instead ))))
*/
function InternalOnRendered(canvas u)
{
  u.setPos(ActualLeft() + 67 , ActualTop() + 423);
  u.Style = EMenuRenderStyle.MSTY_Alpha;
  u.DrawColor = class'DXR_Menu'.static.GetPlayerInterfaceTabsBackground(gl.MenuThemeIndex);
  u.DrawTileStretched(texture'ConWindowBackground', 319, 34);
  u.setPos(ActualLeft() + 70 , ActualTop() + 430);
  u.DrawColor = class'DXR_Menu'.static.GetPlayerInterfaceTextLabels(gl.MenuThemeIndex);
  u.font=font'MSS_9';
  u.DrawText(strAnyText);

  PaintFrames(u);
}

function PaintFrames(canvas u)
{
  local float x,y;

  x = ActualLeft(); y = ActualTop();

//  u.SetDrawColor(0,255,0,128);
  u.DrawColor = class'DXR_Menu'.static.GetPlayerInterfaceFrames(gl.MenuThemeIndex);
  u.Style = EMenuRenderStyle.MSTY_Translucent;

  u.SetPos(x + lFrameX, y + lframeY);
  u.drawtileStretched(texture'SkillsBorder_1', lfSizeX, lfSizeY);

  u.SetPos(x + mFrameX, y + mframeY);
  u.drawtileStretched(texture'SkillsBorder_2', mfSizeX, mfSizeY);

  u.SetPos(x + rFrameX, y + rframeY);
  u.drawtileStretched(texture'SkillsBorder_3', rfSizeX, rfSizeY);
/*-----------------*/
  u.SetPos(x + lFrameXb, y + lframeYb);
  u.drawtileStretched(texture'SkillsBorder_4', lfSizeXb, lfSizeYb);

  u.SetPos(x + mFrameXb, y + mframeYb); 
  u.drawtileStretched(texture'SkillsBorder_5', mfSizeXb, mfSizeYb); 

  u.SetPos(x + rFrameXb, y + rframeYb);
  u.drawtileStretched(texture'SkillsBorder_6', rfSizeXb, rfSizeYb);
}




defaultproperties
{
// Top frames (six textures used) //
 lFrameX=36
 lframeY=20
 lfSizeX=274
 lfSizeY=351

 mFrameX=310
 mframeY=20
 mfSizeX=299
 mfSizeY=351

 rFrameX=609
 rframeY=20
 rfSizeX=128
 rfSizeY=351

//bottom//

 lFrameXb=36
 lframeYb=371
 lfSizeXb=274
 lfSizeYb=261

 mFrameXb=310
 mframeYb=371
 mfSizeXb=363
 mfSizeYb=264

 rFrameXb=673
 rframeYb=371
 rfSizeXb=64
 rfSizeYb=256

    SkillsTitleText="Skills"
    UpgradeButtonLabel="Upgrade"
    PointsNeededHeaderText="Points Needed"
    SkillLevelHeaderText="Skill Level"
    SkillPointsHeaderText="Skill Points:    "
    SkillUpgradedLevelLabel="%s upgraded"
    strAnyText="Placeholder"
    onRendered=InternalOnRendered
}

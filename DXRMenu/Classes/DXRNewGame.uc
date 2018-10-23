/* -----------------------------------------------
  Начало новой игры, выбор навыков и внешности.
----------------------------------------------- */
class DXRNewGame extends DxWindowTemplate;

/* Переменные из MenuScreenNewGame.uc */
var Texture texPortraits[5];
var int     portraitIndex;
var Skill   selectedSkill;
var int     selectedRowId;
var int     saveSkillPointsAvail;
var int     saveSkillPointsTotal;
var float   combatDifficulty;
var Skill   localSkills[32];

var localized string strUpgrade, strDowngrade, strNameLabel, strCodeNameLabel;
var localized string strAppearanceLabel, strSkillsLabel, strSkillPointsLabel, strSkillLevelLabel, strPointsNeededLabel;
var localized string strCancel, strReset, strStart;

/* Элементы управления */
var GUIScrollTextBox sSkillInfo;
var GUIListBox lstSkills;
var GUIEditBox eCodeName, eName, eSkillsAvail;
var GUILabel lName, lCodeName, lAppearence, lSkills, lSkillPoints, lSkillLevel, lSkillRequired, lSkillName;
var GUIButton bLeftArrow, bRightArrow, bUpgrade, bDownGrade; // внешность <>, повысить, понизить
var GUIButton bStart, bCancel, bReset; // Начать игру, назад, сбросить по умолчанию
var GUIImage iPortrait; // Внешность
var GUIImage imgSkill;

function CreateMyControls()
{
  imgSkill  = new(none) class'GUIImage';
	imgSkill.WinHeight = 32;
  imgSkill.WinWidth = 32;
  imgSkill.WinLeft = 176;
  imgSkill.WinTop = 250;
  AppendComponent(imgSkill, true);


  /* Описание выбранного навыка */
  sSkillInfo = new(none) class'GUIScrollTextBox';
  sSkillInfo.MyScrollBar.WinWidth = 16;
  sSkillInfo.StyleName="STY_DXR_DeusExScrollTextBox";
  sSkillInfo.FontScale=FNS_Small;
	sSkillInfo.WinHeight = 112;
  sSkillInfo.WinWidth = 390;
  sSkillInfo.WinLeft = 205;
  sSkillInfo.WinTop = 246;
  sSkillInfo.bRepeat = false;
  sSkillInfo.bNoTeletype = true;
  sSkillInfo.EOLDelay = 0.1;//75;
  sSkillInfo.CharDelay = 0.005;
  sSkillInfo.RepeatDelay = 3.0;
	AppendComponent(sSkillInfo, true);

  /* Список навыков */
  lstSkills = new(none) class'GUIListBox';
  lstSkills.MyScrollBar.WinWidth = 16;
  lstSkills.WinHeight = 158;
  lstSkills.WinWidth = 424;
  lstSkills.WinLeft = 172;
  lstSkills.WinTop = 56;
  lstSkills.SelectedStyleName="STY_DXR_ListSelection";
  lstSkills.StyleName = "STY_DXR_Listbox";
  lstSkills.OnChange = lstSkillsChange;
  AppendComponent(lstSkills, true);
  lstSkills.list.TextAlign = TXTA_Right;

  /* Внешность и кнопки выбора*/
  bLeftArrow = new(none) class'GUIButton';
  bLeftArrow.StyleName="STY_DXR_ArrowButton_Left";
  bLeftArrow.OnClick = PreviousPortrait;
  bLeftArrow.WinHeight = 16;
  bLeftArrow.WinWidth = 16;
  bLeftArrow.WinLeft = 110;
  bLeftArrow.WinTop = 336;
  bLeftArrow.caption="";
	AppendComponent(bLeftArrow, true);

  bRightArrow = new(none) class'GUIButton';
  bRightArrow.StyleName="STY_DXR_ArrowButton_Right";
  bRightArrow.OnClick = NextPortrait;
  bRightArrow.WinHeight = 16;
  bRightArrow.WinWidth = 16;
  bRightArrow.WinLeft = 125;
  bRightArrow.WinTop = 336;
  bRightArrow.caption="";
	AppendComponent(bRightArrow, true);

	iPortrait = new(none) class'GUIImage';
  iPortrait.WinHeight = 161;
  iPortrait.WinWidth = 114;
  iPortrait.WinLeft = 26;
  iPortrait.WinTop = 172;
	AppendComponent(iPortrait, true);

  /* Нижний ряд кнопок */
  bStart = new(none) class'GUIButton'; // Начать игру
  bStart.FontScale = FNS_Small;
  bStart.Caption = strStart;
  bStart.StyleName="STY_DXR_MediumButton";
  bStart.OnClick = InternalOnClick;
  bStart.WinHeight = 21;
  bStart.WinWidth = 129;
  bStart.WinLeft = 476;
  bStart.WinTop = 412;
	AppendComponent(bStart, true);

  bCancel = new(none) class'GUIButton'; // Назад
  bCancel.FontScale = FNS_Small;
  bCancel.Caption = strCancel;
  bCancel.StyleName="STY_DXR_MediumButton";
  bCancel.OnClick = InternalOnClick;
  bCancel.WinHeight = 21;
  bCancel.WinWidth = 109;
  bCancel.WinLeft = 364;
  bCancel.WinTop = 412;
	AppendComponent(bCancel, true);

  bReset = new(none) class'GUIButton'; // Сбросить в начальные значения
  bReset.FontScale = FNS_Small;
  bReset.caption = strReset;
  bReset.StyleName="STY_DXR_MediumButton";
  bReset.OnClick = InternalOnClick;
  bReset.bAutoShrink=false;
  bReset.WinHeight = 21;
  bReset.WinWidth = 201;
  bReset.WinLeft = 8;
  bReset.WinTop = 412;
	AppendComponent(bReset, true);

  /* Upgrade/Downgrade */
  bUpgrade = new(none) class'GUIButton';
  bUpgrade.FontScale = FNS_Small;
  bUpgrade.Caption = strUpgrade;
  bUpgrade.StyleName="STY_DXR_MediumButton";
  bUpgrade.OnClick = InternalOnClick;
  bUpgrade.bAutoShrink=false;
  bUpgrade.WinHeight = 21;
  bUpgrade.WinWidth = 75;
  bUpgrade.WinLeft = 172;
  bUpgrade.WinTop = 361;
	AppendComponent(bUpgrade, true);

  bDownGrade = new(none) class'GUIButton';
  bDownGrade.FontScale = FNS_Small;
  bDownGrade.Caption = strDowngrade;
  bDownGrade.StyleName="STY_DXR_MediumButton";
  bDownGrade.OnClick = InternalOnClick;
  bDownGrade.WinHeight = 21;
  bDownGrade.WinWidth = 90;
  bDownGrade.WinLeft = 249;
  bDownGrade.WinTop = 361;
	AppendComponent(bDownGrade, true);

	/* -- Надписи (label) -------------------------- */
  lSkillName = new(none) class'GUILabel';
  lSkillName.TextFont="UT2HeaderFont";
  lSkillName.TextColor = class'Canvas'.static.MakeColor(200, 200, 200);
  lSkillName.FontScale = FNS_Small;
  lSkillName.WinHeight = 20;
  lSkillName.WinWidth = 330;
  lSkillName.WinLeft = 204;
  lSkillName.WinTop = 227;
	AppendComponent(lSkillName, true);


  lName = new(none) class'GUILabel';
  lName.Caption = strNameLabel;
  lName.TextFont="UT2HeaderFont";
  lName.TextColor = class'Canvas'.static.MakeColor(200, 200, 200);
  lName.FontScale = FNS_Small;
  lName.WinHeight = 20;
  lName.WinWidth = 109;
  lName.WinLeft = 28;
  lName.WinTop = 92;
	AppendComponent(lName, true);

  lAppearence = new(none) class'GUILabel';
  lAppearence.Caption = strAppearanceLabel;
  lAppearence.TextFont="UT2HeaderFont";
  lAppearence.TextColor = class'Canvas'.static.MakeColor(200, 200, 200);
  lAppearence.FontScale = FNS_Small;
  lAppearence.WinHeight = 20;
  lAppearence.WinWidth = 109;
  lAppearence.WinLeft = 28;
  lAppearence.WinTop = 152;
	AppendComponent(lAppearence, true);

	/* Доступно единиц */
  lSkillPoints = new(none) class'GUILabel';
  lSkillPoints.Caption = strSkillPointsLabel;
  lSkillPoints.TextFont="UT2HeaderFont";
  lSkillPoints.TextColor = class'Canvas'.static.MakeColor(200, 200, 200);
  lSkillPoints.FontScale = FNS_Small;
  lSkillPoints.WinHeight = 20;
  lSkillPoints.WinWidth = 105;
  lSkillPoints.WinLeft = 404;
  lSkillPoints.WinTop = 364;
	AppendComponent(lSkillPoints, true);

  /* Кодовое имя */
  lCodeName = new(none) class'GUILabel';
  lCodeName.Caption = strCodeNameLabel;
  lCodeName.TextFont="UT2HeaderFont";
  lCodeName.TextColor = class'Canvas'.static.MakeColor(200, 200, 200);
  lCodeName.FontScale = FNS_Small;
  lCodeName.WinHeight = 20;
  lCodeName.WinWidth = 105;
  lCodeName.WinLeft = 28;
  lCodeName.WinTop = 36;
	AppendComponent(lCodeName, true);

  lSkills = new(none) class'GUILabel';
  lSkills.Caption = strSkillsLabel;
  lSkills.TextFont="UT2HeaderFont";
  lSkills.TextColor = class'Canvas'.static.MakeColor(200, 200, 200);
  lSkills.FontScale = FNS_Small;
  lSkills.WinHeight = 20;
  lSkills.WinWidth = 109;
  lSkills.WinLeft = 176;
  lSkills.WinTop = 36;
	AppendComponent(lSkills, true);

  lSkillLevel = new(none) class'GUILabel';
  lSkillLevel.Caption = strSkillLevelLabel;
  lSkillLevel.TextFont="UT2SmallFont";
  lSkillLevel.TextColor = class'Canvas'.static.MakeColor(200, 200, 200);
  lSkillLevel.FontScale = FNS_Small;
  lSkillLevel.WinHeight = 20;
  lSkillLevel.WinWidth = 70;
  lSkillLevel.WinLeft = 452;
  lSkillLevel.WinTop = 36;
	AppendComponent(lSkillLevel, true);

  lSkillRequired = new(none) class'GUILabel';
  lSkillRequired.Caption = strPointsNeededLabel;
  lSkillRequired.TextFont="UT2SmallFont";
  lSkillRequired.TextColor = class'Canvas'.static.MakeColor(200, 200, 200);
  lSkillRequired.FontScale = FNS_Small;
  lSkillRequired.WinHeight = 20;
  lSkillRequired.WinWidth = 77;
  lSkillRequired.WinLeft = 528;
  lSkillRequired.WinTop = 36;
	AppendComponent(lSkillRequired, true);

	/* -- Поля ввода (хотя задействано будет всего одно из них) ----------------- */
	eCodeName = new(none) class'GUIEditBox';
  eCodeName.StyleName="STY_DXR_EditBox";
	eCodeName.bScaleToParent = false;
	eCodeName.FontScale = FNS_Small;
	eCodeName.bMaskText = false;
	eCodeName.MaxWidth = 128;
	eCodeName.WinHeight = 19;
  eCodeName.WinWidth = 113;
  eCodeName.WinLeft = 26;
  eCodeName.WinTop = 56;
	AppendComponent(eCodeName, true);

  eName = new(none) class'GUIEditBox';
  eName.StyleName="STY_DXR_EditBox";
	eName.bScaleToParent = false;
	eName.FontScale = FNS_Small;
	eName.bMaskText = false;
	eName.MaxWidth = 128;
	eName.WinHeight = 19;
  eName.WinWidth = 113;
  eName.WinLeft = 26;
  eName.WinTop = 112;
	AppendComponent(eName, true);

  eSkillsAvail = new(none) class'GUIEditBox';
  eSkillsAvail.StyleName="STY_DXR_EditBox";
	eSkillsAvail.bScaleToParent = false;
	eSkillsAvail.bReadOnly = true;
	eSkillsAvail.FontScale = FNS_Small;
	eSkillsAvail.bMaskText = false;
	eSkillsAvail.MaxWidth = 128;
	eSkillsAvail.WinHeight = 19;
  eSkillsAvail.WinWidth = 84;
  eSkillsAvail.WinLeft = 512;
  eSkillsAvail.WinTop = 361;
	AppendComponent(eSkillsAvail, true);

	ResetToDefaults();
}


function bool InternalOnClick(GUIComponent Sender)
{
  local string playerName;

  if (Sender==bStart)
  {
  		// Make sure the name isn't blank
		playerName = class'DxUtil'.static.TrimSpaces(eName.GetText());

		if (playerName == "")
		{
        controller.OpenMenu("DXRMenu.DXRNameIsBlank");
		}
		else
		{
			SaveSettings();
			DeusExPlayer(PlayerOwner().pawn).ShowIntro(True);
		}
  }
  if (Sender==bCancel)
  {
    Controller.CloseMenu(true);
  }
  if (Sender==bReset)
  {
     ResetToDefaults();
  }

  if (Sender==bUpgrade)
  {
     UpgradeSkill();
  }

  if (Sender==bDownGrade)
  {
     DowngradeSkill();
  }
  return false;
}


/*event Opened(GUIComponent Sender)
{
  super.Opened(Sender);
}*/
// bCancelled срабатывает если окно закрыто через ESC или командой Controller.CloseMenu(true)
event Closed(GUIComponent Sender, bool bCancelled)  // Called when the Menu Owner is closed
{
//  log("bCancelled"@bCancelled);
  if (bCancelled)
  RestoreSkillPoints();	

  Super.Closed(Sender, bCancelled);
}

event Free()            // This control is no longer needed
{
  DestroyLocalSkills();
  log(self@"event Free()");
  Super.Free();
}


/* -- Перенесено из оригинала ---------------------------------------------------------- */
function UpgradeSkill()
{
	// First make sure we have a skill selected
	if ( selectedSkill == None )
		return;

	selectedSkill.IncLevel(DeusExPlayer(playerOwner().pawn));
  lstSkills.list.Replace(selectedRowId, BuildSkillString(localSkills[selectedRowId]),localSkills[selectedRowId],, true);

	UpdateSkillPoints();
	EnableButtons();
}

function DowngradeSkill()
{
	// First make sure we have a skill selected
	if ( selectedSkill == None )
		return;

	selectedSkill.DecLevel(True, DeusExPlayer(playerOwner().pawn));
  lstSkills.list.Replace(selectedRowId, BuildSkillString(localSkills[selectedRowId]), localSkills[selectedRowId],, true);

	UpdateSkillPoints();
	EnableButtons();
}


function bool PreviousPortrait(GUIComponent Sender)
{
	portraitIndex--;

	if (portraitIndex < 0)
		portraitIndex = arrayCount(texPortraits) - 1;

	iPortrait.Image = texPortraits[portraitIndex];
return true;
}

function bool NextPortrait(GUIComponent Sender)
{
	portraitIndex++;

	if (portraitIndex == arrayCount(texPortraits))
		portraitIndex = 0;

	iPortrait.Image = texPortraits[portraitIndex];
return true;
}

function SetDifficulty(float newDifficulty)
{
	combatDifficulty = newDifficulty;
}

function String BuildSkillString(Skill aSkill)
{
	local String skillString;
	local String levelCost;
	
	if (aSkill.GetCurrentLevel() == 3) 
		levelCost = "----";
	else
		levelCost = String(aSkill.GetCost());

	skillString = aSkill.skillName $ chr(9) $ aSkill.GetCurrentLevelString() $ chr(9) $ levelCost;

	return skillString;
}

function SaveSettings()
{
	ApplySkills();
	DeusExPlayer(PlayerOwner().pawn).TruePlayerName   = eName.GetText();
	DeusExPlayer(PlayerOwner().pawn).PlayerSkin       = portraitIndex;
	DeusExPlayer(PlayerOwner().pawn).CombatDifficulty = combatDifficulty;
}

function SaveSkillPoints()
{
	saveSkillPointsAvail = DeusExPlayer(PlayerOwner().pawn).SkillPointsAvail;
	saveSkillPointsTotal = DeusExPlayer(PlayerOwner().pawn).SkillPointsAvail;
}

function RestoreSkillPoints()
{
	DeusExPlayer(PlayerOwner().pawn).SkillPointsAvail = saveSkillPointsAvail;
	DeusExPlayer(PlayerOwner().pawn).SkillPointsAvail = saveSkillPointsTotal;
}

// Apply our local skills to the real skills in the game.
function ApplySkills()
{
	local Skill aSkill;
	local int skillIndex;

	skillIndex = 0;

	while(localSkills[skillIndex] != None)
	{
		aSkill = DeusExPlayer(PlayerOwner().pawn).SkillSystem.FirstSkill;
		while(aSkill != None)
		{
			if (aSkill.SkillName == localSkills[skillIndex].SkillName)
			{
				// Copy the skill
				aSkill.CurrentLevel = localSkills[skillIndex].GetCurrentLevel();
				break;
			}
			aSkill = aSkill.next;
		}
		skillIndex++;
	}
}

// Makes a local copy of the skills so we can manipulate them without
// actually making changes to the ones attached to the player.
function CopySkills()
{
	local Skill aSkill;
	local int skillIndex;

	skillIndex = 0;

	aSkill = DeusExPlayer(PlayerOwner().pawn).SkillSystem.FirstSkill;
	while(aSkill != None)
	{
		localSkills[skillIndex] = DeusExPlayer(PlayerOwner().pawn).Spawn(aSkill.Class);
		skillIndex++;
		aSkill = aSkill.next;
	}
}


function DestroyLocalSkills()
{
	local int skillIndex;

	skillIndex = 0;

	while(localSkills[skillIndex] != None)
	{
		localSkills[skillIndex].Destroy();
		localSkills[skillIndex] = None;
		skillIndex++;
	}
}


function ResetToDefaults()
{
  eCodeName.SetText(DeusExPlayer(PlayerOwner().pawn).FamiliarName); // CodeName is FamiliarName
  eCodeName.bReadOnly = true;
  combatDifficulty = DeusExPlayer(PlayerOwner().pawn).default.CombatDifficulty;

	eName.SetText(DeusExPlayer(PlayerOwner().pawn).TruePlayerName);

	DeusExPlayer(PlayerOwner().pawn).SkillPointsAvail = DeusExPlayer(PlayerOwner().pawn).default.SkillPointsAvail;
	DeusExPlayer(PlayerOwner().pawn).SkillPointsTotal = DeusExPlayer(PlayerOwner().pawn).default.SkillPointsTotal;

	portraitIndex = 0;
	iPortrait.Image = texPortraits[portraitIndex];

	CopySkills();
	PopulateSkillsList();
	UpdateSkillPoints();
	EnableButtons();
	lstSkillsChange(none);
}

function UpdateSkillPoints()
{
	eSkillsAvail.SetText(String(DeusExPlayer(PlayerOwner().pawn).SkillPointsAvail));
}


function EnableButtons()
{
	// Abort if a skill item isn't selected
	if (selectedSkill == None)
	{
		bUpgrade.DisableMe();
		bDownGrade.DisableMe();
	}
	else
	{
		// Upgrade Skill only available if the skill is not at 
		// the maximum -and- the user has enough skill points
		// available to upgrade the skill
		if (selectedSkill.CanAffordToUpgrade(DeusExPlayer(PlayerOwner().pawn).SkillPointsAvail))
		{
      bUpgrade.EnableMe();
		}
		else
		bUpgrade.DisableMe();

		if (selectedSkill.GetCurrentLevel() > 0)
		{
		   bDownGrade.EnableMe();
		}
		else
		bDownGrade.DisableMe();
	}

	// Only enable the OK button if the player has entered a name
	if (eName != None)
	{
		if (eName.GetText() == "")
			bStart.DisableMe(); // EnableActionButton(AB_Other, False, "START");
		else
			bStart.EnableMe();//			EnableActionButton(AB_Other, True, "START");
	}
}

function PopulateSkillsList()
{
	local int skillIndex;

	lstSkills.List.Clear();
	skillIndex = 0;

	// Iterate through the skills, adding them to our list
	while(localSkills[skillIndex] != None)
	{
	 	lstSkills.List.Add(BuildSkillString(localSkills[skillIndex]), localSkills[skillIndex]);
		skillIndex++;
	}
}

function lstSkillsChange(GUIComponent Sender)
{
//	local Skill aSkill;

	selectedSkill = Skill(lstSkills.List.GetObject());
  selectedRowId = lstSkills.list.FindItemObject(selectedSkill);
	sSkillInfo.SetContent(selectedSkill.Description);
	imgSkill.image = selectedSkill.SkillIcon;
	lSkillName.Caption = selectedSkill.SkillName;

//	lstSkills.ModifyRow(selectedRowId, BuildSkillString( selectedSkill ));

/*	selectedRowId = focusRowId;

	winSkillInfo.SetSkill(selectedSkill);*/

	EnableButtons();
}

/*function int FindItemObject(Object Obj)
{
	return FindIndex("",,,Obj);
}*/





defaultproperties
{
		DefaultHeight=415
		DefaultWidth=610

		MaxPageHeight=415
		MaxPageWidth=610
		MinPageHeight=415
		MinPageWidth=610

    WinTitle="Start New Game"

    strStart="Start Game"
    strReset="Reset to defaults"
    strCancel="Back"

    strUpgrade="Upgrade"
    strDowngrade="Downgrade"

    strNameLabel="Real Name"
    strCodeNameLabel="Code Name"
    strAppearanceLabel="Appearance"
    strSkillsLabel="Skills"
    strSkillPointsLabel="Skill Points"
    strSkillLevelLabel="Skill Level"
    strPointsNeededLabel="Points Needed"

    texPortraits(0)=Texture'DeusExUI.UserInterface.MenuNewGameJCDenton_1'
    texPortraits(1)=Texture'DeusExUI.UserInterface.MenuNewGameJCDenton_2'
    texPortraits(2)=Texture'DeusExUI.UserInterface.MenuNewGameJCDenton_3'
    texPortraits(3)=Texture'DeusExUI.UserInterface.MenuNewGameJCDenton_4'
    texPortraits(4)=Texture'DeusExUI.UserInterface.MenuNewGameJCDenton_5'

	Begin Object Class=FloatingImage Name=FloatingFrameBackground
		Image=Texture'MenuNewGameBackground'
		ImageRenderStyle=MSTY_Normal
		ImageStyle=ISTY_Tiled
		ImageColor=(R=255,G=255,B=255,A=255)
		DropShadow=None
		WinWidth=600
		WinHeight=392
		WinLeft=8
		WinTop=20
		RenderWeight=0.000003
		bBoundToParent=True
		bScaleToParent=True
	End Object
	i_FrameBG=FloatingFrameBackground
}

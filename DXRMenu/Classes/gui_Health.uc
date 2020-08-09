/*
   Экран здоровья игрока
   Эта вкладка почти не изменена, только увеличена область описания.
*/

class gui_Health extends PlayerInterfacePanel;

var() MedKit mk;
var() float playerHealth[6];
var() bool bShowHealButtons;
var() GUIScrollTextBox HealthDetails;
var() localized String PointsHealedLabel;
var() localized String HealthPartDesc[4];
var() GUIImage iHealthBG, iHealthBody, iHealthOverlays, iMedKits;
var() GUILabel lHeader, lMedKits, lMedKitsCount, lHeader2, lMessage;
var() GUIButton lbHead, lbLeftArm, lbRightArm, lbBody, lbLeftLeg, lbRightLeg;
var() GuiButton bHead, bLeftArm, bRightArm, bBody, bLeftLeg, bRightLeg, bHealAll;
var() GUIProgressBar prHead, prLeftArm, prRightArm, prBody, prLeftLeg, prRightLeg;
var() localized String MedKitUseText, HealthTitleText, HealAllButtonLabel, HealthLocationHead, HealthLocationTorso;
var() localized String HealthLocationRightArm, HealthLocationLeftArm, HealthLocationRightLeg, HealthLocationLeftLeg;
var() localized String strHands, strLegs;

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
  {
     PlayerOwner().pawn.PlaySound(Sound'Menu_OK',SLOT_Interface,0.25);
     EnableButtons();
     fillvalues();
  }
}

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    Super.Initcomponent(MyController, MyOwner);
    CreateMyControls();
}

/*
  Пока это самый длинный список компонентов :) 
  Часть текста нарисована напрямую через Canvas.
*/
function CreateMyControls()
{
  iHealthBG = new(none) class'GUIImage'; 
  iHealthBG.Image=texture'DXR_HealthBackground';
  iHealthBG.bBoundToParent = true;
    iHealthBG.WinHeight = 448;
  iHealthBG.WinWidth = 640;
  iHealthBG.WinLeft = 74;
  iHealthBG.WinTop = 32;//0;
  iHealthBG.tag = 75;
  iHealthBG.ImageColor = class'Canvas'.static.MakeColor(128, 128, 128, 128);
    AppendComponent(iHealthBG, true);

  iHealthBody = new(none) class'GUIImage'; 
  iHealthBody.Image=texture'DXR_HealthBody';
  iHealthBody.bBoundToParent = true;
    iHealthBody.WinHeight = 384;
  iHealthBody.WinWidth = 256;
  iHealthBody.WinLeft = 98;
  iHealthBody.WinTop = 68;
    AppendComponent(iHealthBody, true);

  iHealthOverlays = new(none) class'GUIImage'; 
  iHealthOverlays.Image=texture'DXR_HealthOverlays';
  iHealthOverlays.bBoundToParent = true;
    iHealthOverlays.WinHeight = 384;
  iHealthOverlays.WinWidth = 256;
  iHealthOverlays.WinLeft = 98;
  iHealthOverlays.tag = 75;
  iHealthOverlays.WinTop = 68;
    AppendComponent(iHealthOverlays, true);

  lHeader = new(none) class'GUILabel';
  lHeader.bBoundToParent = true;
  lHeader.TextColor = class'DXR_Menu'.static.GetPlayerInterfaceHDR(gl.MenuThemeIndex);
  lHeader.caption = "Health";
  lHeader.TextFont="UT2HeaderFont";
  lHeader.bMultiLine = false;
  lHeader.TextAlign = TXTA_Left;
  lHeader.VertAlign = TXTA_Center;
  lHeader.FontScale = FNS_Small;
    lHeader.WinHeight = 20;
  lHeader.WinWidth = 120;
  lHeader.WinLeft = 90;
  lHeader.WinTop = 32;
    AppendComponent(lHeader, true);

    /* Лечить всё! */
  if (bShowHealButtons)
  {
  bHealAll = new(none) class'GUIButton';
  bHealAll.FontScale = FNS_Small;
  bHealAll.Caption = HealAllButtonLabel;
  bHealAll.Hint = "Restore all health when possible";
  bHealAll.StyleName="STY_DXR_ButtonNavbar";
  bHealAll.bBoundToParent = true;
  bHealAll.OnClick = InternalOnClick;
  bHealAll.WinHeight = 24;
  bHealAll.WinWidth = 100;
  bHealAll.WinLeft = 87;
  bHealAll.WinTop = 439;
  bHealAll.tag = 123;
    AppendComponent(bHealAll, true);
  }

    /*-- По частям... -----------------------------------------------------*/
    if (bShowHealButtons)
    {
  bHead = new(none) class'GUIButton';
  bHead.FontScale = FNS_Small;
  bHead.Caption = "Heal";
  bHead.Hint = "";
  bHead.StyleName="STY_DXR_ButtonNavbar";
  bHead.bBoundToParent = true;
  bHead.OnClick = InternalOnClick;
  bHead.WinHeight = 15;
  bHead.WinWidth = 66;
  bHead.WinLeft = 297;
  bHead.WinTop = 85;
  bHead.tag=123;
    AppendComponent(bHead, true);

  bLeftArm = new(none) class'GUIButton';
  bLeftArm.FontScale = FNS_Small;
  bLeftArm.Caption = "Heal";
  bLeftArm.Hint = "";
  bLeftArm.StyleName="STY_DXR_ButtonNavbar";
  bLeftArm.bBoundToParent = true;
  bLeftArm.OnClick = InternalOnClick;
  bLeftArm.WinHeight = 15;
  bLeftArm.WinWidth = 66;
  bLeftArm.WinLeft = 98;
  bLeftArm.WinTop = 293;
  bLeftArm.tag=123;
    AppendComponent(bLeftArm, true);

  bRightArm = new(none) class'GUIButton';
  bRightArm.FontScale = FNS_Small;
  bRightArm.Caption = "Heal";
  bRightArm.Hint = "";
  bRightArm.StyleName="STY_DXR_ButtonNavbar";
  bRightArm.bBoundToParent = true;
  bRightArm.OnClick = InternalOnClick;
  bRightArm.WinHeight = 15;
  bRightArm.WinWidth = 66;
  bRightArm.WinLeft = 309;
  bRightArm.WinTop = 293;
  bRightArm.tag=123;
    AppendComponent(bRightArm, true);

  bBody = new(none) class'GUIButton';
  bBody.FontScale = FNS_Small;
  bBody.Caption = "Heal";
  bBody.Hint = "";
  bBody.StyleName="STY_DXR_ButtonNavbar";
  bBody.bBoundToParent = true;
  bBody.OnClick = InternalOnClick;
  bBody.WinHeight = 15;
  bBody.WinWidth = 66;
  bBody.WinLeft = 106;
  bBody.WinTop = 99;
  bBody.tag=123;
    AppendComponent(bBody, true);

  bLeftLeg = new(none) class'GUIButton';
  bLeftLeg.FontScale = FNS_Small;
  bLeftLeg.Caption = "Heal";
  bLeftLeg.Hint = "";
  bLeftLeg.StyleName="STY_DXR_ButtonNavbar";
  bLeftLeg.bBoundToParent = true;
  bLeftLeg.OnClick = InternalOnClick;
  bLeftLeg.WinHeight = 15;
  bLeftLeg.WinWidth = 66;
  bLeftLeg.WinLeft = 103;
  bLeftLeg.WinTop = 403;
  bLeftLeg.tag=123;
    AppendComponent(bLeftLeg, true);

  bRightLeg = new(none) class'GUIButton';
  bRightLeg.FontScale = FNS_Small;
  bRightLeg.Caption = "Heal";
  bRightLeg.Hint = "";
  bRightLeg.StyleName="STY_DXR_ButtonNavbar";
  bRightLeg.bBoundToParent = true;
  bRightLeg.OnClick = InternalOnClick;
  bRightLeg.WinHeight = 15;
  bRightLeg.WinWidth = 66;
  bRightLeg.WinLeft = 301;
  bRightLeg.WinTop = 404;
  bRightLeg.tag=123;
    AppendComponent(bRightLeg, true);
    }
    /*---------------------------------------------------------------------*/
  HealthDetails = new(none) class'GUIScrollTextBox'; // описание
  HealthDetails.StyleName="STY_DXR_DeusExScrollTextBox";
  HealthDetails.FontScale=FNS_Small;
  HealthDetails.bBoundToParent = true;
    HealthDetails.WinHeight = 275;
    if (!bShowHealButtons)
      HealthDetails.WinHeight = 183;
  HealthDetails.WinWidth = 278;
  HealthDetails.WinLeft = 423;
  HealthDetails.WinTop = 75;
  HealthDetails.bRepeat = false;//true;
  HealthDetails.bNoTeletype = gl.bUseCursorEffects;
  HealthDetails.EOLDelay = 0.1;//75;
  HealthDetails.CharDelay = 0.005;
  HealthDetails.RepeatDelay = 3.0;
  HealthDetails.MyScrollBar.WinWidth = 16;
    AppendComponent(HealthDetails, true);
    /*---------------------------------------------------------------------*/
  if (bShowHealButtons)
  {
    iMedKits = new(none) class'GUIImage';
    iMedKits.image = texture'LargeIconMedKit';
    iMedKits.bBoundToParent = true;
  iMedKits.bAcceptsInput = false;
    iMedKits.WinLeft = 428;
    iMedKits.WinTop = 399;
    iMedKits.WinHeight = 53;
  iMedKits.WinWidth = 53;
  iMedKits.OnClickSound = CS_None;
//  iMedKits.OnClick = InternalOnClick;
    AppendComponent(iMedKits, true);

  lMedKits = new(none) class'GUILabel';
  lMedKits.bBoundToParent = true;
  lMedKits.TextColor = class'DXR_Menu'.static.GetPlayerInterfaceTextLabels(gl.MenuThemeIndex);
  lMedKits.caption = MedKitUseText;//"To heal a specific region of the body, click on the region, then click the Heal button.";
  lMedKits.TextFont="UT2SmallFont";
  lMedKits.bMultiLine = true;
  lMedKits.TextAlign = TXTA_Center;
  lMedKits.VertAlign = TXTA_Center;
  lMedKits.FontScale = FNS_Small;
    lMedKits.WinHeight = 51;
  lMedKits.WinWidth = 224;
  lMedKits.WinLeft = 476;
  lMedKits.WinTop = 398;
    AppendComponent(lMedKits, true);

  lMedKitsCount = new(none) class'GUILabel';
  lMedKitsCount.bBoundToParent = true;
  lMedKitsCount.TextColor = class'DXR_Menu'.static.GetPlayerInterfaceTextLabels(gl.MenuThemeIndex);
  lMedKitsCount.caption = "x 0";
  lMedKitsCount.TextFont="UT2HeaderFont";
  lMedKitsCount.bMultiLine = true;
  lMedKitsCount.TextAlign = TXTA_Center;
  lMedKitsCount.VertAlign = TXTA_Center;
  lMedKitsCount.FontScale = FNS_Small;
    lMedKitsCount.WinHeight = 16;
  lMedKitsCount.WinWidth = 48;
  lMedKitsCount.WinLeft = 424;
  lMedKitsCount.WinTop = 433;
    AppendComponent(lMedKitsCount, true);
    }
    /*-- Индикаторы -------------------------------------------------------*/
    prHead = new(none) class'GUIProgressBar';
  prHead.FontName="UT2HeaderFont";
    prHead.WinHeight = 10;
  prHead.WinWidth = 64;
  prHead.WinLeft = 297;
  prHead.WinTop = 75;
  prHead.High = DeusExPlayer(PlayerOwner().pawn).default.HealthHead;
    prHead.CaptionWidth = 0.0; //0.45;
  prHead.bBoundToParent = true;
  prHead.bShowLow = true;
  prHead.bShowHigh = true;
  prHead.ValueRightWidth = 0.0;
  prHead.Caption = "test";
  prHead.BarBack = Material'MenuTitleBubble_Center'; // The unselected portion of the bar
  prHead.BarTop = Material'Solid'; // The selected portion of the bar
  prHead.OnRendered = pr_OnRendered;
    AppendComponent(prHead, true);

    prBody = new(none) class'GUIProgressBar';
  prBody.FontName="UT2HeaderFont";
    prBody.WinHeight = 10;
  prBody.WinWidth = 64;
  prBody.WinLeft = 106;
  prBody.WinTop = 89;
  prBody.High = DeusExPlayer(PlayerOwner().pawn).default.HealthTorso;
    prBody.CaptionWidth = 0.0;
  prBody.bBoundToParent = true;
  prBody.bShowLow = true;
  prBody.bShowHigh = true;
  prBody.ValueRightWidth = 0.0;
  prBody.Caption = "test";
  prBody.BarBack = Material'MenuTitleBubble_Center'; // The unselected portion of the bar
  prBody.BarTop = Material'Solid'; // The selected portion of the bar
  prBody.OnRendered = pr_OnRendered;
    AppendComponent(prBody, true);

    prRightArm = new(none) class'GUIProgressBar';
  prRightArm.FontName="UT2HeaderFont";
    prRightArm.WinHeight = 10;
  prRightArm.WinWidth = 64;
  prRightArm.WinLeft = 309;
  prRightArm.WinTop = 283;
  prRightArm.High = DeusExPlayer(PlayerOwner().pawn).default.HealthArmRight;
    prRightArm.CaptionWidth = 0.0; //0.45;
  prRightArm.bBoundToParent = true;
  prRightArm.bShowLow = true;
  prRightArm.bShowHigh = true;
  prRightArm.ValueRightWidth = 0.0;
  prRightArm.Caption = "test";
  prRightArm.BarBack = Material'MenuTitleBubble_Center'; // The unselected portion of the bar
  prRightArm.BarTop = Material'Solid'; // The selected portion of the bar
  prRightArm.OnRendered = pr_OnRendered;
    AppendComponent(prRightArm, true);

    prLeftArm = new(none) class'GUIProgressBar';
  prLeftArm.FontName="UT2HeaderFont";
    prLeftArm.WinHeight = 10;
  prLeftArm.WinWidth = 64;
  prLeftArm.WinLeft = 98;
  prLeftArm.WinTop = 283;
  prLeftArm.High = DeusExPlayer(PlayerOwner().pawn).default.HealthArmLeft;
    prLeftArm.CaptionWidth = 0.0;
  prLeftArm.bBoundToParent = true;
  prLeftArm.bShowLow = true;
  prLeftArm.bShowHigh = true;
  prLeftArm.ValueRightWidth = 0.0;
  prLeftArm.Caption = "test";
  prLeftArm.BarBack = Material'MenuTitleBubble_Center'; // The unselected portion of the bar
  prLeftArm.BarTop = Material'Solid'; // The selected portion of the bar
  prLeftArm.OnRendered = pr_OnRendered;
    AppendComponent(prLeftArm, true);

    prLeftLeg = new(none) class'GUIProgressBar';
  prLeftLeg.FontName="UT2HeaderFont";
    prLeftLeg.WinHeight = 10;
  prLeftLeg.WinWidth = 64;
  prLeftLeg.WinLeft = 103;
  prLeftLeg.WinTop = 393;
  prLeftLeg.High = DeusExPlayer(PlayerOwner().pawn).default.HealthLegLeft;
    prLeftLeg.CaptionWidth = 0.0;
  prLeftLeg.bBoundToParent = true;
  prLeftLeg.bShowLow = true;
  prLeftLeg.bShowHigh = true;
  prLeftLeg.ValueRightWidth = 0.0;
  prLeftLeg.Caption = "test";
  prLeftLeg.BarBack = Material'MenuTitleBubble_Center'; // The unselected portion of the bar
  prLeftLeg.BarTop = Material'Solid'; // The selected portion of the bar
  prLeftLeg.OnRendered = pr_OnRendered;
    AppendComponent(prLeftLeg, true);

    prRightLeg = new(none) class'GUIProgressBar';
  prRightLeg.FontName="UT2HeaderFont";
    prRightLeg.WinHeight = 10;
  prRightLeg.WinWidth = 64;
  prRightLeg.WinLeft = 301;
  prRightLeg.WinTop = 393;
  prRightLeg.High = DeusExPlayer(PlayerOwner().pawn).default.HealthLegRight;
  prRightLeg.NumDecimals = 1;
    prRightLeg.CaptionWidth = 0.0; //0.45;
  prRightLeg.bBoundToParent = true;
  prRightLeg.bShowLow = true;
  prRightLeg.bShowHigh = true;
  prRightLeg.ValueRightWidth = 0.0;
  prRightLeg.Caption = "";
  prRightLeg.BarBack = Material'MenuTitleBubble_Center'; // The unselected portion of the bar
  prRightLeg.BarTop = Material'Solid'; // The selected portion of the bar
  prRightLeg.OnRendered = pr_OnRendered;
    AppendComponent(prRightLeg, true);
    /*---------------------------------------------------------------------*/

    lbHead = new class'GUIButton';
  lbHead.StyleName="STY_DXR_ImgBorder";
  lbHead.OnClick = InternalOnClick;
  lbHead.bAcceptsInput = true;
  lbHead.bBoundToParent = true;
  lbHead.RenderWeight = 0.5;
    lbHead.WinHeight = 52;
  lbHead.WinWidth = 36;
  lbHead.WinLeft = 217;
  lbHead.WinTop = 75;
  lbHead.Tag=11;
    AppendComponent(lbHead, true);

    lbRightArm = new class'GUIButton';
  lbRightArm.StyleName="STY_DXR_ImgBorder";
  lbRightArm.OnClick = InternalOnClick;
  lbRightArm.bAcceptsInput = true;
  lbRightArm.bBoundToParent = true;
    lbRightArm.WinHeight = 61;
  lbRightArm.WinWidth = 25;
  lbRightArm.WinLeft = 280;
  lbRightArm.WinTop = 164;
  lbRightArm.Tag=11;
    AppendComponent(lbRightArm, true);

    lbLeftArm = new class'GUIButton';
  lbLeftArm.StyleName="STY_DXR_ImgBorder";
  lbLeftArm.OnClick = InternalOnClick;
  lbLeftArm.bAcceptsInput = true;
  lbLeftArm.bBoundToParent = true;
    lbLeftArm.WinHeight = 61;
  lbLeftArm.WinWidth = 25;
  lbLeftArm.WinLeft = 166;
  lbLeftArm.WinTop = 164;
  lbLeftArm.Tag=11;
    AppendComponent(lbLeftArm, true);

  lbBody = new class'GUIButton';
  lbBody.StyleName="STY_DXR_ImgBorder";
  lbBody.OnClick = InternalOnClick;
  lbBody.bAcceptsInput = true;
  lbBody.bBoundToParent = true;
    lbBody.WinHeight = 70;
  lbBody.WinWidth = 53;
  lbBody.WinLeft = 209;
  lbBody.WinTop = 131;
  lbBody.Tag=11;
    AppendComponent(lbBody, true);

  lbLeftLeg = new class'GUIButton';
  lbLeftLeg.StyleName="STY_DXR_ImgBorder";
  lbLeftLeg.OnClick = InternalOnClick;
  lbLeftLeg.bAcceptsInput = true;
  lbLeftLeg.bBoundToParent = true;
    lbLeftLeg.WinHeight = 91;
  lbLeftLeg.WinWidth = 38;
  lbLeftLeg.WinLeft = 195;
  lbLeftLeg.WinTop = 267;
  lbLeftLeg.Tag=11;
    AppendComponent(lbLeftLeg, true);

  lbRightLeg = new class'GUIButton';
  lbRightLeg.StyleName="STY_DXR_ImgBorder";
  lbRightLeg.OnClick = InternalOnClick;
  lbRightLeg.bAcceptsInput = true;
  lbRightLeg.bBoundToParent = true;
    lbRightLeg.WinHeight = 91;
  lbRightLeg.WinWidth = 38;
  lbRightLeg.WinLeft = 238;
  lbRightLeg.WinTop = 267;
  lbRightLeg.Tag=11;
    AppendComponent(lbRightLeg, true);

    /*---------------------------------------------------------------*/
    lHeader2 = new(none) class'GUILabel';
  lHeader2.bBoundToParent = true;
  lHeader2.TextColor =  class'DXR_Menu'.static.GetPlayerInterfaceTextLabels(gl.MenuThemeIndex);
  lHeader2.caption = "";
  lHeader2.TextFont="UT2HeaderFont";
  lHeader2.bMultiLine = false;
  lHeader2.TextAlign = TXTA_Left;
  lHeader2.VertAlign = TXTA_Center;
  lHeader2.FontScale = FNS_Small;
    lHeader2.WinHeight = 20;
  lHeader2.WinWidth = 278;
  lHeader2.WinLeft = 423;
  lHeader2.WinTop = 52;
    AppendComponent(lHeader2, true);

    lMessage = new(none) class'GUILabel';
  lMessage.bBoundToParent = true;
  lMessage.TextColor =  class'DXR_Menu'.static.GetPlayerInterfaceTextLabels(gl.MenuThemeIndex);
  lMessage.caption = "";
  lMessage.TextFont="UT2SmallFont";
  lMessage.bMultiLine = false;
  lMessage.TextAlign = TXTA_Left;
  lMessage.VertAlign = TXTA_Center;
  lMessage.FontScale = FNS_Small;
    lMessage.WinHeight = 20;
  lMessage.WinWidth = 278;
  lMessage.WinLeft = 423;
  lMessage.WinTop = 356;
    AppendComponent(lMessage, true);

    ApplyTheme();
}

function pr_OnRendered(canvas C)
{
  if (playerOwner().pawn != none)
  {
   c.SetPos(prBody.ActualLeft(),prBody.ActualTop());
   c.SetDrawColor(255,255,255,255);
   c.font = font'FontMenuHeaders_DS';
   c.DrawText(" "$DeusExPlayer(playerOwner().pawn).HealthTorso$" / "$DeusExPlayer(playerOwner().pawn).default.HealthTorso);

   c.SetPos(prHead.ActualLeft(),prHead.ActualTop());
   c.SetDrawColor(255,255,255,255);
   c.DrawText(" "$DeusExPlayer(playerOwner().pawn).HealthHead$" / "$DeusExPlayer(playerOwner().pawn).default.HealthHead);
//-----------------
   c.SetPos(prLeftArm.ActualLeft(),prLeftArm.ActualTop());
   c.SetDrawColor(255,255,255,255);
   c.DrawText(" "$DeusExPlayer(playerOwner().pawn).HealthArmLeft$" / "$DeusExPlayer(playerOwner().pawn).default.HealthArmLeft);

   c.SetPos(prRightArm.ActualLeft(),prRightArm.ActualTop());
   c.SetDrawColor(255,255,255,255);
   c.DrawText(" "$DeusExPlayer(playerOwner().pawn).HealthArmRight$" / "$DeusExPlayer(playerOwner().pawn).default.HealthArmRight);
//-----------------
   c.SetPos(prRightLeg.ActualLeft(),prRightLeg.ActualTop());
   c.SetDrawColor(255,255,255,255);
   c.DrawText(" "$DeusExPlayer(playerOwner().pawn).HealthLegRight$" / "$DeusExPlayer(playerOwner().pawn).default.HealthLegRight);

   c.SetPos(prLeftLeg.ActualLeft(),prLeftLeg.ActualTop());
   c.SetDrawColor(255,255,255,255);
   c.DrawText(" "$DeusExPlayer(playerOwner().pawn).HealthLegLeft$" / "$DeusExPlayer(playerOwner().pawn).default.HealthLegLeft);
  }
}

function InternalOnRendered(canvas C)
{
  local int Voffset;

  Voffset = 13;

   c.SetPos(prLeftLeg.ActualLeft() - 3,prLeftLeg.ActualTop() - Voffset);
   c.DrawColor =  class'DXR_Menu'.static.GetPlayerInterfaceTextLabels(gl.MenuThemeIndex);
   c.font = font'MSS_8';//font'FontMenuSmall_DS';//font'microTech_7';//font'eur_8';//font'EU_8';//font'Inf_8';
   c.DrawText(HealthLocationLeftLeg);

   c.SetPos(prRightLeg.ActualLeft() - 3,prRightLeg.ActualTop() - Voffset);
   c.DrawText(HealthLocationRightLeg);
//-----------------
   c.SetPos(prRightArm.ActualLeft() - 3,prRightArm.ActualTop() - Voffset);
   c.DrawText(HealthLocationRightArm);

   c.SetPos(prLeftArm.ActualLeft() - 3,prLeftArm.ActualTop() - Voffset);
   c.DrawText(HealthLocationLeftArm);
//-----------------
   c.SetPos(prHead.ActualLeft() - 3,prHead.ActualTop() - Voffset);
   c.DrawText(HealthLocationHead);

   c.SetPos(prBody.ActualLeft() - 3,prBody.ActualTop() - Voffset);
   c.DrawText(HealthLocationTorso);

   PaintFrames(c);
}

function fillvalues()
{
  local DeusExPlayer p;

  p = DeusExPlayer(playerOwner().pawn);
  prHead.BarColor = class'Actor'.static.GetColorScaled(p.HealthHead * 0.01);
  prHead.Value = p.HealthHead;
  prBody.BarColor = class'Actor'.static.GetColorScaled(p.HealthTorso * 0.01);
  prBody.Value = p.HealthTorso;
  prLeftLeg.BarColor = class'Actor'.static.GetColorScaled(p.HealthLegLeft * 0.01);
  prLeftLeg.Value = p.HealthLegLeft;
  prRightLeg.BarColor = class'Actor'.static.GetColorScaled(p.HealthLegRight * 0.01);
  prRightLeg.Value = p.HealthLegRight;
  prLeftArm.BarColor = class'Actor'.static.GetColorScaled(p.HealthArmLeft * 0.01);
  prLeftArm.Value = p.HealthArmLeft;
  prRightArm.BarColor = class'Actor'.static.GetColorScaled(p.HealthArmRight * 0.01);
  prRightArm.Value = p.HealthArmRight;
}

function EnableButtons()
{
  local int i;

    mk = MedKit(PlayerOwner().pawn.FindInventoryType(Class'MedKit'));

    if (mk==none)
    {
     for (i=0; i<controls.length; i++)
     {
       if (controls[i].tag==123)
         GUIButton(controls[i]).DisableMe();
     }
    }
    else if (mk != none)
    {
     lMedKitsCount.Caption = "x "$mk.NumCopies;
     for (i=0; i<controls.length; i++)
     {
       if (controls[i].tag==123)
       {
           GUIButton(controls[i]).EnableMe();
       }
     }
    }
}



function bool InternalOnClick(GUIComponent Sender)
{
  local int pointsHealed;

  if (Sender==lbHead)
  DetailsHead();

  if ((Sender==lbRightArm) || (Sender==lbLeftArm))
  DetailsArms();

  if (Sender==lbBody)
  DetailsBody();

  if ((Sender==lbLeftLeg) || (Sender==lbRightLeg))
  DetailsLegs();

  if (Sender==bHealAll)
  HealAllParts();

  if (Sender==bHead)
  {
        PushHealth();
        pointsHealed = HealPart(0);
        PopHealth();
        lMessage.Caption=class'Actor'.static.Sprintf(PointsHealedLabel, pointsHealed);
        EnableButtons();
  }
  //
  if (Sender==bLeftArm)
  {
        PushHealth();
        pointsHealed = HealPart(3);
        PopHealth();
        lMessage.Caption=class'Actor'.static.Sprintf(PointsHealedLabel, pointsHealed);
        EnableButtons();
  }
  if (Sender==bRightArm)
  {
        PushHealth();
        pointsHealed = HealPart(2);
        PopHealth();
        lMessage.Caption=class'Actor'.static.Sprintf(PointsHealedLabel, pointsHealed);
        EnableButtons();
  }
  //
  if (Sender==bBody)
  {
        PushHealth();
        pointsHealed = HealPart(1);
        PopHealth();
        lMessage.Caption=class'Actor'.static.Sprintf(PointsHealedLabel, pointsHealed);
        EnableButtons();
  }
  //
  if (Sender==bLeftLeg)
  {
        PushHealth();
        pointsHealed = HealPart(5);
        PopHealth();
        lMessage.Caption=class'Actor'.static.Sprintf(PointsHealedLabel, pointsHealed);
        EnableButtons();
  }
  if (Sender==bRightLeg)
  {
        PushHealth();
        pointsHealed = HealPart(4);
        PopHealth();
        lMessage.Caption=class'Actor'.static.Sprintf(PointsHealedLabel, pointsHealed);
        EnableButtons();
  }

  return false;
}

function DetailsArms()
{
  HealthDetails.SetContent(HealthPartDesc[2]);
  lHeader2.Caption=strHands;
}

function DetailsLegs()
{
  HealthDetails.SetContent(HealthPartDesc[3]);
  lHeader2.Caption=strLegs;
}

function DetailsBody()
{
  HealthDetails.SetContent(HealthPartDesc[1]);
  lHeader2.Caption=HealthLocationTorso;
}

function DetailsHead()
{
  HealthDetails.SetContent(HealthPartDesc[0]);
  lHeader2.Caption=HealthLocationHead;
}

function UpdateMedKits()
{
    local MedKit MedKit;

    if (lMedKitsCount != None)
    {
        MedKit = MedKit(playerOwner().pawn.FindInventoryType(Class'MedKit'));

        if (MedKit != None)
        {
         if (MedKit.NumCopies == 0)
             MedKit.NumCopies = 1;

        lMedKitsCount.Caption = "x "$MedKit.NumCopies;
        }
        else
        lMedKitsCount.Caption = "x 0";

    }
}

function UseMedKit(MedKit MedKit)
{
    if (MedKit != None)
    {
        MedKit.UseOnce();
        UpdateMedKits();
        EnableButtons();
    }
}

function RemoveMedKits(int healPointsUsed)
{
    local MedKit MedKit;
    local int    healPointsRemaining;

    healPointsRemaining = healPointsUsed;
    MedKit = MedKit(playerOwner().pawn.FindInventoryType(Class'MedKit'));

    while((MedKit != None) && (healPointsRemaining > 0))
    {
        healPointsRemaining -= DeusExPlayer(playerOwner().pawn).CalculateSkillHealAmount(MedKit.healAmount);
        UseMedKit(MedKit);
        MedKit = MedKit(playerOwner().pawn.FindInventoryType(Class'MedKit'));
    }
}

function int GetMedKitHealPoints()
{
    local MedKit MedKit;

    MedKit = MedKit(playerOwner().pawn.FindInventoryType(Class'MedKit'));

    if (MedKit != None)
        return DeusExPlayer(playerOwner().pawn).CalculateSkillHealAmount(MedKit.NumCopies * MedKit.healAmount);
    else
        return 0;
}

/* как-то интересно тут всё ^_^ */
function bool IsPlayerDamaged()
{
//  local int regionIndex;
    local bool bDamaged;
    local DeusExPlayer p;

    p = DeusExPlayer(playerOwner().pawn);
    bDamaged = False;
    if ((p.HealthLegRight < p.default.HealthLegRight) || (p.HealthLegLeft < p.default.HealthLegLeft) ||
      (p.HealthArmRight < p.default.HealthArmRight) || (p.HealthArmLeft < p.default.HealthArmLeft) ||
            (p.HealthTorso < p.default.HealthTorso) || (p.HealthHead < p.default.HealthHead))
                        bDamaged = True;
    return bDamaged;
}

/* Uses as many medkits as possible to heal as much damage.  Health
   points are distributed evenly among parts */
function int HealAllParts()
{
    local int    healPointsAvailable;
    local int    healPointsRemaining;
    local int    pointsHealed;
    local int    regionIndex;
    local float  damageAmount;
    local bool   bPartDamaged;

    pointsHealed = 0;
    PushHealth();

    // First determine how many medkits the player has
    healPointsAvailable = GetMedKitHealPoints();
    healPointsRemaining = healPointsAvailable;

    // Now loop through all the parts repeatedly until 
    // we either:
    // 
    // A) Run out of parts to heal or 
    // B) Run out of points to distribute.

    while(healPointsRemaining > 0) 
    {
        bPartDamaged = False;

        // Loop through all the parts
//      for(regionIndex=0; regionIndex<arrayCount(regionWindows); regionIndex++)
        for(regionIndex=0; regionIndex<6; regionIndex++)
        {
//          damageAmount = regionWindows[regionIndex].maxHealth - regionWindows[regionIndex].currentHealth;
            damageAmount = 100 - playerHealth[regionIndex];

            if ((damageAmount > 0) && (healPointsRemaining > 0))
            {
                // Heal this part
//              pointsHealed += HealPart(regionWindows[regionIndex], 1, True);
                pointsHealed += HealPart(regionIndex, 1, True);

                healPointsRemaining--;
                bPartDamaged = True;
            }
        }

        if (!bPartDamaged)
            break;
    }
    
    // Now remove any medkits we may have used
    RemoveMedKits(healPointsAvailable - healPointsRemaining);
    PopHealth();
    EnableButtons();
    lMessage.Caption=class'Actor'.static.Sprintf(PointsHealedLabel, pointsHealed);

    return pointsHealed;
}

function int HealPart(int region, optional float pointsToHeal, optional bool bLeaveMedKit)
{
    local float healthAdded;
    local float newHealth;
    local MedKit MedKit;
    local DeusExPlayer p;

    p = DeusExPlayer(playerOwner().pawn);

    // First make sure the player has a medkit
    MedKit = MedKit(playerOwner().pawn.FindInventoryType(Class'MedKit'));
    
    if ((region == -1) || (MedKit == None))
        return 0;

    // If a point value was passesd in, use it as the amount of 
    // points to heal for this body part.  Otherwise use the 
    // medkit's default heal amount.

    if (pointsToHeal == 0)
        pointsToHeal = p.CalculateSkillHealAmount(MedKit.healAmount);

    // Heal the selected body part by the number of 
    // points available in the part

    switch(region)
    {
        case 0:     // head
            newHealth = FMin(playerHealth[0] + pointsToHeal, p.default.HealthHead);
            healthAdded = newHealth - playerHealth[0];
            playerHealth[0] = newHealth;
            break;

        case 1:     // torso
            newHealth = FMin(playerHealth[1] + pointsToHeal, p.default.HealthTorso);
            healthAdded = newHealth - playerHealth[1];
            playerHealth[1] = newHealth;
            break;

        case 2:     // right arm
            newHealth = FMin(playerHealth[2] + pointsToHeal, p.default.HealthArmRight);
            healthAdded = newHealth - playerHealth[2];
            playerHealth[2] = newHealth;
            break;

        case 3:     // left arm
            newHealth = FMin(playerHealth[3] + pointsToHeal, p.default.HealthArmLeft);
            healthAdded = newHealth - playerHealth[3];
            playerHealth[3] = newHealth;
            break;

        case 4:     // right leg
            newHealth = FMin(playerHealth[4] + pointsToHeal, p.default.HealthLegRight);
            healthAdded = newHealth - playerHealth[4];
            playerHealth[4] = newHealth;
            break;

        case 5:     // left leg
            newHealth = FMin(playerHealth[5] + pointsToHeal, p.default.HealthLegLeft);
            healthAdded = newHealth - playerHealth[5];
            playerHealth[5] = newHealth;
            break;
    }

    // Remove the item from the player's invenory and this screen
    if (!bLeaveMedKit)
        UseMedKit(MedKit);

    return healthAdded;
}

function PushHealth()
{
    playerHealth[0] = DeusExPlayer(playerOwner().pawn).HealthHead;
    playerHealth[1] = DeusExPlayer(playerOwner().pawn).HealthTorso;
    playerHealth[2] = DeusExPlayer(playerOwner().pawn).HealthArmRight;
    playerHealth[3] = DeusExPlayer(playerOwner().pawn).HealthArmLeft;
    playerHealth[4] = DeusExPlayer(playerOwner().pawn).HealthLegRight;
    playerHealth[5] = DeusExPlayer(playerOwner().pawn).HealthLegLeft;
}

function PopHealth()
{
    DeusExPlayer(playerOwner().pawn).HealthHead     = playerHealth[0];
    DeusExPlayer(playerOwner().pawn).HealthTorso    = playerHealth[1];
    DeusExPlayer(playerOwner().pawn).HealthArmRight = playerHealth[2];
    DeusExPlayer(playerOwner().pawn).HealthArmLeft  = playerHealth[3];
    DeusExPlayer(playerOwner().pawn).HealthLegRight = playerHealth[4];
    DeusExPlayer(playerOwner().pawn).HealthLegLeft  = playerHealth[5];

    fillvalues();
}


function PaintFrames(canvas u)
{
  local float x,y;

  x = ActualLeft(); y = ActualTop();

  u.DrawColor = class'DXR_Menu'.static.GetPlayerInterfaceFrames(gl.MenuThemeIndex);
  u.Style = EMenuRenderStyle.MSTY_Translucent;

  u.SetPos(x + lFrameX, y + lframeY);
  u.drawtileStretched(texture'HealthBorder_1', lfSizeX, lfSizeY);

  u.SetPos(x + mFrameX, y + mframeY);
  u.drawtileStretched(texture'HealthBorder_2', mfSizeX, mfSizeY);

  u.SetPos(x + rFrameX, y + rframeY);
  u.drawtileStretched(texture'HealthBorder_3', rfSizeX, rfSizeY);
/*-----------------*/
  u.SetPos(x + lFrameXb, y + lframeYb);
  u.drawtileStretched(texture'HealthBorder_4', lfSizeXb, lfSizeYb);

  u.SetPos(x + mFrameXb, y + mframeYb); 
  u.drawtileStretched(texture'DXR_HealthBorder_5', mfSizeXb, mfSizeYb);  // DXR: Modified border texture

  u.SetPos(x + rFrameXb, y + rframeYb);
  u.drawtileStretched(texture'HealthBorder_6', rfSizeXb, rfSizeYb);
}


defaultproperties
{
   lFrameX=48
   lframeY=26
   lfSizeX=257
   lfSizeY=257

   mFrameX=305
   mframeY=26
   mfSizeX=362
   mfSizeY=315

   rFrameX=667
   rframeY=26
   rfSizeX=64
   rfSizeY=315

   lFrameXb=48
   lframeYb=283
   lfSizeXb=257
   lfSizeYb=266

   mFrameXb=305
   mframeYb=341
   mfSizeXb=362
   mfSizeYb=256

   rFrameXb=667
   rframeYb=341
   rfSizeXb=64
   rfSizeYb=256

   OnRendered=InternalOnRendered
   bShowHealButtons=true

   HealthPartDesc(0)="Head wounds are fatal in the vast majority of threat scenarios; however, in those cases where death is not instantaneous, agents will often find that head injuries impair vision and aim. Care should be taken to heal such injuries as quickly as possible or death may result.||Light Wounds: Slightly decreased accuracy.|Medium Wounds: Wavering vision.|Heavy Wounds: Death."
   HealthPartDesc(1)="The torso is by far the portion of the human anatomy able to absorb the most damage, but it is also the easiest to target in close quarters combat. As progressively more damage is inflicted to the torso, agents may find their movements impaired and eventually bleed to death even if a mortal blow to a vital organ is not suffered.||Light Wounds: Slightly impaired movement.|Medium Wounds: Significantly impaired movement.|Major Wounds: Death."
   HealthPartDesc(2)="Obviously damage to the arm is of concern in any combat situation as it has a direct effect on the agent's ability to utilize a variety of weapons. Losing the use of one arm will certainly lower the agent's combat efficiency, while the loss of both arms will render it nearly impossible for an agent to present even a nominal threat to most hostiles.||Light Wounds: Slightly decreased accuracy.|Medium Wounds: Moderately decreased accuracy.|Major Wounds: Significantly decreased accuracy."
   HealthPartDesc(3)="Injuries to the leg will result in drastically diminished mobility. If an agent in hostile territory is unfortunate enough to lose the use of both legs but still remain otherwise viable, they are ordered to execute UNATCO Special Operations Order 99009 (Self-Termination).||Light Wounds: Slightly impaired movement.|Medium Wounds: Moderately impaired movement.|Heavy Wounds: Significantly impaired movement."
   PointsHealedLabel="%d points healed"
   MedKitUseText="To heal a specific region of the body, click on the region, then click the Heal button."
   HealthTitleText="Health"
   HealAllButtonLabel="Heal All"
   HealthLocationHead="Head"
   HealthLocationTorso="Torso"
   HealthLocationRightArm="Right Arm"
   HealthLocationLeftArm="Left Arm"
   HealthLocationRightLeg="Right Leg"
   HealthLocationLeftLeg="Left Leg"
   strHands="Arms"
   strLegs="Legs"
}

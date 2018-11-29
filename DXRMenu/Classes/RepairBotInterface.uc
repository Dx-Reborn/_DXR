/* RepairBot interface */

class RepairBotInterface extends RepairBotInterfaceA;

var DeusExPlayer player;

// Border and Background Translucency
var bool bBorderTranslucent;
var bool bBackgroundTranslucent;
var bool bDrawBorder;
var bool bTickEnabled;

// Default Colors
var Color colBackground;
var Color colBorder;
var Color colHeaderText;
var Color colText;

var GUIButton btnRecharge, btnClose;
var RepairBot repairBot;
var float lastRefresh, refreshInterval;
var() int rFrameX, rframeY, rfSizeX, rfSizeY,lFrameX, lframeY, lfSizeX, lfSizeY;

var GUIProgressBar winBioBar, winRepairBotBar;
var() GUILabel winBioBarText, winRepairBotBarText, winRepairBotInfoText, winTitleName, winInfo;

var localized String RechargeButtonLabel,CloseButtonLabel,RechargeTitle,RepairBotInfoText,RepairBotStatusLabel,RepairBotReadyLabel;
var localized String ReadyLabel,SecondsPluralLabel,SecondsSingularLabel,BioStatusLabel,RepairBotRechargingLabel,RepairBotYouAreHealed;
var localized string strHintRecharge, strHintClose;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	Super.InitComponent(MyController, MyOwner);

	// Get a pointer to the player
	player = DeusExPlayer(PlayerOwner().Pawn);

	CreateControls();
	EnableButtons();
	UpdateBioWindows();

	bTickEnabled = true;
}

// ----------------------------------------------------------------------
// DestroyWindow()
//
// Let the RepairBot go about its business.
// ----------------------------------------------------------------------

event Closed(GUIComponent Sender, bool bCancelled)  // Called when the Menu Owner is closed
{
	if (repairBot != None)
	{
		repairBot.PlayAnim('Stop');
		repairBot.PlaySound(sound'RepairBotLowerArm', SLOT_None);
		repairBot.FollowOrders();
	}
  super.Closed(Sender, bCancelled);
}


function RenderFrames(canvas u)
{
 local int x,y;

  x = ActualLeft(); y = ActualTop();

  u.Style = EMenuRenderStyle.MSTY_Translucent;
  u.DrawColor = class'DXR_Menu'.static.GetPlayerInterfaceFrames(gl.MenuThemeIndex);
  u.SetPos(x + lFrameX, y + lframeY);
  u.drawtileStretched(texture'HUDRepairbotBorder_1', lfSizeX, lfSizeY);
  u.SetPos(x + rFrameX, y + rframeY);
  u.drawtileStretched(texture'HUDRepairbotBorder_2', rfSizeX, rfSizeY);
}

// ----------------------------------------------------------------------
// Tick()
// ----------------------------------------------------------------------

function InternalOnRendered(canvas u)
{
 local float deltaSeconds;

  RenderFrames(u);

 if (!bTickEnabled)
 return;

  deltaSeconds = Controller.renderdelta;

	if (lastRefresh >= refreshInterval)
	{
		lastRefresh = 0.0;
		UpdateRepairBotWindows();
		UpdateInfoText();
		EnableButtons();
	}
	else
	{
		lastRefresh += deltaSeconds;
	}
}

// ----------------------------------------------------------------------
// CreateControls()
// ----------------------------------------------------------------------

function CreateControls()
{
	winBioBar = new class'GUIProgressBar';
 	winBioBar.WinHeight = 12;
  winBioBar.WinWidth = 180;
  winBioBar.WinLeft = 179;
  winBioBar.WinTop = 161;//141;
  winBioBar.Low = 0;
  winBioBar.High = 100;
  winBioBar.NumDecimals = 1;
	winBioBar.CaptionWidth = 0.0; //0.45;
  winBioBar.bBoundToParent = true;
  winBioBar.bShowLow = true;
  winBioBar.bShowHigh = true;
  winBioBar.ValueRightWidth = 0.0;
  winBioBar.BarBack = Material'BlackMaskTex'; // The unselected portion of the bar
  winBioBar.BarTop = Material'Solid'; // The selected portion of the bar
  winBioBar.OnRendered = pr_OnRendered;
	AppendComponent(winBioBar, true);

	winRepairBotBar = new class'GUIProgressBar';
 	winRepairBotBar.WinHeight = 12;
  winRepairBotBar.WinWidth = 180;
  winRepairBotBar.WinLeft = 179;
  winRepairBotBar.WinTop = 141;//161;
  winRepairBotBar.Low = 0;
  winRepairBotBar.High = 100;
  winRepairBotBar.NumDecimals = 1;
	winRepairBotBar.CaptionWidth = 0.0; //0.45;
  winRepairBotBar.bBoundToParent = true;
  winRepairBotBar.bShowLow = true;
  winRepairBotBar.bShowHigh = true;
  winRepairBotBar.ValueRightWidth = 0.0;
  winRepairBotBar.BarBack = Material'BlackMaskTex'; // The unselected portion of the bar
  winRepairBotBar.BarTop = Material'Solid'; // The selected portion of the bar
  winRepairBotBar.OnRendered = pr_OnRendered;
	AppendComponent(winRepairBotBar, true);
	/*----------------------------------------------------------------------------------------------*/

  btnClose = new(none) class'GUIButton';
  btnClose.FontScale = FNS_Small;
  btnClose.Caption = CloseButtonLabel;
  btnClose.Hint = "Close Repair Bot interface";
  btnClose.StyleName="STY_DXR_ButtonNavbar";
  btnClose.bBoundToParent = true;
  btnClose.OnClick = InternalOnClick;
  btnClose.WinHeight = 22;
  btnClose.WinWidth = 110;
  btnClose.WinLeft = 134;
  btnClose.WinTop = 177;
	AppendComponent(btnClose, true);

  btnRecharge = new(none) class'GUIButton';
  btnRecharge.FontScale = FNS_Small;
  btnRecharge.Caption = RechargeButtonLabel;
  btnRecharge.Hint = "Recharge";
  btnRecharge.StyleName="STY_DXR_ButtonNavbar";
  btnRecharge.bBoundToParent = true;
  btnRecharge.OnClick = InternalOnClick;
  btnRecharge.WinHeight = 22;
  btnRecharge.WinWidth = 110;
  btnRecharge.WinLeft = 23;
  btnRecharge.WinTop = 177;
	AppendComponent(btnRecharge, true);
  /*----------------------------------------------------------------------------------------------*/

  WinTitleName = new(none) class'GUILabel';
  WinTitleName.bBoundToParent = true;
  WinTitleName.TextColor = class'DXR_Menu'.static.GetPlayerInterfaceHDR(gl.MenuThemeIndex);
  WinTitleName.caption = RechargeTitle;
  WinTitleName.TextFont="UT2HeaderFont";
  WinTitleName.bMultiLine = false;
  WinTitleName.TextAlign = TXTA_Left;
  WinTitleName.VertAlign = TXTA_Center;
  WinTitleName.FontScale = FNS_Small;
 	WinTitleName.WinHeight = 14;
  WinTitleName.WinWidth = 332;
  WinTitleName.WinLeft = 27;
  WinTitleName.WinTop = 40;
	AppendComponent(WinTitleName, true);

  winInfo = new(none) class'GUILabel';
  winInfo.bBoundToParent = true;
  winInfo.TextColor = class'DXR_Menu'.static.GetPlayerInterfaceTextLabels(gl.MenuThemeIndex);
  winInfo.TextFont="UT2SmallFont";
  winInfo.bMultiLine = true;
  winInfo.TextAlign = TXTA_Left;
  winInfo.VertAlign = TXTA_Center;
  winInfo.FontScale = FNS_Small;
 	winInfo.WinHeight = 75;
  winInfo.WinWidth = 327;
  winInfo.WinLeft = 29;
  winInfo.WinTop = 59;
	AppendComponent(winInfo, true);

  winBioBarText = new(none) class'GUILabel';
  winBioBarText.bBoundToParent = true;
  winBioBarText.TextColor = class'DXR_Menu'.static.GetPlayerInterfaceTextLabels(gl.MenuThemeIndex);
  winBioBarText.caption = BioStatusLabel;
  winBioBarText.TextFont="UT2SmallFont";
  winBioBarText.bMultiLine = false;
  winBioBarText.TextAlign = TXTA_Left;
  winBioBarText.VertAlign = TXTA_Center;
  winBioBarText.FontScale = FNS_Small;
 	winBioBarText.WinHeight = 20;
  winBioBarText.WinWidth = 149;
  winBioBarText.WinLeft = 26;
  winBioBarText.WinTop = 157;
	AppendComponent(winBioBarText, true);

  winRepairBotBarText = new(none) class'GUILabel';
  winRepairBotBarText.bBoundToParent = true;
  winRepairBotBarText.TextColor = class'DXR_Menu'.static.GetPlayerInterfaceTextLabels(gl.MenuThemeIndex);
  winRepairBotBarText.TextFont="UT2SmallFont";
  winRepairBotBarText.bMultiLine = false;
  winRepairBotBarText.TextAlign = TXTA_Left;
  winRepairBotBarText.VertAlign = TXTA_Center;
  winRepairBotBarText.FontScale = FNS_Small;
 	winRepairBotBarText.WinHeight = 20;
  winRepairBotBarText.WinWidth = 149;
  winRepairBotBarText.WinLeft = 26;
  winRepairBotBarText.WinTop = 140;
	AppendComponent(winRepairBotBarText, true);

  winRepairBotInfoText = new(none) class'GUILabel';
  winRepairBotInfoText.bBoundToParent = true;
  winRepairBotInfoText.TextColor = class'DXR_Menu'.static.GetPlayerInterfaceTextLabels(gl.MenuThemeIndex);
  winRepairBotInfoText.TextFont="UT2SmallFont";
  winRepairBotInfoText.bMultiLine = false;
  winRepairBotInfoText.TextAlign = TXTA_Left;
  winRepairBotInfoText.VertAlign = TXTA_Center;
  winRepairBotInfoText.FontScale = FNS_Small;
 	winRepairBotInfoText.WinHeight = 20;
  winRepairBotInfoText.WinWidth = 149;
  winRepairBotInfoText.WinLeft = 26;
  winRepairBotInfoText.WinTop = 140;
	AppendComponent(winRepairBotInfoText, true);
}

// From DeusEx\PlayerInterfacePanel.uc
function ApplyTheme()
{
  local int i;

  for (i=0;i<Controls.Length;i++)
  {
     if ((controls[i].IsA('GUIImage')) && (controls[i].tag == 75))
     {
       if (class'DXR_Menu'.static.GetBackgoundMode(gl.MenuThemeIndex) == 0) // STY_Normal
          {
           GUIImage(controls[i]).ImageRenderStyle = eMenuRenderStyle.MSTY_Normal;
           GUIImage(controls[i]).ImageColor = class'DXR_Menu'.static.GetPlayerInterfaceBG(gl.MenuThemeIndex);
           GUIImage(controls[i]).ImageColor.A = 255;
          }
          else if (class'DXR_Menu'.static.GetBackgoundMode(gl.MenuThemeIndex) == 1)
               {
                GUIImage(controls[i]).ImageRenderStyle = eMenuRenderStyle.MSTY_Translucent;
                GUIImage(controls[i]).ImageColor = class'DXR_Menu'.static.GetPlayerInterfaceBG(gl.MenuThemeIndex);
                GUIImage(controls[i]).ImageColor.A = 255;
               }
          else if (class'DXR_Menu'.static.GetBackgoundMode(gl.MenuThemeIndex) == 2)
               {
                GUIImage(controls[i]).ImageRenderStyle = eMenuRenderStyle.MSTY_Additive;
                GUIImage(controls[i]).ImageColor = class'DXR_Menu'.static.GetPlayerInterfaceBG(gl.MenuThemeIndex);
                GUIImage(controls[i]).ImageColor.A = 255;
               }
          else if (class'DXR_Menu'.static.GetBackgoundMode(gl.MenuThemeIndex) == 3)
               {
                GUIImage(controls[i]).ImageRenderStyle = eMenuRenderStyle.MSTY_Alpha;
                GUIImage(controls[i]).ImageColor = class'DXR_Menu'.static.GetPlayerInterfaceBG(gl.MenuThemeIndex);
                GUIImage(controls[i]).ImageColor.A = class'DXR_Menu'.static.GetAlpha(gl.MenuThemeIndex);
               }
     }
  }
}

function pr_OnRendered(canvas u)
{
   u.font = font'MSS_8';

   u.SetPos(winBioBar.ActualLeft(),winBioBar.ActualTop());
   u.SetDrawColor(255,255,255,255);
   u.DrawTextJustified(winBioBar.Caption, 1, winBioBar.ActualLeft(),winBioBar.ActualTop(), winBioBar.ActualLeft() + winBioBar.ActualWidth(), winBioBar.ActualTop() + winBioBar.ActualHeight());
   u.ReSet();

   u.font = font'MSS_8';
   u.SetPos(winRepairBotBar.ActualLeft(),winRepairBotBar.ActualTop());
   u.SetDrawColor(255,255,255,255);
   u.DrawTextJustified(winRepairBotBar.Caption, 1, winRepairBotBar.ActualLeft(),winRepairBotBar.ActualTop(), winRepairBotBar.ActualLeft() + winRepairBotBar.ActualWidth(), winRepairBotBar.ActualTop() + winRepairBotBar.ActualHeight());
   u.ReSet();
}


// ----------------------------------------------------------------------
// UpdateInfoText()
// ----------------------------------------------------------------------

function UpdateInfoText()
{
	local String infoText;

	if (repairBot != None)
	{
		infoText = class'Actor'.static.Sprintf(RepairBotInfoText, repairBot.chargeAmount, repairBot.chargeRefreshTime);

		if (player.Energy >= player.EnergyMax)
			infoText = infoText $ RepairBotYouAreHealed;
		else if (repairBot.CanCharge())
			infoText = infoText $ RepairBotReadyLabel;
		else
			infoText = infoText $ RepairBotRechargingLabel;

		winInfo.Caption = infoText;
	}
}

// ----------------------------------------------------------------------
// UpdateBioWindows()
// ----------------------------------------------------------------------

function UpdateBioWindows()
{
	local float energyPercent;

	energyPercent = 100.0 * (player.Energy / player.EnergyMax);
	winBioBar.Value = energyPercent;
  winBioBar.BarColor = class'Actor'.static.GetColorScaled(winBioBar.Value * 0.01);

	winBioBar.Caption = String(Int(energyPercent)) $ "%";

//	winBioInfoText.Caption = BioStatusLabel;
}

// ----------------------------------------------------------------------
// UpdateRepairBotWindows()
// ----------------------------------------------------------------------

function UpdateRepairBotWindows()
{
	local float barPercent;
	local float secondsRemaining;

	if (repairBot != None)
	{
		// Update the bar
		if (repairBot.CanCharge())
		{		
			winRepairBotBar.Value = 100;
			winRepairBotBar.Caption = ReadyLabel;
		}
		else
		{
			secondsRemaining = repairBot.GetRefreshTimeRemaining();

			barPercent = 100 * (1.0 - (secondsRemaining / Float(repairBot.chargeRefreshTime)));

			winRepairBotBar.Value = barPercent;

			if (secondsRemaining == 1)
				winRepairBotBar.Caption = class'Actor'.static.Sprintf(SecondsSingularLabel, Int(secondsRemaining));
			else
				winRepairBotBar.Caption = class'Actor'.static.Sprintf(SecondsPluralLabel, Int(secondsRemaining));
		}
	  winRepairBotBar.BarColor = class'Actor'.static.GetColorScaled(winRepairBotBar.Value * 0.01);
    winRepairBotInfoText.Caption = RepairBotStatusLabel;
	}
}

// ----------------------------------------------------------------------
// ButtonActivated()
// ----------------------------------------------------------------------

function bool InternalOnClick(GUIComponent Sender)
{
	local bool bHandled;

	bHandled = True;

	switch(Sender)
	{
		case btnClose:
			Controller.CloseMenu();
			break;

		case btnRecharge:
			if (repairBot != None)
			{
				repairBot.ChargePlayer(player);	

				// play a cool animation
				//repairBot.PlayAnim('Clamp'); // DXR:Turned off, like in GMDX

				UpdateBioWindows();
				UpdateRepairBotWindows();
				UpdateInfoText();
				EnableButtons();
			}
			break;
	}

	return bHandled;
}

// ----------------------------------------------------------------------
// EnableButtons()
// ----------------------------------------------------------------------

function EnableButtons()
{
	if (repairBot != None)
	{
		if (player.Energy >= player.EnergyMax)
			btnRecharge.DisableMe();
		else if (repairBot.CanCharge())
		btnRecharge.EnableMe();
		else
		btnRecharge.DisableMe();
	}
}

// ----------------------------------------------------------------------
// SetRepairBot()
// ----------------------------------------------------------------------

function SetRepairBot(RepairBot newBot)
{
	repairBot = newBot;

	if (repairBot != None)
	{
		repairBot.StandStill();
		repairBot.PlayAnim('Start');
		repairBot.PlaySound(sound'RepairBotRaiseArm', SLOT_None);
		UpdateInfoText();
		UpdateRepairBotWindows();
		EnableButtons();
	}
}

function bool InternalOnKeyEvent(out byte Key, out byte State, float delta)
{
	local bool bKeyHandled;
	local Interactions.EInputKey iKey;

	iKey = EInputKey(Key);
	bKeyHandled = true;

		switch(iKey)
		{
			case IK_ENTER:
       if (State == 1)
       {
       if (btnRecharge.MenuState != MSAT_Disabled)
        InternalOnClick(btnRecharge);
       }
			break;
			default:
				bKeyHandled = false;
		}
		return bKeyHandled;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
    OnRendered=InternalOnRendered
		OnKeyEvent=InternalOnKeyEvent

    refreshInterval=0.20
    RechargeButtonLabel="  Recharge  "
    CloseButtonLabel="  Close  "
    RechargeTitle="REPAIRBOT INTERFACE"
    RepairBotInfoText="The RepairBot can restore up to %d points of Bio Electric Energy every %d seconds."
    RepairBotStatusLabel="RepairBot Status:"
    ReadyLabel="Ready!"
    SecondsPluralLabel="Recharging: %d seconds"
    SecondsSingularLabel="Recharging: %d second"
    BioStatusLabel="Bio Energy:"
    RepairBotRechargingLabel="||The RepairBot is currently Recharging.  Please Wait."
    RepairBotReadyLabel="||The RepairBot is Ready, you may now Recharge."
    RepairBotYouAreHealed="||Your BioElectric Energy is at Maximum."

    winHeight=220
    winWidth=384
 		DefaultHeight=220
		DefaultWidth=384

	MaxPageHeight=220
	MaxPageWidth=384
	MinPageHeight=220
	MinPageWidth=384

	  lFrameX=8
	  lFrameY=19
	  lfSizeX=354
	  lfSizeY=293

	  rFrameX=362
	  rFrameY=19
	  rfSizeX=16
	  rfSizeY=293





	Begin Object Class=FloatingImage Name=FloatingFrameBackground
		Image=Texture'DXR_RepairbotBackground'
		ImageRenderStyle=MSTY_Translucent
		ImageStyle=ISTY_Tiled
		ImageColor=(R=255,G=255,B=255,A=255)
		DropShadow=None
		WinWidth=368
		WinHeight=192
		WinLeft=8
		WinTop=20
		RenderWeight=0.000003
		bBoundToParent=True
		bScaleToParent=True
		tag=75
	End Object
	i_FrameBG=FloatingFrameBackground

	Begin Object Class=GUIHeader Name=TitleBar
		WinWidth=0.0
		WinHeight=0.0
		WinLeft=0
		WinTop=0
		RenderWeight=0.01
		FontScale=FNS_Small
		bUseTextHeight=false
		bAcceptsInput=True
		bNeverFocus=true //False
		bBoundToParent=true
		bScaleToParent=true
    OnRendered=none
		ScalingType=SCALE_ALL
    StyleName=""
    Justification=TXTA_Left
	End Object
	t_WindowTitle=TitleBar


}

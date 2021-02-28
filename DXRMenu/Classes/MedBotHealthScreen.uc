//=============================================================================
// HUDMedBotHealthScreen
//=============================================================================

class MedBotHealthScreen extends gui_Health;

var() MedicalBot medBot;
var GUIProgressBar winHealthBar;
var GUIButton btnHealAll;
var GUILabel winHealthInfoText;
var bool bSkipAnimation;
var bool bTickEnabled;

var Localized String MedbotInterfaceText, HealthInfoTextLabel, MedBotRechargingLabel, MedBotReadyLabel;
var Localized String MedBotYouAreHealed, SecondsPluralLabel, SecondsSingularLabel, ReadyLabel;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------
function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    Super.Initcomponent(MyController, MyOwner);

    MedBot = gl.lastMedBot;
    createSomeControls(); // Don't call createMyControls!
    bTickEnabled = True;
}

function ShowPanel(bool bShow)
{
    EnableButtons();
    super.ShowPanel(bShow);
}

// ----------------------------------------------------------------------
// Tick()
// ----------------------------------------------------------------------

function Tick(float deltaTime)
{
    if (bTickEnabled)
        UpdateMedBotDisplay();
}

// ----------------------------------------------------------------------
// CreateControls()
// ----------------------------------------------------------------------

function CreateSomeControls()
{
    winHealthBar = new class'GUIProgressBar';
    winHealthBar.FontName="UT2HeaderFont";
    winHealthBar.WinHeight = 20;
    winHealthBar.WinWidth = 181;
    winHealthBar.WinLeft = 520;
    winHealthBar.WinTop = 431;//380;
    winHealthBar.High = 100;
    winHealthBar.NumDecimals = 1;
    winHealthBar.CaptionWidth = 0.0; //0.45;
    winHealthBar.bBoundToParent = true;
    winHealthBar.bShowLow = true;
    winHealthBar.bShowHigh = true;
    winHealthBar.ValueRightWidth = 0.0;
    winHealthBar.Caption = "";
    winHealthBar.BarBack = Material'MenuTitleBubble_Center'; // The unselected portion of the bar
    winHealthBar.BarTop = Material'Solid'; // The selected portion of the bar
    winHealthBar.OnRendered = pr_OnRendered;
    AppendComponent(winHealthBar, true);

    winHealthInfoText = new class'GUILabel';
    winHealthInfoText.bBoundToParent = true;
    winHealthInfoText.TextColor = class'DXR_Menu'.static.GetPlayerInterfaceHDR(gl.MenuThemeIndex);
    winHealthInfoText.caption = "Health";
    winHealthInfoText.TextFont="UT2SmallFont";
    winHealthInfoText.bMultiLine = true;
    winHealthInfoText.TextAlign = TXTA_Left;
    winHealthInfoText.VertAlign = TXTA_Center;
    winHealthInfoText.FontScale = FNS_Small;
    winHealthInfoText.WinHeight = 87;
    winHealthInfoText.WinWidth = 278;
    winHealthInfoText.WinLeft = 423;
    winHealthInfoText.WinTop = 338;//288;
    AppendComponent(winHealthInfoText, true);

    btnHealAll = new class'GUIButton';
    btnHealAll.FontScale = FNS_Small;
    btnHealAll.Caption = HealAllButtonLabel;
    btnHealAll.Hint = "Restore all health when possible";
    btnHealAll.StyleName="STY_DXR_ButtonNavbar";
    btnHealAll.bBoundToParent = true;
    btnHealAll.OnClick = ButtonActivated;
    btnHealAll.WinLeft = 420;
    btnHealAll.WinTop = 428; //377;
    btnHealAll.WinWidth = 96;
    btnHealAll.WinHeight = 26;
    AppendComponent(btnHealAll, true);

    if (iHealthBG != none)
        iHealthBG.Image=texture'DXR_MedbotHealthBackground';

    if (iHealthOverlays != none)
        iHealthOverlays.Image=texture'DXR_MedBotOverlays';

}

function pr_OnRendered(canvas u)
{
   u.font = font'MSS_8';
   u.SetPos(winHealthBar.ActualLeft(),winHealthBar.ActualTop());
   u.SetDrawColor(255,255,255,255);
   u.DrawTextJustified(winHealthBar.Caption, 1, winHealthBar.ActualLeft(),winHealthBar.ActualTop(), winHealthBar.ActualLeft() + winHealthBar.ActualWidth(), winHealthBar.ActualTop() + winHealthBar.ActualHeight());

   Super.pr_OnRendered(u);

   u.ReSet();
}

function PaintFrames(canvas u)
{
  local float x,y;

  x = ActualLeft(); y = ActualTop();

  Tick(controller.renderDelta);

//  u.SetDrawColor(0,255,0,128);
  u.DrawColor = class'DXR_Menu'.static.GetPlayerInterfaceFrames(gl.MenuThemeIndex);
  u.Style = EMenuRenderStyle.MSTY_Translucent;

  u.SetPos(x + lFrameX, y + lframeY);
  u.drawtileStretched(texture'HUDMedBotHealthBorder_1', lfSizeX, lfSizeY);

  u.SetPos(x + mFrameX, y + mframeY);
  u.drawtileStretched(texture'HUDMedBotHealthBorder_2', mfSizeX, mfSizeY);

  u.SetPos(x + rFrameX, y + rframeY);
  u.drawtileStretched(texture'HUDMedBotHealthBorder_3', rfSizeX, rfSizeY);
/*-----------------*/
  u.SetPos(x + lFrameXb, y + lframeYb);
  u.drawtileStretched(texture'HUDMedBotHealthBorder_4', lfSizeXb, lfSizeYb);

  u.SetPos(x + mFrameXb, y + mframeYb); 
  u.drawtileStretched(texture'DXR_MedBotHealthBorder_5', mfSizeXb, mfSizeYb);

  u.SetPos(x + rFrameXb, y + rframeYb);
  u.drawtileStretched(texture'DXR_MedBotHealthBorder_6', rfSizeXb, rfSizeYb);
}


// ----------------------------------------------------------------------
// UpdateMedBotDisplay()
// ----------------------------------------------------------------------

function UpdateMedBotDisplay()
{
    local float barPercent;
    local String infoText;
    local float secondsRemaining;

    if (medBot != None)
    {
        infoText = class'Actor'.static.Sprintf(HealthInfoTextLabel, medBot.healAmount);
        winHealthBar.BarColor = class'Actor'.static.GetColorScaled(winHealthBar.value * 0.01);

        // Update the bar
        if (medBot.CanHeal())
        {
            winHealthBar.value = 100; //SetCurrentValue(100);
            winHealthBar.Caption = ReadyLabel; //SetText(ReadyLabel);

            if (IsPlayerDamaged())
                infoText = infoText $ MedBotReadyLabel;
            else
                infoText = infoText $ MedBotYouAreHealed;
        }
        else
        {
            secondsRemaining = medBot.GetRefreshTimeRemaining();

            barPercent = 100 * (1.0 - (secondsRemaining / Float(medBot.healRefreshTime)));

            winHealthBar.value = barPercent; //SetCurrentValue(barPercent);

            if (secondsRemaining == 1)
                winHealthBar.Caption = class'Actor'.static.Sprintf(SecondsSingularLabel, Int(secondsRemaining));
            else
                winHealthBar.Caption = class'Actor'.static.Sprintf(SecondsPluralLabel, Int(secondsRemaining));

            if (IsPlayerDamaged())
                infoText = infoText $ MedBotRechargingLabel;
            else
                infoText = infoText $ MedBotYouAreHealed;
        }
        winHealthInfoText.Caption = infoText;
    }
    EnableButtons();
}

// ----------------------------------------------------------------------
// ButtonActivated()
// ----------------------------------------------------------------------

function bool ButtonActivated(GUIComponent Sender)
{
    local bool bHandled;

    bHandled = True;

    switch(Sender)
    {
        case btnHealAll:
            MedBotHealPlayer();
            fillvalues(); // Обновить индикаторы.
            break;

        default:
            bHandled = False;
            break;
    }

    if (bHandled)
        return True;
}

// ----------------------------------------------------------------------
// MedBotHealPlayer()
// ----------------------------------------------------------------------

function MedBotHealPlayer()
{
    medBot.HealPlayer(player);
    UpdateMedBotDisplay();
//  UpdateRegionWindows();
}

// ----------------------------------------------------------------------
// EnableButtons()
// ----------------------------------------------------------------------

function EnableButtons()
{
    if (medBot != None)
    {
        if (medBot.CanHeal() && IsPlayerDamaged())
            btnHealAll.EnableMe(); //EnableWindow(medBot.CanHeal() && IsPlayerDamaged());
        else
            btnHealAll.DisableMe();// EnableWindow(False);
    }   
}

// ----------------------------------------------------------------------
// SetMedicalBot()
// ----------------------------------------------------------------------

function SetMedicalBot(MedicalBot newBot, optional bool bPlayAnim)
{
    medBot = newBot;

    if (medBot != None)
    {
        medBot.StandStill();

        if (bPlayAnim)
        {
            medBot.PlayAnim('Start');
            medBot.PlaySound(sound'MedicalBotRaiseArm', SLOT_None);
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
    lFrameX=48
    lframeY=26
    lfSizeX=257
    lfSizeY=257

    mFrameX=305
    mframeY=26
    mfSizeX=362
    mfSizeY=256

    rFrameX=667
    rframeY=26
    rfSizeX=64
    rfSizeY=256//
/////////////////

    lFrameXb=48
    lframeYb=283
    lfSizeXb=257
    lfSizeYb=255

    mFrameXb=305
    mframeYb=282
    mfSizeXb=362
    mfSizeYb=256

    rFrameXb=667 //
    rframeYb=282
    rfSizeXb=64
    rfSizeYb=256

    MedbotInterfaceText="MEDBOT INTERFACE"
    HealthInfoTextLabel="The MedBot will heal up to %d units, which are distributed evenly among your damaged body regions."
    MedBotRechargingLabel="|The MedBot is currently Recharging.  Please Wait."
    MedBotReadyLabel="|The MedBot is Ready, you may now be Healed."
    MedBotYouAreHealed="|You are currently in Full Health."
    SecondsPluralLabel="Recharging: %d seconds"
    SecondsSingularLabel="Recharging: %d second"
    ReadyLabel="Ready!"
    HealAllButtonLabel="  Heal All  "
    bShowHealButtons=false
//DXR_MedbotHealthBackground
/*    clientBorderTextures(0)=Texture'DeusExUI.UserInterface.HUDMedBotHealthBorder_1'
    clientBorderTextures(1)=Texture'DeusExUI.UserInterface.HUDMedBotHealthBorder_2'
    clientBorderTextures(2)=Texture'DeusExUI.UserInterface.HUDMedBotHealthBorder_3'
    clientBorderTextures(3)=Texture'DeusExUI.UserInterface.HUDMedBotHealthBorder_4'
    clientBorderTextures(4)=Texture'DeusExUI.UserInterface.HUDMedBotHealthBorder_5'
    clientBorderTextures(5)=Texture'DeusExUI.UserInterface.HUDMedBotHealthBorder_6'*/
}

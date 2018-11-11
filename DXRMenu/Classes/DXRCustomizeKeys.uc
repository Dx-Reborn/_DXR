/*

*/

class DXRCustomizeKeys extends DxWindowTemplate;// dependsOn(Interactions);

struct S_KeyDisplayItem
{
	var() Interactions.EInputKey inputKey;
	var() String DisplayName;
};

var localized string	FunctionText[46];
var string				MenuValues1[46];
var string				MenuValues2[46];
var string				AliasNames[46];
var string				PendingCommands[100];
var S_KeyDisplayItem    keyDisplayNames[71];
var localized string			  NoneText;
var int					Pending;
var int					selection;		
var bool				bWaitingForInput;

var localized string strHeaderActionLabel;
var localized string strHeaderAssignedLabel;
var localized string WaitingHelpText;
var localized string InputHelpText;
var localized string ReassignedFromLabel;

var localized string strOK, strCancel, strDefault;
var GUIButton btnDefault, btnOK, btnCancel;
var GUILabel winHelp;

var DXRKeysActionsListBox lKeys;
var DXR_ka_List lstKeys;

function CreateMyControls()
{
  SetSize(512, 520);

  lKeys = new class'DXRKeysActionsListBox';
  lKeys.WinWidth = 500;
  lKeys.WinHeight = 390;
  lKeys.WinLeft = 17;
  lKeys.WinTop = 41;
  lKeys.bScaleToParent = true;
  lKeys.bBoundToParent = true;
	AppendComponent(lKeys, true);
  lstKeys = lKeys.aList;

  /*----------------------------------------*/
  winHelp = new class'GUILabel';
  winHelp.Caption = "";
  winHelp.WinHeight = 51;
  winHelp.WinWidth = 500;
  winHelp.WinLeft = 17;
  winHelp.WinTop = 451;
  winHelp.bMultiLine = true;
  winHelp.VertAlign = TXTA_Center;
  winHelp.TextAlign = TXTA_Center;
  winHelp.TextFont = "UT2SmallFont";
  winHelp.TextColor = class'Canvas'.static.MakeColor(255,255,255,255);
	AppendComponent(winHelp, true);

  btnDefault = new class'GUIButton';
  btnDefault.OnClick = InternalOnClick;
  btnDefault.fontScale = FNS_Small;
  btnDefault.StyleName="STY_DXR_MediumButton";
  btnDefault.Caption = strDefault;
  btnDefault.WinHeight = 21;
  btnDefault.WinWidth = 180;
  btnDefault.WinLeft = 9;
  btnDefault.WinTop = 529;
	AppendComponent(btnDefault, true);

  btnOK = new class'GUIButton';
  btnOK.OnClick=InternalOnClick;
  btnOK.fontScale = FNS_Small;
  btnOK.StyleName="STY_DXR_MediumButton";
  btnOK.Caption = strOK;
  btnOK.WinHeight = 21;
  btnOK.WinWidth = 100;
  btnOK.WinLeft = 418;
  btnOK.WinTop = 529;
	AppendComponent(btnOK, true);

  btnCancel = new class'GUIButton';
  btnCancel.OnClick=InternalOnClick;
  btnCancel.fontScale = FNS_Small;
  btnCancel.StyleName="STY_DXR_MediumButton";
  btnCancel.Caption = strCancel;
  btnCancel.WinHeight = 21;
  btnCancel.WinWidth = 100;
  btnCancel.WinLeft = 316;
  btnCancel.WinTop = 529;
	AppendComponent(btnCancel, true);
}

function bool InternalOnKeyEvent(out byte Key, out byte State, float delta)
{

	return True;
}

function ListDoubleClick(GUIComponent Sender);

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
    FunctionText(0)="Fire Weapon/Use object in hand"
    FunctionText(1)="Use object in world"
    FunctionText(2)="Drop/Throw Item"
    FunctionText(3)="Put Away Item"
    FunctionText(4)="Move Forward"
    FunctionText(5)="Move Backward"
    FunctionText(6)="Turn Left"
    FunctionText(7)="Turn Right"
    FunctionText(8)="Strafe Left"
    FunctionText(9)="Strafe Right"
    FunctionText(10)="Lean Left"
    FunctionText(11)="Lean Right"
    FunctionText(12)="Jump"
    FunctionText(13)="Crouch"
    FunctionText(14)="Mouse Look"
    FunctionText(15)="Look Up"
    FunctionText(16)="Look Down"
    FunctionText(17)="Center View"
    FunctionText(18)="Walk/Run"
    FunctionText(19)="Toggle Walk/Run"
    FunctionText(20)="Strafe"
    FunctionText(21)="Select Next Belt Item"
    FunctionText(22)="Select Previous Belt Item"
    FunctionText(23)="Reload Weapon"
    FunctionText(24)="Toggle Scope"
    FunctionText(25)="Toggle Laser Sight"
    FunctionText(26)="Activate All Augmentations"
    FunctionText(27)="Deactivate All Augmentations"
    FunctionText(28)="Change Ammo"
    FunctionText(29)="Take Screenshot"
    FunctionText(30)="Activate Inventory Screen"
    FunctionText(31)="Activate Health Screen"
    FunctionText(32)="Activate Augmentations Screen"
    FunctionText(33)="Activate Skills Screen"
    FunctionText(34)="Activate Goals/Notes Screen"
    FunctionText(35)="Activate Conversations Screen"
    FunctionText(36)="Activate Images Screen"
    FunctionText(37)="Activate Logs Screen"
    FunctionText(38)="Quick Save"
    FunctionText(39)="Quick Load"
    FunctionText(40)="Toggle Crosshairs"
    FunctionText(41)="Toggle Hit Display"
    FunctionText(42)="Toggle Compass"
    FunctionText(43)="Toggle Augmentation Display"
    FunctionText(44)="Toggle Object Belt"
    FunctionText(45)="Toggle Ammo Display"
    AliasNames(0)="ParseLeftClick|Fire"
    AliasNames(1)="ParseRightClick"
    AliasNames(2)="DropItem"
    AliasNames(3)="PutInHand"
    AliasNames(4)="MoveForward"
    AliasNames(5)="MoveBackward"
    AliasNames(6)="TurnLeft"
    AliasNames(7)="TurnRight"
    AliasNames(8)="StrafeLeft"
    AliasNames(9)="StrafeRight"
    AliasNames(10)="LeanLeft"
    AliasNames(11)="LeanRight"
    AliasNames(12)="Jump"
    AliasNames(13)="Duck"
    AliasNames(14)="Look"
    AliasNames(15)="LookUp"
    AliasNames(16)="LookDown"
    AliasNames(17)="CenterView"
    AliasNames(18)="Walking"
    AliasNames(19)="ToggleWalk"
    AliasNames(20)="Strafe"
    AliasNames(21)="NextBeltItem"
    AliasNames(22)="PrevBeltItem"
    AliasNames(23)="ReloadWeapon"
    AliasNames(24)="ToggleScope"
    AliasNames(25)="ToggleLaser"
    AliasNames(26)="ActivateAllAugs"
    AliasNames(27)="DeactivateAllAugs"
    AliasNames(28)="SwitchAmmo"
    AliasNames(29)="Shot"
    AliasNames(30)="ShowInventoryWindow"
    AliasNames(31)="ShowHealthWindow"
    AliasNames(32)="ShowAugmentationsWindow"
    AliasNames(33)="ShowSkillsWindow"
    AliasNames(34)="ShowGoalsWindow"
    AliasNames(35)="ShowConversationsWindow"
    AliasNames(36)="ShowImagesWindow"
    AliasNames(37)="ShowLogsWindow"
    AliasNames(38)="QuickSave"
    AliasNames(39)="QuickLoad"
    AliasNames(40)="ToggleCrosshair"
    AliasNames(41)="ToggleHitDisplay"
    AliasNames(42)="ToggleCompass"
    AliasNames(43)="ToggleAugDisplay"
    AliasNames(44)="ToggleObjectBelt"
    AliasNames(45)="ToggleAmmoDisplay"
     keyDisplayNames(0)=(inputKey=IK_LeftMouse,displayName="Left Mouse Button")
     keyDisplayNames(1)=(inputKey=IK_RightMouse,displayName="Right Mouse Button")
     keyDisplayNames(2)=(inputKey=IK_MiddleMouse,displayName="Middle Mouse Button")
     keyDisplayNames(3)=(inputKey=IK_CapsLock,displayName="CAPS Lock")
     keyDisplayNames(4)=(inputKey=IK_PageUp,displayName="Page Up")
     keyDisplayNames(5)=(inputKey=IK_PageDown,displayName="Page Down")
     keyDisplayNames(6)=(inputKey=IK_PrintScrn,displayName="Print Screen")
     keyDisplayNames(7)=(inputKey=IK_GreyStar,displayName="NumPad Asterisk")
     keyDisplayNames(8)=(inputKey=IK_GreyPlus,displayName="NumPad Plus")
     keyDisplayNames(9)=(inputKey=IK_GreyMinus,displayName="NumPad Minus")
     keyDisplayNames(10)=(inputKey=IK_GreySlash,displayName="NumPad Slash")
     keyDisplayNames(11)=(inputKey=IK_NumPadPeriod,displayName="NumPad Period")
     keyDisplayNames(12)=(inputKey=IK_NumLock,displayName="Num Lock")
     keyDisplayNames(13)=(inputKey=IK_ScrollLock,displayName="Scroll Lock")
     keyDisplayNames(14)=(inputKey=IK_LShift,displayName="Left Shift")
     keyDisplayNames(15)=(inputKey=IK_RShift,displayName="Right Shift")
     keyDisplayNames(16)=(inputKey=IK_LControl,displayName="Left Control")
     keyDisplayNames(17)=(inputKey=IK_RControl,displayName="Right Control")
     keyDisplayNames(18)=(inputKey=IK_MouseWheelUp,displayName="Mouse Wheel Up")
     keyDisplayNames(19)=(inputKey=IK_MouseWheelDown,displayName="Mouse Wheel Down")
     keyDisplayNames(20)=(inputKey=IK_MouseX,displayName="Mouse X")
     keyDisplayNames(21)=(inputKey=IK_MouseY,displayName="Mouse Y")
     keyDisplayNames(22)=(inputKey=IK_MouseZ,displayName="Mouse Z")
     keyDisplayNames(23)=(inputKey=IK_MouseW,displayName="Mouse W")
     keyDisplayNames(24)=(inputKey=IK_LeftBracket,displayName="Left Bracket")
     keyDisplayNames(25)=(inputKey=IK_RightBracket,displayName="Right Bracket")
     keyDisplayNames(26)=(inputKey=IK_SingleQuote,displayName="Single Quote")
     keyDisplayNames(27)=(inputKey=IK_Joy1,displayName="Joystick Button 1")
     keyDisplayNames(28)=(inputKey=IK_Joy2,displayName="Joystick Button 2")
     keyDisplayNames(29)=(inputKey=IK_Joy3,displayName="Joystick Button 3")
     keyDisplayNames(30)=(inputKey=IK_Joy4,displayName="Joystick Button 4")
     keyDisplayNames(31)=(inputKey=IK_JoyX,displayName="Joystick X")
     keyDisplayNames(32)=(inputKey=IK_JoyY,displayName="Joystick Y")
     keyDisplayNames(33)=(inputKey=IK_JoyZ,displayName="Joystick Z")
     keyDisplayNames(34)=(inputKey=IK_JoyR,displayName="Joystick R")
     keyDisplayNames(35)=(inputKey=IK_JoyU,displayName="Joystick U")
     keyDisplayNames(36)=(inputKey=IK_JoyV,displayName="Joystick V")
/*     keyDisplayNames(37)=(inputKey=IK_JoyPovUp,displayName="Joystick Pov Up")
     keyDisplayNames(38)=(inputKey=IK_JoyPovDown,displayName="Joystick Pov Down")
     keyDisplayNames(39)=(inputKey=IK_JoyPovLeft,displayName="Joystick Pov Left")
     keyDisplayNames(40)=(inputKey=IK_JoyPovRight,displayName="Joystick Pov Right")*/
     keyDisplayNames(41)=(inputKey=IK_Ctrl,displayName="Control")
     keyDisplayNames(42)=(inputKey=IK_Left,displayName="Left Arrow")
     keyDisplayNames(43)=(inputKey=IK_Right,displayName="Right Arrow")
     keyDisplayNames(44)=(inputKey=IK_Up,displayName="Up Arrow")
     keyDisplayNames(45)=(inputKey=IK_Down,displayName="Down Arrow")
     keyDisplayNames(46)=(inputKey=IK_Insert,displayName="Insert")
     keyDisplayNames(47)=(inputKey=IK_Home,displayName="Home")
     keyDisplayNames(48)=(inputKey=IK_Delete,displayName="Delete")
     keyDisplayNames(49)=(inputKey=IK_End,displayName="End")
     keyDisplayNames(50)=(inputKey=IK_NumPad0,displayName="NumPad 0")
     keyDisplayNames(51)=(inputKey=IK_NumPad1,displayName="NumPad 1")
     keyDisplayNames(52)=(inputKey=IK_NumPad2,displayName="NumPad 2")
     keyDisplayNames(53)=(inputKey=IK_NumPad3,displayName="NumPad 3")
     keyDisplayNames(54)=(inputKey=IK_NumPad4,displayName="NumPad 4")
     keyDisplayNames(55)=(inputKey=IK_NumPad5,displayName="NumPad 5")
     keyDisplayNames(56)=(inputKey=IK_NumPad6,displayName="NumPad 6")
     keyDisplayNames(57)=(inputKey=IK_NumPad7,displayName="NumPad 7")
     keyDisplayNames(58)=(inputKey=IK_NumPad8,displayName="NumPad 8")
     keyDisplayNames(59)=(inputKey=IK_NumPad9,displayName="NumPad 9")
     keyDisplayNames(60)=(inputKey=IK_Period,displayName="Period")
     keyDisplayNames(61)=(inputKey=IK_Comma,displayName="Comma")
     keyDisplayNames(62)=(inputKey=IK_Backslash,displayName="Backslash")
     keyDisplayNames(63)=(inputKey=IK_Semicolon,displayName="Semicolon")
     keyDisplayNames(64)=(inputKey=IK_Equals,displayName="Equals")
     keyDisplayNames(65)=(inputKey=IK_Slash,displayName="Slash")
     keyDisplayNames(66)=(inputKey=IK_Enter,displayName="Enter")
     keyDisplayNames(67)=(inputKey=IK_Alt,displayName="Alt")
     keyDisplayNames(68)=(inputKey=IK_Backspace,displayName="Backspace")
     keyDisplayNames(69)=(inputKey=IK_Shift,displayName="Shift")
     keyDisplayNames(70)=(inputKey=IK_Space,displayName="Space")
    NoneText="[None]"
    strHeaderActionLabel="Action"
    strHeaderAssignedLabel="Assigned Key/Button"
    WaitingHelpText="Select the function you wish to remap and then press [Enter] or Double-Click.  Press [Delete] to remove key bindings."
    InputHelpText="Please press the key or button you wish to assign to this function.  Press [ESC] to cancel."
    ReassignedFromLabel="'%s' reassigned from '%s'"

    strOK="OK"
    strCancel="Cancel"
    strDefault="Reset to defaults"

    WinTitle="Keyboard/Mouse Settings"

		leftEdgeCorrectorX=4
		leftEdgeCorrectorY=0
		leftEdgeHeight=550

		RightEdgeCorrectorX=520
		RightEdgeCorrectorY=20
		RightEdgeHeight=522

		TopEdgeCorrectorX=432
		TopEdgeCorrectorY=16
    TopEdgeLength=86

    TopRightCornerX=518
    TopRightCornerY=16

	Begin Object Class=FloatingImage Name=FloatingFrameBackground
		Image=Texture'DXR_CustomizeKeys'
		ImageRenderStyle=MSTY_Translucent
		ImageStyle=ISTY_Tiled
		ImageColor=(R=255,G=255,B=255,A=255)
		DropShadow=None
		WinWidth=512
		WinHeight=512
		WinLeft=8
		WinTop=20
		RenderWeight=0.000003
		bBoundToParent=True
		bScaleToParent=True
		OnRendered=PaintOnBG
	End Object
	i_FrameBG=FloatingFrameBackground

//	OnKeyEvent=InternalOnKeyEvent
}

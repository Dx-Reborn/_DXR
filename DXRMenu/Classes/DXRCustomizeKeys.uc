/*

*/

class DXRCustomizeKeys extends DXRConfigurationDialog;

struct S_KeyDisplayItem
{
    var() Interactions.EInputKey inputKey;
    var() localized String DisplayName;
};

const AMOUNT_OF_FUNCTIONS = 51; // AmountOfFunctions = 51;
const SetupCommand = "SET Input ";
const MAX_PENDING_COMMANDS = 102;
const MAX_KEYDISPLAY_NAMES = 71;

var localized string    FunctionText[AMOUNT_OF_FUNCTIONS];
var string              MenuValues1[AMOUNT_OF_FUNCTIONS];
var string              MenuValues2[AMOUNT_OF_FUNCTIONS];
var string              AliasNames[AMOUNT_OF_FUNCTIONS];
var string              PendingCommands[MAX_PENDING_COMMANDS];
var S_KeyDisplayItem    keyDisplayNames[MAX_KEYDISPLAY_NAMES];
var localized string              NoneText;
var int                 Pending;
var int                 selection;      
var bool                bWaitingForInput;

var localized string strHeaderActionLabel;
var localized string strHeaderAssignedLabel;
var localized string strSpecial; // ����������� ������?
var localized string WaitingHelpText;
var localized string InputHelpText;
var localized string ReassignedFromLabel;

var GUIButton btnDefault, btnOK, btnCancel, btnSpecial;
var GUIButton hdrKey, hdrAction;
var GUILabel winHelp;

var GUIListBox lstKeys;

var GUIStyles SelStyle;

function CreateMyControls()
{
   SetSize(512, 520);

   SelStyle = Controller.GetStyle("STY_DXR_ListSelection",FontScale); // Get style to draw listbox selection

   lstKeys = new class'GUIListBox';
   lstKeys.WinWidth = 500;
   lstKeys.WinHeight = 390;
   lstKeys.WinLeft = 17;
   lstKeys.WinTop = 41;
   lstKeys.StyleName = "STY_DXR_Listbox";
   lstKeys.bScaleToParent = true;
   lstKeys.bBoundToParent = true;
   AppendComponent(lstKeys, true);
   lstKeys.list.OnDrawItem = CustomDrawing;
   lstKeys.list.OnDblClick = ListDoubleClick;
   lstKeys.list.OnChange = ListChanged;
   lstKeys.OnKeyEvent = lstKeyEvent;

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

   btnSpecial = new class'GUIButton';
   btnSpecial.OnClick=InternalOnClick;
   btnSpecial.fontScale = FNS_Small;
   btnSpecial.StyleName="STY_DXR_MediumButton";
   btnSpecial.Caption = strSpecial;
   btnSpecial.Hint = "Does nothing for now";
   btnSpecial.WinHeight = 21;
   btnSpecial.WinWidth = 100;
   btnSpecial.WinLeft = 216;
   btnSpecial.WinTop = 529;
   AppendComponent(btnSpecial, true);

// ��������� ������ (������ �������, �� multiColumn)

   hdrKey = new(none) class'GUIButton';
   hdrKey.FontScale = FNS_Small;
   hdrKey.Caption = strHeaderActionLabel;
   hdrKey.Hint = "";
   hdrKey.StyleName="STY_DXR_Personal";
   hdrKey.bBoundToParent = true;
   hdrKey.WinHeight = 18;
   hdrKey.WinWidth = 216;
   hdrKey.WinLeft = 16;
   hdrKey.WinTop = 21;
   AppendComponent(hdrKey, true);

   hdrAction = new(none) class'GUIButton';
   hdrAction.FontScale = FNS_Small;
   hdrAction.Caption = strHeaderAssignedLabel;
   hdrAction.Hint = "";
   hdrAction.StyleName="STY_DXR_Personal";
   hdrAction.bBoundToParent = true;
   hdrAction.WinHeight = 18;
   hdrAction.WinWidth = 238;
   hdrAction.WinLeft = 231;
   hdrAction.WinTop = 21;
   AppendComponent(hdrAction, true);

   FillValues();
}

function FillValues()
{
   Pending = 0;
   Selection = -1;
   bWaitingForInput = false;
   BuildKeyBindings();

   PopulateKeyList();
   ShowHelp(WaitingHelpText);
}

function BuildKeyBindings()
{
    local int i, j, pos;
    local string KeyName;
    local string Alias;

    // First, clear all the existing keybinding display 
    // strings in the MenuValues[1|2] arrays
    
    for(i=0; i<arrayCount(MenuValues1); i++)
    {
        MenuValues1[i] = "";
        MenuValues2[i] = "";
    }

    // Now loop through all the keynames and generate
    // human-readable versions of keys that are mapped.

    for (i=0; i<255; i++)
    {
        KeyName = playerOwner().ConsoleCommand ("KEYNAME "$i);
        if ( KeyName != "" )
        {
            Alias = playerOwner().ConsoleCommand("KEYBINDING "$KeyName);

            if ( Alias != "" )
            {
                pos = InStr(Alias, " " );
                if (pos != -1)
                    Alias = Left(Alias, pos);

                for (j=0; j<arrayCount(AliasNames); j++)
                {
                    if (AliasNames[j] == Alias)
                    {
                        if (MenuValues1[j] == "")
                            MenuValues1[j] = GetKeyDisplayNameFromKeyName(KeyName);
                        else if (MenuValues2[j] == "")
                            MenuValues2[j] = GetKeyDisplayNameFromKeyName(KeyName);
                    }
                }
            }
        }
    }
}

function String GetKeyFromDisplayName(String displayName)
{
   local int keyIndex;

   for(keyIndex=0; keyIndex<arrayCount(keyDisplayNames); keyIndex++)
   {
       if (displayName == keyDisplayNames[keyIndex].displayName)
       {
           return mid(String(GetEnum(enum'EInputKey', keyDisplayNames[keyIndex].inputKey)), 3);
           break;
       }
   }
   return displayName;
}

function ClearFunction()
{
   local int rowID;
   local int rowIndex;

   rowID = lstKeys.list.Index; //GetSelectedRow();

   if (rowID != -1) // 0
   {
       rowIndex = lstKeys.list.Index; //lstKeys.RowIdToIndex(rowID);

       if (MenuValues2[rowIndex] != "")
       {
           if (CanRemapKey(MenuValues2[rowIndex]))
           {
               AddPending("SET Input " $ GetKeyFromDisplayName(MenuValues2[rowIndex]));
               MenuValues2[rowIndex] = "";
           }
       }

       if (MenuValues1[rowIndex] != "")
       {
           if (CanRemapKey(MenuValues1[rowIndex]))
           {
               AddPending("SET Input " $ GetKeyFromDisplayName(MenuValues1[rowIndex]));
               MenuValues1[rowIndex] = MenuValues2[rowIndex];
               MenuValues2[rowIndex] = "";
           }
       }

    // Update the buttons
    RefreshKeyBindings();
   }
}

function ProcessKeySelection(int KeyNo, string KeyName, string keyDisplayName)
{
   local int i;

    /* Some keys CANNOT be assigned:
    
     1.  Escape
     2.  Function keys (used by Augs)
     3.  Number keys (used by Object Belt)
     4.  Tilde (used for console)
     5.  Pause (used to pause game)
     6.  Print Screen (Well, duh)

     Make sure the user enters a valid key (Escape and function
     keys can't be assigned)*/
   if ((KeyName == "") || (KeyName == "Escape") ||        // Escape
        ((KeyNo >= 0x70 ) && (KeyNo <= 0x81)) ||           // Function keys
        ((KeyNo >= 48) && (KeyNo <= 57)) ||                // 0 - 9
        (KeyName == "Tilde") ||                            // Tilde
        (KeyName == "PrintScrn") ||                        // Print Screen
        (KeyName == "Pause"))                              // Pause
   {
       PlayerOwner().ClientPlaySound(sound'DeusExSounds.Generic.Buzz1');
       return;
   }

   // Don't waste our time if this key is already assigned here
   if ((MenuValues1[Selection] == keyDisplayName) ||
      (MenuValues2[Selection] == keyDisplayName))
       return;

    // Now check to make sure there are no overlapping 
    // assignments.  

   for (i=0; i<arrayCount(AliasNames); i++)
   {
       if (MenuValues2[i] == keyDisplayName)
       {
           ShowHelp(class'Actor'.static.Sprintf(ReassignedFromLabel, keyDisplayName, FunctionText[i]));
           AddPending("SET Input " $ GetKeyFromDisplayName(MenuValues2[i]));
           MenuValues2[i] = "";
       }

       if (MenuValues1[i] == keyDisplayName)
       {
           ShowHelp(class'Actor'.static.Sprintf(ReassignedFromLabel, keyDisplayName, FunctionText[i]));
           AddPending("SET Input " $ GetKeyFromDisplayName(MenuValues1[i]));
           MenuValues1[i] = MenuValues2[i];
           MenuValues2[i] = "";
       }
   }

   // Now assign the key, trying the first space if it's empty,
   // but using the second space if necessary.  If both slots
   // are filled, then move the second entry into the first 
   // and put the new assignment in the second slot.

   if ( MenuValues1[Selection] == "" ) 
   {
       MenuValues1[Selection] = keyDisplayName;
   }
   else if ( MenuValues2[Selection] == "" )
   {
       MenuValues2[Selection] = keyDisplayName;
   }
   else
   {
       if (CanRemapKey(MenuValues1[Selection]))
       {
           // Undo first key assignment
           AddPending("SET Input " $ GetKeyFromDisplayName(MenuValues1[Selection]));
           MenuValues1[Selection] = MenuValues2[Selection];
           MenuValues2[Selection] = keyDisplayName;
       }
       else if (CanRemapKey(MenuValues2[Selection]))
       {
           // Undo second key assignment
           AddPending("SET Input " $ GetKeyFromDisplayName(MenuValues2[Selection]));

           MenuValues2[Selection] = keyDisplayName;
       }
   }
   AddPending("SET Input "$KeyName$" "$AliasNames[Selection]);

   // Update the buttons
   RefreshKeyBindings();
}


function RefreshKeyBindings()
{
   local int keyIndex;
//  local int rowId;

   for(keyIndex=0; keyIndex<arrayCount(AliasNames); keyIndex++ )
   {
//      rowId = lstKeys.list.Index;

//      log ("gonna replace at "$rowId$" to "$GetInputDisplayText(keyIndex));
// �������� �������� �����, ����� �� ��������� ������.
       lstKeys.list.Replace(selection, FunctionText[selection]$";"$GetInputDisplayText(selection),,, true);
   }
}


function String GetKeyDisplayName(Interactions.EInputKey inputKey)
{
   local int keyIndex;

   for(keyIndex=0; keyIndex<arrayCount(keyDisplayNames); keyIndex++)
   {
       if (inputKey == keyDisplayNames[keyIndex].inputKey)
       {
           return keyDisplayNames[keyIndex].DisplayName;
           break;
       }
   }
   return mid(string(GetEnum(enum'EInputKey',inputKey)),3);
}

function String GetKeyDisplayNameFromKeyName(string keyName)
{
   local int keyIndex;

   for(keyIndex=0; keyIndex<arrayCount(keyDisplayNames); keyIndex++)
   {
       if (mid(string(GetEnum(enum'EInputKey', keyDisplayNames[keyIndex].inputKey)), 3) == keyName)
       {
           return keyDisplayNames[keyIndex].DisplayName;
           break;
       }
   }
    return keyName;
}

function ProcessPending()
{
   local int i;

   for (i=0; i<Pending; i++)
        playerOwner().ConsoleCommand(PendingCommands[i]);
        
   Pending = 0;
}

function AddPending(string newCommand)
{
//  log("AddPending = "$newCommand);

   PendingCommands[Pending] = newCommand;
   Pending++;
   if (Pending == 100)
       ProcessPending();
}


function PopulateKeyList()
{
   local int keyIndex;

   // First erase the old list
   lstKeys.list.Clear();

   for(keyIndex=0; keyIndex<arrayCount(AliasNames); keyIndex++)
       lstKeys.list.Add(FunctionText[keyIndex] $ ";" $ GetInputDisplayText(keyIndex));
}

function String GetInputDisplayText(int keyIndex)
{
   if (MenuValues1[keyIndex] == "")
       return NoneText;
   else if ( MenuValues2[keyIndex] != "" )
       return MenuValues1[keyIndex] $ "," @ MenuValues2[keyIndex];
   else
       return MenuValues1[keyIndex];
}

function ShowHelp(string HelpText)
{
   winHelp.Caption = HelpText;
}

function CustomDrawing(Canvas u, int Item, float X, float Y, float W, float H, bool bSelected, bool bPending)
{
   local string func, key, myStr;

   myStr = lstKeys.list.GetItemAtIndex(Item);
   Divide(myStr, ";", func, key);

   if (bSelected) // Draw selection border
       SelStyle.Draw(u,MSAT_Pressed, X, Y-2, W, H+2);

       lstKeys.Style.DrawText(u,MenuState, lstKeys.ActualLeft() + 2, Y, lstKeys.ActualWidth(), H, TXTA_Left, func, lstKeys.FontScale);
       lstKeys.Style.DrawText(u,MenuState, lstKeys.ActualLeft() + 218, Y, lstKeys.ActualWidth(), H, TXTA_Left, key, lstKeys.FontScale);
}

function bool CanRemapKey(string KeyName)
{
   if ((KeyName == "F1") || (KeyName == "F2"))  // hack - DEUS_EX STM
       return false;
   else
       return true;
}

function WaitingForInput(bool bWaiting)
{
   if (bWaiting)
   {
       ShowHelp(InputHelpText);

       Controller.OnNeedRawKeyPress = RawKey;
       Controller.Master.bRequireRawJoystick=true;

       PlayerOwner().ClientPlaySound(Controller.EditSound);
       PlayerOwner().ConsoleCommand("toggleime 0");
   }
   else
   {
       Controller.OnNeedRawKeyPress = none;
       Controller.Master.bRequireRawJoystick=false;

       PlayerOwner().ClientPlaySound(Controller.ClickSound);
   }
   bWaitingForInput = bWaiting;
}

function bool ListDoubleClick(GUIComponent Sender)
{
   WaitingForInput(true);
   return false;
}

function ResetToDefaults()
{
   Pending = 0;
   Selection = -1;
   bWaitingForInput = false;
   BuildKeyBindings();
   PopulateKeyList();
   ShowHelp(WaitingHelpText);
}

function ListChanged(GUIComponent Sender)
{
   Selection = lstKeys.list.index;
}

function bool lstKeyEvent(out byte NewKey, out byte State, float delta)
{
   local Interactions.EInputKey iKey;

   iKey = EInputKey(NewKey);

   if (!bWaitingForInput) 
   {
       // If the user presses [Delete] or [Backspace], then 
       // clear this setting
       if ((ikey == IK_Delete) || (ikey == IK_Backspace))
       {
           ClearFunction();
           return true;
       }
   }
   else 
   return false;
}

function bool RawKey(byte NewKey)
{
   local Interactions.EInputKey iKey;

   iKey = EInputKey(NewKey);

   // First check to see if we're waiting for the user to select a 
   // keyboard or mouse/joystick button to override. 
   WaitingForInput(false);
                                                                                
   ProcessKeySelection(ikey, mid(string(GetEnum(enum'EInputKey',ikey)),3), GetKeyDisplayName(ikey));

   return true;
}

function bool InternalOnClick(GUIComponent sender)
{
   if (sender == btnOK)
   {
       ProcessPending();
       Controller.CloseMenu();
   }
   else if (sender == btnDefault)
   {
      ResetToDefaults();
   }
   else if (sender == btnCancel)
   {
       Controller.CloseMenu();
   }
   return true;
}


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
    FunctionText(30)="Take JPG Screenshot"    
    FunctionText(31)="Activate Inventory Screen"
    FunctionText(32)="Activate Health Screen"
    FunctionText(33)="Activate Augmentations Screen"
    FunctionText(34)="Activate Skills Screen"
    FunctionText(35)="Activate Goals/Notes Screen"
    FunctionText(36)="Activate Conversations Screen"
    FunctionText(37)="Activate Images Screen"
    FunctionText(38)="Activate Logs Screen"
    FunctionText(39)="Quick Save"
    FunctionText(40)="Quick Load"
    FunctionText(41)="Toggle Crosshairs"
    FunctionText(42)="Toggle Hit Display"
    FunctionText(43)="Toggle Compass"
    FunctionText(44)="Toggle Augmentation Display"
    FunctionText(45)="Toggle Object Belt"
    FunctionText(46)="Toggle Ammo Display"
//  commands for fly/ghost/walk
    FunctionText(47)="DEV: Ghost"
    FunctionText(48)="DEV: Fly"
    FunctionText(49)="DEV: Walk"
    FunctionText(50)="DEV: Custom Debug info on HUD"

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
    AliasNames(30)="JPGShot"
    AliasNames(31)="ShowInventoryWindow"
    AliasNames(32)="ShowHealthWindow"
    AliasNames(33)="ShowAugmentationsWindow"
    AliasNames(34)="ShowSkillsWindow"
    AliasNames(35)="ShowGoalsWindow"
    AliasNames(36)="ShowConversationsWindow"
    AliasNames(37)="ShowImagesWindow"
    AliasNames(38)="ShowLogsWindow"
    AliasNames(39)="QuickSave"
    AliasNames(40)="QuickLoad"
    AliasNames(41)="ToggleCrosshair"
    AliasNames(42)="ToggleHitDisplay"
    AliasNames(43)="ToggleCompass"
    AliasNames(44)="ToggleAugDisplay"
    AliasNames(45)="ToggleObjectBelt"
    AliasNames(46)="ToggleAmmoDisplay"

    AliasNames(47)="Ghost"
    AliasNames(48)="Fly"
    AliasNames(49)="Walk"
    AliasNames(50)="ExtraHUDDebugInfo"

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
      /* There is no such keys in this version of engine, or they are named differently?
     keyDisplayNames(37)=(inputKey=IK_JoyPovUp,displayName="Joystick Pov Up")
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

    strSpecial="Special Button"

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

//  OnKeyEvent=InternalOnKeyEvent
}

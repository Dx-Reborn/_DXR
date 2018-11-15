/*------------------------------------------------------------------
  Copies of this class stored in DXR_Menu.uc, as defaultproperties.

------------------------------------------------------------------*/

class DXR_MenuColor extends hcObject;

var enum eBackgoundMode
{
  BM_Regular, // Regular background
  BM_Translucent, // STY_/MSTY_Translucent
  BM_Additive, // Similar to STY_Translucent
  BM_Alpha // STY_/MSTY_Alpha from 0 to 255. Note: 0 is completely invisible!
} BackgoundMode;

var() string ThemeName;
var() color PlayerInterfaceBG; // Player interface background (inventory, skills, etc.) 
var() color PlayerInterfaceHDR; // ... bold text labels
var() color PlayerInterfaceTextLabels; // ... regular text labels and description box.
var() eBackgoundMode myBackgroundMode; // look up ^
var() byte BackgroundAlpha; // alpha for background. Alpha in color is ignored.
                                      
var() color PlayerInterfaceButton; // colors of STY_DXR_ButtonNavbar. This button only used for player interface
var() color PlayerInterfaceButtonWatched;
var() color PlayerInterfaceButtonFocused;
var() color PlayerInterfaceButtonPressed;
var() color PlayerInterfaceButtonDisabled;

var() color PlayerInterfaceButtonText;
var() color PlayerInterfaceButtonWatchedText;
var() color PlayerInterfaceButtonFocusedText;
var() color PlayerInterfaceButtonPressedText;
var() color PlayerInterfaceButtonDisabledText;

var() color PlayerInterfaceFrames; // Frames around Player Interface panels (Inventory, augs, etc.)
var() color PlayerInterfaceTabsBackground; // Tabs buttons background

var() color MenuButton; // Colors of menu buttons (for STY_DXR_MediumButton && STY_DXR_DeusExRectButton)
var() color MenuButtonWatched;  
var() color MenuButtonButtonFocused;
var() color MenuButtonPressed;
var() color MenuButtonDisabled;

var() color MenuButtonText; 
var() color MenuButtonWatchedText;
var() color MenuButtonButtonFocusedText;
var() color MenuButtonPressedText;
var() color MenuButtonDisabledText;

var() color MenuHeaderText;
var() color MenuHeaderBubble; // Colored bubble in window header
var() color MenuHeader; // Window header
var() color MenuBackground; 
var() color MenuBorders; 

var() color ScrollBarColor;
var() color ScrollBarButtonsColor;
var() color ScrollBarArea;

var() color SliderBG;
var() color SliderKnob;

var() color HintBG;
var() color HintText;

var() color NotesText;
var() color NotesFrame;

var() color AugButtonBorder;


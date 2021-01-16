/* */
class PersonaItemButton extends InventoryButton //GUIImage;
                                config(Ui);

var DeusExPlayer player;

var() texture  icon;                        // Icon to draw

var() int      iconPosWidth;
var() int      iconPosHeight;

var() int      buttonHeight;
var() int      buttonWidth;
var() int      borderHeight;
var() int      borderWidth;

var() bool     bSelected;
var() bool     bIconTranslucent;

var config bool bDrawDebug; // to allow control extra information via config file.

var(offsetCorrection) float correctX, correctY;

// Border and Background Translucency
var bool bBorderTranslucent;
var bool bBackgroundTranslucent;
var bool bDrawBorder;

// Default Colors
var Color colBackground;
var Color colBorder;
var Color colHeaderText;
var Color colText;
var Color colIcon;
var Color colSelectionBorder;
var Color colFillSelected;


function SetActive(bool bNewActive);

function SetSize(float newWidth, float newHeight)
{
   WinHeight = newHeight; WinWidth = newWidth;
   buttonHeight = newHeight; buttonWidth = newWidth;
}

function SetPos(float newX, float newY)
{
   winLeft = correctX + newX; winTop = correctY + newY;
}

// ----------------------------------------------------------------------
// InitWindow()
// ----------------------------------------------------------------------

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    Super.InitComponent(MyController, MyOwner);

    SetSize(buttonWidth, buttonHeight);
    // Get a pointer to the player
    player = DeusExPlayer(PlayerOwner().Pawn);

    OnRendered=InternalOnRendered;
}

// ----------------------------------------------------------------------
// DrawWindow()
// ----------------------------------------------------------------------
//event DrawWindow(GC gc)
function InternalOnRendered(canvas u)
{   
  local float x,y;

  x = ActualLeft(); y = ActualTop();

    if (icon != None)
    {
        // Draw the icon
        if (bIconTranslucent)
            u.Style = EMenuRenderStyle.MSTY_Translucent;//gc.SetStyle(DSTY_Translucent);
        else
            u.Style = EMenuRenderStyle.MSTY_Masked;

            u.DrawColor = colIcon;
            u.SetPos(x + ((borderWidth) / 2)  - (iconPosWidth / 2),y + ((borderHeight) / 2) - (iconPosHeight / 2));
            u.DrawIcon(icon, 1);

//      gc.SetTileColor(colIcon);
//      gc.DrawTexture(((borderWidth) / 2)  - (iconPosWidth / 2),((borderHeight) / 2) - (iconPosHeight / 2),iconPosWidth, iconPosHeight, 0, 0, icon);

/*native(1284) final function DrawTexture(float destX, float destY,
                                        float destWidth, float destHeight,
                                        float srcX, float srcY,
                                        texture tx);*/
    }

    // Draw selection border
    if (bSelected)
    {
        u.DrawColor = class'DXR_Menu'.static.GetAugButtonBorder(gl.MenuThemeIndex);//colSelectionBorder;
        u.Style = EMenuRenderStyle.MSTY_Masked;
        u.SetPos(x,y);
        u.DrawTileStretched(texture'WhiteBorderT', buttonHeight, buttonWidth);
//      gc.DrawBorders(0, 0, borderWidth, borderHeight, 0, 0, 0, 0, texBorders);
    }
}

// ----------------------------------------------------------------------
// SetIcon()
// ----------------------------------------------------------------------

function SetIcon(texture newIcon)
{
    icon = newIcon;
}

// ----------------------------------------------------------------------
// SetIconSize()
// ----------------------------------------------------------------------

function SetIconSize(int newWidth, int newHeight)
{
    iconPosWidth  = newWidth;
    iconPosHeight = newHeight;
}

// ----------------------------------------------------------------------
// SetBorderSize()
// ----------------------------------------------------------------------

function SetBorderSize(int newWidth, int newHeight)
{
    borderWidth  = newWidth;
    borderHeight = newHeight;
}

// ----------------------------------------------------------------------
// SelectButton()
// ----------------------------------------------------------------------

function SelectButton(bool bNewSelected)
{
    PlayerOwner().pawn.PlaySound(Sound'Menu_Press',SLOT_Interface, 0.25); 

    bSelected = bNewSelected;
}

/*function bool InternalOnClick(GUIComponent Sender)
{
   if (sender==self)
   {

     return true;
   }
} */

// ----------------------------------------------------------------------
// StyleChanged()
// ----------------------------------------------------------------------

/*event StyleChanged()
{
    local ColorTheme theme;

    theme = player.ThemeManager.GetCurrentHUDColorTheme();

    colBackground = theme.GetColorFromName('HUDColor_Background');
    colBorder     = theme.GetColorFromName('HUDColor_Borders');
    colText       = theme.GetColorFromName('HUDColor_NormalText');
    colHeaderText = theme.GetColorFromName('HUDColor_HeaderText');

    colFillSelected.r = Int(Float(colBackground.r) * 0.50);
    colFillSelected.g = Int(Float(colBackground.g) * 0.50);
    colFillSelected.b = Int(Float(colBackground.b) * 0.50);

    bBorderTranslucent     = player.GetHUDBorderTranslucency();
    bBackgroundTranslucent = player.GetHUDBackgroundTranslucency();
    bDrawBorder            = player.GetHUDBordersVisible();
}*/

event free()
{
//   bAcceptsInput = false;
//   bBoundToParent = false;
   OnRendered = none;
   super.free();
}

// ----------------------------------------------------------------------
function OnPlaceToToolbeltMenuSelect(GUIContextMenu Sender, int ClickIndex)
{
   log("Clicked contextMenu "$sender$", item index = "$ClickIndex);
   if (GetClientObject() != None)
       DeusExHUD(PlayerOwner().myHUD).AddObjectToBelt(Inventory(GetClientObject()), ClickIndex + 1, true);

   wininv.UpdateBeltSlots();
}

// ----------------------------------------------------------------------
defaultproperties
{
    Begin Object class=DXRContextMenu Name=kmPlaceToToolbeltMenu
        ContextItems(0)="Place to ToolBeltSlot #1"
        ContextItems(1)="Place to ToolBeltSlot #2"
        ContextItems(2)="Place to ToolBeltSlot #3"
        ContextItems(3)="Place to ToolBeltSlot #4"
        ContextItems(4)="Place to ToolBeltSlot #5"
        ContextItems(5)="Place to ToolBeltSlot #6"
        ContextItems(6)="Place to ToolBeltSlot #7"
        ContextItems(7)="Place to ToolBeltSlot #8"
        ContextItems(8)="Place to ToolBeltSlot #9"
        OnSelect=OnPlaceToToolbeltMenuSelect
    End Object
    ContextMenu=kmPlaceToToolbeltMenu

    bAcceptsInput=true
    bBoundToParent=true
    bNeverScale=true

    iconPosWidth=52
    iconPosHeight=52
    buttonWidth=54
    buttonHeight=54
    borderWidth=54
    borderHeight=54
    bIconTranslucent=True
    colIcon=(R=255,G=255,B=255,A=255)
    colSelectionBorder=(R=255,G=255,B=255,A=255)

    correctX=43
    correctY=63

//    OnClick=InternalOnClick
    OnRendered=InternalOnRendered
    bDropSource=true
    StyleName=""
    RenderWeight=0.50
}

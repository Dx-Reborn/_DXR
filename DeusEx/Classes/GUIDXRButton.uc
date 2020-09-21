/* Good example on how to replace rendering code )) 
   From Reborn project */

class GUIDXRButton extends GUIButton;

var() texture Button_Pressed, Button_Normal;
var transient DXCanvas dxc;
var transient DeusExGlobals gl;
var() Font capFont;
var() bool bIcon;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    dxc = DeusExHUD(PlayerOwner().myHUD).dxc; //new(none) class'DxCanvas';  
    gl = class'DeusExGlobals'.static.GetGlobals();
    Super.InitComponent(MyController, MyOwner);
}


function bool InternalOnDraw(canvas c)
{
    local texture border;
    local int x,y, w,h;

    dxc.SetCanvas(c);

      c.Style = EMenuRenderStyle.MSTY_Translucent;

    if(MenuState == MSAT_Pressed)
    {
        border = Button_Pressed;
    }
    else
    {
        border = Button_Normal;
    }

    //c.SetDrawColor(255,255,255);
    c.Style = eMenuRenderStyle.MSTY_Normal;
    c.SetOrigin(0,0);
    c.SetClip(c.SizeX, c.SizeY);

    x=ActualLeft();
    y=ActualTop();
    w=ActualWidth();
    h=ActualHeight();

    c.SetPos(x, y);
    if(bIcon == true)
    {
        c.DrawIcon(border, 1.0);
    }
    else
    {
        if(MenuState == MSAT_Pressed)
        {
            c.DrawColor = class'DXR_Menu'.static.GetPlayerInterfaceButton(gl.MenuThemeIndex);
            c.DrawIcon(texture'DeusExUI.PersonaActionButtonPressed_Left', 1.0);
            c.DrawTile(texture'DeusExUI.PersonaActionButtonPressed_Center', w-12, 16, 0,0, 2,16);

            c.SetPos(x+w-8,y);
            c.DrawIcon(texture'DeusExUI.PersonaActionButtonPressed_Right', 1.0);
        }
        else
        {
            c.DrawColor = class'DXR_Menu'.static.GetPlayerInterfaceButtonPressed(gl.MenuThemeIndex);
            c.DrawIcon(texture'DeusExUI.PersonaActionButtonNormal_Left', 1.0);
            c.DrawTile(texture'DeusExUI.PersonaActionButtonNormal_Center', w-12, 16, 0,0, 2,16);
            c.SetPos(x+w-8,y);
            c.DrawIcon(texture'DeusExUI.PersonaActionButtonNormal_Right', 1.0);
        }
    }

    c.Style = eMenuRenderStyle.MSTY_Normal;
    c.Font=capFont;
    y+=3;
    if(MenuState == MSAT_Pressed)
    {
        x+=1;
        y+=1;
    }
     if (bAcceptsInput == false)
     {
        //c.SetDrawColor(164,164,164);
        c.DrawColor = class'DXR_Menu'.static.GetPlayerInterfaceButtonDisabled(gl.MenuThemeIndex);
     }
     else
    //c.SetDrawColor(255,255,255);
    c.DrawColor = class'DXR_Menu'.static.GetPlayerInterfaceButtonText(gl.MenuThemeIndex);
    dxc.DrawTextJustified(Caption, 1, x,y-2, x+ActualWidth(), y+ActualHeight()-2);

  return bInit;
}

defaultproperties
{
    bIcon=true
    OnDraw = InternalOnDraw
    Button_Pressed = texture'DeusExUI.HUDKeypadButton_Pressed'
    Button_Normal = texture'HUDKeypadButton_Normal'
    capFont = Font'DxFonts.EUX_18'
    StyleName=""
}

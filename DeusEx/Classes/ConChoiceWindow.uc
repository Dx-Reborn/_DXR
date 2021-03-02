/*
   ConChoiceWindow

   DXR: Ну и бардак здесь! Тут половину вообще выкинуть можно...
*/

class ConChoiceWindow extends GUIButton 
                              transient;

var Object userObject;

var font ButtonFont;
var color colNormal, colPressed, colNormalFocus, colPressedFocus, colNormalInsensitive, colPressedInsensitive;
var material MatNormal, MatPressed, MatNormalFocus, MatPressedFocus, MatNormalInsensitive, MatPressedInsensitive;


function SetUserObject(object newUserObject)
{
    userObject = newUserObject;
}

function Object GetUserObject()
{
    return userObject;
}

function SetText(string newtext)
{
    Caption = newText;
}

// ToDo: remove unused parameters in these 3 functons?
final function SetButtonTextures(optional texture tnormal,optional texture tpressed,optional texture tnormalFocus, optional texture tpressedFocus,optional texture tnormalInsensitive,optional texture tpressedInsensitive)
{
    if (tnormal == None) MatNormal=texture'Solid';
    if (MatPressed == None) MatPressed=texture'Solid';
    if (MatNormalFocus == None) MatNormalFocus=texture'Solid';
    if (MatPressedFocus == None) MatPressedFocus=texture'Solid';
    if (MatNormalInsensitive == None) MatNormalInsensitive=texture'Solid';
    if (MatPressedInsensitive == None) MatPressedInsensitive=texture'Solid';

    MatNormal = tnormal;
    MatPressed = tpressed;
    MatNormalFocus = tnormalFocus;
    MatPressedFocus = tpressedFocus;
    MatNormalInsensitive = tnormalInsensitive;
    MatPressedInsensitive = tpressedInsensitive;
}

final function SetButtonColors(optional color inormal,optional color ipressed,optional color inormalFocus,optional color ipressedFocus,optional color inormalInsensitive,optional color ipressedInsensitive)
{
    colNormal = inormal;
    colPressed = iPressed;
    colNormalFocus = iNormalFocus;
    colPressedFocus = iPressedFocus;
    colNormalInsensitive = iNormalInsensitive;
    colPressedInsensitive = iPressedInsensitive;
}


final function SetTextColors(optional color normal,optional color pressed,optional color normalFocus,optional color pressedFocus,optional color normalInsensitive,optional color pressedInsensitive)
{

}


function bool InternalOnDraw(canvas u)
{
    local int x,y, w,h;
    local color TextColor;

    if (caption == "")
        return true;

    u.SetOrigin(0,0);
    u.SetClip(u.SizeX, u.SizeY);

    x = ActualLeft();
    y = ActualTop();
    w = ActualWidth();
    h = ActualHeight();

    u.SetPos(x, y);
    u.Style = eMenuRenderStyle.MSTY_Normal;

    if (MenuState == MSAT_Pressed) //
    {
        TextColor = class'ConWindowActive'.default.colConTextFocus;
        u.DrawColor = colPressed;
        u.DrawTileStretched(texture'Solid', w, h);
    }
    else if (MenuState == MSAT_Focused) //
    {
        TextColor = class'ConWindowActive'.default.colConTextFocus;
        u.DrawColor = colNormalFocus;
        u.DrawTileStretched(texture'Solid', w, h);
    }
    else if (MenuState == MSAT_Blurry) // Component has no focus at all
    {
        TextColor = class'ConWindowActive'.default.colConTextChoiceUnhighlighted; //colConTextChoice;
        u.DrawColor = colNormal;
        u.DrawTileStretched(texture'Solid', w, h);
    }
    else
    {
        TextColor = class'ConWindowActive'.default.colConTextChoice;
        u.DrawColor = colNormalInsensitive;
        u.DrawTileStretched(texture'Solid', w, h);
    }

    u.Style = eMenuRenderStyle.MSTY_Normal;
    u.Font = ButtonFont;
    u.DrawColor = TextColor;
    u.SetPos(x, y);
    u.drawText(Caption, false);

    u.Reset();

  return bInit;
}



defaultproperties
{
    ButtonFont=font'DxFonts.MSS_9'

    // fallback
    MatNormal=texture'Solid'
    MatPressed=texture'Solid'
    MatNormalFocus=texture'Solid'
    MatPressedFocus=texture'Solid'
    MatNormalInsensitive=texture'Solid'
    MatPressedInsensitive=texture'Solid'

    OnDraw=InternalOnDraw

    bAutoShrink=false
    bMouseOverSound=false
    onClickSound=CS_None
    FontScale=FNS_Small
//    StyleName="STY_DXR_ConChoice"
}

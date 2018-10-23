/* All DXR-specific styles */
class DXRStyles extends GUIStyles;

var DeusExGlobals gl;
const ScrollBarWidth = 16;

event Initialize()
{
  super.Initialize();
  gl = class'DeusExGlobals'.static.GetGlobals();

  ApplyTheme(gl.MenuThemeIndex);
}

function ApplyTheme(int index); // Do something in subclasses.

function CorrectScrollBars()
{
  // Very slow, I need something better... Maybe edit XInterface.u and change scrollBar width in defprops.
/*  local GUIVertScrollBar vsb;

   foreach AllObjects(class'GUIVertScrollBar', vsb)
     vsb.WinWidth = ScrollBarWidth;*/
}




defaultproperties
{
    BorderOffsets(0)=0
    BorderOffsets(1)=0
    BorderOffsets(2)=0
    BorderOffsets(3)=0
}

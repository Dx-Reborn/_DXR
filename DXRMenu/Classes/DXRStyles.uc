/* All DXR-specific styles */
class DXRStyles extends GUIStyles;

var DeusExGlobals gl;

event Initialize()
{
  super.Initialize();
  gl = class'DeusExGlobals'.static.GetGlobals();

  ApplyTheme(gl.MenuThemeIndex);
}

function ApplyTheme(int index); // Do something in subclasses.

defaultproperties
{
    BorderOffsets(0)=0
    BorderOffsets(1)=0
    BorderOffsets(2)=0
    BorderOffsets(3)=0
}

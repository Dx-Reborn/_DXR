/* */
class PlayerInterfacePanel extends GUITabPanel;

var DeusExGlobals gl;
var DeusExPlayer player;

function SetMedicalBot(MedicalBot newBot, optional bool bPlayAnim);

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	Super.InitComponent(MyController, MyOwner);
	player = DeusExPlayer(playerOwner().pawn);
	gl = class'DeusExGlobals'.static.GetGlobals();

}

/* Call after creating all controls. If any controls created by request, call this function again )) */
function ApplyTheme()
{
  local int i;
  local GUIStyles wtf;

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
     if ((controls[i].IsA('GUILabel')) && (controls[i].tag == 76)) // Что проще, проставить Tag или скопипастить функцию, возвращающую цвет? )))
          GUILabel(controls[i]).TextColor = class'DXR_Menu'.static.GetPlayerInterfaceHDR(gl.MenuThemeIndex);

  }
  foreach AllObjects(class'GUIStyles', wtf) // it works! :D
  {
   if (wtf != none)
    wtf.initialize();
  }
}


defaultproperties
{
     FadeInTime=0.0
}
/* Обычный ползунок (регулятор) */

class DXRSlider extends GUISlider;

var() int fx; // Для коррекции фона бегунка
var() array<string> enumStrings;
var() float VeryStrangeVariable, bTop;
var DeusExGlobals gl;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	Super.InitComponent(MyController, MyOwner);
	gl = class'DeusExGlobals'.static.GetGlobals();
}

function SetTicks(int numTicks, int startValue, int endValue)
{
  MinValue = startValue;
  MaxValue = endValue;

  /* Исправляет уехавший за край бегунок :) */
  if (value < MinValue)
      SetValue(MinValue);
}

function InternalOnRendered(canvas u)
{
  local int x,y;
  local float fLeft, fWidth;

  x=ActualLeft(); y=ActualTop();

  u.SetPos(x - fx, y);
  u.DrawColor = class'DXR_Menu'.static.GetSliderBG(gl.MenuThemeIndex);
  u.drawIcon(texture'DeusExUI.UserInterface.MenuSliderBar', 1);

  fWidth = VeryStrangeVariable;
  fLeft = (ActualLeft() + (fWidth/2) + ((ActualWidth() - fWidth) * ((Value-MinValue) / (MaxValue - MinValue)))) - (fWidth / 2);
  u.SetPos(fLeft, ActualTop() + bTop);
  u.DrawColor = class'DXR_Menu'.static.GetSliderKnob(gl.MenuThemeIndex);
  u.DrawIcon(texture'DeusExUI.UserInterface.MenuSlider',1);
//  style.Draw(u, MenuState, fLeft, ActualTop() + bTop, fWidth, ActualHeight());
}

function float GetNumTicks()
{
   return MaxValue;
}

function SetEnumeration(int tickPos, coerce string newStr)
{
  enumStrings.length = int(MaxValue); //+= 1;
  enumStrings[tickPos] = newStr;
}

/*function bool MyOnDraw(canvas u)
{
  local float fLeft, fWidth;

  fWidth = VeryStrangeVariable;
  fLeft = (ActualLeft() + (fWidth/2) + ((ActualWidth() - fWidth) * ((Value-MinValue) / (MaxValue - MinValue)))) - (fWidth / 2);
  style.Draw(u, MenuState, fLeft, ActualTop() + bTop, fWidth, ActualHeight());

  return true;
} */

defaultproperties
{
  VeryStrangeVariable=16
  bTop=3
  bBoundToParent=true
  winHeight=21
  winWidth=177//243
  fx=4
  FillImage=texture'pinkmasktex'
  BarStyleName=""
  CaptionStyleName=""//"SliderCaption"
//  OnDraw=MyOnDraw
  OnRendered=InternalOnRendered
  OnClickSound=CS_None
  FontScale=FNS_Small
}

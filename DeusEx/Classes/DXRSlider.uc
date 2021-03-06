/* ������� �������� (���������) */

class DXRSlider extends GUISlider;

var() int fx; // ��� ��������� ���� �������
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

  /* ���������� �������� �� ���� ������� :) */
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

function bool InternalCapturedMouseMove(float deltaX, float deltaY)
{
  if ((deltaX > 0.5) || (deltaY > 0.5) || (deltaX < -0.5) || (deltaY < -0.5)) // DXR: To avoid playing sound when mouse button is pressed.
   playerOwner().pawn.playSound(sound'DeusExSounds.UserInterface.Menu_Slider', slot_Interface, 0.25, true); // True -- do not override sound.

   return super.InternalCapturedMouseMove(deltaX,deltaY);
}

defaultproperties
{
  VeryStrangeVariable=16
  bTop=2.0 // wtf ??? //3
  bBoundToParent=true
  winHeight=21
  winWidth=177//243
  fx=4
  FillImage=texture'pinkmasktex'
  BarStyleName=""
  CaptionStyleName=""
  OnRendered=InternalOnRendered
  OnClickSound=CS_None
  FontScale=FNS_Small
}

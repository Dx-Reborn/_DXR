/* �������� (���������) ���������� ��� ���� ���������� ������� :) */

class DXRSpecialSlider extends GUISlider;

var() int fx; // ��� ��������� ���� �������
var DeusExGlobals gl;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	Super.InitComponent(MyController, MyOwner);
	gl = class'DeusExGlobals'.static.GetGlobals();
}

/* ����������: ��������� � UT2004 �� ������������ ���������� �� ����, ��������� �������� ����� � ����� ������ )) */
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
  u.DrawColor = class'DXR_Menu'.static.GetSliderBG(gl.MenuThemeIndex);//  u.SetDrawColor(255,255,255);
  u.drawIcon(texture'DeusExUI.UserInterface.SecuritySliderBar', 1);

  fWidth = 16;
  fLeft = (ActualLeft() + (fWidth/2) + ((ActualWidth() - fWidth) * ((Value-MinValue) / (MaxValue - MinValue)))) - (fWidth / 2);
  u.SetPos(fLeft, ActualTop() + 3);
  u.DrawColor = class'DXR_Menu'.static.GetSliderKnob(gl.MenuThemeIndex);
  u.DrawIcon(texture'DeusExUI.UserInterface.MenuSlider',1);

//  style.Draw(u, MenuState, fLeft, ActualTop() + /*bTop*/ 3, fWidth, ActualHeight());
}

defaultproperties
{
  bBoundToParent=true
  bDrawPercentSign=false
  winHeight=21
  winWidth=77
  fx=4
  FillImage=texture'pinkmasktex'
  BarStyleName=""
  CaptionStyleName=""//"SliderCaption"
  OnRendered=InternalOnRendered
  OnClickSound=CS_None
  FontScale=FNS_Small
}

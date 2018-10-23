/*
 Container (panel) for augmentation cannister buttons.
 Known problems: when clicking scroll buttons and if one of buttons to install is selected,
 they may flicker. No ideas how to fix that for now.
*/

class AugButtonsContainer extends GUIPanel;

var GUIButton btnUp, btnDown;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	Super.Initcomponent(MyController, MyOwner);
  createScrollButtons();
}

function createScrollButtons()
{
  btnUp = new class'GUIButton';
  btnUp.winLeft = self.ActualWidth() - 16;
  btnUp.winTop = 0.0;
  btnUp.winWidth = 16;
  btnUp.winHeight = 16;
  btnUp.tag = 11;
  btnUp.StyleName = "VertUpButton";
  btnUp.OnClick = buttonClick;
  AppendComponent(btnUp, true);

  btnDown = new class'GUIButton';
  btnDown.winLeft = self.ActualWidth() - 16;
  btnDown.winTop = self.ActualHeight() - 16;
  btnDown.winWidth = 16;
  btnDown.winHeight = 16;
  btnDown.OnClick = buttonClick;
  btnDown.tag = 22;
  btnDown.StyleName = "VertDownButton";
  AppendComponent(btnDown, true);
}


function bool buttonClick(GUIComponent Sender)
{
  if (Sender.tag == 22)
      ClickDown();
   else
  if (Sender.tag == 11)
      ClickUp();

 return true;
}

function ClickUp()
{
 local int i;

 if (Controls.length <6 )
     return;

 if ((controls.length > 2) && (Controls[2].winTop == 0))
     return;

	for (i=0;i<Controls.length;i++)
	{
   if (!controls[i].IsA('GUIButton'))
   controls[i].WinTop += 40;
  }
}

function ClickDown()
{
 local int i;

 if (Controls.length < 6)
     return;

 if (Controls[Controls.length -1].winTop == 80)
     return;

	for (i=0;i<Controls.length;i++)
	{
   if (!controls[i].IsA('GUIButton'))
   controls[i].WinTop -= 40;
  }
}

function funcA()
{
	local int i;

	for (i=0;i<Controls.length;i++)
	{
		Controls[i].bBoundToParent=true;
		Controls[i].bScaleToParent=true;
	}
}

function bool PanelDraw(canvas u)
{
	local int i;

	if (controls.length < 6)
	{
     if ((btnDown != none) && (btnUp != none))
        {
          btnDown.Hide();
          btnUp.Hide();
        }
	}

	for (i=0;i<Controls.length;i++)
	{
   if (controls[i].IsA('GUIButton'))
       continue;

	 if (controls[i].winTop < 0)
	 {
		Controls[i].bVisible = false;
    Controls[i].bAcceptsInput = false;
	 }
	 else if (controls[i].winTop > 116)
	 {
		Controls[i].bVisible = false;
    Controls[i].bAcceptsInput = false;
	 }
	 else if (controls[i].winTop < 116)
	 {
     Controls[i].bVisible = true;
     Controls[i].bAcceptsInput = true;
   }
	}
  return true;
}


defaultproperties
{
   OnPostDraw=PanelDraw
   bNeverScale=true
}
/*-----------------------------*/

class MedBotAugCanWindow extends GUIPanel;

var localized String AugContainsText;
var() MedBotAugItemButton btnAug[2];
var DeusExGlobals gl;
var AugmentationCannisterInv augCan;
var String augDesc[2];
var Color colBorder;
var texture icon;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	Super.Initcomponent(MyController, MyOwner);
	gl = class'DeusExGlobals'.static.GetGlobals();
  OnPostDraw = PanelDraw;
	CreateSubControls();
}

function SetIcon(texture newIcon)
{
  icon = newIcon;
}

function CreateSubControls()
{
  btnAug[0] = new class'MedBotAugItemButton';
  btnAug[0].bBoundToParent = true;
  btnAug[0].winLeft = 179;
  btnAug[0].winTop = 2;
  AppendComponent(btnAug[0], true);

  btnAug[1] = new class'MedBotAugItemButton';
  btnAug[1].bBoundToParent = true;
  btnAug[1].winLeft = 214;
  btnAug[1].winTop = 2;
  AppendComponent(btnAug[1], true);
}

function SetCannister(AugmentationCannisterInv newAugCan)
{
	augCan = newAugCan;

	SetIcon(augCan.Icon);
	btnAug[0].SetAugmentation(augCan.GetAugmentation(0));
	btnAug[0].SetAugCan(augCan);
	btnAug[1].SetAugmentation(augCan.GetAugmentation(1));
	btnAug[1].SetAugCan(augCan);

	augDesc[0] = btnAug[0].GetAugDesc();
	augDesc[1] = btnAug[1].GetAugDesc();
}

function bool PanelDraw(canvas u)
{
  local float x, y;

  x = actualLeft(); y = actualTop();

  u.SetPos(x,y);
  //u.SetDrawColor(0,128,0,255);
  u.DrawColor = class'DXR_Menu'.static.GetPlayerInterfaceButton(gl.MenuThemeIndex);
  u.DrawTileStretched(texture'whiteBorderT', actualWidth(), actualHeight());

  u.SetDrawColor(255,255,255,255);
  u.SetPos(x - 8,y + 1);
  u.DrawIcon(GetCannister().icon, 1);

  u.font = font'MSS_8';
  //u.SetDrawColor(255,128,0,255);
  u.DrawColor = class'DXR_Menu'.static.GetPlayerInterfaceButtonText(gl.MenuThemeIndex);
  u.SetPos(x + 22,y + 2);
  u.DrawText(AugContainsText);

  u.font = font'MSS_7';
  u.SetPos(x + 28,y + 13);
  u.DrawText(augDesc[0]);

  u.SetPos(x + 28,y + 24);
  u.DrawText(augDesc[1]);

  return true;
}

// ----------------------------------------------------------------------
// GetCannister()
// ----------------------------------------------------------------------

function AugmentationCannisterInv GetCannister()
{
	return augCan;
}



defaultproperties
{
   AugContainsText="Contains:"
   WinWidth=250
   WinHeight=38
//   WinLeft=422
//   WinTop=66
//   OnPostDraw=PanelDraw
//	PropagateVisibility=false
   bNeverScale=true
}

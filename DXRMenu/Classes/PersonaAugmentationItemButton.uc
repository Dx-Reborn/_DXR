/*

*/

class PersonaAugmentationItemButton extends PersonaItemButton;//GUIButton;

var() bool  bActive;
var int   hotkeyNumber;
var Color colIconActive;
var Color colIconNormal;
//var Color colIcon;
//var() Augmentation Aug; // pointer to Augmentation. Data updated in Canvas drawing.
var() texture AugIcon, AugSmallIcon; // 
var() int iconCorrectX, iconCorrectY; // корректор значка

const levelSQ = texture'PersonaSkillsChicklet';

//Icon=Texture'DeusExUI.UserInterface.AugIconMuscle'
//smallIcon=Texture'DeusExUI.UserInterface.AugIconMuscle_Small'


/*function SetAug(Augmentation newAug)
{
  Aug = newAug;
}*/

function SetHotkeyNumber(int num)
{
	hotkeyNumber = num;
}

function SetActive(bool bNewActive)
{
	bActive = bNewActive;
	if (bActive)
		colIcon = colIconActive;
	else
		colIcon = colIconNormal;
}

function SetLevel(int newlevel)
{
  // Stub for now.
}

function InternalOnRendered(canvas u)
{
  local int x, y;
  local augmentation aug;

  if (GetClientObject() != none)
  aug = augmentation(GetClientObject());
  else
  return;

  x = actualLeft(); y = actualTop();
  u.font = font'FontMenuSmall_DS';

  if (Aug != none)
  {
    u.SetPos(x + 4, y + 42);
    u.SetDrawColor(255,255,255,255);

    if (hotkeyNumber > 2)
        u.DrawText("F"$hotkeyNumber);

    u.SetPos(x + iconCorrectX, y + iconCorrectY);
    u.Style = EMenuRenderStyle.MSTY_Translucent;
       if ((aug.IsActive()) || (aug.IsAlwaysActive()))
       u.DrawColor = colIconActive;
       else
       u.DrawColor = colIconNormal;
    u.DrawIcon(aug.icon, 1);
    u.Style = EMenuRenderStyle.MSTY_Normal;

    u.SetDrawColor(255,255,255,255);
    u.setPos(x + 31, y + 54);
    u.DrawIcon(levelSQ, 1);

    u.setPos(x + 37, y + 54);
      if (aug.GetCurrentLevel() >= 1)
      u.DrawIcon(levelSQ, 1);

    u.setPos(x + 43, y + 54);
      if (aug.GetCurrentLevel() >= 2)
      u.DrawIcon(levelSQ, 1);

    u.setPos(x + 49, y + 54);
      if (aug.GetCurrentLevel() >= 3)
      u.DrawIcon(levelSQ, 1);

     if (bSelected)
     {
        u.DrawColor = colSelectionBorder;
        u.Style = EMenuRenderStyle.MSTY_Masked;
        u.SetPos(x,y);
        u.DrawTileStretched(texture'WhiteBorderT', winHeight, winWidth);
     }
  }
}




defaultproperties
{
    colIconActive=(R=0,G=255,B=0,A=255)
    colIconNormal=(R=255,G=255,B=0,A=255)
    onRendered=InternalOnRendered
    WinHeight=64
    WinWidth=55
    bBoundToParent=true
    StyleName=""
    iconCorrectX=1
    iconCorrectY=1
}

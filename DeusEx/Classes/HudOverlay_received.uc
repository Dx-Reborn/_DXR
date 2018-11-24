//
//
//

class HudOverlay_received extends HudOverlay;

var() array<Inventory> recentItems;
var localized string strReceived;
var transient DxCanvas dxc;
var color InfoLinkBG, InfoLinkText, InfoLinkTitles, InfoLinkFrame;

function addItem(inventory newItem)
{
  local int x;

  x = recentItems.Length;
  recentItems.Length = x + 1; // ¤®Ў ўЁвм 1 Є ¤«Ё­Ґ ¬ ббЁў 
  recentItems[x] = newItem; // ЇаЁбў®Ёвм ¤ ­­лҐ Є н«Ґ¬Ґ­вг ¬ ббЁў 
}

function SetInitialState()
{
  local DeusExHUD h;

	SetTimer(recentItems.Length, false);
	dxc = new(Outer) class'DxCanvas';
	Super.SetInitialState();

  h = DeusExHUD(level.GetLocalPlayerController().myHUD);
  InfoLinkBG = h.InfoLinkBG;
  InfoLinkText = h.InfoLinkText;
  InfoLinkTitles = h.InfoLinkTitles;
  InfoLinkFrame = h.InfoLinkFrame;
}

function Timer()
{
	Destroy();
}

//
// Уведомляет игрока о том что получен предмет инвентаря.
// На основе кода из Reborn.
// 27/12/2017 : переделано в оверлей.
//
function Render(Canvas C)
{
	local float w,h;
	local int x;
	local texture border;
	local material ico;

	local string infoBuffer;

   dxc.SetCanvas(C);

        c.SetDrawColor(255,255,255);
        c.Font = Font'DXFonts.DPix_7';//'DxFonts.FontMenuSmall_DS';
        c.Style=1;

        w = 50+40*recentItems.Length;
        h = 64;
        infoBuffer=StrReceived;

        c.SetOrigin(int((c.SizeX-w)/2), int((c.SizeY-h)/2));
        c.SetClip(w, h);

        c.DrawColor=InfoLinkBG;// (127,127,127);
        if (DeusExPlayer(Level.GetLocalPlayerController().pawn).bHUDBackgroundTranslucent)
            c.Style = ERenderStyle.STY_Translucent;
              else
                c.Style = ERenderStyle.STY_Normal;

        //TL
        c.SetPos(-13,-16);
        c.DrawTile(texture'DeusExUI.HUDWindowBackground_TL',63,16, 1,0,63,16);
        //L
        c.SetPos(-13,0);
        c.DrawTile(texture'DeusExUI.HUDWindowBackground_Left',63,h, 1,0,63,8);
        //BL
        c.SetPos(-13, c.ClipY);
        c.DrawTile(texture'DeusExUI.HUDWindowBackground_BL',63,16, 1,0,63,16);

        //T
        c.SetPos(50,-16);
        c.DrawTile(texture'DeusExUI.HUDWindowBackground_Top',w-51,16, 0,0,8,16);
        //M
        c.SetPos(50,0);
        c.DrawTile(texture'DeusExUI.HUDWindowBackground_Center',w-51,h, 0,0,8,8);
        //B
        c.SetPos(50,c.ClipY);
        c.DrawTile(texture'DeusExUI.HUDWindowBackground_Bottom',w-51,16, 0,0,8,16);

        c.SetOrigin(c.OrgX+c.ClipX-1,c.OrgY-16);
        c.SetClip(32,h+32);
        //TR
        c.SetPos(0,0);
        c.DrawTileClipped(texture'DeusExUI.HUDWindowBackground_TR',30,16, 1,0,31,16);
        //R
        c.SetPos(0,16);
        c.DrawTileClipped(texture'DeusExUI.HUDWindowBackground_Right',30,h, 1,0,31,8);
        //BR
        c.SetPos(0, c.ClipY-16);
        c.DrawTileClipped(texture'DeusExUI.HUDWindowBackground_BR',30,16, 1,0,31,16);

        c.SetOrigin(int((c.SizeX-w)/2), int((c.SizeY-h)/2));
        c.SetClip(w, h);

   if (DeusExPlayer(Level.GetLocalPlayerController().pawn).bHUDBordersVisible)
   {
     if (DeusExPlayer(Level.GetLocalPlayerController().pawn).bHUDBordersTranslucent)
        c.Style = ERenderStyle.STY_Translucent;
        else
        c.Style = ERenderStyle.STY_Alpha;

        c.DrawColor = InfoLinkFrame;//  SetDrawColor(255,255,255);
        //c.Style = ERenderStyle.STY_Translucent;

        c.SetPos(-14,-16);
        border = texture'DeusExUI.HUDWindowBorder_TL';
        c.DrawTile(border,64,16, 0,0,64,16);

        c.SetPos(-14,0);
        border = texture'DeusExUI.HUDWindowBorder_Left';
        c.DrawTile(border,64,h, 0,0,64,8);

        c.SetPos(-14, c.ClipY);
        border = texture'DeusExUI.HUDWindowBorder_BL';
        c.DrawIcon(border,1.0);

        c.SetPos(50,-16);
        border = texture'DeusExUI.HUDWindowBorder_Top';
        c.DrawTile(border,w-52,16, 0,0,8,16);


        c.SetPos(50,c.ClipY);
        border = texture'DeusExUI.HUDWindowBorder_Bottom';
        c.DrawTile(border,w-52,16, 0,0,8,16);

        c.SetPos(c.ClipX-3,-16);
        border = texture'DeusExUI.HUDWindowBorder_TR';
        c.DrawIcon(border,1.0);

        c.SetPos(C.OrgX+c.ClipX-3,C.OrgY);
        border = texture'DeusExUI.HUDWindowBorder_Right';
        c.DrawTileStretched(border,32,h);

        c.SetPos(c.ClipX-3, c.ClipY);
        border = texture'DeusExUI.HUDWindowBorder_BR';
        c.DrawIcon(border,1.0);
   }

        c.Style=1;
        c.DrawColor = InfoLinkTitles;
        c.SetOrigin(int((c.SizeX-w)/2), int((c.SizeY-h)/2));
        c.SetClip(w, h);
        c.SetPos(0,0);

        dxc.DrawTextJustified(infoBuffer,0,0,0,c.ClipX,c.ClipY);

        c.SetOrigin(c.OrgX, c.OrgY+8);

        for(x=0; x<recentItems.length; x++)
        {
          if (recentItems[x] != none)
          {
            c.Style=2;
            c.SetPos(60+40*x, 0);
            if (recentItems[x].isA('DeusExPickupInv'))
            {
              c.SetDrawColor(255,255,255); // Исправлено, иконки были залиты текущим цветом.
            	ico = DeusExPickupInv(recentItems[x]).Icon;
	            c.DrawIconEx(ico,1.0);
  	          c.Style=1;
              c.DrawColor = InfoLinkText;
	            dxc.DrawTextJustified(DeusExPickupInv(recentItems[x]).default.beltDescription,1,60+40*x,48,100+40*x,58);
            }
            if (recentItems[x].isA('DeusExWeaponInv'))
            {
              c.SetDrawColor(255,255,255); // Исправлено, иконки были залиты текущим цветом.
            	ico = DeusExWeaponInv(recentItems[x]).Icon;
	            c.DrawIconEx(ico,1.0);
  	          c.Style=1;
              c.DrawColor = InfoLinkText;
	            dxc.DrawTextJustified(DeusExWeaponInv(recentItems[x]).default.beltDescription,1,60+40*x,48,100+40*x,58);
	          }
	        }
        }
	c.reset();
	c.SetClip(c.sizeX,c.sizeY);
}




defaultproperties
{
	strReceived="Received: "
}

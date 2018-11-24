//
// ќверлей дл€ носителей информации
// 30/11/2017: исправлено:
// * Ўрифт с тенью теперь с тенью
// * ‘он прозрачный
//

#exec OBJ LOAD FILE=DeusExUI

class HudOverlay_info extends HUDOverlay;

var bool bDrawInfo;
var ExtString currentInfo;
var transient DxCanvas dxc;

var color BooksBG, BooksText, BooksFrame;

function SetInitialState()
{
  local DeusExHUD h;

  h = DeusExHUD(level.GetLocalPlayerController().myHUD);
  BooksBG = h.BooksBG;
  BooksText = h.BooksText;
  BooksFrame = h.BooksFrame;
	dxc = new(Outer) class'DxCanvas';
	Super.SetInitialState();
}

simulated function Render(Canvas C)
{
    local string infoBuffer;
    local float holdX, holdY, w, h;
    local texture border;
    local int x;

    dxc.SetCanvas(C);

    if(bDrawInfo == true)
    {
//        c.SetDrawColor(255,255,255);
        c.Font = Font'DxFonts.EUX_9';//Font'DxFonts.FontFixedWidthSmall_DS';
//        c.Style=ERenderStyle.STY_Translucent;

        c.SetOrigin(0,0);
        c.SetClip(595, c.SizeY);
        c.SetPos(0,0);

        holdX=0;
        holdY=0;
        for(x=0; x<currentInfo.text.length; x++)
        {
            c.StrLen(currentInfo.text[x], w, h);
            infoBuffer = infoBuffer$currentInfo.text[x];

            if(w > holdX)
            {
                holdX = w;
            }
        }

        w = Min(holdX, 595);
        c.SetClip(w,c.SizeY);

        c.SetOrigin(0,0);
        dxc.NoDrawParseText(infoBuffer);

        h = c.CurY;
        c.SetOrigin(int((c.SizeX-w)/2), int((c.SizeY-h)/2));
        c.SetClip(w, h);

        if (DeusExPlayer(Level.GetLocalPlayerController().pawn).bHUDBackgroundTranslucent)
            c.Style = ERenderStyle.STY_Translucent;
              else
                c.Style = ERenderStyle.STY_Normal;

        c.DrawColor = BooksBG;

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


   // –исуем рамки
   if (DeusExPlayer(Level.GetLocalPlayerController().pawn).bHUDBordersVisible)
   {
     if (DeusExPlayer(Level.GetLocalPlayerController().pawn).bHUDBordersTranslucent)
        c.Style = ERenderStyle.STY_Translucent;
        else
        c.Style = ERenderStyle.STY_Alpha;

        c.SetOrigin((c.SizeX-w)/2, (c.SizeY-h)/2);
        c.SetClip(w, h);

        //c.SetDrawColor(255,255,255);
        c.DrawColor = BooksFrame;

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
        c.DrawColor = BooksText;
        c.SetOrigin((c.SizeX-w)/2, (c.SizeY-h)/2);
        c.SetClip(w, h);
        c.SetPos(0,0);
				c.Style=ERenderStyle.STY_Normal;
        dxc.DrawParseText(infoBuffer);
    }
 c.reset();
 c.SetClip(c.SizeX, c.SizeY);
}


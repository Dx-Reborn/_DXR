//
// Оверлей для AI Barks
//

class HudOverlay_Bark extends DXRHudOverlay;

const LINE_LENGTH = 596;

var() private string Speaker;
var() private string fpsSpeech;

var() localized font TitleFont, SpeechFont;
var color InfoLinkBG, InfoLinkText, InfoLinkTitles, InfoLinkFrame;

event SetInitialState()
{
    local DeusExHUD h;

    Super.SetInitialState();

    h = DeusExHUD(level.GetLocalPlayerController().myHUD);
    InfoLinkBG = h.InfoLinkBG;
    InfoLinkText = h.InfoLinkText;
    InfoLinkTitles = h.InfoLinkTitles;
    InfoLinkFrame = h.InfoLinkFrame;
}


event Timer()
{
    Destroy();
}

function AddBark(string text, float newDisplayTime, Actor speakingActor)
{
    if (class'DxUtil'.static.TrimSpaces(text) != "")
    {
        Speaker = speakingActor.GetFamiliarName();
        fpsSpeech = text;
        SetTimer(newDisplayTime, false);
    }
}

// == Прорисовка AI Barks == //
function Render(Canvas C)
{
    local float w,h,holdX,holdY;
    local texture border;

     dxc.SetCanvas(C);

    if(fpsSpeech != "")
    {
        //c.SetDrawColor(255,255,255);
        c.DrawColor = InfoLinkBG;
        c.Font = TitleFont;
        c.Style = ERenderStyle.STY_Translucent;

        c.SetOrigin(0,0);
        c.SetClip(595, c.SizeY);
        c.SetPos(0,0);

        holdX=0;
        holdY=0;

        c.StrLen(fpsSpeech, w, h);
        h += 22;
        w = LINE_LENGTH - 1;

        c.SetOrigin(int((c.SizeX-w)/2), int((c.SizeY-(h+32)-64)));
        c.SetClip(w, h);

        if (DeusExPlayerController(Level.GetLocalPlayerController()).bHUDBackgroundTranslucent)
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


        c.SetOrigin(int((c.SizeX-w)/2), int((c.SizeY-(h+32)-64)));
        c.SetClip(w, h);

        c.DrawColor = InfoLinkFrame;
       if (DeusExPlayerController(Level.GetLocalPlayerController()).bHUDBordersVisible)
       {
         if (DeusExPlayerController(Level.GetLocalPlayerController()).bHUDBordersTranslucent)
            c.Style = ERenderStyle.STY_Translucent;
          else
            c.Style = ERenderStyle.STY_Alpha;

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
       }

        c.SetPos(c.ClipX-3, c.ClipY);
        border = texture'DeusExUI.HUDWindowBorder_BR';
        c.DrawIcon(border,1.0);

        c.Style=1;
        c.SetOrigin(int((c.SizeX-w)/2), int((c.SizeY-(h+32)-64)));
        c.SetClip(w, h);

        c.SetPos(8,0); //x,y
        c.DrawColor = InfoLinkTitles;
        dxc.DrawText(Speaker); // кто
                
        //Нарисовать линию с тенью
        dxc.DrawHorizontal(int(c.CurY)+3,LINE_LENGTH);
        c.SetDrawColor(0,0,0);
        dxc.DrawHorizontal(int(c.CurY)+4,LINE_LENGTH);
        c.SetDrawColor(255,255,255);

        c.font=SpeechFont;
        c.SetPos(c.CurX, c.CurY + 8);
        c.DrawColor = InfoLinkText;
        dxc.DrawText(fpsSpeech); // текст

          c.reset();
        c.SetClip(c.SizeX, c.SizeY);
    }
}

defaultproperties
{
    TitleFont = Font'DxFonts.EUX_9B'
    SpeechFont= Font'DxFonts.EU_10'
}

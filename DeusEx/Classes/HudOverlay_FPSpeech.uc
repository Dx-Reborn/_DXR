//
// ������� ��� ������� ��������/���������
//

class HudOverlay_FPSpeech extends DXRHudOverlay;

var() string Speaker;
var() string fpsSpeech;

var ConPlay conPlay;    // Pointer to current conPlay object
var() font TitleFont, SpeechFont, SpeechFontRus;

var bool bIsVisible, bRestrictInput;
var color InfoLinkBG, InfoLinkText, InfoLinkTitles, InfoLinkFrame;

event PostSetInitialState()
{
   local DeusExHUD h;

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

// == ���������� �������� == //
function Render(Canvas C)
{
   local float w,h,holdX,holdY;
   local texture border;

   if (bIsVisible)
   {
      dxc.SetCanvas(C);
      c.DrawColor = InfoLinkBG;
      c.Font = TitleFont; // DXR: Now using Unicode font.
      c.SetOrigin(0,0);
      c.SetClip(595, c.SizeY);
      c.SetPos(0,0);
      holdX=0;
      holdY=0;

      c.StrLen(fpsSpeech, w, h);
      h += 24;
      w = 595;

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

       if (DeusExPlayerController(Level.GetLocalPlayerController()).bHUDBordersVisible)
       {
           if (DeusExPlayerController(Level.GetLocalPlayerController()).bHUDBackgroundTranslucent)
               c.Style = ERenderStyle.STY_Translucent;
                   else
               c.Style = ERenderStyle.STY_Alpha;

           c.DrawColor = InfoLinkFrame;

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

       c.Style=ERenderStyle.STY_Normal;
       c.SetOrigin(int((c.SizeX-w)/2), int((c.SizeY-(h+32)-64)));
       c.SetClip(w, h);

       c.SetPos(8,0); //x,y

       c.DrawColor = InfoLinkTitles;
       dxc.DrawText(Speaker); // ���
                
       //���������� ����� � �����
       dxc.DrawHorizontal(int(c.CurY)+3,596);
       c.SetDrawColor(0,0,0);
       dxc.DrawHorizontal(int(c.CurY)+4,596);
       c.SetDrawColor(255,255,255);

        //c.SetPos(c.CurX, c.CurY + 8);
       c.SetPos(c.CurX, c.CurY + 6);

       if (class'GameManager'.static.GetGameLanguage() ~= "rus")
           c.font = SpeechFontRus;
       else
           c.Font = SpeechFont;

       c.DrawColor = InfoLinkText;
       // Render the text
       dxc.DrawText(fpsSpeech); 
       c.reset();
       c.SetClip(c.SizeX, c.SizeY);
   }
}

function bool isVisible()
{
   return bIsVisible;
}

function DisplayName(string text)
{
   Speaker = text;
}

function DisplayText(string text, Actor speakingActor)
{
   fpsSpeech = text;
}

function AppendText(string text)
{
   fpsSpeech = text $= fpsSpeech;
}

function Close()
{
   Destroy();
}

function Show()
{
   bIsVisible=true;
}

function Hide()
{
   bIsVisible=false;
}

function Clear()
{
   Speaker = "test";
   fpsSpeech="test";
}

function RestrictInput(bool bNewRestrictInput)
{
    bRestrictInput = bNewRestrictInput;
}

function DisplaySkillChoice(ConChoice choice);
function DisplayChoice(ConChoice choice);


defaultproperties
{
    TitleFont=Font'DxFonts.ZR_14'
    SpeechFont=font'DxFonts.FontFixedWidthSmall_DS'
    SpeechFontRus=Font'DxFonts.EU_10'
    bIsVisible=false
}



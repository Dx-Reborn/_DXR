//
// The infolink? Yes...
// Оверлей для Инфолинка.
//
// 06/12/2017: Избавилась от спама вида 'NULL'
// 19/09/2018: Избавилась от спама вида 'accessed none' (Наконец-то !!)
//

class HudOverlay_Infolink extends DXRHudOverlay;

#exec OBJ LOAD FILE=InfoPortraits
#exec OBJ LOAD FILE=DeusExControls

var DeusExPlayer player;
var dataLinkPlay dataLinkPlay;
var bool bRenderText;

var localized String IncomingTransmission, EndTransmission, strQueued;

var String portraitStringName;
var String winName, endName, buffer;
var float textYStep, textYStart, ttySize, ttyCounter, ttyRate, ttyCRate;

var color InfoLinkBG,InfoLinkText,InfoLinkTitles,InfoLinkFrame;

var texture winPortrait;
var Texture speakerPortrait;
var bool bDrawEffects;

function Render(canvas u)
{
  local float holdX, flicker;
  local texture headIcon, border;

  if (Level.GetLocalPlayerController().Pawn == None)
  return;

     dxc.SetCanvas(u);

    u.DrawColor = InfoLinkBG;
    if (DeusExPlayerController(Level.GetLocalPlayerController()).bHUDBackgroundTranslucent)
        u.Style = ERenderStyle.STY_Translucent;
           else
        u.Style = ERenderStyle.STY_Normal;

        // Фон и рамки
    u.SetPos(104,0);
    u.DrawIcon(texture'DeusExUI.HUDInfolinkBackground_1',1.0);
    u.DrawIcon(texture'DeusExUI.HUDInfolinkBackground_2',1.0);


    if (DeusExPlayerController(Level.GetLocalPlayerController()).bHUDBordersVisible)
    {
      if (DeusExPlayerController(Level.GetLocalPlayerController()).bHUDBordersTranslucent)
          u.Style = ERenderStyle.STY_Translucent;
             else
          u.Style = ERenderStyle.STY_Alpha;

      u.DrawColor = InfoLinkFrame;
      border = texture'DeusExUI.HUDInfolinkBorder_1';
      u.SetPos(104,0);
      u.DrawIcon(border,1.0);
      border = texture'DeusExUI.HUDInfolinkBorder_2';
      u.DrawIcon(border,1.0);
    }

    u.Style=1;
    u.SetDrawColor(255,255,255);
        // Аватарка
    u.SetPos(124,25);
    if (portraitStringName != "")
        headIcon = texture(DynamicLoadObject(portraitStringName,class'texture', false));
    if (headicon != none)
            u.DrawTile(headIcon,64,64,0,0,headIcon.USize,headIcon.VSize);
        // Эффекты
    u.SetPos(124,25);
        if (bDrawEffects)
        u.DrawTile(TexPanner'DeusExControls.Controls.static',64,64,0,0,128,128);

    u.SetPos(124,25);
        if (bDrawEffects)
        u.DrawTile(TexPanner'DeusExControls.Controls.scrolling',64,64,0,0,64,64);

  if ((class'GameManager'.static.GetGameLanguage() ~= "frt") || (class'GameManager'.static.GetGameLanguage() ~= "int"))
   u.Font = font'FontFixedWidthSmall_DS';
   else
   u.Font = font'DxFonts.FR_8'; //Font'DxFonts.Inf_9';//font'FontFixedWidthSmall_DS';

   u.SetOrigin(199,37);
   u.SetPos(0,0);
   u.SetClip(291,u.SizeY);

     if (buffer != "") // Render InfoLink message...
     {
       u.StrLen(buffer, holdX, ttySize);
       u.SetClip(291,55);
       u.SetPos(0,textYStart);
       dxc.TeleTypeTextColor = InfoLinkText;
       dxc.DrawTextTeletype(buffer,"|", Level.TimeSeconds - ttyCounter,ttyCRate);
     }

    if (datalinkplay.bEndTransmission == false)
    {
       u.DrawColor = InfoLinkTitles;
       u.SetOrigin(198,17);
       u.SetPos(0,0);
       u.SetClip(293,15);
       u.Font = Font'DxFonts.HR_9';//FontMenuHeaders_DS';
       u.DrawTextJustified(winName,0,u.OrgX,u.OrgY,u.OrgX+u.ClipX,u.OrgY+u.ClipY);
    }

    //Horizontal line
    u.SetOrigin(198,0);
    u.SetPos(0,0);
    //u.SetDrawColor(255,255,255);
    u.DrawColor = InfoLinkText;
    dxc.DrawHorizontal(32,294);

    if(datalinkplay.dataLinkQueue[0] != none)
    {
      u.DrawColor = InfoLinkTitles;
      u.SetOrigin(198,17);
      u.SetPos(0,0);
      u.SetClip(293,15);
      u.Font = Font'DxFonts.HR_9';
      u.DrawTextJustified(strQueued,2,u.OrgX,u.OrgY,u.OrgX+u.ClipX,u.OrgY+u.ClipY);
    }

     if(datalinkplay.bStartTransmission)
     {
        u.reset();
        u.SetPos(124,25);
        bDrawEffects = false;
        u.SetDrawColor(255,255,255);
        headIcon = texture'DeusExUI.UserInterface.DataLinkIcon';
        headIcon.bMasked=true;

        flicker = Level.TimeSeconds % 1.0; //1.0;
        if(flicker < 0.5) // 0.5
        {
             if (headIcon != none)
           u.DrawTile(headIcon,64,64,0,0,headIcon.USize,headIcon.VSize);
        }

        u.DrawColor = InfoLinkTitles;
        u.SetOrigin(199,17);
        u.SetPos(0,0);
        u.SetClip(291,58);
        u.Font = Font'DxFonts.HR_9';
        if (Level.TimeSeconds%1.0 >= 0.5) // Обеспечивает моргание текста
        u.DrawText(IncomingTransmission);

        u.SetPos(0,15);
        u.DrawColor = InfoLinkText;
        dxc.DrawHorizontal(15, 293);

//          u.reset();
//          u.SetClip(u.sizeX,u.sizeY);
     }
            if (datalinkplay.bEndTransmission == true && (Level.TimeSeconds%1.0 >= 0.5))
            {
               u.DrawColor = InfoLinkTitles;
               u.SetOrigin(198,17);
               u.SetPos(0,0);
               u.SetClip(293,15);
               u.Font = Font'DxFonts.FontMenuHeaders_DS';
               winname="";
               u.DrawTextJustified(endName,0,u.OrgX,u.OrgY,u.OrgX+u.ClipX,u.OrgY+u.ClipY);
            }
   u.reset();
   u.SetClip(u.sizeX,u.sizeY);
}

// ----------------------------------------------------------------------
// SetSpeaker()
// Sets the speaker's name in the window and also the portrait 
// displayed in the window
// ----------------------------------------------------------------------
function SetSpeaker(String bindName, String displayName)
{
    local DeusExLevelInfo info;

    winName = displayName;

    // Default portrait name based on bind naem
    portraitStringName = "InfoPortraits." $ Left(bindName, 16);

    // Okay, we have a special case for Paul Denton who, like JC, 
    // has five different portraits based on what the player selected
    // when starting the game.  Therefore we have to pick the right
    // portrait.

    if (bindName == "PaulDenton")
        portraitStringName = portraitStringName $ "_" $ Chr(49 + player.PlayerSkin);

    // Another hack for Bob Page, to use a different portrait on Mission15.
    if (bindName == "BobPage")
    {
        info = player.GetLevelInfo();

        if ((info != None) && (info.MissionNumber == 15))
            portraitStringName = "InfoPortraits.BobPageAug";
    }

    // Get a pointer to the portrait
    speakerPortrait = Texture(DynamicLoadObject(portraitStringName, class'Texture', false));
}

function MessageQueued(Bool bQueued);
function ClearScreen();
function ShowDatalinkIcon(bool bShow);
function ShowPortrait();

function DisplayText(String newText)
{
    textYStart=0;
    ttyCounter=Level.TimeSeconds;
    buffer = newText;
}

function AppendText(String newText)
{
    textYStart=0;
    ttyCounter=Level.TimeSeconds;
    buffer = newText;
}

// Необходимо для того чтобы сообщение ползло снизу вверх.
event Timer()
{
    if((Level.TimeSeconds - ttyCounter)/ttyRate > 4)
    {
       if(Abs(textYStart) < ttySize - 55)
       {
         textYStart = textYStep*(int((Level.TimeSeconds - ttyCounter)/ttyRate) - 4);
       }
    }
}

event SetInitialState()
{
  local DeusExHUD h;

  h = DeusExHUD(level.GetLocalPlayerController().myHUD);
  SetTimer(0.25, true);
  InfoLinkBG = h.InfoLinkBG;
  InfoLinkText = h.InfoLinkText;
  InfoLinkTitles = h.InfoLinkTitles;
  InfoLinkFrame = h.InfoLinkFrame;
}

defaultproperties
{
    textYStep=-1
    textYStart=0
    ttyRate=0.4 //0.3  // 0.5 1.6 // Меньше - быстрее ползет текст инфолинка снизу вверх.
    ttyCRate=0.04 // 0.05 // Больше  - быстрее бежит текст за курсором

    IncomingTransmission="Incoming Transmission..."
    EndTransmission="End transmission..."
    strQueued="Message waiting..."
}

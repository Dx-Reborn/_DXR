//
// The infolink? Yes...
// Оверлей для Инфолинка.
//
// 06/12/2017: Избавилась от спама вида 'NULL'
// 19/09/2018: Избавилась от спама вида 'accessed none' (Наконец-то !!)
//

class HudOverlay_Infolink extends HudOverlay;

#exec OBJ LOAD FILE=InfoPortraits
#exec OBJ LOAD FILE=DeusExControls

var DeusExPlayer player;
var dataLinkPlay dataLinkPlay;
var bool bRenderText;
var transient DxCanvas dxc;

var localized String IncomingTransmission, EndTransmission, strQueued;

var String portraitStringName;
var String winName, endName, buffer;
var float textYStep, textYStart, ttySize, ttyCounter, ttyRate, ttyCRate;

var color InfoLinkBG,InfoLinkText,InfoLinkTitles,InfoLinkFrame;

var texture winPortrait;
var Texture speakerPortrait;
var bool bDrawEffects;

function Render(canvas c)
{
  local float holdX, flicker;
  local texture headIcon, border;

     dxc.SetCanvas(C);

    c.DrawColor = InfoLinkBG;
    if (DeusExPlayer(Level.GetLocalPlayerController().pawn).bHUDBackgroundTranslucent)
        c.Style = ERenderStyle.STY_Translucent;
           else
             c.Style = ERenderStyle.STY_Normal;

		// Фон и рамки
    c.SetPos(104,0);
    c.DrawIcon(texture'DeusExUI.HUDInfolinkBackground_1',1.0);
    c.DrawIcon(texture'DeusExUI.HUDInfolinkBackground_2',1.0);


    if (DeusExPlayer(Level.GetLocalPlayerController().pawn).bHUDBordersVisible)
    {
      if (DeusExPlayer(Level.GetLocalPlayerController().pawn).bHUDBordersTranslucent)
         c.Style = ERenderStyle.STY_Translucent;
          else
           c.Style = ERenderStyle.STY_Alpha;

      c.DrawColor = InfoLinkFrame;
      border = texture'DeusExUI.HUDInfolinkBorder_1';
      c.SetPos(104,0);
      c.DrawIcon(border,1.0);
      border = texture'DeusExUI.HUDInfolinkBorder_2';
      c.DrawIcon(border,1.0);
    }

    c.Style=1;
    c.SetDrawColor(255,255,255);
		// Аватарка
    c.SetPos(124,25);
    if (portraitStringName != "")
        headIcon = texture(DynamicLoadObject(portraitStringName,class'texture', false));
    if (headicon != none)
		    c.DrawTile(headIcon,64,64,0,0,headIcon.USize,headIcon.VSize);
		// Эффекты
    c.SetPos(124,25);
		if (bDrawEffects)
        c.DrawTile(TexPanner'DeusExControls.Controls.static',64,64,0,0,128,128);

    c.SetPos(124,25);
		if (bDrawEffects)
        c.DrawTile(TexPanner'DeusExControls.Controls.scrolling',64,64,0,0,64,64);

   c.Font = Font'DxFonts.Inf_9';//FontFixedWidthSmall_DS';
   c.SetOrigin(199,37);
   c.SetPos(0,0);
   c.SetClip(291,c.SizeY);

     if (buffer != "")
     {
       c.StrLen(buffer, holdX, ttySize);
       c.SetClip(291,55);
       c.SetPos(0,textYStart);
       dxc.TeleTypeTextColor = InfoLinkText;
       dxc.DrawTextTeletype(buffer,"|", Level.TimeSeconds-ttyCounter,ttyCRate);
     }

    if (datalinkplay.bEndTransmission == false)
    {
       c.DrawColor = InfoLinkTitles;
       c.SetOrigin(198,17);
       c.SetPos(0,0);
       c.SetClip(293,15);
       c.Font = Font'DxFonts.HR_9';//FontMenuHeaders_DS';
       c.DrawTextJustified(winName,0,c.OrgX,c.OrgY,c.OrgX+c.ClipX,c.OrgY+c.ClipY);
    }

    //Horizontal line
    c.SetOrigin(198,0);
    c.SetPos(0,0);
    //c.SetDrawColor(255,255,255);
    c.DrawColor = InfoLinkText;
    dxc.DrawHorizontal(32,294);

    if(datalinkplay.dataLinkQueue[0] != none)
    {
      c.DrawColor = InfoLinkTitles;
      c.SetOrigin(198,17);
      c.SetPos(0,0);
      c.SetClip(293,15);
      c.Font = Font'DxFonts.HR_9';
      c.DrawTextJustified(strQueued,2,c.OrgX,c.OrgY,c.OrgX+c.ClipX,c.OrgY+c.ClipY);
    }

     if(datalinkplay.bStartTransmission)
     {
			  c.reset();
        c.SetPos(124,25);
        bDrawEffects = false;
        c.SetDrawColor(255,255,255);
        headIcon = texture'DeusExUI.UserInterface.DataLinkIcon';
        headIcon.bMasked=true;

        flicker = Level.TimeSeconds % 1.0; //1.0;
        if(flicker < 0.5) // 0.5
        {
        	 if (headIcon != none)
           c.DrawTile(headIcon,64,64,0,0,headIcon.USize,headIcon.VSize);
        }

        c.DrawColor = InfoLinkTitles;
        c.SetOrigin(199,17);
        c.SetPos(0,0);
        c.SetClip(291,58);
        c.Font = Font'DxFonts.HR_9';
        if (Level.TimeSeconds%1.0 >= 0.5) // Обеспечивает моргание текста
        c.DrawText(IncomingTransmission);

        c.SetPos(0,15);
        c.DrawColor = InfoLinkText;
        dxc.DrawHorizontal(15, 293);

//			c.reset();
//			c.SetClip(c.sizeX,c.sizeY);
     }
			if (datalinkplay.bEndTransmission == true && (Level.TimeSeconds%1.0 >= 0.5))
			{
       c.DrawColor = InfoLinkTitles;
     	 c.SetOrigin(198,17);

       c.SetPos(0,0);
 	     c.SetClip(293,15);
       c.Font = Font'DxFonts.FontMenuHeaders_DS';
       winname="";
   	   c.DrawTextJustified(endName,0,c.OrgX,c.OrgY,c.OrgX+c.ClipX,c.OrgY+c.ClipY);
   		}
			c.reset();
			c.SetClip(c.sizeX,c.sizeY);
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
function Timer()
{
    if((Level.TimeSeconds - ttyCounter)/ttyRate > 4)
    {
       if(Abs(textYStart) < ttySize - 55)
       {
         textYStart = textYStep*(int((Level.TimeSeconds - ttyCounter)/ttyRate) - 4);
       }
    }
}

function SetInitialState()
{
  local DeusExHUD h;

  h = DeusExHUD(level.GetLocalPlayerController().myHUD);
	dxc = new(Outer) class'DxCanvas';
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

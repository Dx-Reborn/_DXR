/*
   На вход строка с разделителями |
   Разбивается на части
   Выводится как массив строк.
*/

class HudOverlay_EndGameQuotes extends HudOverlay;

var float displayTime;
var bool bTickEnabled;
var bool bSpewingText;
var int charIndex;
var int NumParts;

var float CharDelay;
var float charTime;

var String message;
var string longest;
var string TheMessage;
var array<String> TheMessages;

var color textColor;
var float tsX, tsY;
var font msgFont;

function Render(Canvas u)
{
  local int i;

  u.Font = msgFont;
    u.DrawColor = TextColor;

  split(TheMessage,"|", TheMessages);

  u.strLen(longest, tsX, tsY);

  for(i=0; i<TheMessages.Length; i++)
  {
    u.SetPos((u.sizeX / 2)  - tsX / 2,(u.sizeY / 3) - (tsY / 2) + tsY * i);
    u.DrawText(TheMessages[i]);
  }

/*  u.SetDrawColor(128, 211, 100); 
  u.SetPos(200,300);
  u.drawText("Время (displayTime) = "$displayTime);
  u.SetPos(200,130);
  u.drawText("Длина массива (Array Length) = "$TheMessages.Length);
  u.SetPos(200,160);
  u.drawText("Длина строки X,Y "$tsX@tsY);*/
}

function AddMessage(String str)
{
    if (str != "")
    {
        if (message != "")
        {
            message = message $ "|";
        }
        message = message $ str;
    }
}

function StartMessage()
{
  class'DxUtil'.static.FindLongestPart(message, longest);
    bTickEnabled = true;
    bSpewingText = true;
}

function Tick(float deltaTime)
{
 if (bTickEnabled)
 {
    if (bSpewingText)
    {
    charTime += deltaTime;
    if (charTime > charDelay)
       PrintNextCharacter();
    }
    else
    {
        displayTime -= deltaTime;

        if (displayTime <= 0)
        {
        bTickEnabled = false;
            Destroy(); // Время вышло, уничтожить.
        }
    }
 }
}

function PrintNextCharacter()
{
    if (charIndex < len(message))
    {
            AppendText(mid(message, charIndex, 1));
            charIndex++;
    }
    else
    {
        // Now more characters to print, so pause and then go away
        bSpewingText = False;
    }
}

function AppendText(string str)
{
   TheMessage $= str;
   charTime = 0;
}


defaultproperties
{
   CharDelay=0.05
   displayTime=5.0
   message="test message"
   msgFont=font'DxFonts.ZR_18' //font'DxFonts.EU_14' //
   TextColor=(R=255,G=255,B=255,A=255)
}

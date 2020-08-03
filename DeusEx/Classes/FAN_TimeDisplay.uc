/*
   Отсчет времени до перезапуска системы вентиляции.
   Для вертикального вентилятора (или один на все?)

*/

class FAN_TimeDisplay extends Info
                              placeable;

var int currentTime;

var() ScriptedTexture DestTexture;
var() bool bEnabled;
var() int RefreshRate;
var() font DigitsFont;
var string TextToRender;
var() color color_text; // !! Alpha must be 255 !!
var() int posX, posY;

event PostLoadSavedGame()
{
   PostBeginPlay();
}


event PostBeginPlay()
{
    if(DestTexture != None)
    {
        DestTexture.Client = Self;
        SetTimer(1.0 / RefreshRate,true);
        Enable('Timer');
    }
}

event Timer()
{
 if (bEnabled)
    DestTexture.Revision++;
}


// Заметка для себя: это не UCanvas!!!
event RenderTexture(ScriptedTexture Tex)
{
   if (Tex == None) 
   return;
   if (DigitsFont == None)
   return;
   if (!bEnabled)
   return;

   TextToRender = "17:53"; // ToDo: Здесь будет таймер

   tex.DrawText(posX,posY,TextToRender,DigitsFont,color_text);
}

defaultproperties
{
   RefreshRate=60
   Texture=SubActionFade
   DigitsFont=font'DxFonts.DS_Digits_72'
   bEnabled=true
//   TextToRender="00:00"
   PosX=100
   posY=100
}


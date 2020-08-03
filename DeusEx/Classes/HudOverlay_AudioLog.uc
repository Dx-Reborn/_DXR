class HudOverlay_AudioLog extends HUDOverlay;

#exec OBJ LOAD FILE=DXR_AudioLogMat.utx

var float LifeTime;

var() float PositionX, PositionY;
var() localized string Caption, MsgFinished;
var() float captionX, captionY;
var DeusExHUD hd;


event SetInitialState()
{
    hd = DeusExHUD(Level.GetLocalPlayerController().myHUD);
    hd.AddHudOverlay(self);

//    SetTimer(LifeTime, false);
}

function Render(Canvas u)
{
   u.SetPos(u.SizeX - PositionX, u.SizeY - PositionY);
   u.DrawTilePartialStretched(material'DXR_AudioLogMat.AudioWave_TP', 128, 32);

   u.SetPos(u.SizeX - CaptionX, u.SizeY - CaptionY);
   u.DrawColor = class'HUD'.default.WhiteColor;
   u.Font = Font'DxFonts.EUR_9';
   u.DrawText(Caption);
}


event Timer()
{
   Destroy();
}

defaultproperties
{
   LifeTime=0.1

   PositionX=200
   PositionY=100

   CaptionX=200
   CaptionY=80

   Caption="Playing message..."
   MsgFinished="End of message..."
}
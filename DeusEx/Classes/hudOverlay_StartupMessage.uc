/*
 Стартовое сообщение. Появляется только один раз за игру (дальнейшее появление предотвращается специальным флагом)
*/

class hudOverlay_StartupMessage extends HudOverlay;

var() font MsgFont;
var() float msgDelays[3];
var string StartUpMessage[4];
var float ttycounter, extratime[4], dtime;
var transient dxCanvas dxc;

const ttyCRate=0.03; // 0.05 // Больше  - быстрее бежит текст за курсором
const StartUpDelay = 8.0;

function SetInitialState()
{
	ttyCounter=Level.TimeSeconds;
	extratime[0]=Level.TimeSeconds + msgDelays[0];
	extratime[1]=Level.TimeSeconds + msgDelays[1];
	extratime[2]=Level.TimeSeconds + msgDelays[2];
	SetTimer(StartUpDelay, false);

	dxc = new(Outer) class'DxCanvas';
}

function Tick(float deltatime)
{
	dtime += deltatime;
}

function timer()
{
	Disable('Tick');
	Destroy();
}

function Render(Canvas c)
{
     dxc.SetCanvas(C);

    c.Font = MsgFont;
    c.Style=1;
    c.SetClip(c.SizeX, c.SizeY);

		c.SetDrawColor(255,255,255);
    c.SetOrigin((c.SizeX/2)-102, (c.SizeY/2)-89);
    c.SetPos(0,0);
		// Первая строка
    if (StartUpMessage[0] !="")
    {
		   c.SetPos(0, 0*21.f);
       dxc.DrawTextTeletypeEx(StartUpMessage[0],"|", Level.TimeSeconds-ttyCounter,ttyCRate, false);
    }
		// далее...
    if ((StartUpMessage[1] !="") && (dtime > 1.0))
    {
		   c.SetPos(0, 1*21.f);
       dxc.DrawTextTeletypeEx(StartUpMessage[1],"|", level.timeseconds-extratime[0],ttyCRate, false);
    }

    if ((StartUpMessage[2] !="") && (dtime > 1.75))
    {
		   c.SetPos(0, 2*21.f);
       dxc.DrawTextTeletypeEx(StartUpMessage[2],"|", level.timeseconds-extratime[1],ttyCRate, false);
    }

    if ((StartUpMessage[3] !="") && (dtime > 2.5))
    {
		   c.SetPos(0, 3*21.f);
       dxc.DrawTextTeletypeEx(StartUpMessage[3],"|", level.timeseconds-extratime[2],ttyCRate, false);
    }

	c.reset();
	c.SetClip(c.sizeX,c.sizeY);
}


defaultproperties
{
  MsgFont = Font'DxFonts.EUX_10B';//12

  msgDelays(0)=1.5
	msgDelays(1)=2.5
	msgDelays(2)=3.5

}

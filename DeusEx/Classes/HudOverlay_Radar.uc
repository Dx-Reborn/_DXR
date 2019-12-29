/*
   Радар можно реализовать как приращение.
   Уровни:
     0 - NPC в радиусе 1000 UU. Выделения цветом нет. Расположение относительно игрока не подсвечивается.
     1 - NPC в радиусе 1000 UU. Выделения цветом нет. Расположение относительно игрока подсвечивается.
     2 - NPC в радиусе 1000 UU. Есть выделение цветом. Расположение относительно игрока подсвечивается.
     3 - NPC в радиусе 3000 UU. Есть выделение цветом. Расположение относительно игрока подсвечивается.
*/

class HudOverlay_Radar extends HUDOverlay;

var float RadarPulse,RadarScale;
var() float RadarPosX, RadarPosY;
var float MinEnemyDist;
var material RadarBackground;

var Human PawnOwner;
var DeusExPlayerController PlayerOwner;
var float HUDScale;
var int RadarLevel; // 0 - 3

function BeginPlay()
{
   PlayerOwner = DeusExPlayerController(Level.GetLocalPlayerController().myHUD.PlayerOwner);
   PawnOwner = Human(Level.GetLocalPlayerController().myHUD.PawnOwner);
   HUDScale = Level.GetLocalPlayerController().myHUD.HUDScale;
}

function Render(Canvas u)
{
  if (PawnOwner != None)
  {
   DrawCircle(u);
   DrawObjects(u);
  }
}

function DrawCircle(canvas u)
{
    local float RadarWidth;

    RadarScale = Default.RadarScale * HUDScale;
    RadarWidth = 0.5 * RadarScale * u.ClipX;

    u.Style = ERenderStyle.STY_Alpha;
    u.DrawColor = class'HUD'.default.BlackColor;

    u.SetPos(RadarPosX * u.ClipX - RadarWidth, RadarPosY * u.ClipY + RadarWidth);
    u.DrawTile(RadarBackground, RadarWidth, RadarWidth, 0, 512, 512, -512);

    u.SetPos(RadarPosX * u.ClipX,RadarPosY * u.ClipY + RadarWidth);
    u.DrawTile(RadarBackground, RadarWidth, RadarWidth, 512, 512, -512, -512);

    u.SetPos(RadarPosX * u.ClipX - RadarWidth,RadarPosY * u.ClipY);
    u.DrawTile(RadarBackground, RadarWidth, RadarWidth, 0, 0, 512, 512);

    u.SetPos(RadarPosX * u.ClipX,RadarPosY * u.ClipY);
    u.DrawTile(RadarBackground, RadarWidth, RadarWidth, 512, 0, -512, 512);

//    u.DrawColor = class'HUD'.default.WhiteColor;
//    u.DrawText(PawnOwner.Location.Z);
}


function DrawObjects(canvas u)
{
    local ScriptedPawn P;
    local float Dist, MaxDist, RadarWidth,Angle,DotSize,OffsetY,OffsetScale;
    local rotator Dir;
    local vector Start;
    local int DistB;
    local float vis;
    
    RadarWidth = 0.5 * RadarScale * u.ClipX;
//    DotSize = 24 * u.ClipX * HUDScale/1600;
    DotSize = 8 * u.ClipX * HUDScale/1600;
    if (PawnOwner == None)
        Start = PlayerOwner.Location;
    else
        Start = PawnOwner.Location;
    
    MaxDist = 3000;// * RadarPulse;
    u.Style = ERenderStyle.STY_Masked;
    OffsetY = RadarPosY + RadarWidth/u.ClipY;
    MinEnemyDist = 3000;
    foreach DynamicActors(class'ScriptedPawn',P)
        if ((P.Health > 0) && (P.bInWorld == true))
        {
            Dist = VSize(Start - P.Location);

            vis = class'DeusExPawn'.static.AiVisibility(P, false);
            if (Dist < 3000)
            {
                if (P != None)
                {
                  if (P.GetAllianceType(pawnOwner.Alliance) == ALLIANCE_Hostile)
                  {
                    u.DrawColor.R = 200;
                    u.DrawColor.G = 0;
                    u.DrawColor.B = 0;
                  }
                  else
                  {
                    u.DrawColor.R = 0;
                    u.DrawColor.G = 200;
                    u.DrawColor.B = 0;
                  }
                }
                else
                {
                    u.DrawColor.R = 0;
                    u.DrawColor.G = 0;
                    u.DrawColor.B = 0;
                }
                Dir = rotator(P.Location - Start);
                OffsetScale = RadarScale * Dist * 0.000167;

                if (Level.GetLocalPlayerController().myHUD.PawnOwner == None)
                    Angle = ((Dir.Yaw - PlayerOwner.Rotation.Yaw) & 65535) * 6.2832/65536;
                else
                    Angle = ((Dir.Yaw - PawnOwner.Rotation.Yaw) & 65535) * 6.2832/65536;

                u.SetPos(RadarPosX * u.ClipX + OffsetScale * u.ClipX * sin(Angle) - 0.5 * DotSize, 
                         OffsetY * u.ClipY - OffsetScale * u.ClipX * cos(Angle) - 0.5 * DotSize);

                DistB = abs(PawnOwner.Location.Z - P.Location.Z) - abs(PawnOwner.default.CollisionHeight - PawnOwner.CollisionHeight);
                if (abs(DistB) >= 0 && abs(DistB) < 60) // Same
                    //u.DrawText(vis);
                    u.DrawTile(Material'CheckboxOff',DotSize,DotSize,0,0,8,8);
                    //u.DrawTile(Material'Dithered',DotSize,DotSize,0,0,8,8);
                else if (DistB > 61) // Below or above
                   // u.DrawText(vis);
                    u.DrawTile(Material'RadarSquare',DotSize,DotSize,0,0,8,8);
            }
        }
}

defaultproperties
{
    RadarScale=0.20
    RadarPosX=0.840
    RadarPosY=0.540
    
    RadarBackground=Texture'UT2k4Extra.RadarQ'
}


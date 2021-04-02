//=============================================================================
// Binoculars.
//=============================================================================
class Binoculars extends DeusExPickup;

var localized string binocsActive, binocsInactive;
var int BinocularsMaxRange;
var int ZoomFOV;

var texture Binocs_Background, Binocs_Cross;
var Material LinesShader;

event PreBeginPlay()
{
   LoadSomeTextures();
   Super.PreBeginPlay();
}

function LoadSomeTextures()
{
   Binocs_Background = Texture(DynamicLoadObject("DeusExUIExtra.HUD.HUDBinocularView", class'Texture', false));
   Binocs_Cross = Texture(DynamicLoadObject("DeusExUIExtra.HUD.HUDBinocularCrossHair", class'Texture', false));
   LinesShader = Material(DynamicLoadObject("GUIContent.back.VisionLined_Gray_SH", class'Material', false));
}


state Activated
{
   function BeginState()
   {
       Super.BeginState();
       ToggleBinocularsView(true);
   }

Begin:
}

state DeActivated
{
   function BeginState()
   {
       local DeusExPlayer player;
       
       Super.BeginState();

       player = DeusExPlayer(Owner);
       if (player != None)
       {
           // Hide the Scope View
           ToggleBinocularsView(false);
       }
   }
}

function ToggleBinocularsView(bool bDoIt)
{
   local DeusExPlayerController dc;

   dc = DeusExPlayerController(level.GetLocalPlayerController());

   if (bDoIt)
   {
       bIsActive = true;
       dc.DesiredFOV = ZoomFOV;
       SetDrawType(DT_None);
   }
   else
   {
       bIsActive = false;
       dc.ResetFOV();
       SetDrawType(default.DrawType);
   }
}

event RenderOverlays(Canvas u)
{
   Super.RenderOverlays(u);

   if (bActive)
   {
       RenderBinoculars(u);
   }
}

function RenderBinoculars(Canvas u)
{
    local ScriptedPawn target;

    // Вид из бинокля...
    u.setPos(u.sizeX / 2 - 512,u.sizeY / 2 - 256);
    u.Style = ERenderStyle.STY_Modulated;
    u.DrawTileJustified(Binocs_Background, 1, 1024, 512); // 0 = left/top, 1 = center, 2 = right/bottom 
    u.Style = ERenderStyle.STY_Normal;

    u.SetDrawColor(0,255,0,255);// Green crosshair
    u.DrawTileJustified(Binocs_Cross, 1, 1024, 512);

    u.SetPos(0,0);
    u.SetDrawColor(255,255,255,255);
    u.DrawPattern(LinesShader, u.SizeX, u.SizeY, 1);

    // Заполнители
    u.Style = ERenderStyle.STY_Normal;
    u.DrawColor = class'DeusExHUD'.default.blackColor;

    u.SetPos(0,0); // верхний
    u.DrawTileStretched(texture'solid', u.sizeX, (u.sizeY / 2) - 256);

    u.SetPos(0,(u.sizeY / 2) + 256); // Нижний заполнитель...
    u.DrawTileStretched(texture'solid', u.sizeX, u.sizeY);

    u.SetPos(0,(u.sizeY /2) - 256); // Левый заполнитель...
    u.DrawTileStretched(texture'solid', (u.sizeX / 2) - 512, (u.sizeY / 2) + 152);

    u.SetPos((u.SizeX / 2) + 512,(u.sizeY /2) - 256); // Правый заполнитель...
    u.DrawTileStretched(texture'solid', (u.sizeX / 2) - 512, (u.sizeY / 2) + 152);

                                  
    foreach Instigator.VisibleCollidingActors(class'ScriptedPawn', target, BinocularsMaxRange, Instigator.Location + vector(Instigator.GetViewRotation()))
            if (target.PlayerCanSeeMe() == true)
                DrawBinocularsView(target,u);
}

//dist = int(vsize(TCP.Location-wpTarget.Location)/52);
// Вид из бинокля: расстояние до цели.
function DrawBinocularsView(Pawn Target, Canvas u)
{
    local String str;
    local float boxCX, boxCY;
    local float x, y, w, h, mult;
    local vector sp1, EyePos;

    if (Target != None)
    {
        u.Font = font'DXFonts.EU_9';
        mult = VSize(Target.Location - Instigator.Location);
        str = class'DeusExHUD'.default.msgRange @ (mult/52) @ class'DeusExHUD'.default.strMeters;

        EyePos = Instigator.Location;
        EyePos.Z += Instigator.EyeHeight;

        // Расстояние до Pawn
        sp1 = u.WorldToScreen(Target.Location);
        boxCX = sp1.X;
        boxCY = sp1.Y;

        u.TextSize(str, w, h);
        x = boxCX - w/2;
        y = boxCY - h;
        u.DrawColor = class'DeusExHUD'.default.RedColor;

        u.SetPos(x,y);
        u.Style=ERenderStyle.STY_Normal;
        u.DrawText(str);

        u.SetPos(x-4,y-4);
        u.Style = ERenderStyle.STY_Translucent;
        u.drawTileStretched(texture'ItemNameBox', w+4,h+4);
    }
    u.reset();
}

function string GetDescription()
{
   return description;
}


defaultproperties
{
    BinocularsMaxRange=2000
    ZoomFOV=20

    bActivatable=True
    PlayerViewOffset=(X=18.00,Y=0.00,Z=-6.00)
    PlayerViewPivot=(Pitch=0,Roll=0,Yaw=16384)
    LandSound=Sound'DeusExSounds.Generic.PaperHit2'

    binocsActive="Binoculars activated"
    binocsInactive="Binoculars DeActivated"
    Description="A pair of military binoculars."
    ItemName="Binoculars"
    beltDescription="BINOCS"
    Icon=Texture'DeusExUI.Icons.BeltIconBinoculars'
    largeIcon=Texture'DeusExUI.Icons.LargeIconBinoculars'
    largeIconWidth=49
    largeIconHeight=34
    bCanHaveMultipleCopies=false

    Mesh=Mesh'DeusExItems.Binoculars'
    PickupViewMesh=Mesh'DeusExItems.Binoculars'
    FirstPersonViewMesh=Mesh'DeusExItems.Binoculars'

    CollisionRadius=7.000000
    CollisionHeight=2.060000
    Mass=5.000000
    Buoyancy=6.000000
}

/*
   DeusExHUD - Графический дисплей игрока.
   ToDo: Implement layout with all HUD parts in lower part of the screen.
*/

class DeusExHUD extends MouseHUD;

const DebugTraceDist = 512;
var localized string TestUkr_String; // Для проверки Украинского языка

var localized string strMeters;
var int BinocularsMaxRange;
var() bool bUseBinocularView;

var transient bool bConversationInvokeRadius;
var transient string DebugConString, DebugConString2;

var bool bRenderMover;
var float vis;

// Radar
var float RadarPulse,RadarScale;
var float RadarPosX, RadarPosY;
var float MinEnemyDist;
var material RadarBackground;

exec function ShowDebug()
{
    bShowDebugInfo = !bShowDebugInfo;
    cubemapmode = bShowDebugInfo;
}

event Tick(float dt)
{
   Super.Tick(dt);

   if (PlayerOwner != None && PlayerOwner.Pawn != None)
   RefreshHUDDisplay(dt);
}

function RefreshHUDDisplay(float DT)
{
    ClearBelt();
    PopulateBelt();
//    UpdateInHand();
}

event SetInitialState()
{
   LoadColorTheme();
   PopulateBelt();

//  foreach AllActors(class'DeusExMover', DxMover)
//  break;

   super.setInitialState();
}

function LoadColorTheme()
{
   local DeusExGlobals gl;
   local int index;

   gl = class'DeusExGlobals'.static.GetGlobals();
   index = gl.HUDThemeIndex;

   MessageBG = class'DXR_HUD'.static.GetMessageBG(index);
   MessageText = class'DXR_HUD'.static.GetMessageText(index);
   MessageFrame = class'DXR_HUD'.static.GetMessageFrame(index);

   ToolBeltBG = class'DXR_HUD'.static.GetToolBeltBG(index);
   ToolBeltText = class'DXR_HUD'.static.GetToolBeltText(index);
   ToolBeltFrame = class'DXR_HUD'.static.GetToolBeltFrame(index);
   ToolBeltHighlight = class'DXR_HUD'.static.GetToolBeltHighlight(index);

   AugsBeltBG = class'DXR_HUD'.static.GetAugsBeltBG(index);
   AugsBeltText = class'DXR_HUD'.static.GetAugsBeltText(index);
   AugsBeltFrame = class'DXR_HUD'.static.GetAugsBeltFrame(index);
   AugsBeltActive = class'DXR_HUD'.static.GetAugsBeltActive(index);
   AugsBeltInActive = class'DXR_HUD'.static.GetAugsBeltInActive(index);

   AmmoDisplayBG = class'DXR_HUD'.static.GetAmmoDisplayBG(index);
   AmmoDisplayFrame = class'DXR_HUD'.static.GetAmmoDisplayFrame(index);

   compassBG = class'DXR_HUD'.static.GetcompassBG(index);
   compassFrame = class'DXR_HUD'.static.GetcompassFrame(index);

   HealthBG = class'DXR_HUD'.static.GetHealthBG(index);
   HealthFrame = class'DXR_HUD'.static.GetHealthFrame(index);

   BooksBG = class'DXR_HUD'.static.GetBooksBG(index);
   BooksText = class'DXR_HUD'.static.GetBooksText(index);
   BooksFrame = class'DXR_HUD'.static.GetBooksFrame(index);

   InfoLinkBG = class'DXR_HUD'.static.GetInfoLinkBG(index);
   InfoLinkText = class'DXR_HUD'.static.GetInfoLinkText(index);
   InfoLinkTitles = class'DXR_HUD'.static.GetInfoLinkTitles(index);
   InfoLinkFrame = class'DXR_HUD'.static.GetInfoLinkFrame(index);

   AIBarksBG = class'DXR_HUD'.static.GetAIBarksBG(index);
   AIBarksText = class'DXR_HUD'.static.GetAIBarksText(index);
   AIBarksHeader = class'DXR_HUD'.static.GetAIBarksHeader(index);
   AIBarksFrame = class'DXR_HUD'.static.GetAIBarksFrame(index);

   FrobBoxColor = class'DXR_HUD'.static.GetFrobBoxColor(index);
   FrobBoxShadow = class'DXR_HUD'.static.GetFrobBoxShadow(index);
   FrobBoxText = class'DXR_HUD'.static.GetFrobBoxText(index);
}

event PostLoadSavedGame()
{
  if (dxc == none)
    dxc = new(none) class'DxCanvas';
}

exec function ExtraHUDDebugInfo()
{
  if (DeusExPlayer(PlayerOwner.Pawn) != none)
  {
    DeusExPlayer(PlayerOwner.Pawn).bExtraDebugInfo = !DeusExPlayer(PlayerOwner.Pawn).bExtraDebugInfo;
  }
}

event PostRender(canvas C)
{
    super.postrender(C);

    if (PlayerOwner.pawn == none)
        return;

//  TrackActors(C);

    if (DeusExPlayer(PlayerOwner.Pawn).bExtraDebugInfo)
    RenderDebugInfo(C);

    if (bUseBinocularView)
    {
      RenderBinoculars(C);
    }
    if ((DeusExWeapon(PlayerOwner.pawn.Weapon) != none) && (DeusExWeapon(PlayerOwner.pawn.Weapon).bZoomed))
        renderScopeView(C);

    if (DeusExPlayer(PlayerOwner.Pawn) != None && DeusExPlayer(PlayerOwner.Pawn).bRadarActive)
    {
        DrawRadarCircle(c); // Фон радара
        DrawRadar(c);
    }

//  if (bRenderMover)
//     RenderMover(C);
}

/*- Converted from ActorDisplayWindow. Used to check mover bounds. ----------------------*/
/*final function RenderMover(Canvas C)
{
    local int         i;
    local vector      topCircle[8];
    local vector      bottomCircle[8];
    local int         numPoints;
    local vector      center, area;
    local vector pp;

  if (DxMover == none)
  return;

  pp = C.WorldToScreen(dxMover.Location - dxMover.PrePivot);
  C.SetPos(pp.x, pp.y);
  c.SetDrawColor(255,0,0);
  C.DrawText("+");

        dxMover.ComputeMovementArea(center, area);

        topCircle[0] = center+area*vect(1,1,1);
        topCircle[1] = center+area*vect(1,-1,1);
        topCircle[2] = center+area*vect(-1,-1,1);
        topCircle[3] = center+area*vect(-1,1,1);
        bottomCircle[0] = center+area*vect(1,1,-1);
        bottomCircle[1] = center+area*vect(1,-1,-1);
        bottomCircle[2] = center+area*vect(-1,-1,-1);
        bottomCircle[3] = center+area*vect(-1,1,-1);
        numPoints = 4;

    for (i=0; i<numPoints; i++)
        DrawLineA(c, topCircle[i], bottomCircle[i]);
    for (i=0; i<numPoints-1; i++)
    {
        DrawLineA(c, topCircle[i], topCircle[i+1]);
        DrawLineA(c, bottomCircle[i], bottomCircle[i+1]);
    }
    DrawLineA(c, topCircle[i], topCircle[0]);
    DrawLineA(c, bottomCircle[i], bottomCircle[0]);
}*/

/*function DrawLineA(Canvas c, vector point1, vector point2)
{
    local float toX, toY;
    local float fromX, fromY;
    local vector tVect1, tVect2;

  tVect1 = c.WorldToScreen(point1);
  tVect2 = c.WorldToScreen(point2);

  fromX = tVect1.X;
  fromY = tVect1.Y;
  toX = tVect2.X;
  toY = tVect2.Y;

    c.Style=ERenderStyle.STY_Normal;

        c.SetDrawColor(120, 250,150);
        DrawPoint(c, fromX, fromY);
        DrawPoint(c, toX, toY);

        c.SetDrawColor(0, 250, 250);
        Interpolate(c, fromX, fromY, toX, toY, 8);
}*/




simulated function DisplayMessages(Canvas C)
{
    local int i, j, MessageCount;
    local float w,h;
    local texture border;

  if ((cubeMapMode) || (PlayerOwner.pawn == none) || bShowDebugInfo)
  return;

        for(i = 0; i<ConsoleMessageCount; i++)
      {
       if (TextMessages[i].Text == "")
           break;
            else if (TextMessages[i].MessageLife < Level.TimeSeconds)
          {
            TextMessages[i].Text = "";

            if(i < ConsoleMessageCount - 1)
            {
             for(j=i; j<ConsoleMessageCount-1; j++)
                 TextMessages[j] = TextMessages[j+1];
            }
            TextMessages[j].Text = "";
            break;
        }
        else
        MessageCount++;
      }


    if ((messageCount > 0) && (DeusExPlayer(playerowner.pawn).DataLinkPlay == none))
    {
        if (dxc != none)
         dxc.SetCanvas(C);

        c.Font = font'DXFonts.EU_8';
//        c.Style=ERenderStyle.STY_Translucent;

        c.SetOrigin(0,0);
        c.SetClip(c.SizeX - 200, c.SizeY);
        c.SetPos(0,0);

        c.StrLen("ЧТО УГОДНО", w, h);
        h += 22;
        w = c.SizeX - 200;

        c.SetOrigin(int((c.SizeX-w)/2), int(h));
        c.SetClip(w, h);

                if (messageCount > 3)
                {
                    c.SetClip(w, (14 * messagecount));
                }
       // Фон
//        c.Style=ERenderStyle.STY_Translucent;
        if (DeusExPlayer(playerowner.pawn).bHUDBackgroundTranslucent)
            c.Style = ERenderStyle.STY_Translucent;
              else
                c.Style = ERenderStyle.STY_Normal;

        c./*Set*/DrawColor = MessageBG;//(64,64,64); // Что за--?


        //TL
        c.SetPos(-13,-16);
        c.DrawTile(texture'DeusExUI.HUDWindowBackground_TL',63,16, 1,0,63,16);
        //L
        c.SetPos(-13,0);
        if (messageCount <= 3)
        c.DrawTile(texture'DeusExUI.HUDWindowBackground_Left',63,h, 1,0,63,8);
        if (messageCount > 3)
        c.DrawTile(texture'DeusExUI.HUDWindowBackground_Left',63,(14 * messagecount), 1,0,63,8);
        //BL
        c.SetPos(-13, c.ClipY);
        c.DrawTile(texture'DeusExUI.HUDWindowBackground_BL',63,16, 1,0,63,16);
        //T
        c.SetPos(50,-16);
        c.DrawTile(texture'DeusExUI.HUDWindowBackground_Top',w-51,16, 0,0,8,16);
        //M
        c.SetPos(50,0);
        if (messageCount <= 3)
        c.DrawTile(texture'DeusExUI.HUDWindowBackground_Center',w-51,h, 0,0,8,8);
        if (messageCount > 3)
        c.DrawTile(texture'DeusExUI.HUDWindowBackground_Center',w-51,(14 * messagecount), 0,0,8,8);
        //B
        c.SetPos(50,c.ClipY);
        c.DrawTile(texture'DeusExUI.HUDWindowBackground_Bottom',w-51,16, 0,0,8,16);

        c.SetOrigin(c.OrgX+c.ClipX-1,c.OrgY-16);
        if (messageCount <= 3)
        c.SetClip(32,h+32);
                if (messageCount > 3)
        c.SetClip(32,(14 * messagecount)+32);
        //TR
        c.SetPos(0,0);
        c.DrawTileClipped(texture'DeusExUI.HUDWindowBackground_TR',30,16, 1,0,31,16);
        //R
        c.SetPos(0,16);
        if (messageCount <= 3)
                c.DrawTileClipped(texture'DeusExUI.HUDWindowBackground_Right',30,h, 1,0,31,8);
        if (messageCount > 3)
        c.DrawTileClipped(texture'DeusExUI.HUDWindowBackground_Right',30,(14 * messagecount), 1,0,31,8);
        //BR
        c.SetPos(0, c.ClipY-16);
        c.DrawTileClipped(texture'DeusExUI.HUDWindowBackground_BR',30,16, 1,0,31,16);

        c.SetOrigin(int((c.SizeX-w)/2), int(h));
        c.SetClip(w, h);

        // Рамки

   if (DeusExPlayer(Level.GetLocalPlayerController().pawn).bHUDBordersVisible)
   {
     if (DeusExPlayer(Level.GetLocalPlayerController().pawn).bHUDBordersTranslucent)
        c.Style = ERenderStyle.STY_Translucent;
        else
        c.Style = ERenderStyle.STY_Alpha;

        if (messageCount > 3)
        c.SetClip(w, (14 * messagecount));
        if (messageCount <= 3)
        c.SetClip(w, h);

        //c.Style=ERenderStyle.STY_Translucent;
        // Рамка
        c.DrawColor = MessageFrame;

        c.SetPos(-14,-16);
        border = texture'DeusExUI.HUDWindowBorder_TL';
        c.DrawTile(border,64,16, 0,0,64,16);

        c.SetPos(-14,0);
        border = texture'DeusExUI.HUDWindowBorder_Left';
        if (messageCount > 3)
        c.DrawTile(border,64,(14 * messagecount), 0,0,64,8);
                if (messageCount <= 3)
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
        if (messageCount <= 3)
        c.DrawTileStretched(border,32,h);
        if (messageCount > 3)
        c.DrawTileStretched(border,32,(14 * messagecount));

        c.SetPos(c.ClipX-3, c.ClipY);
        border = texture'DeusExUI.HUDWindowBorder_BR';
        c.DrawIcon(border,1.0);
   }

        // Иконка сообщения
        c.Style=ERenderStyle.STY_Normal;
        c.SetPos(3, 3);
        c.SetDrawColor(255,255,255);
        border = texture'DeusExUI.LogIcon';
        c.DrawIcon(border,1.0);


        c.Style=ERenderStyle.STY_Normal;
        c.SetOrigin(int((c.SizeX-w)/2), int(h));
        c.SetClip(w, h);

        c.SetPos(40,0); //x,y

            for(i=0; i<MessageCount; i++)
            {
                if (TextMessages[i].Text == "")
            break;
                //c.SetDrawColor(255,255,255);
                // Текст
                c.DrawColor = MessageText;
                dxc.DrawText(TextMessages[i].Text); // текст
                c.SetPos(c.CurX, c.CurY);
            c.SetClip(w, h+=22);
            }

  c.reset();
  c.SetClip(c.SizeX, c.SizeY);
  }
}

function RenderDebugInfo(Canvas c)
{
    local Actor target;
    local vector StartTrace, EndTrace, HitLoc, HitNormal;
    local DXRAiController control;

    c.DrawColor = WhiteColor; 
    c.Font = font'DXFonts.EU_10';
//    c.SetPos(150,150);
//    c.DrawText(TestUkr_String);

    c.Font = font'DXFonts.EU_9';
    c.DrawColor = GoldColor; 


    StartTrace = PlayerOwner.pawn.Location;
    EndTrace = PlayerOwner.pawn.Location + (Vector(PlayerOwner.pawn.GetViewRotation()) * DebugTraceDist);
    StartTrace.Z += PlayerOwner.pawn.BaseEyeHeight - 5;
    EndTrace.Z += PlayerOwner.pawn.BaseEyeHeight - 5;

    c.SetPos(c.SizeX/3, c.SizeY/3);
    foreach TraceActors(class'Actor', target, HitLoc, HitNormal, EndTrace, StartTrace)
    {
       c.SetPos(c.SizeX/3, c.CurY);
       if ((target != none) && (target.isA('pawn')))
       {
         control = DXRAiController(Pawn(Target).Controller);
          if (control != none)
          {
             c.DrawText(target $ " controller in state "$pawn(target).controller.GetStateName()$" ");
             c.SetPos(c.SizeX/3, c.CurY);
             c.DrawText("HasNextState()? "$DXRAiController(pawn(target).controller).HasNextState()$" bInterruptState? "$ScriptedPawn(target).bInterruptState);
             c.DrawColor = WhiteColor;
          }

          if (ScriptedPawn(target) != none)
          {
             c.SetPos(c.SizeX/3, c.CurY);
             switch (ScriptedPawn(target).TurnDirection)
             {
               case TURNING_Right:
               c.DrawText("TurnDirection = _яяTURNING_Right");
               break;

               case TURNING_Left:
               c.DrawText("TurnDirection = _яяTURNING_Left");
               break;

               case TURNING_None:
               c.DrawText("TurnDirection = _яяTURNING_None");
               break;
             }
            // $ 
//            c.DrawText("я EnemyTimer = " $ ScriptedPawn(target).EnemyTimer $ ", PotentialEnemyTimer = " $ ScriptedPawn(target).PotentialEnemyTimer $
//                           ", AiVisibility = " $ class'DeusExPawn'.static.AiVisibility(ScriptedPawn(target), false) $ 
//                           ", AICanSeeActor = " $ ScriptedPawn(target).AICanSeeActor $ 
//                           ", Enemy = "$ScriptedPawn(target).Controller.Enemy);

//            c.DrawText("я ActorAvoiding = "$ScriptedPawn(target).ActorAvoiding @ "AvoidWallTimer = "$ ScriptedPawn(target).AvoidWallTimer @ 
//                       "AvoidBumpTimer = "$ ScriptedPawn(target).AvoidBumpTimer @ "ObstacleTimer = "$ScriptedPawn(target).ObstacleTimer);
          }

       }
       else
       {
         c.SetPos(c.SizeX/3, c.CurY);
         c.DrawText(target $ " in state "$target.GetStateName());
         //c.SetPos(c.SizeX/3, c.CurY);
         //c.DrawText(target $ " StandingCount() = "$target.StandingCount());
       }
    }
    c.DrawColor = WhiteColor;
    if (Human(PlayerOwner.pawn).CarriedDecoration != none)
    {
      c.SetPos(c.SizeX/3, c.CurY);
      c.DrawText("CarriedDecoration + location = "$Human(PlayerOwner.pawn).CarriedDecoration @ Human(PlayerOwner.pawn).CarriedDecoration.location);
    }
    c.SetPos(c.SizeX/3, c.CurY);
    c.DrawText("BaseEyeHeight:"$PlayerOwner.pawn.BaseEyeHeight);
    c.SetPos(c.SizeX/3, c.CurY);
    c.DrawText("InHand:"$DeusExPlayer(PlayerOwner.pawn).InHand);
    c.SetPos(c.SizeX/3, c.CurY);
    c.DrawText("bDuck ? "$PlayerOwner.bDuck$ "    bForceDuck ? "$Human(playerOwner.Pawn).bForceDuck $" StandingCount = "$ PlayerOwner.pawn.StandingCount());
    c.SetPos(c.SizeX/3, c.CurY);
    c.DrawText("__ "$DebugConString2);

    c.SetPos(c.SizeX/3, c.CurY);
    vis = class'DeusExPawn'.static.AiVisibility(PlayerOwner.Pawn, false);
    c.DrawText(" AIVisibility = " $ vis);

    c.SetPos(c.SizeX/5, c.CurY);
    c.DrawText(PlayerOwner.Location @ PlayerOwner.Pawn.Location);

    c.SetPos(c.SizeX/3, c.CurY);
    c.DrawText(DebugConString);
      if (DeusExPlayer(playerOwner.pawn).conPlay != none)
      {
        c.SetPos(c.SizeX/3, c.CurY);
        c.DrawText(DeusExPlayer(playerOwner.pawn).conPlay.currentEvent);
      }
}

function DrawDamagedIndicator(canvas u)
{

}

event Timer()
{
   cubeMapMode = false;
}

function SafeRestore()
{
    SetTimer(0.5,false);
}


// convert to meters (by Kaiser)
//dist = int(vsize(TCP.Location-wpTarget.Location)/52);
// Вид из бинокля: расстояние до цели.
function DrawBinocularsView(Pawn Target, Canvas C)
{
    local String str;
    local float boxCX, boxCY;
    local float x, y, w, h, mult;
    local vector sp1, EyePos;

    if (Target != None)
    {
    c.Font = font'DXFonts.EU_9';
        mult = VSize(Target.Location - Playerowner.pawn.Location);
        str = msgRange @ (mult/52) @ strMeters;

        EyePos = Human(Playerowner.pawn).Location;
    EyePos.Z += Human(Playerowner.pawn).EyeHeight;

    // Расстояние до Pawn
        sp1 = C.WorldToScreen(Target.Location);
        boxCX = sp1.X;
        boxCY = sp1.Y;

        c.TextSize(str, w, h);
        x = boxCX - w/2;
        y = boxCY - h;
        c.DrawColor = RedColor;

        c.SetPos(x,y);
    c.Style=ERenderStyle.STY_Normal;
        c.DrawText(str);

        c.SetPos(x-4,y-4);
    c.Style=ERenderStyle.STY_Translucent;
        c.drawTileStretched(texture'ItemNameBox', w+4,h+4);
    }
    c.reset();
}

function RenderBinoculars(Canvas C)
{
  local ScriptedPawn target;
  local texture bg, cr;

  bg = texture'HUDBinocularView';
  cr = texture'HUDBinocularCrossHair';

  if (playerOwner.pawn != none)
  {

    C.ColorModulate.X = 2;
    C.ColorModulate.Y = 2;
    C.ColorModulate.Z = 2;
      C.ColorModulate.W = 2;

    // Вид из бинокля...
    c.setPos(c.sizeX / 2 - 512,c.sizeY / 2 - 256);
    c.Style=ERenderStyle.STY_Modulated;
    c.DrawTileJustified(bg, 1, 1024, 512); // 0 = left/top, 1 = center, 2 = right/bottom 
    c.Style=ERenderStyle.STY_Normal;

    c.SetDrawColor(0,255,25,255);// Green crosshair
    c.DrawTileJustified(cr, 1, 1024, 512); 

    // Заполнители
    c.Style=ERenderStyle.STY_Normal;
    c.DrawColor=blackColor;

    c.SetPos(0,0); // верхний
    c.DrawTileStretched(texture'solid', c.sizeX, (c.sizeY / 2) - 256);

    c.SetPos(0,(c.sizeY / 2) + 256); // Нижний заполнитель...
    c.DrawTileStretched(texture'solid', c.sizeX, c.sizeY );

    c.SetPos(0,(c.sizeY /2) - 256); // Левый заполнитель...
    c.DrawTileStretched(texture'solid', (c.sizeX / 2) - 512, (c.sizeY / 2) + 152);

    c.SetPos((c.SizeX / 2) + 512,(c.sizeY /2) - 256); // Правый заполнитель...
    c.DrawTileStretched(texture'solid', (c.sizeX / 2) - 512, (c.sizeY / 2) + 152);

                                  
   foreach playerOwner.pawn.VisibleCollidingActors(class'ScriptedPawn', target, BinocularsMaxRange, playerOwner.pawn.Location + vector(PlayerOwner.pawn.GetViewRotation()))
   {
     DrawBinocularsView(target,C);
   }
  }
}

function renderScopeView(canvas u)
{
  local texture bg, cr;

  bg = texture'HUDScopeView';
  cr = texture'HUDScopeCrosshair';

  if (playerOwner.pawn != none)
  {
    u.ColorModulate.X = 4;
    u.ColorModulate.Y = 4;
    u.ColorModulate.Z = 4;
      u.ColorModulate.W = 4;

    // Вид из прицела...
    u.SetDrawColor(255,255,255,255);
    u.setPos(u.sizeX / 2 - 256,u.sizeY / 2 - 256);
    u.Style = ERenderStyle.STY_Modulated;
    u.DrawTileJustified(bg, 1, 512, 512); // 0 = left/top, 1 = center, 2 = right/bottom 
    u.Style = ERenderStyle.STY_Normal;
    u.SetDrawColor(255,255,255,255);
    u.DrawTileJustified(cr, 1, 512, 512); // 0 = left/top, 1 = center, 2 = right/bottom 

    // Заполнители
    u.Style=ERenderStyle.STY_Normal;
    u.DrawColor=blackColor;

    u.SetPos(0,0); // верхний
    u.DrawTileStretched(texture'solid', u.sizeX, (u.sizeY / 2) - 256);

    u.SetPos(0,(u.sizeY / 2) + 256); // Нижний заполнитель...
    u.DrawTileStretched(texture'solid', u.sizeX, u.sizeY );

    u.SetPos(0,(u.sizeY /2) - 256); // Левый заполнитель...
    u.DrawTileStretched(texture'solid', (u.sizeX / 2) - 256, (u.sizeY / 2) + 152);

    u.SetPos((u.SizeX / 2) + 256,(u.sizeY /2) - 256); // Правый заполнитель...
    u.DrawTileStretched(texture'solid', (u.sizeX / 2) - 256, (u.sizeY / 2) + 152);
  }
}

/*---------------------------------------------------------------------------*/

function PlayerPawn GetPlayer()
{
   return PlayerPawn(level.GetLocalPlayerController().pawn);
}

function bool IsValidPos(int pos)
{
    // Don't allow NanoKeySlot to be used
    if ((pos >= 0) && (pos < 10))
        return true;
    else
        return false;
}

function ClearPosition(int pos)
{
    if (IsValidPos(pos))
        GetPlayer().objects[pos] = None;
}

exec function ClearBelt()
{
    local int beltPos;
                //0
    for(beltPos=1; beltPos<10; beltPos++)
        ClearPosition(beltPos);
}

function RemoveObjectFromBelt(Inventory item)
{
   local int i;
   local int StartPos;

   StartPos = 1;

   if (GetPlayer() == None)
   return;

    for (i=StartPos; IsValidPos(i); i++)
    {
        if (GetPlayer().objects[i] == item)
        {
            GetPlayer().objects[i] = None;
            if (item.IsA('RuntimePickup'))
            {
                RuntimePickup(item).bInObjectBelt = false;
                RuntimePickup(item).beltPos = -1;
            }
            if (item.IsA('RuntimeWeapon'))
            {
                RuntimeWeapon(item).bInObjectBelt = false;
                RuntimeWeapon(item).beltPos = -1;
            }
            break;
        }
    }
}

function bool AddObjectToBelt(Inventory newItem, int pos, bool bOverride)
{
    local int  i;
    local bool retval;

    retval = true;

    if ((newItem != None) && (newItem.GetIcon() != None))
    {
        // If this is the NanoKeyRing, force it into slot 0
        if (newItem.IsA('NanoKeyRing'))
        {
            ClearPosition(0);
            pos = 0;
        }

        if (!IsValidPos(pos))
        {
         for (i=1; IsValidPos(i); i++)
            if (GetPlayer().objects[i] == None)
                    break;

            if (!IsValidPos(i))
            {
                if (bOverride)
                    pos = 1;
            }
            else
            {
                pos = i;
            }
        }

        if (IsValidPos(pos))
        {
            // If there's already an object here, remove it
            if (GetPlayer().objects[pos] != None)
                RemoveObjectFromBelt(GetPlayer().objects[pos]);

            GetPlayer().objects[pos] = newItem;
        }
        else
        {
            retval = false;
        }
    }
    else
        retval = false;

    // The inventory item needs to know it's in the object
    // belt, as well as the location inside the belt.  This is used
    // when traveling to a new map.

    if ((retVal) && (PlayerOwner.Pawn.Role == ROLE_Authority))
    {
       if (newItem.IsA('RuntimeWeapon'))
       {
          RuntimeWeapon(newItem).bInObjectBelt = true;
          RuntimeWeapon(newItem).beltPos = pos;
       }
       if (newItem.IsA('RuntimePickup'))
       {
          RuntimePickup(newItem).bInObjectBelt = true;
          RuntimePickup(newItem).beltPos = pos;
       }

    }

    //UpdateInHand();

    return (retval);
}

// ----------------------------------------------------------------------
// Adds an item to the object belt.  There are several types of 
// items that should *NOT* get added to the object belt, we'll 
// check for those here.
// ----------------------------------------------------------------------
function AddInventory(inventory item)
{
    if ((item != None) && !item.IsA('DataVaultImage'))
         AddObjectToBelt(item, -1, false);
}

function DeleteInventory(inventory item)
{
    if (item != None)
        RemoveObjectFromBelt(item);
}

// ----------------------------------------------------------------------
// Looks through the player's inventory and rebuilds the object belt
// based on the inventory items.  This needs to be done after a load
// game
// ----------------------------------------------------------------------
exec function PopulateBelt()
{
    local Inventory anItem;
    local DeusExPlayer myPlayer;

    // Get a pointer to the player
    myPlayer = DeusExPlayer(PlayerOwner.Pawn);

    for (anItem=myPlayer.Inventory; anItem!=None; anItem=anItem.Inventory)
    {
        if (anItem.IsA('RuntimePickup'))
          if (RuntimePickup(anItem).bInObjectBelt)
            AddObjectToBelt(anItem, RuntimePickup(anItem).beltPos, True);

        if (anItem.IsA('RuntimeWeapon'))
          if (RuntimeWeapon(anItem).bInObjectBelt)
            AddObjectToBelt(anItem, RuntimeWeapon(anItem).beltPos, True);
    }
}

function bool ActivateObjectInBelt(int pos)
{
    local Inventory item;
    local DeusExPlayer myPlayer;
    local bool retval;

    retval = false;

    item = GetObjectFromBelt(pos);
    myPlayer = DeusExPlayer(PlayerOwner.pawn);
    if (myPlayer != None)
    {
       // if the object is an ammo box, load the correct ammo into
       // the gun if it is the current weapon
//       if ((item != None) && item.IsA('Ammo') && (player.Weapon != None))
//            DeusExWeapon(player.Weapon).LoadAmmoType(Ammo(item));
//       else
//       {
          myPlayer.PutInHand(item);
          if (item != None)
          retval = true;
//       }
    }
    return retval;
}

function Inventory GetObjectFromBelt(int pos)
{
    if (IsValidPos(pos))
        return (GetPlayer().objects[pos]);
    else
        return (None);
}


function RenderToolBelt(Canvas C)
{
   local float holdX, holdY, w, h;
   local int beltIt;
   local SkilledTool sitem;

   if ((playerowner.Pawn == None) || (DeusExPlayer(playerowner.Pawn).bObjectBeltVisible == false))
       return;

   if (dxc != none)
       dxc.SetCanvas(C);

    c.Font=Font'DXFonts.DPix_6';

    c.DrawColor = ToolBeltBG;//(127,127,127);
    c.SetPos(C.SizeX-544,C.SizeY-62);

    if (DeusExPlayer(playerowner.pawn).bHUDBackgroundTranslucent)
        c.Style = ERenderStyle.STY_Translucent;
            else
        c.Style = ERenderStyle.STY_Normal;
    C.DrawIcon(Texture'HUDObjectBeltBackground_Left',1.0);

    C.SetPos(C.CurX-7,C.CurY);

    for(beltIt=1; beltIt<10; beltIt++)
    {
        holdX = C.CurX;
        holdY = C.CurY;

        c.Font=Font'DXFonts.DPix_6';
        c.DrawColor = ToolBeltBG;
        if (DeusExPlayer(playerowner.pawn).bHUDBackgroundTranslucent)
            c.Style = ERenderStyle.STY_Translucent;
               else
            c.Style = ERenderStyle.STY_Normal;
        C.DrawIcon(Texture'HUDObjectBeltBackground_Cell',1.0);
        C.SetPos(C.CurX-13,C.CurY);

        if ((GetPlayer().Objects[beltIt] != none) && GetPlayer().Objects[beltIt].bInObjectBelt)
        {
            if (GetPlayer().Objects[beltIt].IsA('DeusExWeapon'))
            {
               c.SetDrawColor(255,255,255);
               C.Style = ERenderStyle.STY_Masked;
               C.SetPos(holdX,holdY+3);
               C.DrawIcon(DeusExWeapon(GetPlayer().Objects[beltIt]).Icon,1.0);
               c.DrawColor = ToolBeltText;

               w = C.CurX;
               h = C.CurY-3;

//                  c.Font=Font'DXFonts.FontTiny';
               c.DrawTextJustified(DeusExWeapon(GetPlayer().Objects[beltIt]).beltDescription,1,holdX+1,holdY+43,holdX+43,holdY+53);

               C.SetPos(w-13,h);
 //                 c.Font=Font'DXFonts.FontMenuSmall_DS';
            }
            if (GetPlayer().Objects[beltIt].IsA('SkilledTool'))
            {
                c.SetDrawColor(255,255,255);
                C.Style = ERenderStyle.STY_Masked;
                C.SetPos(holdX,holdY+3);
                        //SkilledTool(p.belt[beltIt]).Icon.bMasked=true;
                C.DrawIconEx(SkilledTool(GetPlayer().Objects[beltIt]).Icon,1.0);
                c.DrawColor = ToolBeltText; //

                w = C.CurX;
                h = C.CurY-3;
//                  c.Font=Font'DXFonts.FontTiny';
                c.DrawTextJustified(SkilledTool(GetPlayer().Objects[beltIt]).beltDescription,1,holdX+1,holdY+43,holdX+43,holdY+53);
                C.SetPos(w-13,h);
//                  c.Font=Font'DXFonts.FontMenuSmall_DS';
            }
            if (GetPlayer().Objects[beltIt].IsA('DeusExPickup'))
            {
                c.SetDrawColor(255,255,255);
                C.Style = ERenderStyle.STY_Masked;
                C.SetPos(holdX,holdY+3);
                        //DeusExPickup(p.belt[beltIt]).Icon.bMasked=true;
                C.DrawIconEx(DeusExPickup(GetPlayer().Objects[beltIt]).Icon,1.0);
                c.DrawColor = ToolBeltText; //

                w = C.CurX;
                h = C.CurY-3;

                    //c.Font=Font'DXFonts.FontTiny';
//                  c.Font=Font'DXFonts.EUX_7';
                c.DrawTextJustified(DeusExPickup(GetPlayer().Objects[beltIt]).beltDescription,1,holdX+1,holdY+43,holdX+43,holdY+53);

                if (DeusExPickup(GetPlayer().Objects[beltIt]).CanHaveMultipleCopies())
                    dxc.DrawTextJustified(strUses $ DeusExPickup(GetPlayer().Objects[beltIt]).NumCopies, 1, holdX, holdY+35, holdX+42, holdY+41);

                C.SetPos(w-13,h);
//                  c.Font=Font'DXFonts.FontMenuSmall_DS';
            }
        }
         c.DrawColor = ToolBeltText;
         C.Style = 1;
         c.SetPos(holdX, holdY);
         c.Font = font'DPix_7'; //
         dxc.DrawTextJustified(string(beltIt), 2, holdX, holdY+2, holdX+42, holdY+13);

        sitem = SkilledTool(GetPlayer().Objects[beltIt]);
        if((sitem != none) && (!sitem.isA('NanoKeyRing')))
        {
            dxc.DrawTextJustified(strUses $ sitem.NumCopies, 1, holdX, holdY+35, holdX+42, holdY+41);
        }
        c.SetPos(holdX+51, holdY);
    }

    c.Font=Font'DXFonts.DPix_7';

   if (DeusExPlayer(playerowner.pawn).bHUDBackgroundTranslucent)
       c.Style = ERenderStyle.STY_Translucent;
          else
       c.Style = ERenderStyle.STY_Normal;

    c.DrawColor = ToolBeltBG;
    C.DrawIcon(Texture'HUDObjectBeltBackground_Cell',1.0);
    C.SetPos(C.CurX-13,C.CurY);
    C.DrawIcon(Texture'HUDObjectBeltBackground_Right',1.0);
//    c.SetPos(holdX, holdY);

    if ((GetPlayer().Objects[0] != none) && (GetPlayer().Objects[0].IsA('NanoKeyRing')))
    {
        c.SetPos(holdX + 51, holdY);
        C.Style = ERenderStyle.STY_Normal;
        c.DrawColor = ToolBeltText;
        c.DrawTextJustified(GetPlayer().Objects[0].GetbeltDescription(),1,holdX+1,holdY+43,holdX+150,holdY+53);
//        c.DrawTextJustified(p.belt[0].GetbeltDescription(),1,holdX+1,holdY+43,holdX+43,holdY+53);

        c.SetPos(holdX + 51, holdY);
        c.SetDrawColor(255,255,255);
        c.DrawIcon(GetPlayer().Objects[0].GetIcon(), 1);
        c.DrawColor = ToolBeltText;
        dxc.DrawTextJustified("0", 2, holdX, holdY+2, holdX+94, holdY+13);
    }

    if (DeusExPlayer(Level.GetLocalPlayerController().pawn).bHUDBordersVisible)
    {
      if (DeusExPlayer(Level.GetLocalPlayerController().pawn).bHUDBordersTranslucent)
          c.Style = ERenderStyle.STY_Translucent;
            else
          c.Style = ERenderStyle.STY_Alpha;

          C.SetPos(C.SizeX-544,C.SizeY-68);
          c.DrawColor = ToolBeltFrame;
          C.DrawIcon(Texture'HUDObjectBeltBorder_1',1.0);
          C.DrawIcon(Texture'HUDObjectBeltBorder_2',1.0);
          C.DrawIcon(Texture'HUDObjectBeltBorder_3',1.0);
    }

  c.ReSet();
  renderToolBeltSelection(c);
}

function renderToolBeltSelection(canvas u)
{
  local DeusExPlayer p;

  p=Human(PlayerOwner.Pawn);
  if (p == none) // || (p.InHand == none));
      return;

  if (p.inHand != none)
  {
   u.DrawColor = ToolBeltHighlight;
   if (p.InHand == P.Objects[1])
   {
     u.SetPos(u.SizeX-toolbeltSelPos[1].positionX,u.SizeY-toolbeltSelPos[1].positionY);
     u.DrawTileStretched(texture'WhiteBorder', 48, 54);
   }
   else if (p.InHand == P.Objects[2])
   {
     u.SetPos(u.SizeX-toolbeltSelPos[2].positionX,u.SizeY-toolbeltSelPos[2].positionY);
     u.DrawTileStretched(texture'WhiteBorder', 48, 54);
   }
   else if (p.InHand == P.Objects[3])
   {
     u.SetPos(u.SizeX-toolbeltSelPos[3].positionX,u.SizeY-toolbeltSelPos[3].positionY);
     u.DrawTileStretched(texture'WhiteBorder', 48, 54);
   }
   else if (p.InHand == P.Objects[4])
   {
     u.SetPos(u.SizeX-toolbeltSelPos[4].positionX,u.SizeY-toolbeltSelPos[4].positionY);
     u.DrawTileStretched(texture'WhiteBorder', 48, 54);
   }
   else if (p.InHand == P.Objects[5])
   {
     u.SetPos(u.SizeX-toolbeltSelPos[5].positionX,u.SizeY-toolbeltSelPos[5].positionY);
     u.DrawTileStretched(texture'WhiteBorder', 48, 54);
   }
   else if (p.InHand == P.Objects[6])
   {
     u.SetPos(u.SizeX-toolbeltSelPos[6].positionX,u.SizeY-toolbeltSelPos[6].positionY);
     u.DrawTileStretched(texture'WhiteBorder', 48, 54);
   }
   else if (p.InHand == P.Objects[7])
   {
     u.SetPos(u.SizeX-toolbeltSelPos[7].positionX,u.SizeY-toolbeltSelPos[7].positionY);
     u.DrawTileStretched(texture'WhiteBorder', 48, 54);
   }
   else if (p.InHand == P.Objects[8])
   {
     u.SetPos(u.SizeX-toolbeltSelPos[8].positionX,u.SizeY-toolbeltSelPos[8].positionY);
     u.DrawTileStretched(texture'WhiteBorder', 48, 54);
   }
   else if (p.InHand == P.Objects[9])
   {
     u.SetPos(u.SizeX-toolbeltSelPos[9].positionX,u.SizeY-toolbeltSelPos[9].positionY);
     u.DrawTileStretched(texture'WhiteBorder', 48, 54);
   }
   else if (p.InHand == P.Objects[0]) // NanoKeyRing
   {
     u.SetPos(u.SizeX-toolbeltSelPos[0].positionX,u.SizeY-toolbeltSelPos[0].positionY);
     u.DrawTileStretched(texture'WhiteBorder', 48, 54);
   }
  }
}

/* Radar (перемещено из оверлея) -----------------------------------------------------------------*/
function DrawRadarCircle(canvas u)
{
    local float RadarWidth;

    RadarScale = default.RadarScale * HUDScale;
    RadarWidth = 0.5 * RadarScale * u.ClipX;

    u.Style = ERenderStyle.STY_Alpha;
    u.DrawColor = class'HUD'.default.GrayColor;

    u.SetPos(RadarPosX * u.ClipX - RadarWidth, RadarPosY * u.ClipY + RadarWidth);
    u.DrawTile(RadarBackground, RadarWidth, RadarWidth, 0, 512, 512, -512);

    u.SetPos(RadarPosX * u.ClipX,RadarPosY * u.ClipY + RadarWidth);
    u.DrawTile(RadarBackground, RadarWidth, RadarWidth, 512, 512, -512, -512);

    u.SetPos(RadarPosX * u.ClipX - RadarWidth,RadarPosY * u.ClipY);
    u.DrawTile(RadarBackground, RadarWidth, RadarWidth, 0, 0, 512, 512);

    u.SetPos(RadarPosX * u.ClipX,RadarPosY * u.ClipY);
    u.DrawTile(RadarBackground, RadarWidth, RadarWidth, 512, 0, -512, 512);
}

function DrawRadar(canvas u)
{
    local ScriptedPawn P;
    local float Dist, MaxDist, RadarWidth,Angle,DotSize,OffsetY,OffsetScale;
    local rotator Dir;
    local vector Start;
    local int DistB;
    local float AIvis;
    
    RadarWidth = 0.5 * RadarScale * u.ClipX;
    DotSize = 8 * u.ClipX * HUDScale/1600;
    if (PawnOwner == None)
        Start = PlayerOwner.Location;
    else
        Start = PawnOwner.Location;
    
    MaxDist = 3000;
    u.Style = ERenderStyle.STY_Masked;
    OffsetY = RadarPosY + RadarWidth/u.ClipY;
    MinEnemyDist = 3000;
    foreach DynamicActors(class'ScriptedPawn',P)
        if ((P.Health > 0) && (P.bInWorld == true) && (P.bAmbientCreature == false))
        {
            Dist = VSize(Start - P.Location);

            AIvis = class'DeusExPawn'.static.AiVisibility(P, false);
            if (Dist < 3000)
            {
                if (P != None)
                {
                  if (P.GetAllianceType((DeusExPawn(pawnOwner).Alliance)) == ALLIANCE_Hostile)
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

                if (PawnOwner == None)
                    Angle = ((Dir.Yaw - PlayerOwner.Rotation.Yaw) & 65535) * 6.2832/65536;
                else
                    Angle = ((Dir.Yaw - PawnOwner.Rotation.Yaw) & 65535) * 6.2832/65536;

                u.SetPos(RadarPosX * u.ClipX + OffsetScale * u.ClipX * sin(Angle) - 0.5 * DotSize, 
                         OffsetY * u.ClipY - OffsetScale * u.ClipX * cos(Angle) - 0.5 * DotSize);

                DistB = abs(PawnOwner.Location.Z - P.Location.Z) - abs(PawnOwner.default.CollisionHeight - PawnOwner.CollisionHeight);
                if (abs(DistB) >= 0 && abs(DistB) < 60) // Same
                    u.DrawTile(Material'CheckboxOff',DotSize,DotSize,0,0,8,8);
                else 
                    if (DistB > 61) // Below or above
                        u.DrawTile(Material'RadarSquare',DotSize,DotSize,0,0,8,8);
            }
        }
}

event Destroyed()
{
    log(self@"has been destroyed()");
}






defaultproperties
{
    RadarScale=0.20
    RadarPosX=0.840
    RadarPosY=0.540

    RadarBackground=Texture'UT2k4Extra.RadarQ'

    BinocularsMaxRange=2000
    strMeters="meters"

    MessageBG=(R=139,G=105,B=35,A=255)   // ClientMessage Background
    MessageText=(R=255,G=255,B=255,A=255) // ClientMessage Text
    MessageFrame=(R=185,G=177,B=140,A=255) // ClientMessage frame

    ToolBeltBG=(R=139,G=105,B=35,A=255)
    ToolBeltText=(R=255,G=255,B=255,A=255)
    ToolBeltFrame=(R=185,G=177,B=140,A=255)

    AugsBeltBG=(R=139,G=105,B=35,A=255)
    AugsBeltText=(R=255,G=255,B=255,A=255)
    AugsBeltFrame=(R=185,G=177,B=140,A=255)
    AugsBeltActive=(R=0,G=233,B=177,A=255)
    AugsBeltInActive=(R=100,G=100,B=100,A=255)

    AmmoDisplayBG=(R=139,G=105,B=35,A=255)
    AmmoDisplayFrame=(R=185,G=177,B=140,A=255)

    compassBG=(R=139,G=105,B=35,A=255)
    compassFrame=(R=185,G=177,B=140,A=255)

    HealthBG=(R=139,G=105,B=35,A=255)
    HealthFrame=(R=185,G=177,B=140,A=255)

    BooksBG=(R=139,G=105,B=35,A=255)
    BooksText=(R=255,G=255,B=255,A=255)
    BooksFrame=(R=185,G=177,B=140,A=255)

    InfoLinkBG=(R=139,G=105,B=35,A=255)
    InfoLinkText=(R=255,G=255,B=255,A=255)
    InfoLinkTitles=(R=255,G=233,B=177,A=255)
    InfoLinkFrame=(R=185,G=177,B=140,A=255)

    TestUkr_String="А а Б б В в Г г Ґ ґ Д д Е е Є є Ж ж З з И и І і Ї ї Й й К к Л л М м Н н О о П п Р р С с Т т У у Ф ф Х х Ц ц Ч ч Ш ш Щ щ Ь ь Ю ю Я я"
}

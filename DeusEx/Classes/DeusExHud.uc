//========================================//
// DeusExHUD - Графический дисплей игрока //
//========================================//

class DeusExHUD extends MouseHUD;

const DebugTraceDist = 512; //256;

var localized string strMeters;
var bool bUseCameraTrick; // Как бы ЭТО назвать...
var int BinocularsMaxRange;
var() bool bUseBinocularView;

var transient bool bConversationInvokeRadius;
var transient string DebugConString, DebugConString2;

var bool bRenderMover;

var DeusExMover dxMover;

function SetInitialState()
{
   LoadColorTheme();

  foreach AllActors(class'DeusExMover', DxMover)
  break;

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
}

event PostLoadSavedGame()
{
  if (dxc == none)
  	dxc = new(none) class'DxCanvas';
}

simulated event PostRender(canvas C)
{
	//if (PlayerOwner.pawn == none)
//	return;

	super.postrender(C);

	if (PlayerOwner.pawn == none)
	    return;

//	TrackActors(C);

	if (DeusExPlayer(PlayerOwner.Pawn).bExtraDebugInfo)
	RenderDebugInfo(C);

  if (bUseBinocularView)
  {
    RenderBinoculars(C);
  }
  if ((DeusExWeaponInv(PlayerOwner.pawn.Weapon) != none) && (DeusExWeaponInv(PlayerOwner.pawn.Weapon).bZoomed))
      renderScopeView(C);

  if (bRenderMover)
     RenderMover(C);
}

/*- Адаптация из ActorDisplayWindow ----------------------*/
final function RenderMover(Canvas C)
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
}


function DrawLineA(Canvas c, vector point1, vector point2)
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

//	if (ConvertVectorToCoordinates(point1, fromX, fromY) && ConvertVectorToCoordinates(point2, toX, toY))
//	{
    c.Style=ERenderStyle.STY_Normal;

		c.SetDrawColor(255, 0, 0);
		DrawPoint(c, fromX, fromY);
		DrawPoint(c, toX, toY);

		c.SetDrawColor(128, 0, 128);
		Interpolate(c, fromX, fromY, toX, toY, 8);
//	}
}


exec function rmover()
{
  bRenderMover =!bRenderMover;
}


function TrackActors(Canvas C)
{
	local /*DeusExDecoration*/ actor Tdeco;
//	local pawn Tpawn;

	if ((PlayerOwner.pawn != none) && (bUseCameraTrick))// && (Level.TimeSeconds % 1.5 > 0.75))
	{
		foreach DynamicActors(class'actor', Tdeco)
		{
		 if (TDeco != none)
		 {
		    if ((AutoTurretGun(TDeco) != none) || (AutoTurret(TDeco) != none) || (SecurityCamera(TDeco) != none) || (AlarmLight(TDeco) != none))
//		       TDeco.LastRenderTime = Level.TimeSeconds;
//      if ((Tdeco.bStatic == false) && (Level.TimeSeconds - tDeco.LastRenderTime > 4) ||
//      (Tdeco.IsA('AutoTurretGun')) || (Tdeco.IsA('AutoTurret'))
//   || (Tdeco.IsA('SecurityCamera') || (Tdeco.IsA('AlarmLight'))))
//   || (tDeco.IsA('conplay'))))
      {
       //C.DrawActor(Tdeco, false, false, 0);
              C.DrawActor(Tdeco, true, true, 0);
      }                        /*wireframe, clearZ, angle*/
		 }
		}
	}
	else
	return;
}


simulated function DisplayMessages(Canvas C)
{
  local int i, j, /*XPos, YPos,*/ MessageCount;
	local float w,h;
	local texture border;//, ico;
//	local DxCanvas dxc;
//	local int x;

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

//        c.SetDrawColor(255,255,255);

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
          if (pawn(target).controller != none)
          {
             c.DrawText(target $ " controller in state "$pawn(target).controller.GetStateName()$", ");
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
               c.DrawText("TurnDirection = TURNING_Right");
               break;

               case TURNING_Left:
               c.DrawText("TurnDirection = TURNING_Left");
               break;

               case TURNING_None:
               c.DrawText("TurnDirection = TURNING_None");
               break;
             }
            
          }

       }
       else
       c.DrawText(target $ " in state "$target.GetStateName());
    }
    c.DrawColor = WhiteColor;
    c.SetPos(c.SizeX/3, c.CurY);
    c.DrawText("CrouchHeight:"$PlayerOwner.pawn.CrouchHeight);
    c.SetPos(c.SizeX/3, c.CurY);
    c.DrawText("BaseEyeHeight:"$PlayerOwner.pawn.BaseEyeHeight);
    c.SetPos(c.SizeX/3, c.CurY);
    c.DrawText("InHand:"$DeusExPlayer(PlayerOwner.pawn).InHand);
    c.SetPos(c.SizeX/3, c.CurY);
    c.DrawText("CheckConversationInvokeRadius ="$DebugConString2);
//    c.DrawText(MAXSTEPHEIGHT);
    c.SetPos(c.SizeX/3, c.CurY);
    c.DrawText(DebugConString);
      if (DeusExPlayer(playerOwner.pawn).conPlay != none)
      {
        c.SetPos(c.SizeX/3, c.CurY);
        c.DrawText(DeusExPlayer(playerOwner.pawn).conPlay.currentEvent);
      }
}

function Timer()
{
   cubeMapMode = false;
}

function SafeRestore()
{
	SetTimer( 0.5,false);
	Level.bPlayersOnly=false;
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


defaultproperties
{
	bUseCameraTrick=true
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
}

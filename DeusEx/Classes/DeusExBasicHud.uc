/*-------------------------------------------------------------------------------------------------------
  Базовый ГДИ. Все основные функции расположены здесь.
  Окно сообщений (перемещено в дочерний класс DeusExHUD)
  Прицел
  Выделение объекта
  Аугментации с интерфейсом

  Прорисовка через DrawHUD не используется, сначала нужно прорисовать
  все ауги, изменяющие цвет и т.д., и только потом собственно HUD.

  Примечание: настройки HUD в UT2004.ini на этот HUD не действуют!
  15/06/2017: функция GetColorScaled(float percent) добавлена в Core.u
  30/12/2017: Удалены ненужные функции и переменные.
  21/06/2018: Как мне реализовать цветовые темы ? :))) 
  11/07/2018: Исправлено растягивание перекрестия с оружием в руке.
  18/06/2020: Реализован индикатор повреждения (за основу взят код из GMDX)
  21/09/2020: Часть кода перенесена в DeusExPlayer (DrawHUD).
-------------------------------------------------------------------------------------------------------*/


#exec OBJ LOAD FILE=DeusExUIExtra
#exec OBJ LOAD FILE=DxFonts
#exec OBJ LOAD FILE=Effects
#EXEC OBJ LOAD FILE=GuiContent.utx

class DeusExBasicHUD extends HUD;

struct sToolBeltSelectedItem
{
  var() int positionX;
  var() int positionY;
};
var(toolbelt) sToolBeltSelectedItem toolbeltSelPos[10];

var(ThemeColors) color MessageBG;   // Фон сообщений
var(ThemeColors) color MessageText; // Текст сообщений
var(ThemeColors) color MessageFrame;

var(ThemeColors) color ToolBeltBG;
var(ThemeColors) color ToolBeltText;
var(ThemeColors) color ToolBeltFrame;
var(ThemeColors) color ToolBeltHighlight;

var(ThemeColors) color AugsBeltBG;
var(ThemeColors) color AugsBeltText;
var(ThemeColors) color AugsBeltFrame;
var(ThemeColors) color AugsBeltActive;
var(ThemeColors) color AugsBeltInActive;

var(ThemeColors) color AmmoDisplayBG;
var(ThemeColors) color AmmoDisplayFrame;

var(ThemeColors) color compassBG;
var(ThemeColors) color compassFrame;

var(ThemeColors) color HealthBG;
var(ThemeColors) color HealthFrame;

var(ThemeColors) color BooksBG;
var(ThemeColors) color BooksText;
var(ThemeColors) color BooksFrame;

var(ThemeColors) color InfoLinkBG;
var(ThemeColors) color InfoLinkText;
var(ThemeColors) color InfoLinkTitles;
var(ThemeColors) color InfoLinkFrame;

var(ThemeColors) color AIBarksBG;
var(ThemeColors) color AIBarksText;
var(ThemeColors) color AIBarksHeader;
var(ThemeColors) color AIBarksFrame;

var(ThemeColors) color FrobBoxColor;
var(ThemeColors) color FrobBoxShadow;
var(ThemeColors) color FrobBoxText;


var color colAmmoLowText, colAmmoText;
var Color crossColor; // цвет перекрестия

var transient DxCanvas dxc; // Transient для безопасности

// Из FrobDisplayWindow
var() float margin, marginX, corner;
var() float barLength;

// FrobDisplayWindow
var localized string msgLocked;
var localized string msgUnlocked;
var localized string msgLockStr;
var localized string msgDoorStr;
var localized string msgHackStr;
var localized string msgInf;
var localized string msgHacked;
var localized string msgPick;
var localized string msgPicks;
var localized string msgTool;
var localized string msgTools;

// AugmentationDisplayWindow
var localized String msgRange;
var localized String msgRangeUnits;
var localized String msgHigh;
var localized String msgMedium;
var localized String msgLow;
var localized String msgHealth;
var localized String msgOverall;
var localized String msgPercent;
var localized String msgHead;
var localized String msgTorso;
var localized String msgLeftArm;
var localized String msgRightArm;
var localized String msgLeftLeg;
var localized String msgRightLeg;
var localized String msgWeapon;
var localized String msgNone;
var localized String msgScanning1;
var localized String msgScanning2;
var localized String msgADSTracking;
var localized String msgADSDetonating;
var localized String msgBehind;
var localized String msgDroneActive;
var localized String msgEnergyLow;
var localized String msgCantLaunch;
var localized String msgLightAmpActive;
var localized String msgIRAmpActive;
var localized String msgNoImage;
var localized String msgDisabled;

// HUDAmmoDisplay
var localized String NotAvailable;
var localized String msgReloading;
var localized String AmmoLabel;
var localized String ClipsLabel;
var localized string strUses;

var(ChargedPickups) float HI_BorderX, HI_BorderY, HI_IconX, HI_IconY, HI_Back_X, HI_Back_Y;

var Color colHeaderText;
var Color colText;

var float CrosshairCorrectionX,CrosshairCorrectionY;
var texture CrosshairTex;
var texture HudHitBase, HudHitFrame, HudHitBody,HudHitArmL,  HudHitArmR,HudHitLegL, HudHitLegR,HudHitHead, HudHitTorso;
var material HitMarkerMat;
var material ItemNameBoxT;
var material INBox;

var float HHframeX, HHframeY, BodyX, BodyY, SHHframeX, SHHframeY, SBodyX, SBodyY;
var int ItemNameOffsetV, ItemNameOffSetH;
var int ItemNameFrameOffsetV, ItemNameFrameOffSetH;

var(FrobColoredBars) float TopBarOffset, LowerBarOffSet;
var float Health, HealthHead, HealthTorso, HealthLegLeft, HealthLegRight, HealthArmLeft, HealthArmRight;

var int bePosX,bePosY, o2PosX, o2PosY;
var int beBarPosX,beBarPosY, o2BarPosX,o2BarPosY;

var float   BioEnergy;
var float   BioEnergyMax;

var bool bGreenPoison, bGrayPoison, bDoubledPoisonEffect;

var bool bUnderwater;
var float breathPercent;
var float o2cr; // корректор индикатора кислорода

var bool cubemapmode, menuMode, midMenuMode;  // cubemapmode и menuMode отключают весь ГДИ, midMenuMode растягивает скриншот на фоне.

var bool bDrawInfo;
var bool bDrawCrossHair, bDrawHealth, bDrawFrobBox;

// Указатель на Север (Задается в DeusExLevelInfo (TrueNorth))
var Int mapNorth;

event PreBeginPlay()
{
   LoadSomeTextures();
   Super.PreBeginPlay();
}

function LoadSomeTextures()
{
   HudHitBase = texture(DynamicLoadObject("DeusExUi.UserInterface.HUDHitDisplayBackground_1", class'texture', false));
   HudHitFrame = texture(DynamicLoadObject("DeusExUi.UserInterface.HUDHitDisplayBorder_1", class'texture', false));
   HudHitBody = texture(DynamicLoadObject("DeusExUi.UserInterface.HUDHitDisplay_Body", class'texture', false));
   HudHitArmL = texture(DynamicLoadObject("DeusExUi.UserInterface.HUDHitDisplay_ArmLeft", class'texture', false));
   HudHitArmR = texture(DynamicLoadObject("DeusExUi.UserInterface.HUDHitDisplay_ArmRight", class'texture', false));
   HudHitLegL = texture(DynamicLoadObject("DeusExUi.UserInterface.HUDHitDisplay_LegLeft", class'texture', false));
   HudHitLegR = texture(DynamicLoadObject("DeusExUi.UserInterface.HUDHitDisplay_LegRight", class'texture', false));
   HudHitHead = texture(DynamicLoadObject("DeusExUi.UserInterface.HUDHitDisplay_Head", class'texture', false));
   HudHitTorso = texture(DynamicLoadObject("DeusExUi.UserInterface.HUDHitDisplay_Torso", class'texture', false));

   HitMarkerMat = Material(DynamicLoadObject("DeusExUIExtra.HUD.HitMarker_TXR", class'Material', false));
   INBox = Material(DynamicLoadObject("DeusExUiExtra.F_ItemNameBox", class'Material', false));
   ItemNameBoxT = Material(DynamicLoadObject("DeusExUIExtra.HUD.ItemNameBox", class'Material', false));
   default.CrosshairTex = texture(DynamicLoadObject("DXRMenuIMG.CrossCircle", class'texture', false));
}


/* returns true if target is projected on visible canvas area */
static function bool IsTargetInFrontOfPlayer(Canvas C, Actor Target, out Vector ScreenPos, Vector CamLoc, Rotator CamRot)
{
    // Is Target located behind camera ?
    if ((Target.Location - CamLoc) Dot vector(CamRot) < 0)
        return false;

    // Is Target on visible canvas area ?
    ScreenPos = C.WorldToScreen(Target.Location);
    if (ScreenPos.X <= 0 || ScreenPos.X >= C.ClipX)
        return false;

    if (ScreenPos.Y <= 0 || ScreenPos.Y >= C.ClipY)
        return false;

    return true;
}

function GetMapTrueNorth()
{
    local DeusExLevelInfo info;

    if (DeusExPlayer(PawnOwner) != None) 
    {
        info = DeusExPlayer(PawnOwner).GetLevelInfo();

        if (info != None)
            mapNorth = info.TrueNorth;
    }
}

function string FormatString(float num)
{
    local string tempstr;

    // round up
    num += 0.5;

    tempstr = Left(String(num), 3);

    if (num < 100.0)
        tempstr = Left(String(num), 2);
    if (num < 10.0)
        tempstr = Left(String(num), 1);

    return tempstr;
}

function AddTextMessage(string M, class<LocalMessage> MessageClass, PlayerReplicationInfo PRI)
{
    local int i;

    if (bMessageBeep && MessageClass.Default.bBeep)
        PlayerOwner.PlayBeepSound();

    for(i=0; i<ConsoleMessageCount; i++)
    {
        if (TextMessages[i].Text == "")
            break;
    }
    if( i == ConsoleMessageCount )
    {
        for( i=0; i<ConsoleMessageCount-1; i++ )
            TextMessages[i] = TextMessages[i+1];
    }
    TextMessages[i].Text = M;
//    if (playerOwner.IsInState('Conversation'))
//        TextMessages[i].MessageLife = Level.TimeSeconds + 9999;//Human(player.pawn).logTimeout; Bad idea -_-
//    else
        TextMessages[i].MessageLife = Level.TimeSeconds + 10;//Human(player.pawn).logTimeout;

    TextMessages[i].TextColor = MessageClass.static.GetConsoleColor(PRI);
    TextMessages[i].PRI = PRI;
}

/* 
   Specific function to use Canvas.DrawActor()
   Clear Z-Buffer once, prior to rendering all actors
   Функция для познания Истины.
*/
function CanvasDrawActors(Canvas C, bool bClearedZBuffer)
{
   if (PlayerOwner.pawn != none)
   {
      if (!PlayerOwner.bBehindView && PawnOwner.Weapon != None)
      {
          if (!bClearedZBuffer)
              C.DrawActor(None, false, true); // Clear the z-buffer here
              PawnOwner.Weapon.RenderOverlays(C);
      }
      else
      if ((Human(Playerowner.pawn).inHand != None) && (!Human(Playerowner.pawn).inHand.IsA('Weapon')) && (!playerOwner.bBehindView))
      {
          Human(Playerowner.pawn).inHand.RenderOverlays(C);
      }
   }
   super.CanvasDrawActors(C, bClearedZBuffer);
}

function UpdateHud()
{
    if (PawnOwner != None)
    {
       if (Human(Playerowner.pawn)!=none)
       {
           Health=                 Human(Playerowner.pawn).Health;
           HealthHead=         Human(Playerowner.pawn).HealthHead;
           HealthTorso=        Human(Playerowner.pawn).HealthTorso;
           HealthLegLeft=  Human(Playerowner.pawn).HealthLegLeft;
           HealthLegRight= Human(Playerowner.pawn).HealthLegRight;
           HealthArmLeft=  Human(Playerowner.pawn).HealthArmLeft;
           HealthArmRight= Human(Playerowner.pawn).HealthArmRight;

           BioEnergy           = Human(Playerowner.pawn).Energy;
           BioEnergyMax    = Human(Playerowner.pawn).EnergyMax;

           if (bUnderwater)
           {
               // if we are already underwater
               if (PawnOwner.HeadVolume.bWaterVolume)
               {
                   // if we are still underwater
                   breathPercent = 100.0 * Human(Playerowner.pawn).swimTimer / Human(Playerowner.pawn).swimDuration;
                   breathPercent = FClamp(breathPercent, 0.0, 100.0);
               }
               else
               {
                   // if we are getting out of the water
                   bUnderwater = false;
                   breathPercent = 100;
               }
           }
           else if (PawnOwner.HeadVolume.bWaterVolume)
           {
               // if we just went underwater
               bUnderwater = true;
               breathPercent = 100;
           }
       }
       if (!DeusExPlayer(PawnOwner).bSpyDroneActive)
       {
          if (DeusExPlayer(PawnOwner).aDrone != None)
          {
              DeusExPlayer(PawnOwner).aDrone.TakeDamage(100, None, DeusExPlayer(PawnOwner).aDrone.Location, vect(0,0,0), class'DM_EMP');
              DeusExPlayer(PawnOwner).aDrone = None;
          }
       }
    }
}

event PostSetInitialState()
{
    dxc = new(Outer) class'DxCanvas';
    GetMapTrueNorth();
    ConsoleMessageCount = 8; // Human(player.pawn).MaxLogLines;
}

// TODO: Добавить условия для включения и отключение ГДИ или его частей
// Стоит использовать переменные из оригинала.
event PostRender(canvas u)
{
    super.postrender(u);
    if ((cubemapmode) || (PawnOwner == none) || !pawnOwner.IsA('DeusExPlayer'))
         return;

    if (menuMode)
    {
       u.setPos(0,0);
       u.style = ERenderStyle.STY_Normal;
       u.SetDrawColor(1,1,1,255);
       u.DrawTileStretched(texture'solid', u.SizeX, u.SizeY);
       return;
    }

    if (midMenuMode)
    {
//    s = class'DeusExGlobals'.default.lastScreenShot;
    //  if (s != none)
//    {
        u.setPos(0,0);
        u.style = ERenderStyle.STY_Modulated;
        u.SetDrawColor(200,200,200,255);
        u.DrawTileStretched(texture'ConWindowBackground', u.SizeX, u.SizeY);
//    }
      return;
    }

      RenderPoisonEffectGray(u);
      RenderPoisonEffectGreen(u);
      RenderFrobTarget(u);
      RenderSmallHUDHitDisplay(u);
      RenderHitMarker(u);
      DisplayMessages(u);
      RenderCompass(u); // Компас
      RenderToolBelt(u); // Быстрый доступ
      RenderAugsBelt(u); // Задействованные аугментации
      RenderAmmoDisplay(u);
      RenderChargedPickups(u);

// DrawActor( Actor A, bool WireFrame, optional bool ClearZ, optional float DisplayFOV ) 
//    c.DrawActor(None, false, true); // Clear the z-buffer here
}

function DrawHud(Canvas C)
{
    if ((PawnOwner != none) && (PawnOwner.IsA('DeusExPlayer')))
    {
        UpdateHud();
    }
    super.drawhud(C);
}

function RenderHitMarker(canvas c)
{
   local float X,Y;

   if (bDrawInfo)
   return;

   if (playerowner.pawn == None)
   return;

   if (PlayerPawn(PawnOwner).HitMarkerTime > 0.05)
   {
        X = (C.SizeX * 0.5) -32;
        Y = (C.SizeY * 0.5) -32;
        c.SetPos(X,Y);
        c.SetDrawColor(255,0,0);
        c.DrawIconEx(HitMarkerMat,1.0);
   }
}

function RenderSmallHUDHitDisplay(Canvas C)
{
   if ((PawnOwner == None) || (PlayerPawn(PawnOwner).bHitDisplayVisible == false))
        return;

   if (DeusExPlayerController(PlayerOwner).bHUDBackgroundTranslucent)
       c.Style = ERenderStyle.STY_Translucent;
          else
       c.Style = ERenderStyle.STY_Normal;

       C.DrawColor = HealthBG;
       C.SetPos(11,11);
       C.DrawIcon(HudHitBase,1);

     if (DeusExPlayerController(PlayerOwner).bHUDBordersVisible)
     {
         if (DeusExPlayerController(PlayerOwner).bHUDBordersTranslucent)
             c.Style = ERenderStyle.STY_Translucent;
         else
             c.Style = ERenderStyle.STY_Alpha;

        C.SetPos(0,0);
        C.DrawColor = HealthFrame;
        C.DrawIcon(HudHitFrame,1);
     }
     C.Style = ERenderStyle.STY_Translucent;
     C.SetPos(24,16);
     C.DrawIcon(HudHitBody,1);


     C.SetPos(39,18);
     C.DrawColor = GetColorScaled(HealthHead / 100);
     if (DeusExPlayer(PawnOwner).HealthHead > 0) // if health of this part is 0 or less, do not render it.
         C.DrawIcon(HudHitHead,1); // Head

     C.SetPos(26,28);
     C.DrawColor = GetColorScaled(HealthArmRight / 100);
     if (DeusExPlayer(PawnOwner).HealthArmRight > 0)
         C.DrawIcon(HudHitArmR,1); // Right arm

     C.SetPos(36,26);
     C.DrawColor = GetColorScaled(HealthTorso / 100);
     if (DeusExPlayer(PawnOwner).HealthTorso > 0)
         C.DrawIcon(HudHitTorso,1);  // Body

     C.SetPos(46,28);
     C.DrawColor = GetColorScaled(HealthArmLeft / 100);
     if (DeusExPlayer(PawnOwner).HealthArmLeft > 0)
         C.DrawIcon(HudHitArmL,1); // Left arm

     C.SetPos(33,45);
     C.DrawColor = GetColorScaled(HealthLegRight / 100);
     if (DeusExPlayer(PawnOwner).HealthLegRight > 0)
         C.DrawIcon(HudHitLegR,1); // Right leg

     C.SetPos(41,45);
     C.DrawColor = GetColorScaled(HealthLegLeft / 100);
     if (DeusExPlayer(PawnOwner).HealthLegLeft > 0)
         C.DrawIcon(HudHitLegL,1); // Left leg


     // From Reborn
     C.SetPos(14,77);
     C.SetDrawColor(0,255,0);
     C.Font = Font'DXFonts.FontMenuSmall_DS';
     C.DrawText("BE");

     C.SetPos(15,20 + 55*(1.0 - (BioEnergy / BioEnergyMax))); // Позиция для индикатора
     C.DrawColor = GetColorScaled(BioEnergy / BioEnergyMax); // Градация от зеленого к красному...
     C.DrawColor.A = 255;

     C.Style = ERenderStyle.STY_Normal;

     // Рисуем индикатор энергии...
     C.DrawTileStretched(texture'Solid', 5, Abs(BioEnergy / BioEnergyMax)*55);
// ------------------------------------------------
    // Рисуем индикатор кислорода...
    if (bUnderwater)
    {
        breathPercent = 100.0 * Human(PawnOwner).swimTimer / Human(PawnOwner).swimDuration;
        breathPercent = FClamp(breathPercent, 0.0, 100.0);

        C.SetPos(o2PosX,o2PosY);
        C.SetDrawColor(0,255,0);
        C.Font = Font'DXFonts.FontMenuSmall_DS';

        if (breathPercent < 10)
        {
           if ((Human(Playerowner.pawn).swimTimer % 0.5) > 0.25)
               C.SetDrawColor(255,0,0);
            else
               C.SetDrawColor(0,0,0);
        }
        C.DrawText("o2");

        C.SetPos(o2BarPosX,o2BarPosY * o2cr - (0.55 * breathPercent)); // Позиция для индикатора
        C.DrawColor=GetColorScaled(0.01 * breathPercent); // Градация от зеленого к красному...
        C.DrawColor.A=255;
        C.DrawTileStretched(texture'Solid', 5, breathPercent * 0.55);
     }
}

// имя выделенного объекта (пока буквально)
// 10/06/17 имя выделенного объекта как в оригинале
function RenderFrobTarget(Canvas C)
{
   local float  X,Y, tH,tW, nH, nW;
   local Actor  FrobName;
   local String FrobStr;
   local int      numTools;
   local string   strInfo;

   local vector sp1, sp2;
   local Vector            centerLoc, v1, v2;//, v3;
   local float             boxCX, boxCY, boxTLX, boxTLY, boxBRX, boxBRY, boxW, boxH;
   local float             fcorner;
   local int               i, j, k, offset;
   local DeusExMover fMover;

   if (!bDrawFrobBox)
       return;

   X=C.ClipX * 0.5;
   Y=C.ClipY * 0.5;
   C.SetPos(X,Y);

   C.Font = LoadProgressFont();
   FrobName = DeusExPlayer(PawnOwner).frobTarget; //DeusExPlayerController(Player).FrobTarget;

   if ((FrobName != None) && (DeusExPlayerController(PlayerOwner).IsHighlighted(frobName)) && (!bDrawInfo))
   {
        // пульсация рамки
          offset = (24.0 * (frobname.Level.TimeSeconds % 0.3)); // Original
//            offset = (14.0 * (frobname.Level.TimeSeconds % 0.6)); // Reborn

            fMover = DeusExMover(FrobName);

            if (fMover != none)
            {
                fMover.GetBoundingBox(v1, v2);
                centerLoc = v1 + (v2 - v1) * 0.5;

                // Если большой DeusExMover то соотвествуюющий размер.
                //fMover.GetBoundingBoxSize(v3);
                //if (vSize(v3) > 100) // Для стандартных дверей 128x64x4
                //{
                  v1.X = 16;
                  v1.Y = 16;
                  v1.Z = 16;
                //}
                //else // Для маленьких. 
                //{
                //  v1.X = 8;
                //  v1.Y = 8;
                //  v1.Z = 8;
                //}

            }
            else
            {
               centerLoc = FrobName.Location;
               v1.X = FrobName.CollisionRadius;
               v1.Y = FrobName.CollisionRadius;
               v1.Z = FrobName.CollisionHeight;
            }

            // берется расположение цели, выдается X(горизонтальная) и Y(вертикальная)
            sp1 = C.WorldToScreen(centerLoc);

            boxCX = sp1.X;
            boxCY = sp1.Y;

            boxTLX = boxCX;
            boxTLY = boxCY;
            boxBRX = boxCX;
            boxBRY = boxCY;

            for (i=-1; i<=1; i+=2)
            {
                for (j=-1; j<=1; j+=2)
                {
                    for (k=-1; k<=1; k+=2)
                    {
                        v2 = v1;
                        v2.X *= i;
                        v2.Y *= j;
                        v2.Z *= k;
                        v2.X += centerLoc.X;
                        v2.Y += centerLoc.Y;
                        v2.Z += centerLoc.Z;

                        sp2 = C.WorldToScreen(v2);

                        boxTLX = FMin(boxTLX, sp2.x);
                        boxTLY = FMin(boxTLY, sp2.y);
                        boxBRX = FMax(boxBRX, sp2.x);
                        boxBRY = FMax(boxBRY, sp2.y);
                    }
                }
            }
            if (!frobName.IsA('DeusExMover'))
            {
                boxTLX += frobName.CollisionRadius / 4.0;
                boxTLY += frobName.CollisionHeight / 4.0;
                boxBRX -= frobName.CollisionRadius / 4.0;
                boxBRY -= frobName.CollisionHeight / 4.0;
            }
                // Ограничить рамку для дверей
/*              if (FrobName.IsA('DeusExMover'))
                {
                  DeusExMover(FrobName).GetBoundingBox(v1, v2);

                centerLoc = v1 + (v2 - v1) * 0.5;
                v1.X = 16;
                v1.Y = 16;
                v1.Z = 16;*/
                //  v1.x = FrobName.location.x;//GetRenderBoundingSphere().x;
                //  v1.y = FrobName.location.y;//GetRenderBoundingSphere().y;
                //  v1.z = 16;

//                  centerLoc.X = FMin( v1.X, v2.X );
//                  centerLoc.Y = FMin( v2.Y, v2.Y );

                /*boxTLX = FClamp(boxTLX, moverCorrectionA, C.SizeX-moverCorrectionA);
                boxTLY = FClamp(boxTLY, moverCorrectionB, C.SizeY-moverCorrectionB);
                boxBRX = FClamp(boxBRX, moverCorrectionC, C.SizeX-moverCorrectionC);
                boxBRY = FClamp(boxBRY, moverCorrectionD, C.SizeY-moverCorrectionD);*/
                // Отказ от абсюлютных значений
//              boxTLX = FClamp(boxTLX, moverCorrectionA * C.SizeX, C.SizeX-moverCorrectionA * C.SizeX);
//              boxTLY = FClamp(boxTLY, moverCorrectionB * C.SizeY, C.SizeY-moverCorrectionB * C.SizeY);
//              boxBRX = FClamp(boxBRX, moverCorrectionC * C.SizeX, C.SizeX-moverCorrectionC * C.SizeX);
//              boxBRY = FClamp(boxBRY, moverCorrectionD * C.SizeY, C.SizeY-moverCorrectionD * C.SizeY);
//              }

                // Не дает видимых изменений... Но пока оставлю
                boxTLX = FClamp(boxTLX, margin, C.SizeX-margin);
                boxTLY = FClamp(boxTLY, margin, C.SizeY-margin);
                boxBRX = FClamp(boxBRX, margin, C.SizeX-margin);
                boxBRY = FClamp(boxBRY, margin, C.SizeY-margin);

                boxW = boxBRX - boxTLX;
                boxH = boxBRY - boxTLY;


                // scale the corner based on the size of the box
                fcorner = FClamp((boxW + boxH) * 0.1, 4.0, 40.0);

                // make sure the box doesn't invert itself
                if (boxBRX - boxTLX < fcorner)
                {
                    boxTLX -= (fcorner+4);
                    boxBRX += (fcorner+4);
                }
                if (boxBRY - boxTLY < fcorner)
                {
                boxTLY -= (fcorner+4);
                boxBRY += (fcorner+4);
                }

            // Рамка рисуется дважды: сначала белая, затем тень.
            // В оригинале белый цвет менялся в зависимости от цветовой темы.
          C.DrawColor = FrobBoxShadow;//SetDrawColor(0,0,0,255);
            for (i=1; i>=0; i--)
            {
                // Нужно переместить окно с инфрмацией в левый верхний угол + небольшое смещение, как в оригинале.
                C.setpos(boxTLX+i+offset, boxTLY+i+offset); // Верхний левый угол
                C.DrawRect(texture'Solid', fcorner, 1); // DrawRect не поддерживает Material (например Shader), только текстуры
                C.setpos(boxTLX+i+offset, boxTLY+i+offset);
                C.DrawRect(texture'Solid', 1, fcorner);


                C.setpos(boxBRX+i-fcorner-offset,boxTLY+i+offset); // Верхний правый угол
                C.DrawRect(texture'Solid', fcorner, 1);
                C.setpos(boxBRX+i-offset, boxTLY+i+offset);
                C.DrawRect(texture'Solid', 1, fcorner);


                C.setpos(boxTLX+i+offset ,boxBRY+i-offset); // ...нижний левый
                C.DrawRect(texture'Solid', fcorner,1);
                C.setpos(boxTLX+i+offset, boxBRY+i-fcorner-offset);
                C.DrawRect(texture'Solid', 1, fcorner);


                C.setpos(boxBRX+i-fcorner+1-offset,boxBRY+i-offset); // ...и нижний правый
                C.DrawRect(texture'Solid', fcorner,1);
                C.setpos(boxBRX+i-offset, boxBRY+i-fcorner-offset);
                C.DrawRect(texture'Solid', 1, fcorner);
                C.DrawColor = FrobBoxColor;//SetDrawColor(255,255,255,255);

            }
       FrobStr = string(FrobName);
       C.TextSize(FrobStr, tH,tW);

       C.SetDrawColor(250,250,250,200);// выставляем цвет фона для названия
       C.SetPos(X + ItemNameFrameOffsetH,Y + ItemNameFrameOffsetV); // Коррекция смещения фона

       C.SetDrawColor(255,255,255,255);
       C.SetPos(X + ItemNameOffsetH,Y + ItemNameOffsetV);

         If (FrobName.IsA('Hackabledevices'))
         {
                        if (Hackabledevices(frobName).bHackable)
                        {
                            if (Hackabledevices(frobName).hackStrength != 0.0)
                            {       // Можно взломать, отобразить сколько мультиинструментов нужно
                                 Frobstr=Hackabledevices(frobName).itemName; // присвоить строку
                                 C.TextSize(msgHackStr $ msgInf $ msgHacked, tH,tW);    // Соединяем строки, полученный размер строки передан в tH, tW
                                 C.SetDrawColor(250,250,250,200);
                                 C.setpos(boxTLX+ItemNameFrameOffsetH, boxTLY+ItemNameFrameOffsetV);    // Верхний левый угол
                          //C.Style = ERenderStyle.STY_Additive; // STY_Modulated;  // C.Style = ERenderStyle.STY_Normal;
                                 C.DrawTileStretched(INBox, tH, tW + 22);
                                 C.Style = ERenderStyle.STY_Normal;
                                 C.SetDrawColor(255,255,255,255);   // подготовка к рисованию текста
                                 C.setpos(boxTLX+ItemNameOffsetH, boxTLY+ItemNameOffsetV);  // Верхний левый угол
                                 C.DrawText(Hackabledevices(frobName).itemName);    // Пишем отображаемое имя
                                 C.setpos(boxTLX+ItemNameOffsetH, boxTLY+ItemNameOffsetV + 20); // отступ вниз для второй строки
                                 C.DrawText(msgHackStr $ FormatString(Hackabledevices(frobName).hackStrength * 100.0) $ "%"); // ...вторая строка

                                 C.DrawColor=GetColorScaled(Hackabledevices(frobName).hackStrength);
                                 C.DrawColor.A=200;
                                 C.TextSize(msgHackStr, nH,nW);
                                 C.setpos(boxTLX+ItemNameOffsetH + nH + 40, boxTLY+ItemNameOffsetV + 20); // отступ для индикатора взлома
                                 C.DrawTileStretched(texture'Solid', barLength*Hackabledevices(frobName).hackStrength, 15); // Рисуем индикатор (функциональный!)
                                 C.DrawColor = FrobBoxText;// SetDrawColor(255,255,255,255); // указываем цвет для текст названия (белый)

                                    numTools = int((Hackabledevices(frobName).hackStrength / Human(Playerowner.pawn).SkillSystem.GetSkillLevelValue(class'SkillTech')) + 0.99);
                                    if (numTools == 1)
                                    strInfo = numTools @ msgTool;
                                    else
                                    strInfo = numTools @ msgTools;
                                    C.DrawText(strInfo);
                            }
                            else
                                {   // Взломано
                                 Frobstr=Hackabledevices(frobName).itemName; // присвоить строку
                                 C.TextSize(FrobStr $ msgInf, tH,tW);   // Размер строки передан в tH, tW
                               C.SetDrawColor(250,250,250,200);
                                 C.setpos(boxTLX+ItemNameFrameOffsetH, boxTLY+ItemNameFrameOffsetV);    // Верхний левый угол
                               //C.DrawTileStretched(texture'ItemNameBox', tH + 24, tW + 2);
                               C.DrawTileStretched(INBox, tH + 24, tW + 2);
                                 C.DrawColor = FrobBoxText;//SetDrawColor(255,255,255,255); // подготовка к рисованию текста
                                 C.setpos(boxTLX+ItemNameOffsetH, boxTLY+ItemNameOffsetV);  // Верхний левый угол
                       C.DrawText(Hackabledevices(frobName).itemName $ ": " $ msgHacked);
                                }
                        }
                else
                {    // Стойкость к взлому: бесконечно
                     Frobstr=Hackabledevices(frobName).itemName; // присвоить строку
                     C.TextSize(msgInf $ msgHackStr, tH,tW);    // Размер строки передан в tH, tW
                   C.SetDrawColor(250,250,250,200);
                     C.setpos(boxTLX+ItemNameFrameOffsetH, boxTLY+ItemNameFrameOffsetV);    // Верхний левый угол
                   C.DrawTileStretched(INBox, tH + 80, tW + 22);
                     C.DrawColor = FrobBoxText;//SetDrawColor(255,255,255,255); // подготовка к рисованию текста
                     C.setpos(boxTLX+ItemNameOffsetH, boxTLY+ItemNameOffsetV);  // Верхний левый угол
                 C.DrawText(Hackabledevices(frobName).itemName);
                     C.setpos(boxTLX+ItemNameOffsetH, boxTLY+ItemNameOffsetV + 20); // отступ вниз для второй строки
                 C.DrawText(msgHackStr $ msgInf);
                     C.SetDrawColor(0,255,0,200);
                     C.setpos(boxTLX+ItemNameOffsetH + tH + 8, boxTLY+ItemNameOffsetV + 21); // отступ вниз для второй строки
                     C.DrawTileStretched(texture'Solid', barLength, 15); // Рисуем индикатор (можно не функциональный)
                }
                }
             else
         If (FrobName.IsA('DeusExDecoration') && (DeusExPlayer(PlayerOwner.pawn) != none) && (DeusExPlayer(PlayerOwner.pawn).bObjectNames))
         {
             Frobstr=DeusExDecoration(frobName).itemName;
             C.TextSize(FrobStr, tH,tW);
           C.SetDrawColor(250,250,250,200);
             C.setpos(boxTLX+ItemNameFrameOffsetH, boxTLY+ItemNameFrameOffsetV);    // Верхний левый угол
           C.DrawTileStretched(INBox, tH + 24, tW + 2);
             C.DrawColor = FrobBoxText;//C.SetDrawColor(255,255,255,255);
             C.setpos(boxTLX+ItemNameOffsetH, boxTLY+ItemNameOffsetV);  // Верхний левый угол
             C.DrawText(DeusExDecoration(frobName).itemName);
             }
             else
             If (FrobName.IsA('ScriptedPawn') && (DeusExPlayer(PlayerOwner.pawn) != none) && (DeusExPlayer(PlayerOwner.pawn).bObjectNames))
         {
             Frobstr=ScriptedPawn(frobName).FamiliarName;
             C.TextSize(FrobStr, tH,tW);
           C.SetDrawColor(250,250,250,200);
             C.SetPos(boxTLX+ItemNameFrameOffsetH,boxTLY + ItemNameFrameOffsetV);
           C.DrawTileStretched(INBox, tH + 24, tW+ 2);
             C.DrawColor = FrobBoxText;;//C.SetDrawColor(255,255,255,255);
             C.SetPos(boxTLX + ItemNameOffsetH,boxTLY + ItemNameOffsetV);
         C.DrawText(ScriptedPawn(frobName).FamiliarName);
         }
         else
         If (FrobName.IsA('DeusExPickup'))
         {
             Frobstr=DeusExPickup(frobName).itemName;
             C.TextSize(FrobStr, tH,tW);
           C.SetDrawColor(250,250,250,200);
             C.SetPos(boxTLX + ItemNameFrameOffsetH,boxTLY + ItemNameFrameOffsetV);
           C.DrawTileStretched(INBox, tH + 24, tW+ 2);
             C.DrawColor = FrobBoxText;//C.SetDrawColor(255,255,255,255);
             C.SetPos(boxTLX + ItemNameOffsetH,boxTLY + ItemNameOffsetV);
         C.DrawText(DeusExPickup(frobName).itemName);
                }
            else
         If (FrobName.IsA('DeusExAmmo'))
         {
             Frobstr=DeusExAmmo(frobName).itemName;
             C.TextSize(FrobStr, tH,tW);
           C.SetDrawColor(250,250,250,200);
             C.SetPos(boxTLX+ItemNameFrameOffsetH,boxTLY + ItemNameFrameOffsetV);
           C.DrawTileStretched(INBox, tH + 24, tW+ 2);
             C.DrawColor = FrobBoxText;//C.SetDrawColor(255,255,255,255);
             C.SetPos(boxTLX + ItemNameOffsetH,boxTLY + ItemNameOffsetV);
         C.DrawText(DeusExAmmo(frobName).itemName);
             }
            else
         If (FrobName.IsA('DeusExCarcass') && (DeusExPlayer(PlayerOwner.pawn) != none) && (DeusExPlayer(PlayerOwner.pawn).bObjectNames))
         {
             Frobstr=DeusExCarcass(frobName).itemName;
             C.TextSize(FrobStr, tH,tW);
           C.SetDrawColor(250,250,250,200);
             C.SetPos(boxTLX + ItemNameFrameOffsetH,boxTLY + ItemNameFrameOffsetV);
           C.DrawTileStretched(INBox, tH + 24, tW+ 2);
             C.DrawColor = FrobBoxText;//C.SetDrawColor(255,255,255,255);
           C.SetPos(boxTLX + ItemNameOffsetH,boxTLY + ItemNameOffsetV);
         C.DrawText(DeusExCarcass(frobName).itemName);
         }
            else
         If (FrobName.IsA('DeusExWeapon')) // Версия предметов инвентаря на карте.
         {
             Frobstr=DeusExWeapon(frobName).itemName;
             C.TextSize(FrobStr, tH,tW);
             C.SetDrawColor(250,250,250,200);
             C.SetPos(boxTLX + ItemNameFrameOffsetH,boxTLY + ItemNameFrameOffsetV);
             C.DrawTileStretched(INBox, tH + 24, tW+ 2);
             C.DrawColor = FrobBoxText;//C.SetDrawColor(255,255,255,255);
             C.SetPos(boxTLX + ItemNameOffsetH,boxTLY + ItemNameOffsetV);
             C.DrawText(DeusExWeapon(frobName).itemName);
         }
            else
        If (FrobName.IsA('DeusExProjectile')) // TODO: сбегать наверх и проверить
        {
             Frobstr=DeusExProjectile(frobName).itemName;
             C.TextSize(FrobStr, tH,tW);
             C.SetDrawColor(250,250,250,200);
             C.SetPos(boxTLX + ItemNameFrameOffsetH,boxTLY + ItemNameFrameOffsetV);
             C.DrawTileStretched(INBox, tH + 24, tW+ 2);
             C.DrawColor = FrobBoxText;//C.SetDrawColor(255,255,255,255);
             C.SetPos(boxTLX + ItemNameOffsetH,boxTLY + ItemNameOffsetV);
             C.DrawText(DeusExProjectile(frobName).itemName);
        }
            else
        If (FrobName.IsA('DeusExMover'))
        {
                If (DeusExMover(frobName).bLocked) // Дверь закрыта, отобразить сложность замка, прочность двери и другую информацию.
                {
                        C.TextSize(msgLockStr $ msgInf, tH,tW); // соединяем строки и получаем длину рамки + небольшой запас.
                C.SetDrawColor(250,250,250,200); // R,G,B, optional alpha
                        C.setpos(boxTLX+ItemNameFrameOffsetH, boxTLY+ItemNameFrameOffsetV); // Верхний левый угол
//                C.SetPos(X + ItemNameFrameOffsetH,Y + ItemNameFrameOffsetV);
                C.DrawTileStretched(INBox, tH + barLength * 2.5, tW + 44); // вмещаем фоновый рисунок, размер соответствует полученным размерам из TextSize
                      C.SetDrawColor(255,255,255,255); // указываем цвет для текст названия (белый)
                        C.setpos(boxTLX+ItemNameOffsetH, boxTLY+ItemNameOffsetV);   // Верхний левый угол
//              C.SetPos(X + ItemNameOffsetH,Y + ItemNameOffsetV);
                C.DrawText(msgLocked); // Закрыто, теперь нужно отобразить информацию как и насколько.

                            if (DeusExMover(frobName).bPickable) // Закрыто но можно открыть отмычкой
                            {                                                                        //----------------------------------
                      C.SetPos(boxTLX+i + ItemNameOffsetH,boxTLY+i + ItemNameOffsetV + 20);
                                C.DrawText(msgLockStr $ FormatString(DeusExMover(frobName).lockStrength * 100.0) $ "%");
                        C.SetPos(boxTLX + tH + 30,boxTLY + tW + ItemNameOffsetV /* + 25*/); // расположение индикатора
                                C.DrawColor=GetColorScaled(DeusExMover(frobName).lockStrength);
                                C.DrawColor.A=200;
                                C.DrawTileStretched(texture'Solid', barLength*DeusExMover(frobName).lockStrength, 15); // Рисуем индикатор
                              C.DrawColor = FrobBoxText;//C.SetDrawColor(255,255,255,255); // указываем цвет для текст названия (белый)
                                    // Получаем информацию...
                                    numTools = int((DeusExMover(frobName).lockStrength / Human(Playerowner.pawn).SkillSystem.GetSkillLevelValue(class'SkillLockpicking')) + 0.99);
                                    if (numTools == 1)
                                    strInfo = numTools @ msgPick;
                                    else
                                    strInfo = numTools @ msgPicks;
                                C.DrawText(strInfo);
                              C.SetDrawColor(255,255,255,255);
                            }
                    else
                            {
                C.DrawColor = FrobBoxText;
                        C.SetPos(boxTLX + ItemNameOffsetH,boxTLY + ItemNameOffsetV + 20); // Закрыто но отмычкой не открыть
                                C.DrawText(msgLockStr $ msgInf);
                        C.SetPos(boxTLX + tH + 30,boxTLY + tW + ItemNameOffsetV /* + 25*/); // расположение индикатора
                                C.SetDrawColor(0,255,0,200);
                                C.DrawTileStretched(texture'Solid', barLength, 15); // Рисуем индикатор
                              C.SetDrawColor(255,255,255,255);
                            }
                            if (DeusExMover(frobName).bBreakable) // Закрыто но можно выломать
                            {                                     //--------------------------
                            C.DrawColor = FrobBoxText;
                        C.SetPos(boxTLX + ItemNameOffsetH,boxTLY + ItemNameOffsetV + 40);
                                C.DrawText(msgDoorStr $ FormatString(DeusExMover(frobName).doorStrength * 100.0) $ "%");
                        C.SetPos(boxTLX + tH + 30,boxTLY + tW + ItemNameOffsetV + 20); // расположение индикатора
                                C.DrawColor=GetColorScaled(DeusExMover(frobName).doorStrength);
                                C.DrawColor.A=200;
                                C.DrawTileStretched(texture'Solid', barLength*DeusExMover(frobName).doorStrength, 15); // Рисуем индикатор

                        C.SetPos(boxTLX + tH + 30,boxTLY + tW + ItemNameOffsetV + 20); // расположение индикатора
                            }
                    else
                            {
                            C.DrawColor = FrobBoxText;
                        C.SetPos(boxTLX + ItemNameOffsetH,boxTLY + ItemNameOffsetV + 40); // Закрыто, невозможно открыть отмычкой или сломать
                                C.DrawText(msgDoorStr $ msgInf);
                        C.SetPos(boxTLX + tH + 30,boxTLY + tW + ItemNameOffsetV + 20); // расположение индикатора
                                C.SetDrawColor(0,255,0,200);
                                C.DrawTileStretched(texture'Solid', barLength, 15); // Рисуем индикатор
                            }
                }
                  If (!DeusExMover(frobName).bLocked) // дверь открыта, ничего не делать
                {
                     C.TextSize(msgUnLocked, tH,tW);
               C.SetDrawColor(250,250,250,200);
               C.SetPos(boxTLX + ItemNameFrameOffsetH,boxTLY + ItemNameFrameOffsetV);
               //C.DrawTileStretched(texture'ItemNameBox', tH + 24, tW); // вмещаем фоновый рисунок
               C.DrawTileStretched(INBox, tH + 24, tW); // вмещаем фоновый рисунок
                     C.DrawColor = FrobBoxText;//C.SetDrawColor(255,255,255,255);
               C.SetPos(boxTLX + ItemNameOffsetH,boxTLY + ItemNameOffsetV);
             C.DrawText(msgUnLocked);
                }
            }
            else
            {
            if ((DeusExPlayer(PlayerOwner.pawn) != none) && (DeusExPlayer(PlayerOwner.pawn).bObjectNames))
            {
             FrobStr=FrobName.GetHumanReadableName();
             C.TextSize(FrobStr, tH,tW);
           C.SetDrawColor(250,250,250,200);
             C.SetPos(boxTLX + ItemNameFrameOffsetH,boxTLY + ItemNameFrameOffsetV);
           C.DrawTileStretched(INBox, tH + 20, tW+ 2);
             C.DrawColor = FrobBoxText;//C.SetDrawColor(255,255,255,255);
           C.SetPos(boxTLX + ItemNameOffsetH,boxTLY + ItemNameOffsetV);
           C.DrawText(FrobStr);
          }
      }
   }
}

//------------------
// Серая текстура
//------------------
function RenderPoisonEffectGray(Canvas C)
{
    local texture Gray;
  local float X,Y;

   X=C.ClipX * 0.0;
   Y=C.ClipY * 0.0;

    if (bGrayPoison)
    {
        C.SetPos(X,Y);
        C.SetDrawColor(255,255,255,255);
        Gray=wetTexture'Effects.UserInterface.DrunkFX';
    C.Style = ERenderStyle.STY_Modulated;
        C.DrawTileScaled(Gray, C.ClipX, C.ClipY);
            if (bDoubledPoisonEffect)
        C.DrawTileScaled(Gray, C.ClipX, C.ClipY);
    }
}

//------------------
// Зеленая текстура
//------------------
function RenderPoisonEffectGreen(Canvas C)
{
    local texture Green;
    local float X,Y;

     X = C.ClipX * 0.0;
     Y = C.ClipY * 0.0;

    if (bGreenPoison)
    {
        C.SetPos(X,Y);
        C.SetDrawColor(255,255,255,255);
        Green = wetTexture'Effects.UserInterface.DrunkBoy';
        C.Style = ERenderStyle.STY_Modulated;
        C.DrawTileScaled(Green, C.ClipX, C.ClipY);
        if (bDoubledPoisonEffect)
            C.DrawTileScaled(Green, C.ClipX, C.ClipY);
    }
}

//
// Компас из Reborn + коррекция с учетом TrueNorth
//
function RenderCompass(Canvas C)
{
  local float offset, width, bearing;

   c.DrawColor = compassBG;
   C.SetPos(11,116);

   if (DeusExPlayerController(playerowner).bHUDBackgroundTranslucent)
       c.Style = ERenderStyle.STY_Translucent;
          else
       c.Style = ERenderStyle.STY_Normal;

   C.DrawIcon(Texture'HUDCompassBackground_1',1.0);

   c.DrawColor = compassFrame;
   c.Style = ERenderStyle.STY_Translucent;
   C.SetPos(0,110);
   C.DrawIcon(Texture'HUDCompassBorder_1',1.0);

   C.SetDrawColor(255,255,255);
   C.SetPos(11,116);

   bearing = PlayerOwner.GetViewRotation().Yaw - mapNorth;
   if(bearing < 0)
   {
      bearing = bearing * -1;
      bearing = bearing % 65536.0;
      bearing = 65536.0 - bearing;
   }
   else
   {
      bearing = bearing % 65536.0;
   }
        offset = (bearing/65536.0)*240.0;

   if(offset > 180)
   {
      width=offset-180;
      C.DrawTile(Texture'HUDCompassTicks',60-width,19,offset,0.0,60-width,19);
      C.DrawTile(Texture'HUDCompassTicks',width,19,0,0.0,width,19);
   }
   else
   {
      C.DrawTile(Texture'HUDCompassTicks',60,19,offset,0.0,60,19);
   }
        c.SetDrawColor(0,0,0);
//      c.Style = ERenderStyle.STY_Normal;
      C.SetPos(11,116);
      C.DrawIcon(Texture'HUDCompassTickBox',1.0);
}

function RenderToolBelt(Canvas C);
function renderToolBeltSelection(canvas u);

function RenderAugsBelt(Canvas C)
{
//  local DxCanvas dxc;
  local float /*holdX,*/ holdY, /*w, h, width,*/ auglen;
  local DeusExPlayer p;
  local Augmentation aug;
  local texture border;
  local string AugKeyName;

    p = Human(PawnOwner);
    if(p == none)
    {
        return;
    }
      c.Font=Font'DXFonts.FontMenuSmall_DS';
    if (dxc != none)
        dxc.SetCanvas(C);

        c.Style = 1;
        holdY = 7;
        auglen=0;
        aug = p.AugmentationSystem.FirstAug;
        while(aug != none)
        {
            if(aug != none && aug.bAlwaysActive == false && aug.bHasIt == true)
            {
                if(auglen == 0)
                {
                    auglen = 27;
                }
                else
                {
                    auglen += 36;
                }
            }
            aug = aug.next;
        }
        auglen -= 16;

        aug = p.AugmentationSystem.FirstAug;
        while(aug != none)
        {
            if(aug != none && aug.bAlwaysActive == false && aug.bHasIt == true)
            {
                c.DrawColor = AugsBeltBG;//SetDrawColor(127,127,127);
                C.SetPos(C.SizeX-44,holdY+6);

                if (DeusExPlayerController(playerowner).bHUDBackgroundTranslucent)
                    c.Style = ERenderStyle.STY_Translucent;
                       else
                    c.Style = ERenderStyle.STY_Normal;

                C.DrawIcon(Texture'HUDIconsBackground',1.0);

                if(aug.bIsActive)
                {
                                    //if (Playerowner.pawn.Level.TimeSeconds % 1.5 > 0.75)
                      //  c.SetDrawColor(0,255,0);
                          //  else
                            c.DrawColor = AugsBeltActive;
                }
                else
                {
                    c.DrawColor = AugsBeltInActive;
                }

                c.Style = 3;
                C.SetPos(C.SizeX-42,holdY+7);
                border=aug.smallIcon;
                c.DrawIcon(border,1.0);

                    c.DrawColor = AugsBeltText;
                    C.Style = 1;
                    C.SetPos(C.SizeX-38,holdY);
                    AugKeyName=string(aug.GetHotKey());
                    dxc.DrawTextJustified("F"$AugKeyName, 2, C.SizeX-42, holdY+5, c.SizeX-12, holdY+20);
                holdY += 36;
            }
            aug = aug.next;
        }

        if (DeusExPlayerController(PlayerOwner).bHUDBordersVisible)
        {
           if (DeusExPlayerController(PlayerOwner).bHUDBordersTranslucent)
               c.Style = ERenderStyle.STY_Translucent;
                 else
                   c.Style = ERenderStyle.STY_Alpha;

            c.DrawColor = AugsBeltFrame;
            C.SetPos(C.SizeX-64,0);
            border=Texture'DeusExUI.HUDAugmentationsBorder_Top';
            C.DrawIcon(border,1.0);

            C.SetPos(C.SizeX-64,21);
            border=Texture'DeusExUI.HUDAugmentationsBorder_Center';
            c.DrawTile(border,64,auglen,0,0,64,2);

            C.SetPos(C.SizeX-64,13+auglen);
            border=Texture'DeusExUI.HUDAugmentationsBorder_Bottom';
            C.DrawIcon(border,1.0);
        }
}

function RenderChargedPickups(Canvas u)
{
  local inventory inv;
  local int step, hudY, amount;

  if (PawnOwner == none)
      return;

  hudY = u.SizeY - 80; // Отступ от размера экрана по вертикали

  for (inv=PawnOwner.Inventory; inv!=None; inv=inv.Inventory)
  {
    if (ChargedPickup(inv) != none && ChargedPickup(inv).IsActive())
    {
      step += 40;
      amount++;

/*      if (amount == 1)
      {
        u.Style = ERenderStyle.STY_Translucent;
        u.SetPos(u.SizeX-50 + HI_Back_X,hudY - step + HI_Back_Y);
        u.DrawColor = AugsBeltBG;
        u.DrawIcon(texture'DeusExUI.UserInterface.HUDIconsBackground',1); // background...

//      u.Style = ERenderStyle.STY_Normal;
        u.DrawColor = AugsBeltFrame;
        u.SetPos(u.SizeX-50 + HI_BorderX,hudY - step + HI_BorderY);
        u.DrawTileStretched(texture'DXR_HUDItemsBorder',64,64);

        u.SetPos(u.SizeX-50 + HI_IconX, hudY - step + HI_IconY);
        u.Style = ERenderStyle.STY_Normal;
        u.SetDrawColor(255,255,255,255);
        u.DrawIconEx(ChargedPickup(inv).ChargedIcon,1); // DrawIconEx can use materials (not only textures).

        u.SetPos(u.SizeX-50,hudY - step + 32);
        u.DrawColor = AugsBeltText;
        u.Font=Font'DXFonts.FontMenuSmall_DS';
        u.DrawText(ChargedPickup(inv).charge);//@amount);
      }
      if (amount > 1)
      {*/
        u.SetPos(u.SizeX-50 + HI_Back_X,hudY - step + HI_Back_Y);
        u.DrawColor = AugsBeltBG;
            if (DeusExPlayerController(playerowner).bHUDBackgroundTranslucent)
                u.Style = ERenderStyle.STY_Translucent;
                  else
                    u.Style = ERenderStyle.STY_Normal;
        u.DrawTileStretched(texture'DeusExUI.UserInterface.HUDIconsBackground',64, 64); // background...

//      u.Style = ERenderStyle.STY_Normal;
        if (DeusExPlayerController(PlayerOwner).bHUDBordersVisible)
        {
          if (DeusExPlayerController(PlayerOwner).bHUDBordersTranslucent)
              u.Style = ERenderStyle.STY_Translucent;
              else
              u.Style = ERenderStyle.STY_Alpha;

           u.DrawColor = AugsBeltFrame;
           u.SetPos(u.SizeX-50 + HI_BorderX,hudY - step + HI_BorderY);
           u.DrawTileStretched(texture'DXR_HUDItemsBorder',64,64);
        }

        u.SetPos(u.SizeX-50 + HI_IconX, hudY - step + HI_IconY);
        u.Style = ERenderStyle.STY_Normal;
        u.SetDrawColor(255,255,255,255);
        u.DrawIconEx(ChargedPickup(inv).ChargedIcon,1); // DrawIconEx can use materials (not only textures).

        u.SetPos(u.SizeX-50,hudY - step + 32);
        u.DrawColor = AugsBeltText;
        u.Font=Font'DXFonts.FontMenuSmall_DS';
        u.DrawText(ChargedPickup(inv).charge);//@amount);
      //}
    }
  }
}



// Счетчик патронов и обойм/инструментов и ключей
function RenderAmmoDisplay(Canvas c)
{
    local material ico;
    local int toolsLeft, clipsRemaining, ammoRemaining, ammoInClip;
    local DeusExWeapon weapon;

    local inventory item;

    item = DeusExPlayer(PawnOwner).InHand;

    if (item == none)
        return;

      c.Font = font'DxFonts.DPix_7';

          if (item.IsA('SkilledTool'))
          {
                ico =  SkilledTool(DeusExPlayer(PawnOwner).inhand).icon;
                toolsleft = SkilledTool(DeusExPlayer(PawnOwner).inhand).NumCopies;
                if (toolsleft == 0)
                    toolsleft = 1;

                if (DeusExPlayer(PawnOwner).InHand.IsA('NanoKeyRing'))
                    toolsleft = NanoKeyRing(DeusExPlayer(PawnOwner).inhand).GetKeyCount();

            c.DrawColor = AmmoDisplayBG;
            C.SetPos(13,C.SizeY-63);

            if (DeusExPlayerController(playerowner).bHUDBackgroundTranslucent)
                c.Style = ERenderStyle.STY_Translucent;
                   else
                c.Style = ERenderStyle.STY_Normal;
            C.DrawIcon(Texture'HUDAmmoDisplayBackground_1',1.0);

/*            c.DrawColor = AmmoDisplayFrame;
            C.SetPos(0,C.SizeY-77);
            C.DrawIcon(Texture'HUDAmmoDisplayBorder_1',1.0);*/
           if (DeusExPlayerController(PlayerOwner).bHUDBordersVisible)
           {
            if (DeusExPlayerController(PlayerOwner).bHUDBordersTranslucent)
              c.Style = ERenderStyle.STY_Translucent;
              else
              c.Style = ERenderStyle.STY_Alpha;

            c.DrawColor = AmmoDisplayFrame;
            C.SetPos(0,C.SizeY-77);
            C.DrawIcon(Texture'HUDAmmoDisplayBorder_1',1.0);
           }

            c.Style = ERenderStyle.STY_Normal;
            C.SetPos(21,C.SizeY-58);
            c.SetDrawColor(255,255,255,255);
            C.DrawIconEx(ico,1.0);

            C.SetPos(66,C.SizeY-50);
            c.Style = ERenderStyle.STY_Normal;
            c.SetDrawColor(0,255,0,255);// R G B A
            C.DrawTextJustified(toolsleft,1,66,C.SizeY-50,85,C.SizeY-41);
          }
          else if (item.IsA('DeusExWeapon'))
          {
            if (DeusExPlayer(PawnOwner) != None)
                weapon = DeusExWeapon(DeusExPlayer(PawnOwner).InHand);

            if (weapon == none)
                return;

                ico = weapon.icon;

            c.DrawColor = AmmoDisplayBG;
            C.SetPos(13,C.SizeY-63);
            if (DeusExPlayerController(PlayerOwner).bHUDBackgroundTranslucent)
                c.Style = ERenderStyle.STY_Translucent;
                  else
                    c.Style = ERenderStyle.STY_Normal;
            C.DrawIcon(Texture'HUDAmmoDisplayBackground_1',1.0);

           if (DeusExPlayerController(PlayerOwner).bHUDBordersVisible)
           {
            if (DeusExPlayerController(PlayerOwner).bHUDBordersTranslucent)
              c.Style = ERenderStyle.STY_Translucent;
              else
              c.Style = ERenderStyle.STY_Alpha;

            c.DrawColor = AmmoDisplayFrame;
            C.SetPos(0,C.SizeY-77);
            C.DrawIcon(Texture'HUDAmmoDisplayBorder_1',1.0);
           }

            c.Style = ERenderStyle.STY_Normal;
            c.SetDrawColor(255,255,255,255);
            C.SetPos(21,C.SizeY-58);
            C.DrawIconEx(ico,1.0);

            // Converted from HUDAmmoDisplay.uc :)
            // how much ammo of this type do we have left?
            if (weapon.AmmoType != None)
              ammoRemaining = weapon.AmmoType.AmmoAmount;
            else
              ammoRemaining = 0;

            if (ammoRemaining < weapon.LowAmmoWaterMark)
              c.DrawColor = colAmmoLowText;
            else
              c.DrawColor = colAmmoText;

            // Ammo count drawn differently depending on user's setting
            if (weapon.ReloadCount > 1)
            {
              // how much ammo is left in the current clip?
              ammoInClip = weapon.AmmoLeftInClip();
              clipsRemaining = weapon.NumClips();

              if (weapon.IsInState('Reload'))
              {
                C.SetPos(66,C.SizeY-50);
                C.DrawTextJustified(msgReloading,1,66,C.SizeY-50,85,C.SizeY-41);
              }
              else
              {
                C.SetPos(66,C.SizeY-50);
                C.DrawTextJustified(ammoInClip,1,66,C.SizeY-50,85,C.SizeY-41);
              }

              // if there are no clips (or a partial clip) remaining, color me red
              if (( clipsRemaining == 0 ) || (( clipsRemaining == 1 ) && ( ammoRemaining < 2 * weapon.ReloadCount )))
                c.DrawColor = colAmmoLowText;
              else
                c.DrawColor = colAmmoText;

              if (weapon.IsInState('Reload'))
              {
                C.SetPos(66,C.SizeY-38);
                C.DrawTextJustified(msgReloading,1,66,C.SizeY-38,85,C.SizeY-29);
              }
              else
              {
                C.SetPos(66,C.SizeY-38);
                if (DeusExPlayer(PawnOwner).RemainingAmmoMode == 0)
                   C.DrawTextJustified(clipsRemaining,1,66,C.SizeY-38,85,C.SizeY-29);
               else
                   C.DrawTextJustified(weapon.AmmoType.AmmoAmount - weapon.AmmoLeftInClip(),1,66,C.SizeY-38,85,C.SizeY-29);
              }
            }
            else
            {
              C.SetPos(66,C.SizeY-38);
              C.DrawTextJustified(NotAvailable,1,66,C.SizeY-50,85,C.SizeY-41);

              if (weapon.ReloadCount == 0)
              {
                C.SetPos(66,C.SizeY-50);
                C.DrawTextJustified(NotAvailable,1,66,C.SizeY-38,85,C.SizeY-29);
              }
              else
              {
                if (weapon.IsInState('Reload'))
                {
                  C.SetPos(66,C.SizeY-50);
                  C.DrawTextJustified(msgReloading,1,66,C.SizeY-38,85,C.SizeY-29);
                }
                else
                {
                  C.SetPos(66,C.SizeY-50);
                  C.DrawTextJustified(ammoRemaining,1,66,C.SizeY-38,85,C.SizeY-29);
                }
              }
            }

/*            C.SetPos(66,C.SizeY-50);
            C.DrawTextJustified(ammoInClip,1,66,C.SizeY-50,85,C.SizeY-41);

            C.SetPos(66,C.SizeY-38);
            C.DrawTextJustified(clipRemaining,1,66,C.SizeY-38,85,C.SizeY-29);*/
          }
}


/*Список шрифтов в DxFonts.u (все из оригинала)
FontFixedWidthSmall
FontFixedWidthSmall_DS
FontMenuExtraLarge
FontMenuHeaders
FontMenuHeaders_DS
FontMenuTitle
FontMenuSmall
FontMenuSmall_DS
FontTiny
FontTitleLarge
FontFixedWidthLocation
FontHUDWingDings
FontConversation
FontConversationBold
FontConversationLarge
FontConversationLargeBold
FontLocation
FontSpinningDX

FontComputer8x20_A
FontComputer8x20_B
FontComputer8x20_C

FontSansSerif_8
FontSansSerif_8_Bold
*/

defaultproperties
{
    HI_Back_X=4.5
    HI_Back_Y=7.0

    HI_IconX=4.5
    HI_IconY=7.0

    toolbeltSelPos(1)=(positionX=537,positionY=62)
    toolbeltSelPos(2)=(positionX=486,positionY=62)
    toolbeltSelPos(3)=(positionX=435,positionY=62)
    toolbeltSelPos(4)=(positionX=384,positionY=62)
    toolbeltSelPos(5)=(positionX=333,positionY=62)
    toolbeltSelPos(6)=(positionX=282,positionY=62)
    toolbeltSelPos(7)=(positionX=231,positionY=62)
    toolbeltSelPos(8)=(positionX=180,positionY=62)
    toolbeltSelPos(9)=(positionX=129,positionY=62)
    toolbeltSelPos(0)=(positionX=78,positionY=62) // KeyRing

    o2barPosX=62
    o2BarPosY=11
    o2posX=62
    o2posY=77
    o2cr=7.00000

    beBarPosX=8
    beBarPosY=10
    bePosX=4
    bePosY=70

    ItemNameFrameOffsetV=15
    ItemNameFrameOffSetH=10
    ItemNameOffsetV=17
    ItemNameOffSetH=15

    ConsoleMessagePosX=0.01
    ConsoleMessagePosY=0.9
//  ConsoleMessageCount=8 // Максимум 8
//  MessageLifeTime=10 // сколько секунд показывать сообщения.
    ProgressFadeTime=10.0

    TopBarOffset=0
    LowerBarOffSet=0

    CrosshairCorrectionX=-8
    CrosshairCorrectionY=-8

    HHframeY=-21
    HHframeX=-21

//-------------------------------------------------------
    marginX=4.00 // Для аугментаций с графическим интерфейсом !!!
    corner=9.00
    margin=70.00 // Для рамки выделения!!!
    barLength=50.00

    strUses="X "
    NotAvailable="N/A"
    msgReloading="---"
    AmmoLabel="AMMO"
    ClipsLabel="CLIPS"

    msgLocked="Locked"
    msgUnlocked="Unlocked"
    msgLockStr="Lock Str: "
    msgDoorStr="Door Str: "
    msgHackStr="Bypass Str: "
    msgInf="INF"
    msgHacked="Bypassed"
    msgPick="pick"
    msgPicks="picks"
    msgTool="tool"
    msgTools="tools"
    msgRange="Range"
    msgRangeUnits="ft"
    msgHigh="High"
    msgMedium="Medium"
    msgLow="Low"
    msgHealth="health"
    msgOverall="Overall"
    msgPercent="%"
    msgHead="Head"
    msgTorso="Torso"
    msgLeftArm="L Arm"
    msgRightArm="R Arm"
    msgLeftLeg="L Leg"
    msgRightLeg="R Leg"
    msgWeapon="Weapon:"
    msgNone="None"
    msgScanning1="* No Target *"
    msgScanning2="* Scanning *"
    msgADSTracking="* ADS Tracking *"
    msgADSDetonating="* ADS Detonating *"
    msgBehind="BEHIND"
    msgDroneActive="Remote SpyDrone Active"
    msgEnergyLow="BioElectric energy low!"
    msgCantLaunch="ERROR - No room for SpyDrone construction!"
    msgLightAmpActive="LightAmp Active"
    msgIRAmpActive="IRAmp Active"
    msgNoImage="Image Not Available"
    msgDisabled="Disabled"

//----------------------------------------------------------------------------------------------------------------------
    OverrideConsoleFontName="DXFonts.MSS_9"

    ProgressFontName="DXFonts.MSS_8"
    FontArrayNames(0)="DXFonts.MSS_9"
    FontArrayNames(1)="DXFonts.MSS_9"
    FontArrayNames(2)="DXFonts.MSS_9"
    FontArrayNames(3)="DXFonts.MSS_9"
    FontArrayNames(4)="DXFonts.MSS_9"
    FontArrayNames(5)="DXFonts.MSS_9"
    FontArrayNames(6)="DXFonts.MSS_9"
    FontArrayNames(7)="DXFonts.MSS_9"
    FontArrayNames(8)="DXFonts.MSS_9"

//    ProgressFontName="DXFonts.EUR_12"
/*    FontArrayNames(0)="DXFonts.EUX_9"
    FontArrayNames(1)="DXFonts.EUX_9"
    FontArrayNames(2)="DXFonts.EUX_9"
    FontArrayNames(3)="DXFonts.EUX_9"
    FontArrayNames(4)="DXFonts.EUX_9"
    FontArrayNames(5)="DXFonts.EUX_9"
    FontArrayNames(6)="DXFonts.EUX_9"
    FontArrayNames(7)="DXFonts.EUX_9"
    FontArrayNames(8)="DXFonts.EUX_9"
*/
    FontScreenWidthMedium(0)=2048
    FontScreenWidthMedium(1)=1600
    FontScreenWidthMedium(2)=1280
    FontScreenWidthMedium(3)=1024
    FontScreenWidthMedium(4)=800
    FontScreenWidthMedium(5)=640
    FontScreenWidthMedium(6)=512
    FontScreenWidthMedium(7)=400
    FontScreenWidthMedium(8)=320

    FontScreenWidthSmall(0)=4096
    FontScreenWidthSmall(1)=3200
    FontScreenWidthSmall(2)=2560
    FontScreenWidthSmall(3)=2048
    FontScreenWidthSmall(4)=1600
    FontScreenWidthSmall(5)=1280
    FontScreenWidthSmall(6)=1024
    FontScreenWidthSmall(7)=800
    FontScreenWidthSmall(8)=640

    colAmmoText=(R=0,G=255,B=0,A=255)
    colAmmoLowText=(R=255,G=0,B=0,A=255)

    cubemapmode=false
    bDrawFrobBox=true
}

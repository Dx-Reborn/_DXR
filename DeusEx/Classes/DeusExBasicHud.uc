/*-------------------------------------------------------------------------------------------------------
  ������� ���. ��� �������� ������� ����������� �����.
  ���� ��������� (���������� � �������� ����� DeusExHUD)
  ������
  ��������� �������
  ����������� � �����������

  ����������: ��������� HUD � UT2004 �� ���� HUD �� ���������!
  15/06/2017: ������� GetColorScaled(float percent) ��������� � Core.u
  30/12/2017: ������� �������� ������� � ����������.

  ����� �������� ��������� �� ������ (pawn) ����� ����������:
  ... DeusExPlayer(Playerowner.pawn)

  ���������� ����� DrawHUD �� ������������, ������� ����� �����������
  ��� ����, ���������� ���� � �.�., � ������ ����� ���������� HUD.
  21/06/2018: ��� ��� ����������� �������� ���� ? :))) 
  11/07/2018: ���������� ������������ ����������� � ������� � ����.
  18/06/2020: ���������� ��������� ����������� (�� ������ ���� ��� �� GMDX)
-------------------------------------------------------------------------------------------------------*/


#exec OBJ LOAD FILE=DeusExUIExtra
#exec OBJ LOAD FILE=DxFonts
#exec OBJ LOAD FILE=Effects
#EXEC OBJ LOAD FILE=GuiContent.utx

class DeusExBasicHUD extends HUD;

// ������������ ��������� ��� ������ �����������
// CullDistance ��� ScriptedPawn ����� 8000.
const TRACE_LOS_DIST = 8000;

struct sToolBeltSelectedItem
{
  var() int positionX;
  var() int positionY;
};
var(toolbelt) sToolBeltSelectedItem toolbeltSelPos[10];


var(ThemeColors) color MessageBG;   // ��� ���������
var(ThemeColors) color MessageText; // ����� ���������
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
var Color crossColor; // ���� �����������

var transient DxCanvas dxc; // Transient ��� ������������

// �� FrobDisplayWindow
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
var texture ItemNameBoxT;
var texture HudHitBase, HudHitFrame, HudHitBody,HudHitArmL,  HudHitArmR,HudHitLegL, HudHitLegR,HudHitHead, HudHitTorso;
var material HitMarkerMat;
var material INBox;

var PlayerController Player;

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
var bool bUseAltVBarTexture;

var bool bUnderwater;
var float   breathPercent;
var float o2cr; // ��������� ���������� ���������

var bool cubemapmode, menuMode, midMenuMode;  // cubemapmode � menuMode ��������� ���� ���, midMenuMode ����������� �������� �� ����.

var bool bDrawInfo;

var bool bDefenseActive;
var int defenseLevel;
var DeusExProjectile defenseTarget;

var bool bSpyDroneActive;
var int spyDroneLevel;
var float spyDroneLevelValue;
var SpyDrone aDrone;

var bool bTargetActive;
var int targetLevel;
var Actor lastTarget;
var float lastTargetTime;

var bool bVisionActive;
var int visionLevel;
var float visionLevelValue;
var int activeCount;

// ����� �������, ��������� ������ ��� ��������� ����� �������.
//var array<Inventory> recentItems;

var bool bTalking;
var bool bIncoming;
var bool bDrawCrossHair, bDrawHealth, bDrawFrobBox;
var float textYStep, textYStart, ttySize, ttyCounter, ttyRate, ttyCRate, resistance;

var float recentItemTime, recentPainTime;
// <<

// ��������� �� �����
// �������� � DeusExLevelInfo (TrueNorth)
var Int mapNorth;

// ��� ���������� �������.
var ConPlay ConPlay;

var float sinTable[16];
var int   maxPoints;


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





//=======================================================================
// ��������� AugmentationDisplayWindow
//=======================================================================

// SpyDrone: ������ �� ��������, �������� ����� ��� � ���������.
// ����������� ����� �������� �� DeusExPlayerController.
function DrawSpyDroneAugmentation(Canvas c)
{
    local String str;
    local float boxCX, boxCY, boxTLX, boxTLY, boxBRX, boxBRY, boxW, boxH;
    local float x, y, w, h;//, mult;
    local Vector loc;

    // set the coords of the drone window
    boxW = c.SizeX/4;
    boxH = c.SizeY/4;
    boxCX = c.SizeX/8 + marginX;
    boxCY = c.SizeY/2;
    boxTLX = boxCX - boxW/2;
    boxTLY = boxCY - boxH/2;
    boxBRX = boxCX + boxW/2;
    boxBRY = boxCY + boxH/2;

        str = msgDroneActive;
        c.textsize(str, w,h);
        x = boxCX - w/2;
        y = boxTLY - h - marginX;
        c.SetPos(x,y);
        c.DrawText(str);

    if (aDrone == None)
    {
        loc = (2.0 + class'SpyDrone'.Default.CollisionRadius + Playerowner.pawn.CollisionRadius) * Vector(Playerowner.pawn.GetViewRotation());
        loc.Z = Playerowner.pawn.BaseEyeHeight;
        loc += Playerowner.pawn.Location;
        aDrone = Playerowner.pawn.Spawn(class'SpyDrone', Playerowner.pawn,, loc, Playerowner.pawn.Rotation);
    }
        if (aDrone != None)
        {
            aDrone.Speed = 3 * spyDroneLevelValue;
            aDrone.MaxSpeed = 3 * spyDroneLevelValue;
            aDrone.Damage = 5 * spyDroneLevelValue;
            aDrone.blastRadius = 8 * spyDroneLevelValue;

            c.reset();
            C.Font = LoadProgressFont();
            C.DrawActor(None, false, true); // Clear the z-buffer here
            c.DrawPortal(boxTLX, boxTLY, boxW,boxH, aDrone, aDrone.Location, aDrone.Rotation, 90);
            DrawDropShadowBox(c, boxTLX, boxTLY, boxW, boxH);

                    // print a low energy warning message
                if ((Human(Playerowner.pawn).Energy / Human(Playerowner.pawn).Default.Energy) < 0.2)
                {
                str = msgEnergyLow;
                c.TextSize(str, w, h);
                x = boxCX - w/2;
                y = boxTLY + marginX;
                c.SetDrawColor(255,0,0);
                c.SetPos(x,y);
                c.DrawText(str);
                c.DrawColor = colHeaderText;
                }

        }
        else
            Playerowner.ClientMessage(msgCantLaunch);
}


// ----------------------------------------------------------------------
// DrawTargetAugmentation()
// ----------------------------------------------------------------------
// ���� �������� � ������������ �������, ��� ������ ���� �� ����.
function DrawTargetAugmentation(Canvas C)
{
    local String str, strG;
    local Actor target;
    local float boxCX, boxCY, boxTLX, boxTLY, boxBRX, boxBRY, boxW, boxH;//, XL;
    local float x, y, w, h, mult;//, x2, y2;
    local Vector v1, v2, sp1, sp2;
    local int i, j, k, r;
    local DeusExWeapon weapon;
    local bool bUseOldTarget;
    local vector AimLocation;
    local array<string> Lines;

    crossColor.R = 255;
    crossColor.G = 255;
    crossColor.B = 255;
    crossColor.A = 255;

    C.Font = LoadProgressFont();

    // check 500 feet in front of the player
    target = TraceLOS(TRACE_LOS_DIST, AimLocation);

    // draw targetting reticle information based on the weapon's accuracy
    // reticle size is based on accuracy - larger box = higher (worse) accuracy value
    // reticle shrinks as accuracy gets better (value decreases)
//    if ((target != None) && (!target.IsA('StaticMeshActor'))) // ��-��
    if (Target != None)
    {
        // get friend/foe color info
        if (target.IsA('ScriptedPawn'))
        {
            if (ScriptedPawn(target).GetPawnAllianceType(DeusExPawn(Playerowner.pawn)) == ALLIANCE_Hostile)
            {
                crossColor.R = 255;
                crossColor.G = 0;
                crossColor.B = 0;
            }
            else
            {
                crossColor.R = 0;
                crossColor.G = 255;
                crossColor.B = 0;
            }
        }

        weapon = DeusExWeapon(Playerowner.pawn.Weapon);
        if ((weapon != None) && !weapon.bHandToHand && !bUseOldTarget)
        {
            // if the target is out of range, don't draw the reticle
            if (weapon.MaxRange >= VSize(target.Location - Playerowner.pawn.Location))
            {
                w = c.sizeX;
                h = c.sizeY;
                x = int(w * 0.5)-1;
                y = int(h * 0.5)-1;

                // scale based on screen resolution - default is 640x480
                mult = FClamp(weapon.currentAccuracy * 80.0 * (c.sizeX/640.0), corner, 80.0);

                // make sure it's not too close to the center unless you have a perfect accuracy
                mult = FMax(mult, corner+4.0);
                if (weapon.currentAccuracy == 0.0)
                    mult = corner;

                // draw the drop shadowed reticle
                c.SetDrawColor(0,0,0);
                for (i=1; i>=0; i--)
                {
                    c.setpos(x+i, y-mult+i);
                    c.DrawTileStretched(texture'Solid', 1, corner);

                    c.setpos(x+i, y+mult-corner+i);
                    c.DrawTileStretched(texture'Solid', 1, corner);

                    c.setpos(x-(corner-1)/2+i, y-mult+i);
                    c.DrawTileStretched(texture'Solid', corner, 1);

                    c.setpos(x-(corner-1)/2+i, y+mult+i);
                    c.DrawTileStretched(texture'Solid', corner, 1);


                    c.setpos(x-mult+i, y+i);
                    c.DrawTileStretched(texture'Solid', corner, 1);

                    c.setpos(x+mult-corner+i, y+i);
                    c.DrawTileStretched(texture'Solid', corner, 1);

                    c.setpos(x-mult+i, y-(corner-1)/2+i);
                    c.DrawTileStretched(texture'Solid', 1, corner);

                    c.setpos(x+mult+i, y-(corner-1)/2+i);
                    c.DrawTileStretched(texture'Solid', 1, corner);

                    c.DrawColor = crossColor;
                }
            }
        }

        // movers are invalid targets for the aug
        if (target.IsA('DeusExMover'))
            target = None;
    }

    // let there be a 0.5 second delay before losing a target
    if (target == None)
    {
        if ((Playerowner.pawn.Level.TimeSeconds - lastTargetTime < 0.5)  && (lastTarget != none))
        {
            target = lastTarget;
            bUseOldTarget = True;

            if (target.IsA('ScriptedPawn')) // DXR: Set back to default if pawn is not our target.
               ScriptedPawn(Target).bOwnerNoSee = ScriptedPawn(Target).default.bOwnerNoSee;
        }
        else
        {
            lastTarget = None;
        }
    }
    else
    {
        lastTargetTime = Playerowner.Pawn.Level.TimeSeconds;
        bUseOldTarget = False;
        if (lastTarget != target)
        {
            lastTarget = target;
        }
    }

    if (target != None)
    {
        // draw a cornered targetting box
        v1.X = target.CollisionRadius;
        v1.Y = target.CollisionRadius;
        v1.Z = target.CollisionHeight;
            
            sp1 = C.WorldToScreen(target.Location);

            boxCX = sp1.X;
            boxCY = sp1.Y;

            boxTLX = boxCX;
            boxTLY = boxCY;
            boxBRX = boxCX;
            boxBRY = boxCY;

            // get the smallest box to enclose actor
            // modified from Scott's ActorDisplayWindow
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
                        v2.X += target.Location.X;
                        v2.Y += target.Location.Y;
                        v2.Z += target.Location.Z;

                            sp2 = C.WorldToScreen(v2);
                            x = sp2.X;
                            x = sp2.Y;

                            boxTLX = FMin(boxTLX, x);
                            boxTLY = FMin(boxTLY, y);
                            boxBRX = FMax(boxBRX, x);
                            boxBRY = FMax(boxBRY, y);
                    }
                }
            }

            boxTLX = FClamp(boxTLX, marginX, c.SizeX-marginX);
            boxTLY = FClamp(boxTLY, marginX, c.SizeY-marginX);
            boxBRX = FClamp(boxBRX, marginX, c.SizeX-marginX);
            boxBRY = FClamp(boxBRY, marginX, c.SizeY-marginX);

            boxW = boxBRX - boxTLX;
            boxH = boxBRY - boxTLY;

            if (bTargetActive)
            {
                // set the coords of the zoom window, and draw the box
                // even if we don't have a zoom window
                x = c.sizeX/8 + marginX;
                y = c.sizeY/2;
                w = c.sizeX/4;
                h = c.sizeY/4;

//              DrawDropShadowBox(c, x-w/2, y-h/2, w, h);

                boxCX = c.SizeX/8 + marginX;
                boxCY = c.SizeY/2;
                boxTLX = boxCX - c.SizeX/8;
                boxTLY = boxCY - c.SizeY/8;
                boxBRX = boxCX + c.SizeX/8;
                boxBRY = boxCY + c.SizeY/8;

                if (targetLevel > 2)
                {
                        mult = (target.CollisionRadius + target.CollisionHeight);
                        v1 = Playerowner.pawn.Location;
                        v1.Z += Playerowner.pawn.BaseEyeHeight;
                        v2 = 1.5 * Playerowner.pawn.Normal(target.Location - v1);

                        C.DrawActor(None, false, true); // Clear the z-buffer here

                        if (target.IsA('ScriptedPawn'))
                            ScriptedPawn(Target).bOwnerNoSee = false;

                        c.DrawPortal(boxTLX, boxTLY, w,h, target, target.Location - mult * v2, Playerowner.pawn.GetViewRotation(), 75);
                        DrawDropShadowBox(c, x-w/2, y-h/2, w, h);
                }
                else
                {
                    DrawDropShadowBox(c, x-w/2, y-h/2, w, h);
                    // black out the zoom window and draw a "no image" message
                    c.Style = ERenderStyle.STY_Normal;
                    c.SetDrawColor(0,0,0);
                    c.setpos(boxTLX, boxTLY);
                    c.DrawPattern(texture'solid', w,h, 1); 

                    c.SetDrawColor(255,255,255);
                    c.drawcolor.a=255;
                    c.TextSize(msgNoImage, w, h);
                    x = boxCX - w/2;
                    y = boxCY - h/2;
                    c.SetPos(x,y);
                    c.DrawText(msgNoImage);
                }

                // print the name of the target above the box
                if (target.IsA('ScriptedPawn'))
                    str = ScriptedPawn(target).BindName;
                else if (target.IsA('DeusExDecoration'))
                    str = DeusExDecoration(target).itemName;
                else if (target.IsA('DeusExProjectile'))
                    str = DeusExProjectile(target).itemName;
                else
                    str = target.GetItemName(String(target.Class));

                // print disabled robot info
                if (target.IsA('Robot') && (Robot(target).EMPHitPoints == 0))
                    str = str $ " (" $ msgDisabled $ ")";
                c.SetDrawColor(crossColor.r, crossColor.g, crossColor.b);

                // print the range to target
                mult = VSize(target.Location - Playerowner.pawn.Location);
                /*str = str $ CR() $*/ strG = msgRange @ Int(mult/16) @ msgRangeUnits;

                c.textsize(str, w,h);
                x = boxTLX + marginX;
                y = boxTLY - h - marginX;
                c.SetPos(x,y);
                c.DrawText(str);
                c.SetPos(x,y+20);
                c.DrawText(strG);

                // level zero gives very basic health info
                if (target.IsA('ScriptedPawn'))
                    mult = Float(ScriptedPawn(target).Health) / Float(ScriptedPawn(target).Default.Health);
                else if (target.IsA('DeusExDecoration'))
                    mult = Float(DeusExDecoration(target).HitPoints) / Float(DeusExDecoration(target).Default.HitPoints);
                else
                    mult = 1.0;

                if (targetLevel == 0)
                {
                    // level zero only gives us general health readings
                    if (mult >= 0.66)
                    {
                        str = msgHigh;
                        mult = 1.0;
                    }
                    else if (mult >= 0.33)
                    {
                        str = msgMedium;
                        mult = 0.5;
                    }
                    else
                    {
                        str = msgLow;
                        mult = 0.05;
                    }

                    str = str @ msgHealth;
                }
                else
                {
                    // level one gives exact health readings
                    str = Int(mult * 100.0) $ msgPercent;
                    if (target.IsA('ScriptedPawn') && !target.IsA('Robot') && !target.IsA('Animal'))
                    {
                        x = mult;       // save this for color calc
                        str = str @ msgOverall;
                        mult = Float(ScriptedPawn(target).HealthHead) / Float(ScriptedPawn(target).Default.HealthHead);
                        str = str $ CR() $ Int(mult * 100.0) $ msgPercent @ msgHead;
                        mult = Float(ScriptedPawn(target).HealthTorso) / Float(ScriptedPawn(target).Default.HealthTorso);
                        str = str $ CR() $ Int(mult * 100.0) $ msgPercent @ msgTorso;
                        mult = Float(ScriptedPawn(target).HealthArmLeft) / Float(ScriptedPawn(target).Default.HealthArmLeft);
                        str = str $ CR() $ Int(mult * 100.0) $ msgPercent @ msgLeftArm;
                        mult = Float(ScriptedPawn(target).HealthArmRight) / Float(ScriptedPawn(target).Default.HealthArmRight);
                        str = str $ CR() $ Int(mult * 100.0) $ msgPercent @ msgRightArm;
                        mult = Float(ScriptedPawn(target).HealthLegLeft) / Float(ScriptedPawn(target).Default.HealthLegLeft);
                        str = str $ CR() $ Int(mult * 100.0) $ msgPercent @ msgLeftLeg;
                        mult = Float(ScriptedPawn(target).HealthLegRight) / Float(ScriptedPawn(target).Default.HealthLegRight);
                        str = str $ CR() $ Int(mult * 100.0) $ msgPercent @ msgRightLeg;
                        mult = x;
                    }
                    else
                    {
                        str = str @ msgHealth;
                    }
                }

                C.Font = LoadProgressFont();
                C.StrLen(str, w, h);
                C.WrapStringToArray(str, Lines, w, "|");
                x = boxTLX + marginX;
                y = boxTLY + marginX;
                C.DrawColor = GetColorScaled(mult);
                C.DrawColor.A=255;
                    for ( r = 0; r < Lines.Length; r++ )
                    {
                        C.SetPos(x,y += 15);
                    C.DrawText(lines[r]);
                }
                C.DrawColor = colHeaderText;

                if (targetLevel > 1)
                {
                    // level two gives us weapon info as well
                    if (target.IsA('Pawn'))
                    {
                        str = msgWeapon;

                        if (Pawn(target).Weapon != None)
                            str = str @ target.GetItemName(String(Pawn(target).Weapon.Class));
                        else
                            str = str @ msgNone;

                        c.textsize(str, w,h);
                        x = boxTLX + marginX;
                        y = boxBRY - h - marginX;
                        c.setpos(x,y);
                        c.drawtext(str);
                    }
                }
            }
            else
            {
                // display disabled robots
                if (target.IsA('Robot') && (Robot(target).EMPHitPoints == 0))
                {
                    str = msgDisabled;
                    crossColor.A = 255;
                    c.drawColor = crossColor;
                    c.textsize(str, w,h);
                    x = boxCX - w / 2;// �����. - c.SizeX / 2; //w/2;
                    y = boxTLY + h + marginX;

                    c.SetPos(200,200);
                    c.DrawText("Robots: X = "$x$" Y = "$y $ "  boxTLY = "$boxTLY$"  boxTLX = "$boxTLX);

                    c.setpos(x,y);
                    c.drawtext(str);
                }
            }
    }
    else if (bTargetActive)
    {
        if (Playerowner.pawn.Level.TimeSeconds % 1.5 > 0.75)
            str = msgScanning1;
        else
            str = msgScanning2;
        c.textsize(str, w,h);
        x = c.SizeX/2 - w/2;
        y = (c.sizeY/2 - h) - 20;
        c.setpos(x,y);
        c.DrawText(str);
    }
 c.ReSet();
    // set the crosshair colors
//  DeusExRootWindow(player.rootWindow).hud.cross.SetCrosshairColor(crossColor);
}

//
// AugDefense. ������ ���� ���! �������� ������� ����� �� ������������ ������
// NPC �������� ������� ������� :D
// �������� ��� � ���������, ������� �� ��������.
function DrawDefenseAugmentation(Canvas C)
{
    local String str, strA;
    local float boxCX, boxCY;
    local float x, y, w, h, mult;
    local bool bDrawLine;
    local vector sp1, EyePos, RelativeToPlayer;

    C.Font = LoadProgressFont();
    // ������ �������� �� AugDefense � ���������� 0.1 ���.
    if (defenseTarget != None)
    {
        bDrawLine = False;

        if (defenseTarget.IsInState('Exploding'))
        {
            str = msgADSDetonating;
            bDrawLine = True;
        }
        else
            str = msgADSTracking;

        mult = VSize(defenseTarget.Location - Playerowner.pawn.Location);
//      str = str $ Cr() $ msgRange @ Int(mult/16) @ msgRangeUnits;
        strA = msgRange @ Int(mult/16) @ msgRangeUnits;

//
        EyePos = Human(Playerowner.pawn).Location;
    EyePos.Z += Human(Playerowner.pawn).EyeHeight;

        RelativeToPlayer = (defenseTarget.Location - EyePos) << Human(Playerowner.pawn).GetViewRotation();
        if (RelativeToPlayer.X < 0.01)
        {
            str = str @ msgBehind;
        }
//
        sp1 = C.WorldToScreen(defenseTarget.Location);
        boxCX = sp1.X;
        boxCY = sp1.Y;

        c.TextSize(str, w, h);
        x = boxCX - w/2;
        y = boxCY - h;
        c.DrawColor = RedColor;

        c.SetPos(x,y);
        c.DrawText(str);
// ������� ������� ������������, ���� ������� ���������� �� ��������� ����� �������� :\
        c.SetPos(x + 20,y + 20);
        c.DrawText(strA);

        c.DrawColor = colHeaderText;

        if (bDrawLine)
        {
            c.DrawColor = RedColor;
            Interpolate(c, c.sizeX/2, c.sizeY/2, boxCX, boxCY, 64);
            c.DrawColor = colHeaderText;
        }
    }
}

//
// AugVision
// ���������: \/
/*native(1288) final function DrawActor(Actor actor, optional bool bClearZ,
                                      optional bool bConstrain, optional bool bUnlit,
                                      optional float drawScale, optional float scaleGlow,
                                      optional texture skin);

native(1285) final function DrawPattern(float destX, float destY,
                                        float destWidth, float destHeight,
                                        float orgX, float orgY,
                                        texture tx);*/
// ��������� ���������...
function DrawVisionAugmentation(Canvas C)
{
    local Vector loc;
    local float boxCX, boxCY, boxTLX, boxTLY, boxBRX, boxBRY, boxW, boxH;
    local float dist, x, y, w, h;
    local Actor A;
    local Material oldSkins[9];

    // �������� ���������
    C.ColorModulate.X = 8;
    C.ColorModulate.Y = 8;
    C.ColorModulate.Z = 8;
    C.ColorModulate.W = 8;

    boxW = C.SizeX / 2;
    boxH = C.SizeY / 2;
    boxCX = C.SizeX / 2;
    boxCY = C.SizeY / 2;
    boxTLX = boxCX - boxW/2;
    boxTLY = boxCY - boxH/2;
    boxBRX = boxCX + boxW/2;
    boxBRY = boxCY + boxH/2;

    // at level one and higher, enhance heat sources (FLIR)
    // use DrawActor to enhance NPC visibility
    if (visionLevel >= 1)
    {
        // shift the entire screen to dark red (except for the middle box)
        C.Style = ERenderStyle.STY_Modulated;

        c.SetPos(0,0);
        C.DrawTileStretched(Texture'ConWindowBackground',C.SizeX,boxTLY);

        c.SetPos(0,boxBRY);
        C.DrawTileStretched(Texture'ConWindowBackground',C.SizeX,C.SizeY-boxBRY);

        c.SetPos(0,boxTLY);
        C.DrawTileStretched(Texture'ConWindowBackground',boxTLX,boxH);

        c.SetPos(boxBRX,boxTLY);
        C.DrawTileStretched(Texture'ConWindowBackground',C.SizeX-boxBRX,boxH);
        //--//
        c.SetPos(0,0);
        C.DrawPattern(Texture'RedVisionVLined',C.SizeX,boxTLY,1);

        c.SetPos(0,boxBRY);
        C.DrawPattern(Texture'RedVisionVLined',C.SizeX,C.SizeY-boxBRY,1);

        c.SetPos(0,boxTLY);
        C.DrawPattern(Texture'RedVisionVLined',boxTLX,boxH,1);

        c.SetPos(boxBRX,boxTLY);
        C.DrawPattern(Texture'RedVisionVLined',C.SizeX-boxBRX,boxH,1); // SolidRed

        // adjust for the player's eye height
        loc = Human(Playerowner.pawn).Location;
        loc.Z += Human(Playerowner.pawn).BaseEyeHeight;

        // look for visible actors first
        foreach Human(Playerowner.pawn).VisibleActors(class'Actor', A,, loc)
            if (IsHeatSource(A))
            {
                SetSkins(A, oldSkins);
                A.bUnlit=true;
                c.DrawActor(A, false, true);
                ResetSkins(A, oldSkins);
            }

        // now look through walls
        if (visionLevel >= 2)
        {
            dist = visionLevelValue;
            foreach Human(Playerowner.pawn).RadiusActors(class'Actor', A, dist, loc)
                if (IsHeatSource(A))
                {
                    SetSkins(A, oldSkins);
                    A.bUnlit=true;
                    c.DrawActor(A, false, true);
                    ResetSkins(A, oldSkins);
                }
        }

            // draw text label
            C.Style = ERenderStyle.STY_Normal;
            C.TextSize (msgIRAmpActive, w, h);
            x = boxTLX + marginX;
            y = boxTLY - marginX - h;
            C.SetDrawColor(255,255,255);
            c.SetPos(x,y);
            C.DrawText(msgIRAmpActive);
    }

    // shift the middle of the screen green (NV) and increase the contrast
    C.Style = ERenderStyle.STY_Modulated;
    c.SetPos(boxTLX, boxTLY);
    C.SetDrawColor(32,255,16);
    C.DrawPattern(Texture'GreenVisionLined',boxW,boxH,1); // ��� �� ���� ���� ������ ������!
    c.SetPos(boxTLX, boxTLY);
    C.DrawPattern(Texture'GreenVisionLined',boxW,boxH,1);
    C.Style = ERenderStyle.STY_Normal;

    DrawDropShadowBox(c, boxTLX, boxTLY, boxW, boxH);

    // draw text label
    C.TextSize (msgLightAmpActive, w, h);
    x = boxTLX + marginX;
    y = boxTLY + marginX;
    C.SetDrawColor(255,255,255);
    c.SetPos(x,y);
    C.DrawText(msgLightAmpActive);
}



// <��������� �������>
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function bool GetAssignedKeys( string BindAlias, out array<string> BindKeyNames, out array<string> LocalizedBindKeyNames )
{
    local int i, iKey;
    local string s;

    BindKeyNames.Length = 0;
    LocalizedBindKeyNames.Length = 0;
    s = PlayerOwner.ConsoleCommand("BINDINGTOKEY" @ "\"" $ BindAlias $ "\"");
    if ( s != "" )
    {
        Split(s, ",", BindKeyNames);
        for ( i = 0; i < BindKeyNames.Length; i++ )
        {
            iKey = int(PlayerOwner.ConsoleCommand("KEYNUMBER" @ BindKeyNames[i]));
            if ( iKey != -1 )
                LocalizedBindKeyNames[i] = PlayerOwner.ConsoleCommand("LOCALIZEDKEYNAME" @ iKey);
        }
    }
    return BindKeyNames.Length > 0;
}

function bool GetAugBind(string BindKeyName, out string BindKeyValue)
{
    if (BindKeyName != "")
    {
        BindKeyValue = PlayerOwner.ConsoleCommand("KEYBINDING" @ BindKeyName);
        return BindKeyValue != "";
    }
    return false;
}


function GetMapTrueNorth()
{
    local DeusExLevelInfo info;

    if (player != None) 
    {
        info = Human(Playerowner.pawn).GetLevelInfo();

        if (info != None)
            mapNorth = info.TrueNorth;
    }
}

// ������� ������
function String CR()
{
    return "|";
}

// ----------------------------------------------------------------------
// IsHeatSource()
// ----------------------------------------------------------------------

function bool IsHeatSource(Actor A)
{
    if (A.IsA('ScriptedPawn'))
        return True;
    else if (A.IsA('DeusExCarcass'))
        return True;
    else if (A.IsA('FleshFragment'))
        return True;
    else
        return False;
}

// ----------------------------------------------------------------------
// TraceLOS()
// ----------------------------------------------------------------------
function Actor TraceLOS(float checkDist, out vector HitLocation)
{
    local Actor target;
    local Vector HitLoc, HitNormal, StartTrace, EndTrace;
    local Human DXR;

    target = None;

    // figure out how far ahead we should trace
    StartTrace = PlayerOwner.Pawn.Location;
    EndTrace = PlayerOwner.Pawn.Location + (Vector(Player.GetViewRotation()) * checkDist);

    // adjust for the eye height
    StartTrace.Z += PlayerOwner.Pawn.BaseEyeHeight;
    EndTrace.Z += PlayerOwner.Pawn.BaseEyeHeight;

    // find the object that we are looking at
    // make sure we don't select the object that we're carrying
    DXR = Human(PlayerOwner.pawn);
    foreach DXR.TraceActors(class'Actor', target, HitLoc, HitNormal, EndTrace, StartTrace)
    {
      if (target.bWorldGeometry) //DXR: Not StaticMeshes.
      {
         target = none;
         break;
      }
        //G-Flex: allow remote viewing of corpses too
        //G-Flex: don't allow viewing of trash
        //Bjorn: View pickups that are projectile targets.
        if (target.IsA('Pawn') || target.IsA('DeusExCarcass') || (target.IsA('DeusExDecoration') && !target.IsA('Trash')) || target.IsA('ThrownProjectile') ||
            (target.IsA('DeusExMover') || (target.IsA('Inventory') && Inventory(target).bProjTarget)))
        {                                                              
            //== Y|y: don't find hidden objects
            if (target.bHidden)
                target = None;
            else if (target != DXR.CarriedDecoration)
            {
                //G-Flex: disallow viewing of invincible, no-highlight decorations like trees
                if (target.IsA('DeusExDecoration'))
                {
                    if (!DeusExDecoration(target).bInvincible || DeusExDecoration(target).bHighlight)
                        break;
                }
                else
                    break;
            }
        }
    }
    HitLocation = HitLoc;
    return target;
}

// ----------------------------------------------------------------------
// Interpolate()
// ----------------------------------------------------------------------
function Interpolate(Canvas C, float fromX, float fromY, float toX, float toY, int power)
{
    local float xPos, yPos;
    local float deltaX, deltaY;
    local float maxDist;
    local int   points;
    local int   i;

    maxDist = 16;

    points = 1;
    deltaX = (toX-fromX);
    deltaY = (toY-fromY);
    while (power >= 0)
    {
        if ((deltaX >= maxDist) || (deltaX <= -maxDist) || (deltaY >= maxDist) || (deltaY <= -maxDist))
        {
            deltaX *= 0.5;
            deltaY *= 0.5;
            points *= 2;
            power--;
        }
        else
            break;
    }

    xPos = fromX + ((Playerowner.pawn.Level.TimeSeconds % 0.5) * deltaX * 2);
    yPos = fromY + ((Playerowner.pawn.Level.TimeSeconds % 0.5) * deltaY * 2);

    for (i=0; i<points-1; i++)
    {
        xPos += deltaX;
        yPos += deltaY;
        C.SetPos(xPos, yPos);
        C.DrawTileStretched(Texture'Solid', 2, 2);
    }
}

// ��������������� ������� �� ActorDisplayWindow //
// ������ ������� ��������.                      //
function DrawCylinder(Canvas c, actor trackActor)
{
    local int         i;
    local vector      topCircle[8];
    local vector      bottomCircle[8];
    local float       topSide, bottomSide;
    local int         numPoints;

        topSide = trackActor.Location.Z + trackActor.CollisionHeight;
        bottomSide = trackActor.Location.Z - trackActor.CollisionHeight;
        for (i=0; i<maxPoints; i++)
        {
            topCircle[i] = trackActor.Location;
            topCircle[i].Z = topSide;
            topCircle[i].X += sinTable[i]*trackActor.CollisionRadius;
            topCircle[i].Y += sinTable[i+maxPoints/4]*trackActor.CollisionRadius;
            bottomCircle[i] = topCircle[i];
            bottomCircle[i].Z = bottomSide;
        }
        numPoints = maxPoints;

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

//  if (ConvertVectorToCoordinates(point1, fromX, fromY) && ConvertVectorToCoordinates(point2, toX, toY))
//  {
    c.Style=ERenderStyle.STY_Normal;

        c.SetDrawColor(255, 255, 255);
        DrawPoint(c, fromX, fromY);
        DrawPoint(c, toX, toY);

        c.SetDrawColor(128, 128, 128);
        Interpolate(c, fromX, fromY, toX, toY, 8);
//  }
}

function DrawPoint(Canvas c, float xPos, float yPos)
{
    c.SetPos(xPos, yPos);
    c.DrawTilePartialStretched(Texture'Solid',1, 1);
}




// ----------------------------------------------------------------------
// SetSkins()
//
// copied from ActorDisplayWindow
// ----------------------------------------------------------------------

function SetSkins(Actor actor, out Material oldSkins[9])
{
    actor.OverlayMaterial = material'GuiContent.back.AUGVIS_Shader';
//  local int     i;
//  local material curSkin;

//  for (i=0; i<8; i++)
//      oldSkins[i] = actor.Skins[i];
//  oldSkins[i] = actor.Skin;

//  for (i=0; i<8; i++)
//  {
//      curSkin = actor.GetMeshTexture(i);
//      actor.Skins[i] = GetGridTexture(curSkin);
//  }
//  actor.Skin = GetGridTexture(oldSkins[i]);
}

// ----------------------------------------------------------------------
// ResetSkins()
//
// copied from ActorDisplayWindow
// ----------------------------------------------------------------------

function ResetSkins(Actor actor, Material oldSkins[9])
{
        actor.Overlaymaterial = none;
//  local int i;

//  for (i=0; i<8; i++)
//      actor.Skins[i] = oldSkins[i];
//  actor.Skin = oldSkins[i];
}

// ----------------------------------------------------------------------
// DrawDropShadowBox()
// ----------------------------------------------------------------------

function DrawDropShadowBox(Canvas C, float x, float y, float w, float h)
{
    local Color oldColor;

    oldColor = C.DrawColor; // ��������� ����
    C.SetDrawColor(0,0,0);
    C.Style = ERenderStyle.Sty_Normal; //STY_Modulated;

    C.SetPos(x, y+h+1);
    C.DrawTileStretched(texture'ShadowBox',w+2,1);

    C.SetPos(x+w+1, y);
    C.DrawTileStretched(texture'ShadowBox',1,h+2);

    C.SetDrawColor(128,128,128);

    C.SetPos(x-1,y-1);
    C.DrawTileStretched(texture'ShadowBox', w+2, h+2);

    C.SetDrawColor(oldColor.R,oldColor.G,oldColor.B, oldColor.A);
}

// ----------------------------------------------------------------------
// FormatString()
// ----------------------------------------------------------------------

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

// Based on UnrealWiki examples
/*function bool ConvertVectorToCoordinates(canvas C, vector loc,out float relativeX,out float relativeY)
{
    local vector EyePos, RelativeToPlayer;

    C.WorldToScreen(loc);

    relativeX=loc.X;
    relativeY=loc.Y;

     EyePos = Human(Playerowner.pawn).Location;
   EyePos.Z += Human(Playerowner.pawn).EyeHeight;

    RelativeToPlayer = (loc - EyePos) << Human(Playerowner.pawn).GetViewRotation();
    if (RelativeToPlayer.X < 0.01)
    {
//          log("false");
      return false;
  }
//log("true");
return true;
}*/

function AddTextMessage(string M, class<LocalMessage> MessageClass, PlayerReplicationInfo PRI)
{
    local int i;
    if( bMessageBeep && MessageClass.Default.bBeep )
        PlayerOwner.PlayBeepSound();

    for( i=0; i<ConsoleMessageCount; i++ )
    {
        if ( TextMessages[i].Text == "" )
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

/* Specific function to use Canvas.DrawActor()
 Clear Z-Buffer once, prior to rendering all actors */
// ������� ��� �������� ������.
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

// >��������� �������<
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


function UpdateHud()
{
 Player = PlayerOwner; //Level.GetLocalPlayerController();

 if (player != none)
 {
     If (Human(Playerowner.pawn)!=none) // && Human(player.pawn).Health > 0)
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
            if (Human(Playerowner.Pawn).HeadVolume.bWaterVolume)
            {
                // if we are still underwater
                breathPercent = 100.0 * Human(Playerowner.pawn).swimTimer / Human(Playerowner.pawn).swimDuration;
                breathPercent = FClamp(breathPercent, 0.0, 100.0);
            }
            else
            {
                // if we are getting out of the water
                bUnderwater = False;
                breathPercent = 100;
            }
        }
        else if (Human(Playerowner.Pawn).HeadVolume.bWaterVolume)
        {
            // if we just went underwater
            bUnderwater = True;
            breathPercent = 100;
        }
     }
        if (!bSpyDroneActive)
        {
            if (aDrone != None)
            {
                aDrone.TakeDamage(100, None, aDrone.Location, vect(0,0,0), class'DM_EMP');
                aDrone = None;
            }
        }
 }
}

event SetInitialState()
{
    local int i; // ���������� �� ActorDisplayWindow > InitWindow()<<

    maxPoints = 8;
    for (i=0; i<maxPoints*2; i++)
        sinTable[i] = sin(2*3.1415926*(i/float(maxPoints)));
        //>>

    GetMapTrueNorth();
    ConsoleMessageCount=8; // Human(player.pawn).MaxLogLines;

    dxc = new(none) class'DxCanvas';

    Super.SetInitialState();
}


// TODO: �������� ������� ��� ��������� � ���������� ��� ��� ��� ������
// ����� ������������ ���������� �� ���������.
event PostRender(canvas C)
{
    super.postrender(C);
    if ((cubemapmode) || (playerOwner.pawn == none))
    return;

    if (menuMode)
    {
      c.setPos(0,0);
      c.style = ERenderStyle.STY_Normal;
      c.SetDrawColor(1,1,1,255);
      c.DrawTileStretched(texture'solid', c.SizeX, c.SizeY);
/*    c.setPos(0,0);
    c.style = ERenderStyle.STY_Modulated; //ERenderStyle.STY_Normal;
    c.DrawTileStretched(texture'ConWindowBackground', c.SizeX, c.SizeY);*/

      return;
    }

    if (midMenuMode)
    {
//    s = class'DeusExGlobals'.default.lastScreenShot;
    //  if (s != none)
//    {
        c.setPos(0,0);
      c.style = ERenderStyle.STY_Modulated; //ERenderStyle.STY_Normal;
      c.DrawTileStretched(texture'ConWindowBackground', c.SizeX, c.SizeY);
//      c.SetDrawColor(64,64,64,255);
//      c.DrawTile(s, c.SizeX, c.SizeY, 0, 256, 512, 256);
//      c.DrawTile(texture'ConWindowBackground', c.SizeX, c.SizeY, 0, 256, 512, 256);
//    }
      return;
    }

// �������� ��������� � AugVision.

        if (bVisionActive)
        {
            DrawVisionAugmentation(C);
        }
        if (bDefenseActive)
        {
            DrawDefenseAugmentation(C);
        }
        if (bSpyDroneActive)
        {
            DrawSpyDroneAugmentation(C);
        }

      RenderPoisonEffectGray(C);
      RenderPoisonEffectGreen(C);
      RenderFrobTarget(C);
      RenderSmallHUDHitDisplay(C);
      RenderCrosshair(C);
      RenderHitMarker(c);
      DisplayMessages(C);
      RenderCompass(C); // ������
      RenderToolBelt(C); // ������� ������
      RenderAugsBelt(C); // ��������������� �����������
      RenderAmmoDisplay(C);
      DrawTargetAugmentation(C);
      RenderChargedPickups(C);

// DrawActor( Actor A, bool WireFrame, optional bool ClearZ, optional float DisplayFOV ) 
//    c.DrawActor(None, false, true); // Clear the z-buffer here
}

function DrawHud(Canvas C)
{
    if (playerowner.pawn != none)
    {
        UpdateHud();
    }
    super.drawhud(C);
}

//
// ��������� � ������� ���� ������ �� ��������� �
// ���������� �����. ������� � ������� ��� �����.
//
function RenderCrosshair(Canvas C)
{
   local float X,Y;
   local string MSTarget;

   if (bDrawInfo)
   return;

   X = C.ClipX * 0.5 + CrosshairCorrectionX;
   Y = C.ClipY * 0.5 + CrosshairCorrectionY;

    if (DeusExPlayer(PlayerOwner.pawn).bCrosshairVisible)
    {
      C.SetPos(X,Y);
      c.DrawColor = crossColor;
      C.DrawIcon(CrosshairTex, 1);
    }

    if (DeusExWeapon(DeusExPlayer(playerowner.pawn).weapon) != none)
    {
      if (DeusExWeapon(DeusExPlayer(playerowner.pawn).weapon).bCanTrack == true)
      {
         MStarget = DeusExWeapon(DeusExPlayer(playerowner.pawn).weapon).TargetMessage;
         c.SetPos(X + 35,Y + 35); // ����� �� ����������� ������
         c.font=font'DxFonts.EUX_8'; //font'DxFonts.TB_9';

            if (DeusExWeapon(DeusExPlayer(playerowner.pawn).weapon).LockMode == LOCK_Locked)
                c.SetDrawColor(255,0,0); // �������
            else if (DeusExWeapon(DeusExPlayer(playerowner.pawn).weapon).LockMode == LOCK_Acquire)
                c.SetDrawColor(255,255,0); // ������
            else
                c.SetDrawColor(0,255,0); // �������
         c.DrawText(MStarget);
      }
  }
}

function RenderHitMarker(canvas c)
{
   local float X,Y;

   if (bDrawInfo)
   return;

   if (playerowner.pawn == None)
   return;

   if (PlayerPawn(playerowner.pawn).HitMarkerTime > 0.05)
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
   if (DeusExPlayer(playerowner.pawn).bHUDBackgroundTranslucent)
       c.Style = ERenderStyle.STY_Translucent;
          else
             c.Style = ERenderStyle.STY_Normal;
   C.DrawColor = HealthBG;
   C.SetPos(11,11);
     C.DrawIcon(HudHitBase,1);

   if (DeusExPlayer(Level.GetLocalPlayerController().pawn).bHUDBordersVisible)
   {
     if (DeusExPlayer(Level.GetLocalPlayerController().pawn).bHUDBordersTranslucent)
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
     C.DrawIcon(HudHitHead,1);

   C.SetPos(26,28);
   C.DrawColor = GetColorScaled(HealthArmRight / 100);
     C.DrawIcon(HudHitArmR,1);

   C.SetPos(C.CurX-6,C.CurY-2);
   C.DrawColor = GetColorScaled(HealthTorso / 100);
     C.DrawIcon(HudHitTorso,1);

   C.SetPos(C.CurX-6,C.CurY+2);
   C.DrawColor = GetColorScaled(HealthArmLeft / 100);
     C.DrawIcon(HudHitArmL,1);

   C.SetPos(33,45);
   C.DrawColor = GetColorScaled(HealthLegRight / 100);
     C.DrawIcon(HudHitLegR,1);

   C.SetPos(C.CurX,C.CurY);
   C.DrawColor = GetColorScaled(HealthLegLeft / 100);
     C.DrawIcon(HudHitLegL,1);


     // From Reborn
   C.SetPos(14,77);
   C.SetDrawColor(0,255,0);
   C.Font = Font'DXFonts.FontMenuSmall_DS';
   C.DrawText("BE");

   C.SetPos(15,20 + 55*(1.0 - (BioEnergy / BioEnergyMax))); // ������� ��� ����������
     C.DrawColor=GetColorScaled(BioEnergy / BioEnergyMax); // �������� �� �������� � ��������...
     C.DrawColor.A=255;

     C.Style = ERenderStyle.STY_Normal;

// ������ ��������� �������...
//   if (bUseAltVBarTexture) // �� ���������...
//    C.DrawTilePartialStretched(TexScaler'EpicParticles.Shaders.TexScaler2', 5, Abs(BioEnergy / BioEnergyMax)*55);
//    else  // ...��� �� ������ �������� ������ ����������.
        C.DrawTileStretched(texture'Solid', 5, Abs(BioEnergy / BioEnergyMax)*55);
// ------------------------------------------------
// ������ ��������� ���������...

    if (bUnderwater)
    {
        breathPercent = 100.0 * Human(Playerowner.pawn).swimTimer / Human(Playerowner.pawn).swimDuration;
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

     C.SetPos(o2BarPosX,o2BarPosY * o2cr - (0.55 * breathPercent)); // ������� ��� ����������
     C.DrawColor=GetColorScaled(0.01 * breathPercent); // �������� �� �������� � ��������...
     C.DrawColor.A=255;
     C.DrawTileStretched(texture'Solid', 5, breathPercent * 0.55);
     }
}

// ��� ����������� ������� (���� ���������)
// 10/06/17 ��� ����������� ������� ��� � ���������
function RenderFrobTarget(Canvas C)
{
   local float  X,Y, tH,tW, nH, nW;
   local Actor  FrobName;
   local String FrobStr;
   local int      numTools;
   local string   strInfo;

   local vector sp1, sp2;
   local Vector            centerLoc, v1, v2, v3;
   local float             boxCX, boxCY, boxTLX, boxTLY, boxBRX, boxBRY, boxW, boxH;
   local float             fcorner;//, xF, yF;
   local int               i, j, k, offset;
   local DeusExMover fMover;

   if (!bDrawFrobBox)
       return;

   X=C.ClipX * 0.5;
   Y=C.ClipY * 0.5;
   C.SetPos(X,Y);

   C.Font = LoadProgressFont();
   FrobName = DeusExPlayer(playerOwner.pawn).frobTarget; //DeusExPlayerController(Player).FrobTarget;

   if ((FrobName != None) && (DeusExPlayerController(Player).IsHighlighted(frobName)) && (!bDrawInfo))
   {
        // ��������� �����
//          offset = (24.0 * (frobname.Level.TimeSeconds % 0.3)); // Original
            offset = (14.0 * (frobname.Level.TimeSeconds % 0.6)); // Reborn

            fMover = DeusExMover(FrobName);

            if (fMover != none)
            {
                fMover.GetBoundingBox(v1, v2);
                centerLoc = v1 + (v2 - v1) * 0.5;

                // ���� ������� DeusExMover �� ��������������� ������.
                fMover.GetBoundingBoxSize(v3);
                if (vSize(v3) > 100) // ��� ����������� ������ 128x64x4
                {
                  v1.X = 16;
                  v1.Y = 16;
                  v1.Z = 16;
                }
                else // ��� ���������. 
                {
                  v1.X = 8;
                  v1.Y = 8;
                  v1.Z = 8;
                }

            }
            else
            {
               centerLoc = FrobName.Location;
               v1.X = FrobName.CollisionRadius;
               v1.Y = FrobName.CollisionRadius;
               v1.Z = FrobName.CollisionHeight;
            }

            // ������� ������������ ����, �������� X(��������������) � Y(������������)
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
                // ���������� ����� ��� ������
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
                // ����� �� ���������� ��������
//              boxTLX = FClamp(boxTLX, moverCorrectionA * C.SizeX, C.SizeX-moverCorrectionA * C.SizeX);
//              boxTLY = FClamp(boxTLY, moverCorrectionB * C.SizeY, C.SizeY-moverCorrectionB * C.SizeY);
//              boxBRX = FClamp(boxBRX, moverCorrectionC * C.SizeX, C.SizeX-moverCorrectionC * C.SizeX);
//              boxBRY = FClamp(boxBRY, moverCorrectionD * C.SizeY, C.SizeY-moverCorrectionD * C.SizeY);
//              }

                // �� ���� ������� ���������... �� ���� �������
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

            // ����� �������� ������: ������� �����, ����� ����.
            // � ��������� ����� ���� ������� � ����������� �� �������� ����.
          C.DrawColor = FrobBoxShadow;//SetDrawColor(0,0,0,255);
            for (i=1; i>=0; i--)
            {
                // ����� ����������� ���� � ���������� � ����� ������� ���� + ��������� ��������, ��� � ���������.
                C.setpos(boxTLX+i+offset, boxTLY+i+offset); // ������� ����� ����
                C.DrawRect(texture'Solid', fcorner, 1); // DrawRect �� ������������ Material (�������� Shader), ������ ��������
                C.setpos(boxTLX+i+offset, boxTLY+i+offset);
                C.DrawRect(texture'Solid', 1, fcorner);


                C.setpos(boxBRX+i-fcorner-offset,boxTLY+i+offset); // ������� ������ ����
                C.DrawRect(texture'Solid', fcorner, 1);
                C.setpos(boxBRX+i-offset, boxTLY+i+offset);
                C.DrawRect(texture'Solid', 1, fcorner);


                C.setpos(boxTLX+i+offset ,boxBRY+i-offset); // ...������ �����
                C.DrawRect(texture'Solid', fcorner,1);
                C.setpos(boxTLX+i+offset, boxBRY+i-fcorner-offset);
                C.DrawRect(texture'Solid', 1, fcorner);


                C.setpos(boxBRX+i-fcorner+1-offset,boxBRY+i-offset); // ...� ������ ������
                C.DrawRect(texture'Solid', fcorner,1);
                C.setpos(boxBRX+i-offset, boxBRY+i-fcorner-offset);
                C.DrawRect(texture'Solid', 1, fcorner);
              C.DrawColor = FrobBoxColor;//SetDrawColor(255,255,255,255);

            }
     FrobStr=string(FrobName);
         C.TextSize(FrobStr, tH,tW);

       C.SetDrawColor(250,250,250,200);// ���������� ���� ���� ��� ��������
       C.SetPos(X + ItemNameFrameOffsetH,Y + ItemNameFrameOffsetV); // ��������� �������� ����

       C.SetDrawColor(255,255,255,255);
       C.SetPos(X + ItemNameOffsetH,Y + ItemNameOffsetV);

         If (FrobName.IsA('Hackabledevices'))
         {
                        if (Hackabledevices(frobName).bHackable)
                        {
                            if (Hackabledevices(frobName).hackStrength != 0.0)
                            {       // ����� ��������, ���������� ������� ������������������ �����
                                 Frobstr=Hackabledevices(frobName).itemName; // ��������� ������
                                 C.TextSize(msgHackStr $ msgInf $ msgHacked, tH,tW);    // ��������� ������, ���������� ������ ������ ������� � tH, tW
                               C.SetDrawColor(250,250,250,200);
                                 C.setpos(boxTLX+ItemNameFrameOffsetH, boxTLY+ItemNameFrameOffsetV);    // ������� ����� ����
                          //C.Style = ERenderStyle.STY_Additive; // STY_Modulated;  // C.Style = ERenderStyle.STY_Normal;
                               C.DrawTileStretched(INBox, tH, tW + 22);
                                 C.Style = ERenderStyle.STY_Normal;
                                 C.SetDrawColor(255,255,255,255);   // ���������� � ��������� ������
                                 C.setpos(boxTLX+ItemNameOffsetH, boxTLY+ItemNameOffsetV);  // ������� ����� ����
                                 C.DrawText(Hackabledevices(frobName).itemName);    // ����� ������������ ���
                                 C.setpos(boxTLX+ItemNameOffsetH, boxTLY+ItemNameOffsetV + 20); // ������ ���� ��� ������ ������
                                 C.DrawText(msgHackStr $ FormatString(Hackabledevices(frobName).hackStrength * 100.0) $ "%"); // ...������ ������

                                 C.DrawColor=GetColorScaled(Hackabledevices(frobName).hackStrength);
                                 C.DrawColor.A=200;
                                 C.TextSize(msgHackStr, nH,nW);
                                 C.setpos(boxTLX+ItemNameOffsetH + nH + 40, boxTLY+ItemNameOffsetV + 20); // ������ ��� ���������� ������
                                 C.DrawTileStretched(texture'Solid', barLength*Hackabledevices(frobName).hackStrength, 15); // ������ ��������� (��������������!)
                                 C.DrawColor = FrobBoxText;// SetDrawColor(255,255,255,255); // ��������� ���� ��� ����� �������� (�����)

                                    numTools = int((Hackabledevices(frobName).hackStrength / Human(Playerowner.pawn).SkillSystem.GetSkillLevelValue(class'SkillTech')) + 0.99);
                                    if (numTools == 1)
                                    strInfo = numTools @ msgTool;
                                    else
                                    strInfo = numTools @ msgTools;
                                    C.DrawText(strInfo);
                            }
                            else
                                {   // ��������
                                 Frobstr=Hackabledevices(frobName).itemName; // ��������� ������
                                 C.TextSize(FrobStr $ msgInf, tH,tW);   // ������ ������ ������� � tH, tW
                               C.SetDrawColor(250,250,250,200);
                                 C.setpos(boxTLX+ItemNameFrameOffsetH, boxTLY+ItemNameFrameOffsetV);    // ������� ����� ����
                               //C.DrawTileStretched(texture'ItemNameBox', tH + 24, tW + 2);
                               C.DrawTileStretched(INBox, tH + 24, tW + 2);
                                 C.DrawColor = FrobBoxText;//SetDrawColor(255,255,255,255); // ���������� � ��������� ������
                                 C.setpos(boxTLX+ItemNameOffsetH, boxTLY+ItemNameOffsetV);  // ������� ����� ����
                       C.DrawText(Hackabledevices(frobName).itemName $ ": " $ msgHacked);
                                }
                        }
                else
                {    // ��������� � ������: ����������
                     Frobstr=Hackabledevices(frobName).itemName; // ��������� ������
                     C.TextSize(msgInf $ msgHackStr, tH,tW);    // ������ ������ ������� � tH, tW
                   C.SetDrawColor(250,250,250,200);
                     C.setpos(boxTLX+ItemNameFrameOffsetH, boxTLY+ItemNameFrameOffsetV);    // ������� ����� ����
                   C.DrawTileStretched(INBox, tH + 80, tW + 22);
                     C.DrawColor = FrobBoxText;//SetDrawColor(255,255,255,255); // ���������� � ��������� ������
                     C.setpos(boxTLX+ItemNameOffsetH, boxTLY+ItemNameOffsetV);  // ������� ����� ����
                 C.DrawText(Hackabledevices(frobName).itemName);
                     C.setpos(boxTLX+ItemNameOffsetH, boxTLY+ItemNameOffsetV + 20); // ������ ���� ��� ������ ������
                 C.DrawText(msgHackStr $ msgInf);
                     C.SetDrawColor(0,255,0,200);
                     C.setpos(boxTLX+ItemNameOffsetH + tH + 8, boxTLY+ItemNameOffsetV + 21); // ������ ���� ��� ������ ������
                     C.DrawTileStretched(texture'Solid', barLength, 15); // ������ ��������� (����� �� ��������������)
                }
                }
             else
         If (FrobName.IsA('DeusExDecoration') && (DeusExPlayer(PlayerOwner.pawn) != none) && (DeusExPlayer(PlayerOwner.pawn).bObjectNames))
         {
             Frobstr=DeusExDecoration(frobName).itemName;
             C.TextSize(FrobStr, tH,tW);
           C.SetDrawColor(250,250,250,200);
             C.setpos(boxTLX+ItemNameFrameOffsetH, boxTLY+ItemNameFrameOffsetV);    // ������� ����� ����
           C.DrawTileStretched(INBox, tH + 24, tW + 2);
             C.DrawColor = FrobBoxText;//C.SetDrawColor(255,255,255,255);
             C.setpos(boxTLX+ItemNameOffsetH, boxTLY+ItemNameOffsetV);  // ������� ����� ����
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
         If (FrobName.IsA('DeusExWeapon')) // ������ ��������� ��������� �� �����.
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
            If (FrobName.IsA('DeusExProjectile')) // TODO: ������� ������ � ���������
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
                If (DeusExMover(frobName).bLocked) // ����� �������, ���������� ��������� �����, ��������� ����� � ������ ����������.
                {
                        C.TextSize(msgLockStr $ msgInf, tH,tW); // ��������� ������ � �������� ����� ����� + ��������� �����.
                C.SetDrawColor(250,250,250,200); // R,G,B, optional alpha
                        C.setpos(boxTLX+ItemNameFrameOffsetH, boxTLY+ItemNameFrameOffsetV); // ������� ����� ����
//                C.SetPos(X + ItemNameFrameOffsetH,Y + ItemNameFrameOffsetV);
                C.DrawTileStretched(INBox, tH + barLength * 2.5, tW + 44); // ������� ������� �������, ������ ������������� ���������� �������� �� TextSize
                      C.SetDrawColor(255,255,255,255); // ��������� ���� ��� ����� �������� (�����)
                        C.setpos(boxTLX+ItemNameOffsetH, boxTLY+ItemNameOffsetV);   // ������� ����� ����
//              C.SetPos(X + ItemNameOffsetH,Y + ItemNameOffsetV);
                C.DrawText(msgLocked); // �������, ������ ����� ���������� ���������� ��� � ���������.

                            if (DeusExMover(frobName).bPickable) // ������� �� ����� ������� ��������
                            {                                                                        //----------------------------------
                      C.SetPos(boxTLX+i + ItemNameOffsetH,boxTLY+i + ItemNameOffsetV + 20);
                                C.DrawText(msgLockStr $ FormatString(DeusExMover(frobName).lockStrength * 100.0) $ "%");
                        C.SetPos(boxTLX + tH + 30,boxTLY + tW + ItemNameOffsetV /* + 25*/); // ������������ ����������
                                C.DrawColor=GetColorScaled(DeusExMover(frobName).lockStrength);
                                C.DrawColor.A=200;
                                C.DrawTileStretched(texture'Solid', barLength*DeusExMover(frobName).lockStrength, 15); // ������ ���������
                              C.DrawColor = FrobBoxText;//C.SetDrawColor(255,255,255,255); // ��������� ���� ��� ����� �������� (�����)
                                    // �������� ����������...
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
                        C.SetPos(boxTLX + ItemNameOffsetH,boxTLY + ItemNameOffsetV + 20); // ������� �� �������� �� �������
                                C.DrawText(msgLockStr $ msgInf);
                        C.SetPos(boxTLX + tH + 30,boxTLY + tW + ItemNameOffsetV /* + 25*/); // ������������ ����������
                                C.SetDrawColor(0,255,0,200);
                                C.DrawTileStretched(texture'Solid', barLength, 15); // ������ ���������
                              C.SetDrawColor(255,255,255,255);
                            }
                            if (DeusExMover(frobName).bBreakable) // ������� �� ����� ��������
                            {                                     //--------------------------
                            C.DrawColor = FrobBoxText;
                        C.SetPos(boxTLX + ItemNameOffsetH,boxTLY + ItemNameOffsetV + 40);
                                C.DrawText(msgDoorStr $ FormatString(DeusExMover(frobName).doorStrength * 100.0) $ "%");
                        C.SetPos(boxTLX + tH + 30,boxTLY + tW + ItemNameOffsetV + 20); // ������������ ����������
                                C.DrawColor=GetColorScaled(DeusExMover(frobName).doorStrength);
                                C.DrawColor.A=200;
                                C.DrawTileStretched(texture'Solid', barLength*DeusExMover(frobName).doorStrength, 15); // ������ ���������

                        C.SetPos(boxTLX + tH + 30,boxTLY + tW + ItemNameOffsetV + 20); // ������������ ����������
                            }
                    else
                            {
                            C.DrawColor = FrobBoxText;
                        C.SetPos(boxTLX + ItemNameOffsetH,boxTLY + ItemNameOffsetV + 40); // �������, ���������� ������� �������� ��� �������
                                C.DrawText(msgDoorStr $ msgInf);
                        C.SetPos(boxTLX + tH + 30,boxTLY + tW + ItemNameOffsetV + 20); // ������������ ����������
                                C.SetDrawColor(0,255,0,200);
                                C.DrawTileStretched(texture'Solid', barLength, 15); // ������ ���������
                            }
                }
                  If (!DeusExMover(frobName).bLocked) // ����� �������, ������ �� ������
                {
                     C.TextSize(msgUnLocked, tH,tW);
               C.SetDrawColor(250,250,250,200);
               C.SetPos(boxTLX + ItemNameFrameOffsetH,boxTLY + ItemNameFrameOffsetV);
               //C.DrawTileStretched(texture'ItemNameBox', tH + 24, tW); // ������� ������� �������
               C.DrawTileStretched(INBox, tH + 24, tW); // ������� ������� �������
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
// ����� ��������
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
// ������� ��������
//------------------
function RenderPoisonEffectGreen(Canvas C)
{
    local texture Green;
  local float X,Y;

   X=C.ClipX * 0.0;
   Y=C.ClipY * 0.0;

    if (bGreenPoison)
    {
        C.SetPos(X,Y);
        C.SetDrawColor(255,255,255,255);
        Green=wetTexture'Effects.UserInterface.DrunkBoy';
    C.Style = ERenderStyle.STY_Modulated;
        C.DrawTileScaled(Green, C.ClipX, C.ClipY);
            if (bDoubledPoisonEffect)
        C.DrawTileScaled(Green, C.ClipX, C.ClipY);
    }
}

//
// ������ �� Reborn + ��������� � ������ TrueNorth
//
function RenderCompass(Canvas C)
{
  local float offset, width, bearing;

   c.DrawColor = compassBG;
   C.SetPos(11,116);
   if (DeusExPlayer(playerowner.pawn).bHUDBackgroundTranslucent)
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

   bearing = PlayerOwner.Pawn.GetViewRotation().Yaw - mapNorth;
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
//  local int x;
//  local array<string> bindKeyNames, localizedBindKeyNames;
  local string AugKeyName;

    p=Human(PlayerOwner.Pawn);
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
                if (DeusExPlayer(playerowner.pawn).bHUDBackgroundTranslucent)
                    c.Style = ERenderStyle.STY_Translucent;
                       else
                        c.Style = ERenderStyle.STY_Normal;
                C.DrawIcon(Texture'HUDIconsBackground',1.0);

                if(aug.bIsActive)
                {
                                    //if (Playerowner.pawn.Level.TimeSeconds % 1.5 > 0.75)
                      //  c.SetDrawColor(0,255,0);
                          //  else
                            c.DrawColor = AugsBeltActive;//SetDrawColor(255,0,0);
                }
                else
                {
                    c.DrawColor = AugsBeltInActive;//SetDrawColor(127,127,127);
                }

                c.Style = 3;
                C.SetPos(C.SizeX-42,holdY+7);
                border=aug.smallIcon;
                c.DrawIcon(border,1.0);

//                c.SetDrawColor(255,255,255);
//                if(GetAssignedKeys("ActivateAugmentation "$x, bindKeyNames, localizedBindKeyNames))
//                {
                    c.DrawColor = AugsBeltText;//SetDrawColor(255,255,255);
                    C.Style = 1;
                    C.SetPos(C.SizeX-38,holdY);
//                    dxc.DrawTextJustified(AugKeyName, 2, C.SizeX-42, holdY+5, c.SizeX-12, holdY+20);
                    AugKeyName=string(aug.GetHotKey());//DeusExPlayer(playerowner.pawn)
                    dxc.DrawTextJustified("F"$AugKeyName, 2, C.SizeX-42, holdY+5, c.SizeX-12, holdY+20);
//                }
                holdY += 36;
            }
            aug = aug.next;
        }
        //c.SetDrawColor(127,127,127);
        //c.Style = 3;

        if (DeusExPlayer(Level.GetLocalPlayerController().pawn).bHUDBordersVisible)
        {
           if (DeusExPlayer(Level.GetLocalPlayerController().pawn).bHUDBordersTranslucent)
               c.Style = ERenderStyle.STY_Translucent;
                 else
                   c.Style = ERenderStyle.STY_Alpha;

            c.DrawColor = AugsBeltFrame;//SetDrawColor(127,127,127);
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

  if (playerOwner.pawn == none)
     return;

  hudY = u.SizeY - 80; // ������ �� ������� ������ �� ���������

  for (inv=PlayerOwner.pawn.Inventory; inv!=None; inv=inv.Inventory)
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
            if (DeusExPlayer(playerowner.pawn).bHUDBackgroundTranslucent)
                u.Style = ERenderStyle.STY_Translucent;
                  else
                    u.Style = ERenderStyle.STY_Normal;
        u.DrawTileStretched(texture'DeusExUI.UserInterface.HUDIconsBackground',64, 64); // background...

//      u.Style = ERenderStyle.STY_Normal;
        if (DeusExPlayer(Level.GetLocalPlayerController().pawn).bHUDBordersVisible)
        {
          if (DeusExPlayer(Level.GetLocalPlayerController().pawn).bHUDBordersTranslucent)
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



// ������� �������� � �����/������������ � ������
function RenderAmmoDisplay(Canvas c)
{
    local material ico;
    local int toolsLeft, clipsRemaining, ammoRemaining, ammoInClip;
    local DeusExWeapon weapon;

    local inventory item;

    item = DeusExPlayer(playerowner.pawn).InHand;

    if (item == none)
        return;

      c.Font = font'DxFonts.DPix_7';

          if (item.IsA('SkilledTool'))
          {
                ico =  SkilledTool(DeusExPlayer(playerowner.pawn).inhand).icon;
                toolsleft = SkilledTool(DeusExPlayer(playerowner.pawn).inhand).NumCopies;
                if (toolsleft == 0)
                     toolsleft = 1;

                if (DeusExPlayer(playerowner.pawn).InHand.IsA('NanoKeyRing'))
                    toolsleft = NanoKeyRing(DeusExPlayer(playerowner.pawn).inhand).GetKeyCount();

            c.DrawColor = AmmoDisplayBG;
            C.SetPos(13,C.SizeY-63);
            if (DeusExPlayer(playerowner.pawn).bHUDBackgroundTranslucent)
                c.Style = ERenderStyle.STY_Translucent;
                  else
                    c.Style = ERenderStyle.STY_Normal;
            C.DrawIcon(Texture'HUDAmmoDisplayBackground_1',1.0);

/*            c.DrawColor = AmmoDisplayFrame;
            C.SetPos(0,C.SizeY-77);
            C.DrawIcon(Texture'HUDAmmoDisplayBorder_1',1.0);*/
           if (DeusExPlayer(Level.GetLocalPlayerController().pawn).bHUDBordersVisible)
           {
            if (DeusExPlayer(Level.GetLocalPlayerController().pawn).bHUDBordersTranslucent)
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
            if (DeusExPlayer(playerowner.pawn) != None)
                weapon = DeusExWeapon(DeusExPlayer(playerowner.pawn).InHand);

            if (weapon == none)
                return;

                ico = weapon.icon;

            c.DrawColor = AmmoDisplayBG;
            C.SetPos(13,C.SizeY-63);
            if (DeusExPlayer(playerowner.pawn).bHUDBackgroundTranslucent)
                c.Style = ERenderStyle.STY_Translucent;
                  else
                    c.Style = ERenderStyle.STY_Normal;
            C.DrawIcon(Texture'HUDAmmoDisplayBackground_1',1.0);

           if (DeusExPlayer(Level.GetLocalPlayerController().pawn).bHUDBordersVisible)
           {
            if (DeusExPlayer(Level.GetLocalPlayerController().pawn).bHUDBordersTranslucent)
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
                if (DeusExPlayer(PlayerOwner.pawn).RemainingAmmoMode == 0)
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


/*������ ������� � DxFonts.u (��� �� ���������)
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

    bUseAltVBarTexture=false

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
//  ConsoleMessageCount=8 // �������� 8
//  MessageLifeTime=10 // ������� ������ ���������� ���������.
    ProgressFadeTime=10.0

    TopBarOffset=0
    LowerBarOffSet=0

    CrosshairCorrectionX=-8
    CrosshairCorrectionY=-8

    HHframeY=-21
    HHframeX=-21

    HitMarkerMat=TexRotator'DeusExUIExtra.HUD.HitMarker_TXR'
    CrosshairTex=Texture'CrossSquare'
    ItemNameBoxT=Texture'ItemNameBox'

    HudHitBase=texture'DeusExUi.UserInterface.HUDHitDisplayBackground_1'
    HudHitFrame=texture'DeusExUi.UserInterface.HUDHitDisplayBorder_1'
    HudHitBody=texture'DeusExUi.UserInterface.HUDHitDisplay_Body'
    HudHitArmL=texture'DeusExUi.UserInterface.HUDHitDisplay_ArmLeft'
    HudHitArmR=texture'DeusExUi.UserInterface.HUDHitDisplay_ArmRight'
    HudHitLegL=texture'DeusExUi.UserInterface.HUDHitDisplay_LegLeft'
    HudHitLegR=texture'DeusExUi.UserInterface.HUDHitDisplay_LegRight'
    HudHitHead=texture'DeusExUi.UserInterface.HUDHitDisplay_Head'
    HudHitTorso=texture'DeusExUi.UserInterface.HUDHitDisplay_Torso'
    INBox=FinalBlend'DeusExUiExtra.F_ItemNameBox'

//-------------------------------------------------------

    textYStep=-1
    textYStart=0
    ttyRate=1.6
    ttyCRate=0.05
    marginX=4.00 // ��� ����������� � ����������� ����������� !!!
    corner=9.00
    margin=70.00 // ��� ����� ���������!!!
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

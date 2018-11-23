//
// Базовый класс контроллера игрока.
// 02/12/2017: добавлено state PlayerMousing (из примеров с UDN)
//

class PlayerControllerEXT extends DeusExNativePlayerController // playercontroller
                                  config (DeusExNativePlayerController);

#exec OBJ LOAD FILE=DeusExSounds

var config  bool bIsAmericanWeek; // влияет только на первый день недели.
var config int MenuThemeIndex;
var config int HUDThemeIndex;

var vector PlayerMouse;
var float LastHUDSizeX;
var float LastHUDSizeY;

var transient DeusExGlobals gl; // if not Transient, game will instantly crash when trying to saveGame, since DeusExGobals's outer is in transient "system" package.

var int SavedbRun;

// Расстояние на котором можно использовать объекты
// Функция UT2004 нереально косая, надо адаптировать из оригинала!!!
// 09/07/2017 -- Сделано!
var float MaxFrobDistance;
var Actor FrobTarget;
var float FrobTime;
var float curLeanDist;

// Добавляет звуки шагов по лестнице
var float LStepTimer;
CONST LADDERSTEPINTERVAL = 0.5; // Два раза в секунду
var bool bUsingWoodenLadder;

// Необходимо для работы наклонов влево/вправо
// Ось ввода (axis Extra)
var input float aExtra0;

var bool bCheatsEnabled;

var(flashFineTuning) float deltaStep, flashFogMult;

/*-- Color themes for Interface (menus, windows...) ----------------------------------*/
exec function AllMenuThemes()
{
  local array<string> themes;
  local int x;

  themes = class'DXR_Menu'.static.GetAllThemes();

	for (x = 0; x < themes.Length; x++)
	{
     log(themes[x]);
	}
}

exec function SetMenuTheme(int index)
{
  local string tmp;

  gl = class'DeusExGlobals'.static.GetGlobals();
  tmp = class'DXR_Menu'.static.GetThemeName(index);

  if (tmp != "")
  {
    MenuThemeIndex = index;
    gl.MenuThemeIndex = MenuThemeIndex;
    ClientMessage("Selected menu theme:"@tmp@"("$index$")");
    ConsoleCommand("Set DeusExGlobals MenuThemeIndex"@MenuThemeIndex);
    class'DeusExGlobals'.static.StaticSaveConfig();
    //SaveConfig();
  }
}

/*-- Color themes for HUD ------------------------------------------------------------*/
exec function AllHUDThemes()
{
  local array<string> themes;
  local int x;

  themes = class'DXR_HUD'.static.GetAllHUDThemes();

	for (x = 0; x < themes.Length; x++)
	{
     log(themes[x]);
	}
}

exec function HudColor(int index)
{
  local string tmp;

  tmp = class'DXR_Menu'.static.GetThemeName(index);
  gl = class'DeusExGlobals'.static.GetGlobals();

  AssignHUDColors(index);

  HUDThemeIndex = index;
  gl.HUDThemeIndex = HUDThemeIndex;
  ClientMessage("Selected HUD theme:"@tmp@"("$index$")");
  ConsoleCommand("Set DeusExGlobals HUDThemeIndex"@HUDThemeIndex);
  class'DeusExGlobals'.static.StaticSaveConfig();
}

function AssignHUDColors(int index)
{
  local DeusExHUD m;

   m = DeusEXHUD(myHUD);

   if (m != none)
   {
     m.MessageBG = class'DXR_HUD'.static.GetMessageBG(index);
     m.MessageText = class'DXR_HUD'.static.GetMessageText(index);
     m.MessageFrame = class'DXR_HUD'.static.GetMessageFrame(index);

     m.ToolBeltBG = class'DXR_HUD'.static.GetToolBeltBG(index);
     m.ToolBeltText = class'DXR_HUD'.static.GetToolBeltText(index);
     m.ToolBeltFrame = class'DXR_HUD'.static.GetToolBeltFrame(index);
     m.ToolBeltHighlight = class'DXR_HUD'.static.GetToolBeltHighlight(index);

     m.AugsBeltBG = class'DXR_HUD'.static.GetAugsBeltBG(index);
     m.AugsBeltText = class'DXR_HUD'.static.GetAugsBeltText(index);
     m.AugsBeltFrame = class'DXR_HUD'.static.GetAugsBeltFrame(index);
     m.AugsBeltActive = class'DXR_HUD'.static.GetAugsBeltActive(index);
     m.AugsBeltInActive = class'DXR_HUD'.static.GetAugsBeltInActive(index);

     m.AmmoDisplayBG = class'DXR_HUD'.static.GetAmmoDisplayBG(index);
     m.AmmoDisplayFrame = class'DXR_HUD'.static.GetAmmoDisplayFrame(index);

     m.compassBG = class'DXR_HUD'.static.GetcompassBG(index);
     m.compassFrame = class'DXR_HUD'.static.GetcompassFrame(index);

     m.HealthBG = class'DXR_HUD'.static.GetHealthBG(index);
     m.HealthFrame = class'DXR_HUD'.static.GetHealthFrame(index);

     m.BooksBG = class'DXR_HUD'.static.GetBooksBG(index);
     m.BooksText = class'DXR_HUD'.static.GetBooksText(index);
     m.BooksFrame = class'DXR_HUD'.static.GetBooksFrame(index);

     m.InfoLinkBG = class'DXR_HUD'.static.GetInfoLinkBG(index);
     m.InfoLinkText = class'DXR_HUD'.static.GetInfoLinkText(index);
     m.InfoLinkTitles = class'DXR_HUD'.static.GetInfoLinkTitles(index);
     m.InfoLinkFrame = class'DXR_HUD'.static.GetInfoLinkFrame(index);

     m.AIBarksBG = class'DXR_HUD'.static.GetAIBarksBG(index);
     m.AIBarksText = class'DXR_HUD'.static.GetAIBarksText(index);
     m.AIBarksHeader = class'DXR_HUD'.static.GetAIBarksHeader(index);
     m.AIBarksFrame = class'DXR_HUD'.static.GetAIBarksFrame(index);

     ClientMessage("Current HUD colorTheme: "$class'DXR_HUD'.static.GetHUDThemeName(index));
   }
}
/*
function SetInitialState()
{
  super.SetInitialState();

  gl = class'DeusExGlobals'.static.GetGlobals();
  AssignHUDColors(gl.HUDThemeIndex);
}
*/

// ----------------------------------------------------------------------
// RestrictInput()
// Are we in a state which doesn't allow certain exec functions?
// ----------------------------------------------------------------------
function bool RestrictInput()
{
	if (IsInState('Interpolating') || pawn.IsInState('Dying') || IsInState('Paralyzed'))
		return True;

	return False;
}

// ----------------------------------------------------------------------
// IsHighlighted()
// checks to see if we should highlight this actor
// ----------------------------------------------------------------------
function bool IsHighlighted(actor A)
{
	if (bBehindView)
		return False;

	if (A != None)
	{
		if (A.bDeleteMe || A.bHidden)
			return False;

		if (A.IsA('Pawn'))
		{
			if (!Human(pawn).bNPCHighlighting)
				return False;
		}

		if (A.IsA('DeusExMover') && !DeusExMover(A).bHighlight)
			return False;
		else if (A.IsA('Mover') && !A.IsA('DeusExMover'))
			return False;
		else if (A.IsA('DeusExDecoration') && !DeusExDecoration(A).bHighlight)
			return False;
		else if (A.IsA('DeusExCarcass') && !DeusExCarcass(A).bHighlight)
			return False;
		else if (A.IsA('ThrownProjectile') && !ThrownProjectile(A).bHighlight)
			return False;
		else if (A.IsA('DeusExProjectile') && !DeusExProjectile(A).bStuck)
			return False;
		else if (A.IsA('ScriptedPawn') && !ScriptedPawn(A).bHighlight)
			return False;
	}
	return True;
}

// Находит объект в центре внимания.
// Эта функция используется в DeusExHud, для рендеринга рамки выделения.
// Поскольку BoundingBox как в DeusEx мы узнать не можем, будем базироваться 
// на цилиндре коллизии.
function HighlightCenterObject()
{
  local Actor mytarget, smallestTarget;
  local Vector HitLoc, HitNormal, StartTrace, EndTrace;
  local float minSize;
  local bool bFirstTarget;

  if (pawn.IsInState('Dying'))
    return;

  // only do the trace every tenth of a second
  if (FrobTime >= 0.1)
  {
    // figure out how far ahead we should trace
    StartTrace = pawn.Location;
    EndTrace = pawn.Location + (Vector(GetViewRotation()) * MaxFrobDistance);

    // adjust for the eye height +=
    StartTrace.Z += pawn.BaseEyeHeight;
    EndTrace.Z += pawn.BaseEyeHeight;

    smallestTarget = None;
    minSize = 99999;
    bFirstTarget = True;

    // find the object that we are looking at
    // make sure we don't select the object that we're carrying
    // use the last traced object as the target...this will handle
    // smaller items under larger items for example
    // ScriptedPawns always have precedence, though
    foreach TraceActors(class'Actor', mytarget, HitLoc, HitNormal, EndTrace, StartTrace)
    {
    if 	(mytarget.IsA('StaticMeshActor')) // исключить StaticMesh
    return;

      if (IsFrobbable(mytarget) && (mytarget != Human(pawn).CarriedDecoration))
      {
        if (mytarget.IsA('ScriptedPawn'))
        {
          smallestTarget = mytarget;
          break;
        }
        else if (mytarget.IsA('Mover') && bFirstTarget)
        {
          smallestTarget = mytarget;
          break;
        }
        else if (mytarget.CollisionRadius < minSize)
        {
          minSize = mytarget.CollisionRadius;
          smallestTarget = mytarget;
          bFirstTarget = False;
        }
      }
    }
    FrobTarget = smallestTarget;
    Human(pawn).FrobTarget = smallestTarget;
    // reset our frob timer
    FrobTime = 0;
  }
}

// ----------------------------------------------------------------------
// is this actor frobbable?
// ----------------------------------------------------------------------
function bool IsFrobbable(actor A)
{
	if (!A.bHidden)
		if (A.IsA('Mover') || A.IsA('DeusExDecoration') || A.IsA('DeusExAmmoInv') ||
			A.IsA('ScriptedPawn') || A.IsA('DeusExCarcass') || A.IsA('DeusExProjectile') ||
			A.IsA('DeusExWeapon') || A.IsA('DeusExPickupInv') || A.IsA('DeusExWeaponInv'))
			return True;

	return False;
}

function DeusExLevelInfo GetLevelInfo()
{
	local DeusExLevelInfo info;

	foreach AllActors(class'DeusExLevelInfo', info)
		break;

	return info;
}

/*function bool CanJumpOffLadder()
{
	return (bPressedJump && (aForward != 0 || aStrafe != 0) && Level != None && Level.Pauser == None);
}*/

function HandleWalking()
{
	Super.HandleWalking();

  if (pawn != none) // To avoid spamlog if player is dead )))))
  {

	if (Human(pawn).bAlwaysRun)
		Human(pawn).SetWalking((bRun != 0) || (bDuck != 0));
	else
		Human(pawn).SetWalking((bRun == 0) || (bDuck != 0));
	}
}

//
// STATES
//

// Player movement.
// Player Standing, walking, running, falling.
state PlayerWalking
{
ignores SeePlayer, HearNoise, Bump;

		function PlayerTick(float DeltaTime)
		{
			HighlightCenterObject();
	    FrobTime += deltaTime;

	   if (Human(pawn) != none)
	   {
			Human(pawn).MaintainEnergy(deltaTime);
      Human(pawn).UpdateInHand();
			Human(pawn).DrugEffects(deltaTime);
			Human(pawn).UpdatePoison(deltaTime);
  		Human(pawn).Bleed(deltaTime);
  		Human(pawn).UpdateDynamicMusic(deltaTime);
  		Human(pawn).RepairInventory();//
  		

			if (Human(pawn).bOnFire)
			{
				Human(pawn).burnTimer += deltaTime;
				if (Human(pawn).burnTimer >= 30)
					Human(pawn).ExtinguishFire();
			}

			// save some texture info
			//FloorMaterial = GetFloorMaterial();
			//WallMaterial = GetWallMaterial(WallNormal);
      Human(pawn).UpdateTimePlayed(DeltaTime);

			// Check if player has walked outside a first-person convo.
			Human(pawn).CheckActiveConversationRadius();

			// Check if all the people involved in a conversation are 
			// still within a reasonable radius.
			Human(pawn).CheckActorDistances();
     }
			Super.PlayerTick(DeltaTime);
		}

    function bool NotifyPhysicsVolumeChange( PhysicsVolume NewVolume )
    {
        if (NewVolume.bWaterVolume)
        		{
   						Human(pawn).DropDecoration(); // бросить переносимый предмет
	            GotoState(Human(pawn).WaterMovementState);
            }
        return false;
    }

    function ProcessMove(float DeltaTime, vector NewAccel, eDoubleClickDir DoubleClickMove, rotator DeltaRot)
    {
        local vector OldAccel;
//        local bool OldCrouch;

				local int newSpeed, defSpeed;
//				local name mat;
				local vector HitLocation, HitNormal, checkpoint, downcheck;
				local Actor HitActor, HitActorDown;
				local bool bCantStandUp;
				local Vector loc, traceSize;
				local float alpha, maxLeanDist, prevLeanDist;
//				local float legTotal;
				local rotator Lr;
				local bool bCanLean;
				local SpyDrone aDrone;

        if (Human(pawn).bToggleWalk)
				{
				  bRun = 0;
				  Human(pawn).SetWalking(true);
				}

				// if the spy drone augmentation is active
					if (DeusExHud(myHUD).bSpyDroneActive)
					{
						aDrone = DeusExHud(myHUD).aDrone;
							if (aDrone != None)
							{
								// put away whatever is in our hand
							if (Human(pawn).inHand != None)
								Human(pawn).PutInHand(None);

								// make the drone's rotation match the player's view
								aDrone.SetRotation(pawn.GetViewRotation());

								// move the drone
								loc = Normal((aUp * vect(0,0,1) + aForward * vect(1,0,0) + aStrafe * vect(0,1,0)) >> pawn.GetViewRotation());

								// if the wanted velocity is zero, apply drag so we slow down gradually
								if (VSize(loc) == 0)
									aDrone.Velocity *= 0.9;
								else
								aDrone.Velocity += DeltaTime * aDrone.MaxSpeed * loc;

								// add slight bobbing
								aDrone.Velocity += DeltaTime * Sin(Level.TimeSeconds * 2.0) * vect(0,0,1);

								// freeze the player
								Human(pawn).Velocity = vect(0,0,0);
								return;
							}
					}

						// crouching makes you two feet tall
//				if (Human(pawn).bIsCrouched || Human(pawn).bForceDuck) //////////////
     		if (Human(pawn).bIsCrouched || Human(pawn).bForceDuck)
				{
//					Human(pawn).SetBasedPawnSize(Human(pawn).Default.CollisionRadius, 16);
					bRun=0;
					Human(pawn).SetWalking(true); // Перейти в режим ходьбы

				// check to see if we could stand up if we wanted to
					checkpoint = Human(pawn).Location;
			// check normal standing height
					checkpoint.Z = checkpoint.Z - Human(pawn).CollisionHeight + 2 * Human(pawn).GetDefaultCollisionHeight();
					traceSize.X = Human(pawn).CollisionRadius;
					traceSize.Y = Human(pawn).CollisionRadius;
					traceSize.Z = 1;
					HitActor = Trace(HitLocation, HitNormal, checkpoint, Human(pawn).Location, True, traceSize);
					if (HitActor == None)
						bCantStandUp = False;
							else
						bCantStandUp = True;
					}
				else
				{
					Human(pawn).GroundSpeed = Human(pawn).GetCurrentGroundSpeed();

				// make sure the collision height is fudged for the floor problem - CNN
					if (!Human(pawn).IsLeaning())
					{
						Human(pawn).ResetBasedPawnSize();
					}
				}

				if (bCantStandUp)
					Human(pawn).bForceDuck = True;
						else
					Human(pawn).bForceDuck = False;

		// if the player's legs are damaged, then reduce our speed accordingly
				defSpeed = Human(pawn).GetCurrentGroundSpeed();
				newSpeed = defSpeed;

				if (Human(pawn).HealthLegLeft < 1)
					newSpeed -= (defSpeed/2) * 0.25;
				else if (Human(pawn).HealthLegLeft < 34)
					newSpeed -= (defSpeed/2) * 0.15;
				else if (Human(pawn).HealthLegLeft < 67)
					newSpeed -= (defSpeed/2) * 0.10;

				if (Human(pawn).HealthLegRight < 1)
					newSpeed -= (defSpeed/2) * 0.25;
				else if (Human(pawn).HealthLegRight < 34)
					newSpeed -= (defSpeed/2) * 0.15;
				else if (Human(pawn).HealthLegRight < 67)
				newSpeed -= (defSpeed/2) * 0.10;

				if (Human(pawn).HealthTorso < 67)
					newSpeed -= (defSpeed/2) * 0.05;

				// let the player pull themselves along with their hands even if both of
				// their legs are blown off
				if ((Human(pawn).HealthLegLeft < 1) && (Human(pawn).HealthLegRight < 1))
				{
					newSpeed = defSpeed * 0.8;
					Human(pawn).bForceDuck = True;
					Human(pawn).bIsWalking = True;
				}
				// make crouch speed faster than normal
				else if (Human(pawn).bIsCrouched || Human(pawn).bForceDuck)
				{
					//newSpeed = defSpeed * 1.8;		// DEUS_EX CNN - uncomment to speed up crouch
					Human(pawn).bIsWalking = True;
					bRun=-1;
				}

				// slow the player down if he's carrying something heavy
				// Like a DEAD BODY!  AHHHHHH!!!
				if (Human(pawn).CarriedDecoration != None)
				{
					newSpeed -= Human(pawn).CarriedDecoration.Mass * 2;
				}
				// don't slow the player down if he's skilled at the corresponding weapon skill
				else if ((Human(pawn).Weapon != None) && (Human(pawn).Weapon.Mass > 30)) // && (DeusExWeaponInv(Human(pawn).weapon).GetWeaponSkill() > -0.25))
				{
					Human(pawn).bIsWalking = True;
					newSpeed = defSpeed;
				}
				else if ((Human(pawn).inHand != None) && Human(pawn).inHand.IsA('POVCorpse'))
				{
					newSpeed -= Human(pawn).inHand.Mass * 3;
				}

				// if we are moving really slow, force us to walking
				if ((newSpeed <= defSpeed / 3) && !Human(pawn).bForceDuck)
				{
					Human(pawn).bIsWalking = True;
					newSpeed = defSpeed;
				}

				// if we are moving backwards, we should move slower
				if (aForward < 0)
					newSpeed *= 0.65;

				Human(pawn).GroundSpeed = FMax(newSpeed, 100);


////////// if we are moving or crouching, we can't lean
				// uncomment below line to disallow leaning during crouch
				if ((Human(pawn).VSize(Velocity) < 10) && (aForward == 0))		// && !bIsCrouching && !bForceDuck)
					/*Human(pawn).*/bCanLean = True;
				else
					/*Human(pawn).*/bCanLean = False;

				// check leaning buttons (axis aExtra0 is used for leaning)
				maxLeanDist = 40;
				if (Human(pawn).IsLeaning())
				{ //			ViewRotation.Roll = curLeanDist * 20;
					Lr=Human(pawn).GetViewRotation();
					Lr.Roll = /*Human(pawn).*/curLeanDist * 20;
					Human(pawn).SetViewRotation(Lr);

					if (!Human(pawn).bIsCrouched && !Human(pawn).bForceDuck)
					Human(pawn).SetBasedPawnSize(Human(pawn).CollisionRadius, Human(pawn).GetDefaultCollisionHeight() - Abs(/*Human(pawn).*/curLeanDist) / 3.0);
				}

				if (/*Human(pawn).*/bCanLean && (aExtra0 != 0))
				{
				// lean
				Human(pawn).DropDecoration();		// drop the decoration that we are carrying
//				if (Human(pawn).SimAnim.AnimSequence != 'CrouchWalk')
//					Human(pawn).PlayCrawling();

				alpha = maxLeanDist * aExtra0 * 2.0 * DeltaTime;
				loc = vect(0,0,0);
				loc.Y = alpha;
				if (Abs(/*Human(pawn).*/curLeanDist + alpha) < maxLeanDist)
				{
				// check to make sure the destination not blocked
				checkpoint = (loc >> Human(pawn).GetViewRotation()) + Human(pawn).Location;
				traceSize.X = Human(pawn).CollisionRadius;
				traceSize.Y = Human(pawn).CollisionRadius;
				traceSize.Z = Human(pawn).CollisionHeight;
				HitActor = Trace(HitLocation, HitNormal, checkpoint, Human(pawn).Location, True, traceSize);

				// check down as well to make sure there's a floor there
				downcheck = checkpoint - vect(0,0,1) * Human(pawn).CollisionHeight;
				HitActorDown = Trace(HitLocation, HitNormal, downcheck, checkpoint, True, traceSize);
				if ((HitActor == None) && (HitActorDown != None))
					{
					Human(pawn).SetLocation(checkpoint);
					/*Human(pawn).*/curLeanDist += alpha;
					}
				}
				else
					/*Human(pawn).*/curLeanDist = aExtra0 * maxLeanDist;
				}
				else if (Human(pawn).IsLeaning())	//if (!bCanLean && IsLeaning())	// uncomment this to not hold down lean
				{
				// un-lean
					if (Human(pawn).GetAnimSequence() == 'CrouchWalk')
						Human(pawn).PlayRising();
		
				prevLeanDist = /*Human(pawn).*/curLeanDist;
				alpha = FClamp(7.0 * DeltaTime, 0.001, 0.9);
				/*Human(pawn).*/curLeanDist *= 1.0 - alpha;
				if (Abs(/*Human(pawn).*/curLeanDist) < 1.0)
					/*Human(pawn).*/curLeanDist = 0;
				loc = vect(0,0,0);
				loc.Y = -(prevLeanDist - /*Human(pawn).*/curLeanDist);

				// check to make sure the destination not blocked
				checkpoint = (loc >> Human(pawn).GetViewRotation()) + Human(pawn).Location;
				traceSize.X = Human(pawn).CollisionRadius;
				traceSize.Y = Human(pawn).CollisionRadius;
				traceSize.Z = Human(pawn).CollisionHeight;
				HitActor = Trace(HitLocation, HitNormal, checkpoint, Human(pawn).Location, True, traceSize);

			// check down as well to make sure there's a floor there
				downcheck = checkpoint - vect(0,0,1) * Human(pawn).CollisionHeight;
				HitActorDown = Trace(HitLocation, HitNormal, downcheck, checkpoint, True, traceSize);
				if ((HitActor == None) && (HitActorDown != None))
					Human(pawn).SetLocation(checkpoint);
				}

				Super.ProcessMove(DeltaTime, NewAccel, DoubleClickMove, DeltaRot);

        
				if ( Pawn == None )
					return;
        OldAccel = Human(pawn).Acceleration;
        if (Human(pawn).Acceleration != NewAccel )
				Human(pawn).Acceleration = NewAccel;
        if ( bPressedJump )
				Human(pawn).DoJump(bUpdating);
        Human(pawn).SetViewPitch(Rotation.Pitch);

/*        if ( Human(pawn).Physics != PHYS_Falling )
        {
            OldCrouch = Human(pawn).bWantsToCrouch;
            if (bDuck == 0)
            	{
                Human(pawn).ShouldCrouch(false);
                Human(pawn).ResetBasedPawnSize();
              }
            else if (Human(pawn).bCanCrouch)
            	{
                Human(pawn).ShouldCrouch(true);
                Human(pawn).SetBasedPawnSize(Human(pawn).Default.CollisionRadius, 16);
               }
        }*/
    }

    function PlayerMove( float DeltaTime )
    {
        local vector X,Y,Z, NewAccel;
        local eDoubleClickDir DoubleClickMove;
        local rotator OldRotation, ViewRotation;
        local bool  bSaveJump;

        if(Pawn == None)
        {
            GotoState('Dead'); // this was causing instant respawns in mp games
            return;
        }

        GetAxes(Pawn.Rotation,X,Y,Z);

        // Update acceleration.
        NewAccel = aForward*X + aStrafe*Y;
        NewAccel.Z = 0;

        GroundPitch = 0; //
        ViewRotation = Rotation;
        if (Pawn.Physics == PHYS_Walking)
        {
            // tell pawn about any direction changes to give it a chance to play appropriate animation
            //if walking, look up/down stairs - unless player is rotating view
             if ( (bLook == 0)
                && (((Pawn.Acceleration != Vect(0,0,0)) && bSnapToLevel) || !bKeyboardLook) )
            {
                if ( bLookUpStairs || bSnapToLevel )
                {
                    GroundPitch = FindStairRotation(deltaTime);
                    ViewRotation.Pitch = GroundPitch;
                }
                else if ( bCenterView )
                {
                    ViewRotation.Pitch = ViewRotation.Pitch & 65535;
                    if (ViewRotation.Pitch > 32768)
                        ViewRotation.Pitch -= 65536;
                    ViewRotation.Pitch = ViewRotation.Pitch * (1 - 12 * FMin(0.0833, deltaTime));
                    if ( (Abs(ViewRotation.Pitch) < 250) && (ViewRotation.Pitch < 100) )
                        ViewRotation.Pitch = -249;
                }
            }
        }
        else
        {
            if ( !bKeyboardLook && (bLook == 0) && bCenterView )
            {
                ViewRotation.Pitch = ViewRotation.Pitch & 65535;
                if (ViewRotation.Pitch > 32768)
                    ViewRotation.Pitch -= 65536;
		                ViewRotation.Pitch = ViewRotation.Pitch * (1 - 12 * FMin(0.0833, deltaTime));
                if ( (Abs(ViewRotation.Pitch) < 250) && (ViewRotation.Pitch < 100) )
                    ViewRotation.Pitch = -249;
            }
        }
        Pawn.CheckBob(DeltaTime, Y);

        // Update rotation.
        SetRotation(ViewRotation);
        OldRotation = Rotation;
        UpdateRotation(DeltaTime, 1);
				bDoubleJump = false;

        if ( bPressedJump && Pawn.CannotJumpNow() )
        {
            bSaveJump = true;
            bPressedJump = false;
        }
        else
            bSaveJump = false;

        if ( Role < ROLE_Authority ) // then save this move and replicate it
            ReplicateMove(DeltaTime, NewAccel, DoubleClickMove, OldRotation - Rotation);
        else
            ProcessMove(DeltaTime, NewAccel, DoubleClickMove, OldRotation - Rotation);
        bPressedJump = bSaveJump;
    }
    function BeginState()
    {
       	DoubleClickDir = DCLICK_None;
       	bPressedJump = false;
       	GroundPitch = 0;
				if ( Pawn != None )
				{
            if (Pawn.Mesh == None)
                Pawn.SetMesh();
		            Pawn.ShouldCrouch(false);

            if (Pawn.Physics != PHYS_Falling && Pawn.Physics != PHYS_Karma) // FIXME HACK!!!
            	{
                Pawn.SetPhysics(PHYS_Walking);
 								//bRun=1; // пока так
 							}
				}
     }
    function EndState()
    {
        GroundPitch = 0;
        if ( Pawn != None && bDuck==0 )
            Pawn.ShouldCrouch(false);
    }

Begin:
}

state PlayerSwimming
{
ignores SeePlayer, HearNoise, Bump;

    function bool WantsSmoothedView()
    {
        return (!Human(pawn).bJustLanded);
    }

    function GrabDecoration()
		{
			// перенесено в DeusExPlayer
		}

    function bool NotifyLanded(vector HitNormal)
    {
        if (Human(pawn).PhysicsVolume.bWaterVolume)
            Human(pawn).SetPhysics(PHYS_Swimming);
        else
        		{
		            GotoState(Human(pawn).LandMovementState);	
            }
        return bUpdating;
    }

    function bool NotifyPhysicsVolumeChange(PhysicsVolume NewVolume)
    {
        local actor HitActor;
        local vector HitLocation, HitNormal, checkpoint;

        if ( !NewVolume.bWaterVolume )
        {
            Pawn.SetPhysics(PHYS_Falling);
            if ( (Human(pawn).Velocity.Z > 0) || Human(pawn).bWaterStepup)
            {
      				if (Human(pawn).bUpAndOut && Human(pawn).CheckWaterJump(HitNormal)) //check for waterjump
							{
							Human(pawn).velocity.Z = FMax(Human(pawn).JumpZ,420) + 2 * Human(pawn).CollisionRadius; //set here so physics uses this for remainder of tick
							GotoState(Human(pawn).LandMovementState);
							}
							else if ((Human(pawn).Velocity.Z > 160) || !Human(pawn).TouchingWaterVolume())
							GotoState(Human(pawn).LandMovementState);
							else //check if in deep water
							{
								checkpoint = Human(pawn).Location;
								checkpoint.Z -= (Human(pawn).CollisionHeight + 6.0);
								HitActor = Trace(HitLocation, HitNormal, checkpoint, Human(pawn).Location, false);
								if (HitActor != None)
									GotoState(Human(pawn).LandMovementState);
									else
										{
										Enable('Timer');
										SetTimer(0.7,false);
										}
								}
						}
        }
        else
        {
            Disable('Timer');
            Human(pawn).SetPhysics(PHYS_Swimming);
        }
        return false;
    }
    function ProcessMove(float DeltaTime, vector NewAccel, eDoubleClickDir DoubleClickMove, rotator DeltaRot)
    {
        local vector X,Y,Z, OldAccel;
				local bool bUpAndOut;

        GetAxes(Rotation,X,Y,Z);
        OldAccel = Human(pawn).Acceleration;

        if (Human(pawn).Acceleration != NewAccel)
					Human(pawn).Acceleration = NewAccel;
        	bUpAndOut = ((X Dot Human(pawn).Acceleration) > 0) && ((Human(pawn).Acceleration.Z > 0) || (Rotation.Pitch > 4096)); // 

					if ( Human(pawn).bUpAndOut != bUpAndOut )
					Human(pawn).bUpAndOut = bUpAndOut;

	        if ( !Human(pawn).PhysicsVolume.bWaterVolume ) //check for waterjump
            NotifyPhysicsVolumeChange(Human(pawn).PhysicsVolume);
    }

    function PlayerMove(float DeltaTime)
    {
        local rotator oldRotation;
        local vector X,Y,Z, NewAccel;

        GetAxes(Rotation,X,Y,Z);

        NewAccel = aForward*X + aStrafe*Y + aUp*vect(0,0,1);
//        if ( VSize(NewAccel) < 1.0 )
//            NewAccel = vect(0,0,0);

        //add bobbing when swimming
        Human(pawn).CheckBob(DeltaTime, Y);

        // Update rotation.
        oldRotation = Rotation;
        UpdateRotation(DeltaTime, 2);

        if ( Role < ROLE_Authority ) // then save this move and replicate it
            ReplicateMove(DeltaTime, NewAccel, DCLICK_None, OldRotation - Rotation);
        else
            ProcessMove(DeltaTime, NewAccel, DCLICK_None, OldRotation - Rotation);
        bPressedJump = false;
    }

    function Timer()
    {
        Human(pawn).bIsWalking = True;

        if ( !Human(pawn).PhysicsVolume.bWaterVolume && (Role == ROLE_Authority) )
            GotoState(Human(pawn).LandMovementState);
			      Disable('Timer');
    }

    event PlayerTick(float DeltaTime)
		{
				local vector loc;

				HighlightCenterObject();
		    FrobTime += deltaTime;

  		if (Human(pawn) != none)
  		{
				Human(pawn).MaintainEnergy(deltaTime);
				Human(pawn).UpdateInHand();
				Human(pawn).DrugEffects(deltaTime);
        Human(pawn).UpdateTimePlayed(DeltaTime);
        Human(pawn).UpdateDynamicMusic(deltaTime);
     		Human(pawn).RepairInventory(); //
    
				Human(pawn).SetWalking(true); // Перейти в режим ходьбы
				bRun=-1;

				if (Human(pawn).bOnFire)
				Human(pawn).ExtinguishFire();

				// update our swimming info
				Human(pawn).swimTimer -= deltaTime;
				Human(pawn).swimTimer = FMax(0, Human(pawn).swimTimer);
				if (Human(pawn).swimTimer > 0)           // Human(pawn).PainTime = Human(pawn).swimTimer;
     				Human(pawn).LastPainTime = Human(pawn).swimTimer;
				Human(pawn).swimBubbleTimer += deltaTime;
				Human(pawn).swimSoundTimer += deltaTime;

					if (Human(pawn).swimSoundTimer >= 1.0)
					{
						Human(pawn).swimSoundTimer = 0;
						if (FRand() < 0.4)
						Human(pawn).inWaterLeft();
						else
						Human(pawn).inWaterRight();
					}

				  if (Human(pawn).swimBubbleTimer >= 0.2)
					{
					Human(pawn).swimBubbleTimer = 0;
					if (FRand() < 0.4)
						{
							loc = Human(pawn).Location + VRand() * 4;
							loc += Vector(Human(pawn).GetViewRotation()) * Human(pawn).CollisionRadius * 2;
							loc.Z += Human(pawn).CollisionHeight * 0.9;
							Spawn(class'AirBubble', Human(pawn),, loc);
						}
					}
					Human(pawn).CheckActiveConversationRadius();
					Human(pawn).CheckActorDistances();
			}
			Super.PlayerTick(deltaTime);
		}
		//-------------------
    function BeginState()
    {
			local float mult;

				SavedBRun=bRun;

				// set us to be two feet high
				Human(pawn).SetBasedPawnSize(Default.CollisionRadius, 16);

				// get our skill info
				mult = Human(pawn).SkillSystem.GetSkillLevelValue(class'SkillSwimming');
				Human(pawn).swimDuration = Human(pawn).UnderWaterTime * mult;
				Human(pawn).swimTimer = Human(pawn).swimDuration;
				Human(pawn).swimBubbleTimer = 0;
				Human(pawn).WaterSpeed = Human(pawn).Default.WaterSpeed * mult;

        Disable('Timer');
        Human(pawn).SetPhysics(PHYS_Swimming);
				Super.BeginState();
    }
    function EndState()
    {
			bRun=savedbRun;
    }
}

//
// player is climbing ladder
// Play ladder step sounds here :)
//
state PlayerClimbing
{
ignores SeePlayer, HearNoise, Bump;

    function bool NotifyPhysicsVolumeChange(PhysicsVolume NewVolume)
    {
        if (NewVolume.bWaterVolume)
            GotoState(Human(pawn).WaterMovementState);
        else
            GotoState(Human(pawn).LandMovementState);
        return false;
    }

    function ProcessMove(float DeltaTime, vector NewAccel, eDoubleClickDir DoubleClickMove, rotator DeltaRot)
    {
        local vector	OldAccel;

        OldAccel = Human(pawn).Acceleration;
        if (Human(pawn).Acceleration != NewAccel)
        {
						Human(pawn).Acceleration = NewAccel;
				}
        if (bPressedJump)
        {
            Human(pawn).DoJump(bUpdating);
            if (Human(pawn).Physics == PHYS_Falling)
             GotoState('PlayerWalking');
        }
    }
    function PlayerMove(float DeltaTime)
    {
        local vector X,Y,Z, NewAccel;
        local eDoubleClickDir DoubleClickMove;
        local rotator OldRotation, ViewRotation;
        local bool  bSaveJump;

        GetAxes(Rotation,X,Y,Z);

        // Update acceleration.
        if ( Human(pawn).OnLadder != None )
        {
            NewAccel = aForward*Human(pawn).OnLadder.ClimbDir;
            if (Human(pawn).OnLadder.bAllowLadderStrafing )
						NewAccel += aStrafe*Y;
				}
        else
            NewAccel = aForward*X + aStrafe*Y;
		        if (VSize(NewAccel) < 1.0)
    	        NewAccel = vect(0,0,0);

        ViewRotation = Rotation;

        // Update rotation.
        SetRotation(ViewRotation);
        OldRotation = Rotation;
        UpdateRotation(DeltaTime, 1);
        ProcessMove(DeltaTime, NewAccel, DoubleClickMove, OldRotation - Rotation);
        bPressedJump = bSaveJump;
        // Play Ladder Stepping sounds here...
     	  LStepTimer+=DeltaTime;
		  	if ((LStepTimer > LADDERSTEPINTERVAL) && (Human(pawn).velocity.z !=0))
	  		{
	  			if (bUsingWoodenLadder)
						Human(pawn).WLadderStepSounds();
	  					else
			  		Human(pawn).LadderStepSounds();
					LStepTimer=0;
				}
//        Human(pawn).ForceCrouch();
    }

    function BeginState()
    {
//        Human(pawn).ShouldCrouch(false);
//        Human(pawn).ShouldCrouch(true);
        bPressedJump = false;
    }

    function EndState()
    {
//        if ( Pawn != None )
//        Human(pawn).ShouldCrouch(true);
//        Human(pawn).ShouldCrouch(false);
    }

		function PlayerTick( float DeltaTime )
		{
			HighlightCenterObject();
	    FrobTime += deltaTime;
			Human(pawn).MaintainEnergy(deltaTime);
			Human(pawn).UpdateInHand();
			Human(pawn).DrugEffects(deltaTime);
			Human(pawn).UpdatePoison(deltaTime);
  		Human(pawn).Bleed(deltaTime);
      Human(pawn).UpdateTimePlayed(DeltaTime);
      Human(pawn).RepairInventory(); //

  		if (Human(pawn).bOnFire)
			{
				Human(pawn).burnTimer += deltaTime;
				if (Human(pawn).burnTimer >= 30)
					Human(pawn).ExtinguishFire();
			}
			// save some texture info
			//FloorMaterial = GetFloorMaterial();
			//WallMaterial = GetWallMaterial(WallNormal);

			// Check if player has walked outside a first-person convo.
			Human(pawn).CheckActiveConversationRadius();

			// Check if all the people involved in a conversation are 
			// still within a reasonable radius.
			Human(pawn).CheckActorDistances();
			Super.PlayerTick(DeltaTime);
		}	
}


state PlayerMousing
{
   exec function Fire(float f)
   {
      // do stuff here for when players click their fire/select button

      return;
   }

   simulated function PlayerMove(float DeltaTime)
   {
      local vector MouseV, ScreenV;

      // get the new mouse position offset
      MouseV.X = DeltaTime * aMouseX / (InputClass.default.MouseSensitivity * DesiredFOV * 0.01111);
      MouseV.Y = DeltaTime * aMouseY / (InputClass.default.MouseSensitivity * DesiredFOV * -0.01111);

      // update mouse position
      PlayerMouse += MouseV;

      // convert mouse position to screen coords, but only if we have good screen sizes
      if ((LastHUDSizeX > 0) && (LastHUDSizeY > 0))
      {
         ScreenV.X = PlayerMouse.X + LastHUDSizeX * 0.5;
         ScreenV.Y = PlayerMouse.Y + LastHUDSizeY * 0.5;
         // here is where you would use the screen coords to do a trace or check HUD elements
      }

      return;
   }
}


state Conversation
{
ignores SeePlayer, HearNoise, Bump;

	event PlayerTick(float deltaTime)
	{
		local rotator tempRot;
		local float   yawDelta;

		UpdateRotation(DeltaTime, 0);

		Human(pawn).UpdateInHand();
		Human(pawn).UpdateDynamicMusic(deltaTime);

		Human(pawn).DrugEffects(deltaTime);
		Human(pawn).Bleed(deltaTime);
		Human(pawn).MaintainEnergy(deltaTime);
    Human(pawn).UpdateTimePlayed(DeltaTime);
		// must update viewflash manually incase a flash happens during a convo
		ViewFlash(deltaTime);

		// Check if player has walked outside a first-person convo.
		Human(pawn).CheckActiveConversationRadius();
	
		// Check if all the people involved in a conversation are 
		// still within a reasonable radius.
		Human(pawn).CheckActorDistances();

		Super.PlayerTick(deltaTime);
//		LipSynch(deltaTime);

		// Keep turning towards the person we're speaking to
		if (Human(pawn).ConversationActor != None)
		{
//			Human(pawn).LookAtActor(Human(pawn).ConversationActor, true, true, true, 0, 0.5);

			// Hacky way to force the player to turn...
			tempRot = rot(0,0,0);
			tempRot.Yaw = (DesiredRotation.Yaw - Rotation.Yaw) & 65535;
			if (tempRot.Yaw > 32767)
				tempRot.Yaw -= 65536;
			yawDelta = RotationRate.Yaw * deltaTime;
			if (tempRot.Yaw > yawDelta)
				tempRot.Yaw = yawDelta;
			else if (tempRot.Yaw < -yawDelta)
				tempRot.Yaw = -yawDelta;
			SetRotation(Rotation + tempRot);
		}

		// Update Time Played
//		UpdateTimePlayed(deltaTime);
	}

	function EndState()
	{
		Human(pawn).conPlay = None;

		// Re-enable the PC's detectability
//		MakePlayerIgnored(false);

//		MoveTarget = None;
		bBehindView = false;
//		StopBlendAnims();
		Human(pawn).ConversationActor = None;
	}

Begin:
//function BeginState()
// {
		ClientMessage(self@"entered State Conversation");
	// Make sure we're stopped
		Velocity.X = 0;
		Velocity.Y = 0;
		Velocity.Z = 0;

		Human(pawn).Acceleration = Velocity;

		Human(pawn).PlayRising();

		// Make sure the player isn't on fire!
		if (Human(pawn).bOnFire)
			Human(pawn).ExtinguishFire();

	// Make sure the PC can't be attacked while in conversation
//	MakePlayerIgnored(true);

//		Human(pawn).LookAtActor(Human(pawn).conPlay.startActor, true, false, true, 0, 0.5);

		Human(pawn).SetRotation(DesiredRotation);

		Human(pawn).PlayTurning();
//	TurnToward(conPlay.startActor);
//	TweenToWaiting(0.1);
//	FinishAnim();

		if (!Human(pawn).conPlay.StartConversation(Human(pawn))) // self
		{
			Human(pawn).AbortConversation(True);
			ClientMessage(self@"Conversation ABORTED!!!");
		}
		else
		{
			// Put away whatever the PC may be holding
			Human(pawn).conPlay.SetInHand(Human(pawn).InHand);
			Human(pawn).PutInHand(None);
			Human(pawn).UpdateInHand();

			if (Human(pawn).conPlay.GetDisplayMode() == DM_ThirdPerson )
				bBehindView = true;	
		}
// }
}


exec function QuickSave();

function ShowMidGameMenu(bool bPause)
{
  if ((DeusExGameInfo(level.game).missionNumber == -2) || (DeusExGameInfo(level.game).missionNumber == -1))
  ClientOpenMenu(class'GameEngine'.default.MainMenuClass);

   else
    {
     class'DxUtil'.static.PrepareShotForSaveGame(self.XLevel, ConsoleCommand("get System savepath"));

	// Pause if not already
   if(bPause && Level.Pauser == None)
	   SetPause(true);
     StopForceFeedback();  // jdf - no way to pause feedback
     ClientOpenMenu(MidGameMenuClass);
    }
}

function DeusExGameInfo getFlagBase()
{
  return DeusExGameInfo(Level.Game);
}

defaultproperties
{
  MaxFrobDistance=112.00
  bWantsLedgeCheck=false
}
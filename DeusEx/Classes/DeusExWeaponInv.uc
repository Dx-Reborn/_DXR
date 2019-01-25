// ==============================
//  Классы оружия для инвентаря
// ==============================

class DeusExWeaponInv extends WeaponEx;

var name AnimSequence, lastMaterialGroup;
var float AnimFrame,AnimRate;

// for tweaking Projectile spawning offset  // +x forward, +y right, +z up
exec function Zup() // Z
{
   ProjSpawnOffset.Z += 1;
   pawn(owner).Clientmessage("proj spawn offset: X = "$ProjSpawnOffset.X$" Y = "$ProjSpawnOffset.Y$" Z = "$ProjSpawnOffset.Z);
}

exec function Zdown() // A
{
   ProjSpawnOffset.Z -= 1;
   pawn(owner).Clientmessage("proj spawn offset: X = "$ProjSpawnOffset.X$" Y = "$ProjSpawnOffset.Y$" Z = "$ProjSpawnOffset.Z);
}

exec function Xup() // X
{
   ProjSpawnOffset.X += 1;
   pawn(owner).Clientmessage("proj spawn offset: X = "$ProjSpawnOffset.X$" Y = "$ProjSpawnOffset.Y$" Z = "$ProjSpawnOffset.Z);
}

exec function Xdown() // C
{
   ProjSpawnOffset.X -= 1;
   pawn(owner).Clientmessage("proj spawn offset: X = "$ProjSpawnOffset.X$" Y = "$ProjSpawnOffset.Y$" Z = "$ProjSpawnOffset.Z);
}

exec function Yup() // Y
{
   ProjSpawnOffset.Y += 1;
   pawn(owner).Clientmessage("proj spawn offset: X = "$ProjSpawnOffset.X$" Y = "$ProjSpawnOffset.Y$" Z = "$ProjSpawnOffset.Z);
}

exec function Ydown() // U
{
   ProjSpawnOffset.Y -= 1;
   pawn(owner).Clientmessage("proj spawn offset: X = "$ProjSpawnOffset.X$" Y = "$ProjSpawnOffset.Y$" Z = "$ProjSpawnOffset.Z);
}


function TravelPostAccept()
{
	local int i;

	Super.TravelPostAccept();

	// make sure the AmmoName matches the currently loaded AmmoType
	if (AmmoType != None)
		AmmoName = AmmoType.Class;

	if (!bInstantHit)
	{
		if (ProjectileClass != None)
			ProjectileSpeed = ProjectileClass.Default.speed;

		// make sure the projectile info matches the actual AmmoType
		// since we can't "var travel class" (AmmoName and ProjectileClass)
		if (AmmoType != None)
		{
			FireSound = None;
			for (i=0; i<ArrayCount(AmmoNames); i++)
			{
				if (AmmoNames[i] == AmmoName)
				{
					ProjectileClass = ProjectileNames[i];
					break;
				}
			}
		}
	}
}

function bool HandlePickupQuery(Inventory Item)
{
	local DeusExWeaponInv W;
	local DeusExPlayer player;
	local bool bResult;
	
	// make sure that if you pick up a modded weapon that you
	// already have, you get the mods
	W = DeusExWeaponInv(Item);
	if ((W != None) && (W.Class == Class))
	{
		if (W.ModBaseAccuracy > ModBaseAccuracy)
			ModBaseAccuracy = W.ModBaseAccuracy;
		if (W.ModReloadCount > ModReloadCount)
			ModReloadCount = W.ModReloadCount;
		if (W.ModAccurateRange > ModAccurateRange)
			ModAccurateRange = W.ModAccurateRange;

		// these are negative
		if (W.ModReloadTime < ModReloadTime)
			ModReloadTime = W.ModReloadTime;
		if (W.ModRecoilStrength < ModRecoilStrength)
			ModRecoilStrength = W.ModRecoilStrength;

		if (W.bHasLaser)
			bHasLaser = True;
		if (W.bHasSilencer)
			bHasSilencer = True;
		if (W.bHasScope)
			bHasScope = True;

		// copy the actual stats as well
		if (W.ReloadCount > ReloadCount)
			ReloadCount = W.ReloadCount;
		if (W.AccurateRange > AccurateRange)
			AccurateRange = W.AccurateRange;

		// these are negative
		if (W.BaseAccuracy < BaseAccuracy)
			BaseAccuracy = W.BaseAccuracy;
		if (W.ReloadTime < ReloadTime)
			ReloadTime = W.ReloadTime;
		if (W.RecoilStrength < RecoilStrength)
			RecoilStrength = W.RecoilStrength;
	}

	bResult = Super.HandlePickupQuery(Item);

	// Notify the object belt of the new ammo
	player = DeusExPlayer(Owner);
	if (player != None)
		player.UpdateBeltText(Self);

	return bResult;
}


function BringUp(optional weapon PrevWeapon)
{
	// alert NPCs that I'm whipping it out
	if (!bNativeAttack && bEmitWeaponDrawn)
		class'EventManager'.static.AIStartEvent(self,'WeaponDrawn', EAITYPE_Visual);

	// reset the standing still accuracy bonus
	standingTimer = 0;

	Super.BringUp();
}

function bool PutDown()
{
	// alert NPCs that I'm putting away my gun
	class'EventManager'.static.AIEndEvent(self,'WeaponDrawn', EAITYPE_Visual);

	// reset the standing still accuracy bonus
	standingTimer = 0;

	return Super.PutDown();
}

function ReloadAmmo()
{
	// single use or hand to hand weapon if ReloadCount == 0
	if (ReloadCount == 0)
	{
		Pawn(Owner).ClientMessage(msgCannotBeReloaded);
		return;
	}

	if (!IsInState('Reload'))
	{
		TweenAnim('Still', 0.1);
		GotoState('Reload');
	}
}

function float GetWeaponSkill()
{
	local DeusExPlayer player;
	local float value;

	player = DeusExPlayer(Owner);
	value = 0.0;

	if (player != None)
	{
		// get the target augmentation
		value = player.AugmentationSystem.GetAugLevelValue(class'AugTarget');
		if (value == -1.0)
			value = 0;

		// get the skill
		value += player.SkillSystem.GetSkillLevelValue(GoverningSkill);
	}

	return value;
}

// calculate the accuracy for this weapon and the owner's damage
function float CalculateAccuracy()
{
	local float accuracy;	// 0 is dead on, 1 is pretty far off
	local float tempacc, div;
	local int HealthArmRight, HealthArmLeft, HealthHead;
	local int BestArmRight, BestArmLeft, BestHead;
	local bool checkit;
	local DeusExPlayer player;

	accuracy = BaseAccuracy;		// start with the weapon's base accuracy

	player = DeusExPlayer(Owner);

	if (player != None)
	{
		// check the player's skill
		// 0.0 = dead on, 1.0 = way off
		accuracy += GetWeaponSkill();

		// get the health values for the player
		HealthArmRight = player.HealthArmRight;
		HealthArmLeft  = player.HealthArmLeft;
		HealthHead     = player.HealthHead;
		BestArmRight   = player.Default.HealthArmRight;
		BestArmLeft    = player.Default.HealthArmLeft;
		BestHead       = player.Default.HealthHead;
		checkit = True;
	}
	else if (ScriptedPawn(Owner) != None)
	{
		// update the weapon's accuracy with the ScriptedPawn's BaseAccuracy
		// (BaseAccuracy uses higher values for less accuracy, hence we add)
		accuracy += ScriptedPawn(Owner).BaseAccuracy;

		// get the health values for the NPC
		HealthArmRight = ScriptedPawn(Owner).HealthArmRight;
		HealthArmLeft  = ScriptedPawn(Owner).HealthArmLeft;
		HealthHead     = ScriptedPawn(Owner).HealthHead;
		BestArmRight   = ScriptedPawn(Owner).Default.HealthArmRight;
		BestArmLeft    = ScriptedPawn(Owner).Default.HealthArmLeft;
		BestHead       = ScriptedPawn(Owner).Default.HealthHead;
		checkit = True;
	}
	else
		checkit = False;

	if (checkit)
	{
		if (HealthArmRight < 1)
			accuracy += 0.5;
		else if (HealthArmRight < BestArmRight * 0.34)
			accuracy += 0.2;
		else if (HealthArmRight < BestArmRight * 0.67)
			accuracy += 0.1;

		if (HealthArmLeft < 1)
			accuracy += 0.5;
		else if (HealthArmLeft < BestArmLeft * 0.34)
			accuracy += 0.2;
		else if (HealthArmLeft < BestArmLeft * 0.67)
			accuracy += 0.1;

		if (HealthHead < BestHead * 0.67)
			accuracy += 0.1;
	}

	// increase accuracy (decrease value) if we haven't been moving for awhile
	// this only works for the player, because NPCs don't need any more aiming help!
	if (player != None)
	{
		tempacc = accuracy;
		if (standingTimer > 0)
		{
			// higher skill makes standing bonus greater
			div = Max(15.0 + 29.0 * GetWeaponSkill(), 0.0);
			accuracy -= FClamp(standingTimer/div, 0.0, 0.6);
	
			// don't go too low
			if ((accuracy < 0.1) && (tempacc > 0.1))
				accuracy = 0.1;
		}
	}

	// make sure we don't go negative
	if (accuracy < 0.0)
		accuracy = 0.0;

	return accuracy;
}

//
// functions to change ammo types
//
function bool LoadAmmo(int ammoNum)
{
	local class<Ammunition> newAmmoClass;
	local Ammunition newAmmo;
	local Pawn P;

	if ((ammoNum < 0) || (ammoNum > 2))
		return False;

	P = Pawn(Owner);

	// sorry, only pawns can have weapons
	if (P == None)
		return False;

	newAmmoClass = AmmoNames[ammoNum];

	if (newAmmoClass != None)
	{
		if (newAmmoClass != AmmoName)
		{
			newAmmo = Ammunition(P.FindInventoryType(newAmmoClass));
			if (newAmmo == None)
			{
				P.ClientMessage(Sprintf(msgOutOf, newAmmoClass.default.ItemName));
				return False;
			}
			
			// if we don't have a projectile for this ammo type, then set instant hit
			if (ProjectileNames[ammoNum] == None)
			{
				bInstantHit = True;
				bAutomatic = Default.bAutomatic;
				ShotTime = Default.ShotTime;
				if (HasReloadMod())
					ReloadTime = Default.ReloadTime * (1.0+ModReloadTime);
				else
					ReloadTime = Default.ReloadTime;
				FireSound = Default.FireSound;
				ProjectileClass = None;
			}
			else
			{
				// otherwise, set us to fire projectiles
				bInstantHit = False;
				bAutomatic = False;
				ShotTime = 1.0;
				if (HasReloadMod())
					ReloadTime = 2.0 * (1.0+ModReloadTime);
				else
					ReloadTime = 2.0;
				FireSound = None;		// handled by the projectile
				ProjectileClass = ProjectileNames[ammoNum];
				ProjectileSpeed = ProjectileClass.Default.Speed;
			}

			AmmoName = newAmmoClass;
			AmmoType = newAmmo;

			// Notify the object belt of the new ammo
			if (DeusExPlayer(P) != None)
				DeusExPlayer(P).UpdateBeltText(Self);

			ReloadAmmo();

			P.ClientMessage(Sprintf(msgNowHas, ItemName, newAmmoClass.Default.ItemName));
			return True;
		}
		else
		{
			P.ClientMessage(Sprintf(MsgAlreadyHas, ItemName, newAmmoClass.Default.ItemName));
		}
	}

	return False;
}

// ----------------------------------------------------------------------
// CanLoadAmmoType()
//
// Returns True if this ammo type can be used with this weapon
// ----------------------------------------------------------------------

function bool CanLoadAmmoType(Ammunition ammo)
{
	local int  ammoIndex;
	local bool bCanLoad;

	bCanLoad = False;

	if (ammo != None)
	{
		// First check "AmmoName"

		if (AmmoName == ammo.Class)
		{
			bCanLoad = True;
		}
		else
		{
			for (ammoIndex=0; ammoIndex<3; ammoIndex++)
			{
				if (AmmoNames[ammoIndex] == ammo.Class)
				{
					bCanLoad = True;
					break;
				}
			}
		}
	}

	return bCanLoad;
}

// ----------------------------------------------------------------------
// LoadAmmoType()
// 
// Load this ammo type given the actual object
// ----------------------------------------------------------------------

function LoadAmmoType(Ammunition ammo)
{
	local int i;

	if (ammo != None)
		for (i=0; i<3; i++)
			if (AmmoNames[i] == ammo.Class)
				LoadAmmo(i);
}

// ----------------------------------------------------------------------
// LoadAmmoClass()
// 
// Load this ammo type given the class
// ----------------------------------------------------------------------

function LoadAmmoClass(Class<Ammunition> ammoClass)
{
	local int i;

	if (ammoClass != None)
		for (i=0; i<3; i++)
			if (AmmoNames[i] == ammoClass)
				LoadAmmo(i);
}

// ----------------------------------------------------------------------
// CycleAmmo()
// ----------------------------------------------------------------------

function CycleAmmo()
{
	local int i, last;

	if (NumAmmoTypesAvailable() < 2)
		return;

	for (i=0; i<ArrayCount(AmmoNames); i++)
		if (AmmoNames[i] == AmmoName)
			break;

	last = i;

	do
	{
		if (++i >= 3)
			i = 0;

		if (LoadAmmo(i))
			break;
	} until (last == i);
}

function bool CanReload()
{
	if ((ClipCount > 0) && (ReloadCount != 0) && (AmmoType != None) && (AmmoType.AmmoAmount > 0) &&
	    (AmmoType.AmmoAmount > (ReloadCount-ClipCount)))
		return true;
	else
		return false;
}

function bool MustReload()
{
	if ((AmmoLeftInClip() == 0) && (AmmoType != None) && (AmmoType.AmmoAmount > 0))
		return true;
	else
		return false;
}

function int AmmoLeftInClip()
{
	if (ReloadCount == 0)	// if this weapon is not reloadable
		return 1;
	else if (AmmoType == None)
		return 0;
	else if (AmmoType.AmmoAmount == 0)		// if we are out of ammo
		return 0;
	else if (ReloadCount - ClipCount > AmmoType.AmmoAmount)		// if we have no clips left
		return AmmoType.AmmoAmount;
	else
		return ReloadCount - ClipCount;
}

function int NumClips()
{
	if (ReloadCount == 0)  // if this weapon is not reloadable
		return 0;
	else if (AmmoType == None)
		return 0;
	else if (AmmoType.AmmoAmount == 0)	// if we are out of ammo
		return 0;
	else  // compute remaining clips
		return ((AmmoType.AmmoAmount-AmmoLeftInClip()) + (ReloadCount-1)) / ReloadCount;
}

function int AmmoAvailable(int ammoNum)
{
	local class<Ammunition> newAmmoClass;
	local Ammunition newAmmo;
	local Pawn P;

	P = Pawn(Owner);

	// sorry, only pawns can have weapons
	if (P == None)
		return 0;

	newAmmoClass = AmmoNames[ammoNum];

	if (newAmmoClass == None)
		return 0;

	newAmmo = Ammunition(P.FindInventoryType(newAmmoClass));

	if (newAmmo == None)
		return 0;

	return newAmmo.AmmoAmount;
}

function int NumAmmoTypesAvailable()
{
	local int i;

	for (i=0; i<ArrayCount(AmmoNames); i++)
		if (AmmoNames[i] == None)
			break;

	// to make Al fucking happy
	if (i == 0)
		i = 1;

	return i;
}

function class<DamageType> WeaponDamageType()
{
	local class<DamageType>      damageType;
	local class<DeusExProjectile> projClass;

	projClass = class<DeusExProjectile>(ProjectileClass);
	if (bInstantHit)
	{
		if (StunDuration > 0)
			damageType = class'DM_Stunned';
		else
			damageType = class'DM_Shot';

		if (AmmoType != None)
			if (AmmoType.IsA('AmmoSabot'))
				damageType = class'DM_Sabot';
	}
	else if (projClass != None)
		damageType = projClass.Default.damageType;
	else
		damageType = none;//'None';

	return (damageType);
}


//
// target tracking info
//
function Actor AcquireTarget()
{
	local vector StartTrace, EndTrace, HitLocation, HitNormal;
	local Actor hit;//, retval;
	local Pawn p;

	p = Pawn(Owner);
	if (p == None)
		return None;

	StartTrace = p.Location;
	if (PlayerPawn(p) != None)
		EndTrace = p.Location + (10000 * Vector(p.GetViewRotation()));
	else
		EndTrace = p.Location + (10000 * Vector(p.Rotation));

	// adjust for eye height
	StartTrace.Z += p.BaseEyeHeight;
	EndTrace.Z += p.BaseEyeHeight;

	foreach TraceActors(class'Actor', hit, HitLocation, HitNormal, EndTrace, StartTrace)
		if (!hit.bHidden && (hit.IsA('Decoration') || hit.IsA('Pawn')))
			return hit;

	return None;
}

//
// Used to determine if we are near (and facing) a wall for placing LAMs, etc.
//
function bool NearWallCheck()
{
	local Vector StartTrace, EndTrace, HitLocation, HitNormal;
	local Actor HitActor;

	// Scripted pawns can't place LAMs
	if (ScriptedPawn(Owner) != None)
		return False;

	// trace out one foot in front of the pawn
	StartTrace = Owner.Location;
	EndTrace = StartTrace + Vector(Pawn(Owner).GetViewRotation()) * 32;

	StartTrace.Z += Pawn(Owner).BaseEyeHeight;
	EndTrace.Z += Pawn(Owner).BaseEyeHeight;

	HitActor = Trace(HitLocation, HitNormal, EndTrace, StartTrace);
	if ((HitActor == Level) || ((HitActor != none) && HitActor.IsA('StaticMeshActor')) || ((HitActor != None) && HitActor.IsA('Mover')))
	{
		placeLocation = HitLocation;
		placeNormal = HitNormal;
		placeMover = Mover(HitActor);
		return True;
	}

	return False;
}

//
// used to place a grenade on the wall
//
function PlaceGrenade()
{
	local ThrownProjectile gren;
	local float dmgX;

	gren = ThrownProjectile(spawn(ProjectileClass, Owner,, placeLocation, Rotator(placeNormal)));
	if (gren != None)
	{
		gren.PlayAnim('Open');
		gren.PlaySound(gren.MiscSound, SLOT_None, 0.5+FRand()*0.5,, 512, 0.85+FRand()*0.3);
		gren.SetPhysics(PHYS_None);
		gren.bBounce = False;
		gren.bProximityTriggered = True;
		gren.bStuck = True;
		if (placeMover != None)
			gren.SetBase(placeMover);

		// up the damage based on the skill
		// returned value from GetWeaponSkill is negative, so negate it to make it positive
		// dmgX value ranges from 1.0 to 2.4 (max demo skill and max target aug)
		dmgX = -2.0 * GetWeaponSkill() + 1.0;
		gren.Damage *= dmgX;

		// Update ammo count on object belt
		if (DeusExPlayer(Owner) != None)
			DeusExPlayer(Owner).UpdateBeltText(Self);
	}
}

//
// scope, laser, and targetting updates are done here
//
simulated function WeaponTick(float deltaTime)
{
	local vector loc;
	local rotator rot, recoilrot, limitRot, extraRot;
	local float beepspeed, recoil;
	local DeusExPlayer player;
	local Pawn pawn;

	player = DeusExPlayer(Owner);
	pawn = Pawn(Owner);

	// don't do any of this if this weapon isn't currently in use
	if (pawn == None)
		return;

	if (pawn.Weapon != self)
		return;

	GetAnimParams(0,AnimSequence,AnimFrame,AnimRate);


	// all this should only happen IF you have ammo loaded
	if (ClipCount < ReloadCount)
	{
		// check for LAM or other placed mine placement
		if (bHandToHand && (ProjectileClass != None))
		{
			if (NearWallCheck())
			{
				if (!bNearWall || (AnimSequence == 'Select'))
				{
					PlayAnim('PlaceBegin',, 0.1);
					bNearWall = True;
				}
			}
			else
			{
				if (bNearWall)
				{
					PlayAnim('PlaceEnd',, 0.1);
					bNearWall = False;
				}
			}
		}

		if (bCanTrack)
		{
			Target = AcquireTarget();

			// change LockTime based on skill
			// -0.7 = max skill
			LockTime = FMax(Default.LockTime + 3.0 * GetWeaponSkill(), 0.0);

			// calculate the range
			if (Target != None)
				TargetRange = Abs(VSize(Target.Location - Location));

			// update our timers
			LockTimer += deltaTime;
			SoundTimer += deltaTime;

			// check target and range info to see what our mode is
			if ((Target == None) || IsInState('Reload'))
				LockMode = LOCK_None;
			else if (!Target.IsA('Pawn'))
				LockMode = LOCK_Invalid;
			else
			{
				if (TargetRange > MaxRange)
					LockMode = LOCK_Range;
				else
				{
					if (LockTimer >= LockTime)
						LockMode = LOCK_Locked;
					else
						LockMode = LOCK_Acquire;
				}
			}

			// act on the lock mode
			switch (LockMode)
			{
				case LOCK_None:
					TargetMessage = msgNone;
					LockTimer = 0;
					break;

				case LOCK_Invalid:
					TargetMessage = msgLockInvalid;
					LockTimer = 0;
					break;

				case LOCK_Range:
					TargetMessage = msgLockRange @ Int(TargetRange/16) @ msgRangeUnit;
					LockTimer = 0;
					break;

				case LOCK_Acquire:
					TargetMessage = msgLockAcquire @ Left(String(LockTime-LockTimer), 4) @ msgTimeUnit;
					beepspeed = FClamp((LockTime - LockTimer) / Default.LockTime, 0.2, 1.0);
					if (SoundTimer > beepspeed)
					{
						Owner.PlaySound(TrackingSound, SLOT_None);
						SoundTimer = 0;
					}
					break;

				case LOCK_Locked:
					TargetMessage = msgLockLocked @ Int(TargetRange/16) @ msgRangeUnit;
					if (SoundTimer > 0.1)
					{
						Owner.PlaySound(LockedSound, SLOT_None);
						SoundTimer = 0;
					}
					break;
			}
		}
	}
	else
	{
		LockMode = LOCK_None;
		TargetMessage = msgNone;
		LockTimer = 0;
	}

	currentAccuracy = CalculateAccuracy();

	if (player != None)
	{
		// reduce the recoil based on skill
		recoil = recoilStrength + GetWeaponSkill() * 2.0;
		if (recoil < 0.0)
			recoil = 0.0;

		// simulate recoil while firing
		if (bFiring && IsAnimating() && (AnimSequence == 'Shoot') && (recoil > 0.0))
		{
		  recoilrot.roll = player.GetViewRotation().roll;
		  recoilrot.Yaw = player.GetViewRotation().yaw + deltaTime * (Rand(4096) - 2048) * recoil; //.Yaw += deltaTime * (Rand(4096) - 2048) * recoil;
		  recoilrot.Pitch = player.GetViewRotation().Pitch + deltaTime * (Rand(4096) + 4096) * recoil;//.Pitch += deltaTime * (Rand(4096) + 4096) * recoil;
			player.SetViewRotation(recoilrot);
			                                 
			if ((player.GetViewRotation().Pitch > 16384) && (player.GetViewRotation().Pitch < 32768))
			{
			  limitRot.roll = player.GetViewRotation().roll;
			  limitRot.yaw = player.GetViewRotation().yaw;
			  limitRot.Pitch = 16384;

				player.SetViewRotation(limitRot);//.Pitch = 16384;
			}
		}
	}

	// if were standing still, increase the timer
	if (VSize(Owner.Velocity) < 10)
		standingTimer += deltaTime;
	else	// otherwise, decrease it slowly based on velocity
		standingTimer = FMax(0, standingTimer - 0.03*deltaTime*VSize(Owner.Velocity));

	if (bLasing || bZoomed)
	{
		// shake our view to simulate poor aiming
		if (ShakeTimer > 0.25)
		{
			ShakeYaw = currentAccuracy * (Rand(4096) - 2048);
			ShakePitch = currentAccuracy * (Rand(4096) - 2048);
			ShakeTimer -= 0.25;
		}

		ShakeTimer += deltaTime;

		if (bLasing && (Emitter != None))
		{
			loc = Owner.Location;
			loc.Z += Pawn(Owner).BaseEyeHeight;

			// add a little random jitter - looks cool!
			rot = Pawn(Owner).GetViewRotation();
			rot.Yaw += Rand(5) - 2;
			rot.Pitch += Rand(5) - 2;

			Emitter.SetLocation(loc);
			Emitter.SetRotation(rot);
		}

		if ((player != None) && bZoomed)
		{
		  extraRot = player.GetViewRotation();
		  extraRot.Yaw = player.GetViewRotation().Yaw + deltaTime * ShakeYaw;
      extraRot.Pitch = player.GetViewRotation().Pitch + deltaTime * ShakePitch;
			player.SetViewRotation(extraRot);//.Yaw += deltaTime * ShakeYaw;
			//player.ViewRotation.Pitch += deltaTime * ShakePitch;
		}
	}
}

//
// scope functions for weapons which have them
//

function ScopeOn()
{
	if (bHasScope && !bZoomed && (Owner != None) && Owner.IsA('DeusExPlayer'))
	{
		// Show the Scope View
		bZoomed = True;
		DeusExPlayerController(DeusExPlayer(Owner).Controller).DesiredFov = ScopeFOV;
//		RefreshScopeDisplay(DeusExPlayer(Owner), False);
	}
}

function ScopeOff()
{
	if (bHasScope && bZoomed && (Owner != None) && Owner.IsA('DeusExPlayer'))
	{
		// Hide the Scope View
//		DeusExRootWindow(DeusExPlayer(Owner).rootWindow).scopeView.DeactivateView();
		bZoomed = False;
		DeusExPlayerController(DeusExPlayer(Owner).Controller).ResetFov();
	}
}

function ScopeToggle()
{
	if (IsInState('Idle'))
	{
		if (bHasScope && (Owner != None) && Owner.IsA('DeusExPlayer'))
		{
			if (bZoomed)
				ScopeOff();
			else
				ScopeOn();
		}
	}
}

// ----------------------------------------------------------------------
// RefreshScopeDisplay()
// ----------------------------------------------------------------------

function RefreshScopeDisplay(DeusExPlayer player, bool bInstant)
{
	if (bZoomed && (player != None))
	{
		// Show the Scope View
//		DeusExRootWindow(player.rootWindow).scopeView.ActivateView(ScopeFOV, False, bInstant);
	}
}

//
// laser functions for weapons which have them
//

function LaserOn()
{
	if (bHasLaser && !bLasing)
	{
		// if we don't have an emitter, then spawn one
		// otherwise, just turn it on
		if (Emitter == None)
		{
			Emitter = Spawn(class'EM_LaserBeam', Self, , Location, Pawn(Owner).GetViewRotation());
			if (Emitter != None)
			{
				Emitter.SetHiddenBeam(True);
				Emitter.AmbientSound = None;
				Emitter.TurnOn();
			}
		}
		else
			Emitter.TurnOn();

		bLasing = True;
	}
}

function LaserOff()
{
	if (bHasLaser && bLasing)
	{
		if (Emitter != None)
			Emitter.TurnOff();

		bLasing = False;
	}
}

function LaserToggle()
{
	if (IsInState('Idle'))
	{
		if (bHasLaser)
		{
			if (bLasing)
				LaserOff();
			else
				LaserOn();
		}
	}
}

//
// called from the MESH NOTIFY
//
function SwapMuzzleFlashTexture()
{
	if (FRand() < 0.5)
		Skins[2] = Texture'FlatFXTex34';
	else
		Skins[2] = Texture'FlatFXTex37';

	MuzzleFlashLight();
	SetTimer(0.1, False);
}

function EraseMuzzleFlashTexture()
{
//	Skins[2] = None;
}

function Timer()
{
	EraseMuzzleFlashTexture();
}

function MuzzleFlashLight()
{
	local Vector offset, X, Y, Z;

	if (!bHasMuzzleFlash)
		return;

	if ((flash != None) && !flash.bDeleteMe)
		flash.LifeSpan = flash.Default.LifeSpan;
	else
	{
		GetAxes(Pawn(Owner).GetViewRotation(),X,Y,Z);
		offset = Owner.Location;
		offset += X * Owner.CollisionRadius * 2;
		flash = spawn(class'MuzzleFlash',,, offset);
		if (flash != None)
			flash.SetBase(Owner);
	}
}

//
// HandToHandAttack
// called by the MESH NOTIFY for the H2H weapons
//
function HandToHandAttack()
{
	if (bOwnerWillNotify)
		return;

//	if (ScriptedPawn(Owner) != None)
//		ScriptedPawn(Owner).SetAttackAngle();

	if (bInstantHit)
		TraceFire(0.0,0,0);
	else
		ProjectileFire(ProjectileClass, ProjectileSpeed);
}

//
// OwnerHandToHandAttack
// called by the MESH NOTIFY for this weapon's owner
//
function OwnerHandToHandAttack()
{
	if (!bOwnerWillNotify)
		return;

//	if (ScriptedPawn(Owner) != None)
//		ScriptedPawn(Owner).SetAttackAngle();

	if (bInstantHit)
		TraceFire(0.0,0,0);
	else
		ProjectileFire(ProjectileClass, ProjectileSpeed);
}

//
// from Weapon.uc - modified so we can have the accuracy in TraceFire
//
function Fire(float Value)
{
	// check for surrounding environment
	if ((EnviroEffective == ENVEFF_Air) || (EnviroEffective == ENVEFF_Vacuum) || (EnviroEffective == ENVEFF_AirVacuum))
	{
		if (PhysicsVolume.bWaterVolume)
		{
			if (Pawn(Owner) != None)
			{
				Pawn(Owner).ClientMessage(msgNotWorking);
				if (!bHandToHand)
					Owner.PlaySound(Misc1Sound, SLOT_None,,, 1024);		// play dry fire sound
			}
			GotoState('Idle');
			return;
		}
	}

	if (bHandToHand)
	{
		if (ReloadCount > 0)
			AmmoType.UseAmmo(1);

		bReadyToFire = False;
		GotoState('NormalFire');
		bPointing=True;
		PlayFiring();
	}
	// if we are a single-use weapon, then our ReloadCount is 0 and we don't use ammo
	else if ((ClipCount < ReloadCount) || (ReloadCount == 0))
	{
		if ((ReloadCount == 0) || AmmoType.UseAmmo(1))
		{
			ClipCount++;
			bFiring = True;
			bReadyToFire = False;
			GotoState('NormalFire');
			if (PlayerPawn(Owner) != None)		// shake us based on accuracy
			   PlayerController(PlayerPawn(Owner).controller).ShakeView(ShakeRotMag, ShakeRotRate, ShakeRotTime,ShakeOffsetMag, ShakeOffsetRate, ShakeOffsetTime);
				//PlayerPawn(Owner).ShakeView(ShakeTime, currentAccuracy * ShakeMag + ShakeMag, currentAccuracy * ShakeVert);
			bPointing=True;
			if ( bInstantHit )
				TraceFire(currentAccuracy,0,0);
			else
				ProjectileFire(ProjectileClass, ProjectileSpeed);
			PlayFiring();
			if ( Owner.bHidden )
				CheckVisibility();
		}
		else
			Owner.PlaySound(Misc1Sound, SLOT_None,,, 1024);		// play dry fire sound
	}
	else
		Owner.PlaySound(Misc1Sound, SLOT_None,,, 1024);		// play dry fire sound

	// Update ammo count on object belt
	if (DeusExPlayer(Owner) != None)
		DeusExPlayer(Owner).UpdateBeltText(Self);
}

function ReadyToFire()
{
	if (!bReadyToFire)
	{
		// BOOGER!
		//if (ScriptedPawn(Owner) != None)
		//	ScriptedPawn(Owner).ReadyToFire();
		bReadyToFire = True;
	}
}

function PlayPostSelect()
{
	// let's not zero the ammo count anymore - you must always reload
//	ClipCount = 0;		
}

function PlayFiring()
{
	local float rnd;
	local Name anim;

	anim = 'Shoot';

	if (bAutomatic)
		LoopAnim(anim,, 0.1);
	else
	{
		if (bHandToHand)
		{
			rnd = FRand();
			if (rnd < 0.33)
				anim = 'Attack';
			else if (rnd < 0.66)
				anim = 'Attack2';
			else
				anim = 'Attack3';
		}
		PlayAnim(anim,,0.1);
	}

	if (bHasSilencer)
		Owner.PlaySound(Sound'StealthPistolFire', SLOT_None,,, 2048);
	else
		Owner.PlaySound(FireSound, SLOT_None,,, 2048);
}

function PlayIdleAnim()
{
	local float rnd;

	if (bZoomed || bNearWall)
		return;

	rnd = FRand();

	if (rnd < 0.1)
		PlayAnim('Idle1',,0.1);
	else if (rnd < 0.2)
		PlayAnim('Idle2',,0.1);
	else if (rnd < 0.3)
		PlayAnim('Idle3',,0.1);
}

function SpawnBlood(Vector HitLocation, Vector HitNormal)
{
	spawn(class'BloodSpurt',,,HitLocation+HitNormal);
	spawn(class'BloodDrop',,,HitLocation+HitNormal);
	if (FRand() < 0.5)
		spawn(class'BloodDrop',,,HitLocation+HitNormal);
}

function SpawnEffects(Vector HitLocation, Vector HitNormal, Actor Other, float Damage)
{
	local SmokeTrail puff;
	local int i;
	local BulletHole hole;
//	local Rotator rot;
	local DeusExMover mov;

	if (bPenetrating && !bHandToHand && !Other.IsA('DeusExDecoration'))
	{
		if (FRand() < 0.5)
		{
			puff = spawn(class'SmokeTrail',,,HitLocation+HitNormal, Rotator(HitNormal));
			if (puff != None)
			{
				puff.SetDrawScale(puff.DrawScale / 0.3);
				puff.OrigScale = puff.DrawScale;
				puff.LifeSpan = 0.25;
				puff.OrigLifeSpan = puff.LifeSpan;
			}
		}

		if (!Other.IsA('DeusExMover'))
			for (i=0; i<2; i++)
				if (FRand() < 0.8)
					spawn(class'Rockchip',,,HitLocation+HitNormal);
	}

	if (bHandToHand)
	{
		// if we are hand to hand, play an appropriate sound
		if (Other.IsA('DeusExDecoration'))
			Owner.PlaySound(Misc3Sound, SLOT_None,,, 1024);
		else if (Other.IsA('Pawn'))
			Owner.PlaySound(Misc1Sound, SLOT_None,,, 1024);
		else if (Other.IsA('BreakableGlass'))
			Owner.PlaySound(sound'GlassHit1', SLOT_None,,, 1024);
		else if (GetWallMaterial(HitLocation, HitNormal) == 'Glass')
			Owner.PlaySound(sound'BulletProofHit', SLOT_None,,, 1024);
		else
			Owner.PlaySound(Misc2Sound, SLOT_None,,, 1024);
	}
	else if (bInstantHit && bPenetrating)
	{
		//hole = spawn(class'BulletHole', Other,, HitLocation, Rotator(HitNormal));
    hole = Spawn(class'BulletHole', Other,,HitLocation, rotator(-1 * HitNormal));
	}

	// draw the correct damage art for what we hit
	if (bPenetrating || bHandToHand)
	{
		if (Other.IsA('DeusExMover'))
		{
			mov = DeusExMover(Other);
			if ((mov != None) && (hole == None))
          hole = Spawn(class'BulletHole', Other,,HitLocation, rotator(-1 * HitNormal));
				//hole = spawn(class'BulletHole', Other,, HitLocation, Rotator(HitNormal));

			if (hole != None)
			{
				if (mov.bBreakable && (mov.minDamageThreshold <= Damage))
				{
					// don't draw damage art on destroyed movers
					if (mov.bDestroyed)
						hole.Destroy();
					else if (mov.FragmentClass == class'GlassFragment')
					{
						// glass hole
						if (FRand() < 0.5)
							hole.ProjTexture = Texture'FlatFXTex29';
						else
							hole.ProjTexture = Texture'FlatFXTex30';

						hole.SetDrawScale(0.1);
						//hole.ReattachDecal();
					}
					else
					{
						// non-glass crack
						if (FRand() < 0.5)
							hole.ProjTexture = Texture'FlatFXTex7';
						else
							hole.ProjTexture = Texture'FlatFXTex8';

						hole.SetDrawScale(0.4);
						//hole.ReattachDecal();
					}
				}
				else
				{
					if (!bPenetrating || bHandToHand)
						hole.Destroy();
				}
			}
		}
	}
}

function name GetWallMaterial(vector HitLocation, vector HitNormal)
{
	local vector EndTrace, StartTrace;
	local actor mytarget;
	local int texFlags;
	local name texName, texGroup;

	StartTrace = HitLocation + HitNormal*16;		// make sure we start far enough out
	EndTrace = HitLocation - HitNormal;

	foreach class'ActorManager'.static.TraceTexture(self,class'Actor', mytarget, texName, texGroup, texFlags, StartTrace, HitNormal, EndTrace)
		if ((mytarget == Level) || mytarget.IsA('Mover'))
			break;

	return texGroup;
}

function GenerateBullet()
{
	if (AmmoType.UseAmmo(1))
	{
		if ( bInstantHit )
			TraceFire(currentAccuracy,0,0);
		else
			ProjectileFire(ProjectileClass, ProjectileSpeed);
		ClipCount++;
	}
	else
		GotoState('FinishFire');
}


//
// we have to use an actor to play the hit sound at the correct location
//
function PlayHitSound(actor destActor, Actor hitActor)
{
	local float rnd;
	local sound snd;
	local class<DamageType> damageType;

	damageType = WeaponDamageType();

	// don't ricochet unless it's hit by a bullet
	if ((damageType != class'DM_Shot') && (damageType != class'DM_Sabot'))
		return;

	rnd = FRand();

	if (rnd < 0.25)
		snd = sound'Ricochet1';
	else if (rnd < 0.5)
		snd = sound'Ricochet2';
	else if (rnd < 0.75)
		snd = sound'Ricochet3';
	else
		snd = sound'Ricochet4';

	// play a different ricochet sound if the object isn't damaged by normal bullets
	if (hitActor != None) 
	{
		if (hitActor.IsA('DeusExDecoration') && (DeusExDecoration(hitActor).minDamageThreshold > 10))
			snd = sound'ArmorRicochet';
		else if (hitActor.IsA('Robot'))
			snd = sound'ArmorRicochet';
	}

	if (destActor != None)
		destActor.PlaySound(snd, SLOT_None,,, 1024, 1.1 - 0.2*FRand());
}

// Only for ScriptedPawn.
function GetWeaponRanges(out float wMinRange,out float wMaxAccurateRange,out float wMaxRange)
{
	local Class<DeusExProjectile> dxProjectileClass;

	dxProjectileClass = Class<DeusExProjectile>(ProjectileClass);
	if (dxProjectileClass != None)
	{
		wMinRange         = dxProjectileClass.default.blastRadius;
		wMaxAccurateRange = dxProjectileClass.default.AccurateRange;
		wMaxRange         = dxProjectileClass.default.MaxRange;
	}
	else
	{
		wMinRange         = 0;
		wMaxAccurateRange = AccurateRange;
		wMaxRange         = MaxRange;
	}
}

//
// computes the start position of a projectile/trace
//
function Vector ComputeProjectileStart(Vector X, Vector Y, Vector Z)
{
	local Vector Start;

	// if we are instant-hit, non-projectile, then don't offset our starting point by PlayerViewOffset
	if (bInstantHit)
		Start = Owner.Location + Pawn(Owner).BaseEyeHeight * vect(0,0,1);
	else
    //return Instigator.Location + Instigator.EyePosition() + X*ProjSpawnOffset.X + Y*ProjSpawnOffset.Y + Z*ProjSpawnOffset.Z;
		Start = Owner.Location + CalcDrawOffset() + ProjSpawnOffset.X * X + ProjSpawnOffset.Y * Y + ProjSpawnOffset.Z * Z;

	return Start;
}

//
// Modified to work better with scripted pawns
//
simulated function vector CalcDrawOffset()
{
	local vector		DrawOffset, WeaponBob;
	local ScriptedPawn	SPOwner;
	local Pawn			PawnOwner;

	SPOwner = ScriptedPawn(Owner);
	if (SPOwner != None)
	{
		DrawOffset = ((0.9/SPOwner.Controller.FOVAngle * PlayerViewOffset) >> SPOwner.GetViewRotation());
		DrawOffset += (SPOwner.BaseEyeHeight * vect(0,0,1));
	}
	else
	{
		// copied from Engine.Inventory to not be FOVAngle dependent
		PawnOwner = Pawn(Owner);
		DrawOffset = ((0.9/PawnOwner.controller.default.FOVAngle * PlayerViewOffset) >> PawnOwner.GetViewRotation());

		DrawOffset += (PawnOwner.EyeHeight * vect(0,0,1));
		WeaponBob = BobDamping * PawnOwner.WalkBob;
		WeaponBob.Z = (0.45 + 0.55 * BobDamping) * PawnOwner.WalkBob.Z;
		DrawOffset += WeaponBob;
	}

	return DrawOffset;
}

function GetAIVolume(out float volume, out float radius)
{
	volume = 0;
	radius = 0;

	if (!bHasSilencer && !bHandToHand)
	{
		volume = NoiseLevel*Pawn(Owner).SoundDampening;
		radius = volume * 800.0;
	}
}

//
// copied from Weapon.uc
//
function Projectile ProjectileFire(class<projectile> ProjClass, optional float ProjSpeed)
{
	local Vector StartProj, StartTrace, X, Y, Z;
  local Vector HitLocation, HitNormal;
  local Actor Other;
	local float mult;
	local DeusExProjectile proj;
	local float volume, radius;
	local int i, numProj;

	// AugCombat increases our speed (distance) if hand to hand
	mult = 1.0;
	if (bHandToHand && (DeusExPlayer(Owner) != None))
	{
		mult = DeusExPlayer(Owner).AugmentationSystem.GetAugLevelValue(class'AugCombat');
		if (mult == -1.0)
			mult = 1.0;
		ProjSpeed *= mult;
	}

	// skill also affects our damage
	// GetWeaponSkill returns 0.0 to -0.7 (max skill/aug)
	mult += -2.0 * GetWeaponSkill();

	// make noise if we are not silenced
	if (!bHasSilencer && !bHandToHand)
	{
		GetAIVolume(volume, radius);
		class'EventManager'.static.AISendEvent(owner,'WeaponFire', EAITYPE_Audio, volume, radius);
		class'EventManager'.static.AISendEvent(Owner,'LoudNoise', EAITYPE_Audio, volume, radius);
		if (!Owner.IsA('PlayerPawn'))
			class'EventManager'.static.AISendEvent(Owner,'Distress', EAITYPE_Audio, volume, radius);
	}

	// should we shoot multiple projectiles in a spread?
	if (AreaOfEffect == AOE_Sphere) // DXR: Added 
		numProj = 6;
	if (AreaOfEffect == AOE_Cone)
		numProj = 3;
	else
		numProj = 1;

//	GetAxes(Pawn(owner).GetViewRotation(),X,Y,Z);
//	StartProj = ComputeProjectileStart(X, Y, Z);
    GetViewAxes(X,Y,Z);

    StartTrace = Instigator.Location + Instigator.EyePosition();
    StartProj = StartTrace + X*ProjSpawnOffset.X;
    //if (!WeaponCentered())
	    StartProj = StartProj + Hand * Y*ProjSpawnOffset.Y + Z*ProjSpawnOffset.Z;

    Other = Trace(HitLocation, HitNormal, StartProj, StartTrace, false);
    if (Other != None)
    {
        StartProj = HitLocation;
    }

	for (i=0; i<numProj; i++)
	{
		AdjustedAim = AdjustAim(StartProj, AimError); //pawn(owner).AdjustAim(aFireProperties, Start, AimError);
		AdjustedAim.Yaw += currentAccuracy * (Rand(1024) - 512);
		AdjustedAim.Pitch += currentAccuracy * (Rand(1024) - 512);

		proj = DeusExProjectile(Spawn(ProjClass, Owner,, StartProj,  AdjustedAim));
//		log(proj$" rotation = "$proj.rotation$", defined = "$AdjustedAim);
		if (proj != None)
		{
			// AugCombat increases our damage as well
			proj.Damage *= mult;

//			proj.Correct(projSpawnoffset);

			// send the targetting information to the projectile
			if (bCanTrack && (Target != None) && (LockMode == LOCK_Locked))
			{
				proj.Target = Target;
				proj.bTracking = True;
			}
		}
	}

	return proj;
}

function Rotator AdjustAim(Vector Start, float InAimError)
{
	if ( !aFireProperties.bInitialized )
	{
		aFireProperties.AmmoClass = AmmoType.class;//AmmoClass;
		aFireProperties.ProjectileClass = ProjectileClass;
		aFireProperties.WarnTargetPct = 0.9;//AmmoType.WarnTargetPct;
		aFireProperties.MaxRange = MaxRange;//();
		aFireProperties.bTossed = bTossedOut;
		aFireProperties.bTrySplash = AmmoType.bRecommendSplashDamage;
		aFireProperties.bLeadTarget = AmmoType.bLeadTarget;
		aFireProperties.bInstantHit = bInstantHit; //AmmoType.bInstantHit;
		aFireProperties.bInitialized = true;
	}
    return Instigator.AdjustAim(aFireProperties, Start, InAimError);
}


//
// copied from Weapon.uc so we can add range information
//
function TraceFire(float Accuracy, float YOffset, float ZOffset)
{
	local vector HitLocation, HitNormal, StartTrace, EndTrace, X, Y, Z;
	local Rotator rot;
	local actor Other;
	local float dist, alpha, degrade;
	local int i, numSlugs;
	local float volume, radius;

	// make noise if we are not silenced
	if (!bHasSilencer && !bHandToHand)
	{
		GetAIVolume(volume, radius);
		class'EventManager'.static.AISendEvent(Owner,'WeaponFire', EAITYPE_Audio, volume, radius);
		class'EventManager'.static.AISendEvent(Owner,'LoudNoise', EAITYPE_Audio, volume, radius);
		if (!Owner.IsA('PlayerPawn'))
			class'EventManager'.static.AISendEvent(Owner,'Distress', EAITYPE_Audio, volume, radius);
	}

	GetAxes(Pawn(owner).GetViewRotation(),X,Y,Z);
	StartTrace = ComputeProjectileStart(X, Y, Z);
	AdjustedAim = AdjustAim(StartTrace, AimError*2); //pawn(owner).AdjustAim(aFireProperties, StartTrace, 2*AimError);
//	AdjustedAim = pawn(owner).AdjustAim(1000000, StartTrace, 2.75*AimError, False, False);

makeNoise(1.0);

	// check to see if we are a shotgun-type weapon
	if (AreaOfEffect == AOE_Sphere)
		numSlugs = 9;
	else if (AreaOfEffect == AOE_Cone)
		numSlugs = 5;
	else
		numSlugs = 1;

	// if there is a scope, but the player isn't using it, decrease the accuracy
	// so there is an advantage to using the scope
	if (bHasScope && !bZoomed)
		Accuracy += 0.2;
	// if the laser sight is on, make this shot dead on
	// also, if the scope is on, zero the accuracy so the shake makes the shot inaccurate
	else if (bLasing || bZoomed)
		Accuracy = 0.0;

	for (i=0; i<numSlugs; i++)
	{
		EndTrace = StartTrace + Accuracy * (FRand()-0.5)*Y*1000 + Accuracy * (FRand()-0.5)*Z*1000 ;
		EndTrace += (FMax(1024.0, MaxRange) * vector(AdjustedAim));
		Other = Trace(HitLocation,HitNormal,EndTrace,StartTrace,True);//Pawn(Owner).TraceShot(HitLocation,HitNormal,EndTrace,StartTrace);

		// randomly draw a tracer for relevant ammo types
		// don't draw tracers if we're zoomed in with a scope - looks stupid
		if (!bZoomed && (numSlugs == 1) && (FRand() < 0.5))
		{
			if ((AmmoName == Class'Ammo10mmInv') || (AmmoName == Class'Ammo3006Inv') || (AmmoName == Class'Ammo762mmInv'))
			{
				if (VSize(HitLocation - StartTrace) > 250)
				{
					rot = Rotator(EndTrace - StartTrace);
					Spawn(class'Tracer',,, StartTrace + 96 * Vector(rot), rot);
				}
			}
		}

		// check our range
		dist = Abs(VSize(HitLocation - Owner.Location));

		if (dist <= AccurateRange)		// we hit just fine
			ProcessTraceHit(Other, HitLocation, HitNormal, vector(AdjustedAim),Y,Z);
		else if (dist <= MaxRange)
		{
			// simulate gravity by lowering the bullet's hit point
			// based on the owner's distance from the ground
			alpha = (dist - AccurateRange) / (MaxRange - AccurateRange);
			degrade = 0.5 * Square(alpha);
			HitLocation.Z += degrade * (Owner.Location.Z - Owner.CollisionHeight);
			ProcessTraceHit(Other, HitLocation, HitNormal, vector(AdjustedAim),Y,Z);
		}
	}

	// otherwise we don't hit the target at all
}

function ProcessTraceHit(Actor Other, Vector HitLocation, Vector HitNormal, Vector X, Vector Y, Vector Z)
{
	local float        mult;
	local class<damageType>  damageType;
//	local Spark        spark;
//  local WallSparks     spark;
	local DeusExPlayer dxPlayer;

	if (Other != None)
	{
		// AugCombat increases our damage if hand to hand
		mult = 1.0;
		if (bHandToHand && (DeusExPlayer(Owner) != None))
		{
			mult = DeusExPlayer(Owner).AugmentationSystem.GetAugLevelValue(class'AugCombat');
			if (mult == -1.0)
				mult = 1.0;
		}

		// skill also affects our damage
		// GetWeaponSkill returns 0.0 to -0.7 (max skill/aug)
		mult += -2.0 * GetWeaponSkill();

		// Determine damage type
		damageType = WeaponDamageType();

		// spawn a little spark and make a ricochet sound if we hit something
		if (Other != None)
		{
			if (!bHandToHand && bInstantHit && bPenetrating)
			{
				/*spark = spawn(class'WallSparks',,,HitLocation+HitNormal, Rotator(HitNormal));
				if (spark != None)
				{
					spark.SetDrawScale(0.05);
					PlayHitSound(spark, Other);
				}*/
			}
		}

		if (Other != None)
		{
			if (Other.IsOwned())
			{
				dxPlayer = DeusExPlayer(Owner);
				if (dxPlayer != None)
					class'EventManager'.static.AISendEvent(dxPlayer,'Futz', EAITYPE_Visual);
			}
		}

		if ((Other == Level) || (Other.IsA('Mover')))
		{
			Other.TakeDamage(HitDamage * mult, Pawn(Owner), HitLocation, momentum*X, damageType);

			SpawnEffects(HitLocation, HitNormal, Other, HitDamage * mult);
		}
		else if ((Other != self) && (Other != Owner))
		{
			Other.TakeDamage(HitDamage * mult, Pawn(Owner), HitLocation, momentum*X, damageType);
			if (bHandToHand)
				SpawnEffects(HitLocation, HitNormal, Other, HitDamage * mult);

			if (bPenetrating && Other.IsA('Pawn') && !Other.IsA('Robot'))
				SpawnBlood(HitLocation, HitNormal);
		}
	}
}

// Finish a firing sequence (ripped off and modified from Engine\Weapon.uc)
function Finish()
{
	if (bHasMuzzleFlash)
		EraseMuzzleFlashTexture();

	if (bChangeWeapon)
	{
		GotoState('DownWeapon');
		return;
	}

	if (Pawn(Owner) == None)
	{
		GotoState('Idle');
		return;
	}

	if (PlayerPawn(Owner) == None)
	{
		if ( ((AmmoType==None) || (AmmoType.AmmoAmount<=0)) && ReloadCount!=0 )
		{
			Pawn(Owner).controller.StopFiring();
			Pawn(Owner).controller.SwitchToBestWeapon();
		}
		else if ((Pawn(Owner).controller.bFire != 0) && (FRand() < RefireRate))
			Global.Fire(0);
		else if ((Pawn(Owner).controller.bAltFire != 0) && (FRand() < AltRefireRate))
			Global.AltFire(0);	
		else 
		{
			Pawn(Owner).controller.StopFiring();
			GotoState('Idle');
		}
		return;
	}
	if ( ((AmmoType==None) || (AmmoType.AmmoAmount<=0)) || (Pawn(Owner).Weapon != self) )
		GotoState('Idle');
	else if (Pawn(Owner).controller.bFire!=0)
		Global.Fire(0);
	else if (Pawn(Owner).controller.bAltFire!=0)
		Global.AltFire(0);
	else 
		GotoState('Idle');
}

function CheckVisibility()
{
	local Pawn PawnOwner;

	PawnOwner = Pawn(Owner);
	if(Owner.bHidden && (PawnOwner.Health > 0) && (PawnOwner.Visibility < PawnOwner.Default.Visibility))
	{
		Owner.bHidden = false;
		PawnOwner.Visibility = PawnOwner.Default.Visibility;
	}
}


//
// weapon states
//

state NormalFire
{
	function AnimEnd(int Channel)
	{
		if (bAutomatic)
		{
			if ((Pawn(Owner).Controller.bFire != 0) && (AmmoType.AmmoAmount > 0))
			{
				if (PlayerPawn(Owner) != None)
					Global.Fire(0);
				else 
					GotoState('FinishFire');
			}
			else 
				GotoState('FinishFire');
		}
		else
		{
			// if we are a thrown weapon and we run out of ammo, destroy the weapon
			if (bHandToHand && (ReloadCount > 0) && (AmmoType.AmmoAmount <= 0))
				Destroy();
		}
	}

	function float GetShotTime()
	{
		local float mult;

		if (ScriptedPawn(Owner) != None)
			return ShotTime * (ScriptedPawn(Owner).BaseAccuracy*2+1);
		else
		{
			// AugCombat decreases shot time
			mult = 1.0;
			if (bHandToHand && DeusExPlayer(Owner) != None)
			{
				mult = 1.0 / DeusExPlayer(Owner).AugmentationSystem.GetAugLevelValue(class'AugCombat');
				if (mult == -1.0)
					mult = 1.0;
			}
			return (ShotTime * mult);
		}
	}

Begin:
	if ((ClipCount >= ReloadCount) && (ReloadCount != 0))
	{
		if (!bAutomatic)
		{
			bFiring = False;
			FinishAnim();
		}

		if (Owner != None)
		{
			if (Owner.IsA('DeusExPlayer'))
			{
				bFiring = False;

				// should we autoreload?
				if (DeusExPlayer(Owner).bAutoReload)
				{
					// auto switch ammo if we're out of ammo and
					// we're not using the primary ammo
					if ((AmmoType.AmmoAmount == 0) && (AmmoName != AmmoNames[0]))
						CycleAmmo();

					ReloadAmmo();
				}
				else
				{
					if (bHasMuzzleFlash)
						EraseMuzzleFlashTexture();
					GotoState('Idle');
				}
			}
			else if (Owner.IsA('ScriptedPawn'))
			{
				bFiring = False;
				ReloadAmmo();
			}
		}
		else
		{
			if (bHasMuzzleFlash)
				EraseMuzzleFlashTexture();
			GotoState('Idle');
		}
	}

	Sleep(GetShotTime());
	if (bAutomatic)
	{
		GenerateBullet();
		Goto('Begin');
	}
	bFiring = False;
	FinishAnim();

	// if ReloadCount is 0 and we're not hand to hand, then this is a
	// single-use weapon so destroy it after firing once
	if ((ReloadCount == 0) && !bHandToHand)
	{
		if (DeusExPlayer(Owner) != None)
			DeusExPlayer(Owner).RemoveItemFromSlot(Self);   // remove it from the inventory grid
		Destroy();
	}

	ReadyToFire();

Done:
	bFiring = False;
	Finish();
}

state FinishFire
{
Begin:
	bFiring = False;
	Finish();
}

state Pickup
{
	function BeginState()
	{
		// alert NPCs that I'm putting away my gun
		class'EventManager'.static.AIEndEvent(self,'WeaponDrawn', EAITYPE_Visual);

		Super.BeginState();
	}
}

state Reload
{
ignores Fire, AltFire;

	function float GetReloadTime()
	{
		local float val;

		val = ReloadTime;

		if (ScriptedPawn(Owner) != None)
		{
			val = ReloadTime * (ScriptedPawn(Owner).BaseAccuracy*2+1);
		}
		else if (DeusExPlayer(Owner) != None)
		{
			// check for skill use if we are the player
			val = GetWeaponSkill();
			val = ReloadTime + (val*ReloadTime);
		}

		return val;
	}

	function NotifyOwner(bool bStart)
	{
		local DeusExPlayer player;
		local ScriptedPawn pawn;

		player = DeusExPlayer(Owner);
		pawn   = ScriptedPawn(Owner);

		if (player != None)
		{
			if (bStart)
				player.Reloading(self, GetReloadTime()+(1.0/AnimRate));
			else
				player.DoneReloading(self);
		}
		else if (pawn != None)
		{
			if (bStart)
				pawn.Reloading(self, GetReloadTime()+(1.0/AnimRate));
			else
				pawn.DoneReloading(self);
		}
	}

Begin:
	FinishAnim();

	bWasZoomed = bZoomed;
	if (bWasZoomed)
		ScopeOff();

	// only reload if we have ammo left
	if (AmmoType.AmmoAmount > 0)
	{
		Owner.PlaySound(CockingSound, SLOT_None,,, 1024);		// CockingSound is reloadbegin
		PlayAnim('ReloadBegin');
		NotifyOwner(True);
		FinishAnim();
		LoopAnim('Reload');
		Sleep(GetReloadTime());
		Owner.PlaySound(ReloadEndSound, SLOT_None,,, 1024);		// AltFireSound is reloadend
		PlayAnim('ReloadEnd');
		FinishAnim();
		NotifyOwner(False);
	}

	if (bWasZoomed)
		ScopeOn();

	// don't actually complete the reload until AFTER the anims/sleep have finished
	ClipCount = 0;
	GotoState('Idle');
}

state Idle
{
	function bool PutDown()
	{
		// alert NPCs that I'm putting away my gun
		class'EventManager'.static.AIEndEvent(self,'WeaponDrawn', EAITYPE_Visual);

		return Super.PutDown();
	}

	function AnimEnd(int Channel)
	{
		
	}

	function Timer()
	{
		PlayIdleAnim();
	}

Begin:
	ReadyToFire();
	if (!bNearWall)
		PlayAnim('Idle1',,0.1);
	SetTimer(3.0, True);
}


state Active
{
	function bool PutDown()
	{
		// alert NPCs that I'm putting away my gun
		class'EventManager'.static.AIEndEvent(self,'WeaponDrawn', EAITYPE_Visual);

		return Super.PutDown();
	}

Begin:
	if (!Owner.IsA('ScriptedPawn'))
		FinishAnim();
	if ( bChangeWeapon )
		GotoState('DownWeapon');
	bWeaponUp = True;
	PlayPostSelect();
	if (!Owner.IsA('ScriptedPawn'))
		FinishAnim();

	// reload the weapon if it's empty and autoreload is true
	if ((ClipCount >= ReloadCount) && (ReloadCount != 0))
		if (Owner.IsA('ScriptedPawn') || ((DeusExPlayer(Owner) != None) && DeusExPlayer(Owner).bAutoReload))
			ReloadAmmo();

	Finish();
}


state DownWeapon
{
ignores Fire, AltFire;

	function bool PutDown()
	{
		// alert NPCs that I'm putting away my gun
		class'EventManager'.static.AIEndEvent(self,'WeaponDrawn', EAITYPE_Visual);

		return Super.PutDown();
	}

Begin:
    ScopeOff();
	LaserOff();
	TweenDown();
	FinishAnim();
	bOnlyOwnerSee = false;
	if (Pawn(Owner) != None)
		Pawn(Owner).ChangedWeapon();
}

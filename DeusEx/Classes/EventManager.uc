//===========================================================================================//
// EventManager. Рассылает событие акторам. Используется как аналог EventManager из Deus Ex. //
//===========================================================================================//

/*
// Чтобы не забыть
enum EAIEventState
{
	EAISTATE_Begin,
	EAISTATE_End,
	EAISTATE_Pulse,
	EAISTATE_ChangeBest
};
enum EAIEventType
{
	EAITYPE_Visual,
	EAITYPE_Audio,
	EAITYPE_Olifactory
};
struct XAIParams
{
	var actor BestActor;
	var float Score;
	var float Visibility;
	var float Volume;
	var float Smell;
};
*/

class EventManager extends Info
											placeable;

enum EAIEventState // DEUS_EX STM
{
	EAISTATE_Begin,
	EAISTATE_End,
	EAISTATE_Pulse,
	EAISTATE_ChangeBest
};
enum EAIEventType
{
	EAITYPE_Visual,
	EAITYPE_Audio,
	EAITYPE_Olifactory
};

// DEUS_EX AJY 
enum EBarkModes 
{
	BM_Idle,
	BM_CriticalDamage,
	BM_AreaSecure,
	BM_TargetAcquired,
	BM_TargetLost,
	BM_GoingForAlarm,
	BM_OutOfAmmo,
	BM_Scanning,
	BM_Futz,
	BM_OnFire,
	BM_TearGas,
	BM_Gore,
	BM_Surprise,
	BM_PreAttackSearching,
	BM_PreAttackSighting,
	BM_PostAttackSearching,
	BM_SearchGiveUp,
	BM_AllianceHostile,
	BM_AllianceFriendly,
};

//		AIStartEvent('Alarm', EAITYPE_Audio, SoundVolume/255.0, 25*(SoundRadius+1));

// TODO: Должна возвращать освещенность игрока
static function float AIGetLightLevel(vector Location)
{
	return 1.0;
}

// В оригинале не использовалась.
static function float AIVisibility(optional bool bIncludeVelocity)
{
	return 1.0;
}

static function AISetEventCallback(name eventName, name callback, 
														optional name scoreCallback, 
														optional bool bCheckVisibility, 
														optional bool bCheckDir,
														optional bool bCheckCylinder,
														optional bool bCheckLOS)
{
	// пока заглушка
//	Log("AISetEventCallback("@eventName@callback@scoreCallback@bCheckVisibility@bCheckDir@bCheckCylinder@bCheckLOS@")");
}

static function AIClearEventCallback(name eventName)
{
	// пока заглушка
//	Log("AIClearEventCallback("@eventName);
}

static function AISendEvent(actor A, name eventName, EAIEventType eventType, optional float Value, optional float Radius)
{
//   log("AISendEvent"@A@EventName@eventType@Value@radius);

   if (Radius < 1)
       Radius = 800;

   if (eventName == 'Futz')
   {
		 foreach A.RadiusActors(class'Actor', A, Radius)
		 {
			if (A.IsA('ScriptedPawn'))
				ScriptedPawn(A).ReactToFutz();
		 }
   }
}

static function AIStartEvent(actor A, name eventName, EAIEventType eventType, optional float Value, optional float Radius)
{
	if (eventName == 'Alarm')
	{
//		Log("AIStartEvent"@EventName@eventType@Value@radius);

		foreach A.RadiusActors(class'Actor', A, Radius)
		{
			If (A.IsA('AutoTurret')) // && (A != none))
				AutoTurret(A).AlarmHeard(eventName, EAISTATE_Begin); //, XAIParams);
		}
	}
}

static function AIEndEvent(actor A, name eventName, EAIEventType eventType)
{
	if (eventName == 'Alarm')
	{
//	Log("AIEndEvent"@EventName@eventType);

		foreach A.AllActors(class'Actor', A) // RadiusActors(class'Actor', A, Radius)
		{
			If (A.IsA('AutoTurret')) //&& (A != none))
				AutoTurret(A).AlarmHeard(eventName, EAISTATE_End); //, XAIParams);
		}
	}
}

static function AIClearEvent(name eventName)
{
//	Log("AIClearEvent"@EventName);
}


//=============================================================================
// Подсказка

/* Пример реакции:	EventManager.AIStartEvent('Alarm', EAITYPE_Audio, SoundVolume/255.0, 25*(SoundRadius+1));
function AlarmHeard(Name event, EAIEventState state, XAIParams params)
{
	if (state == EAISTATE_Begin)
	{
		if (!bActive)
		{
			bPreAlarmActiveState = bActive;
			bActive = True;
		}
	}
	else if (state == EAISTATE_End)
	{
		if (bActive)
			bActive = bPreAlarmActiveState;
	}
}*/


// Iterator functions for dealing with sets of actors.

/* AllActors() - avoid using AllActors() too often as it iterates through the whole actor list and is therefore slow
*/

//native(304) final iterator function AllActors     ( class<actor> BaseClass, out actor Actor, optional name MatchTag );

/* DynamicActors() only iterates through the non-static actors on the list (still relatively slow, bu
 much better than AllActors).  This should be used in most cases and replaces AllActors in most of
 Epic's game code.
*/
//native(313) final iterator function DynamicActors     ( class<actor> BaseClass, out actor Actor, optional name MatchTag );

/* ChildActors() returns all actors owned by this actor.  Slow like AllActors()
*/
//native(305) final iterator function ChildActors   ( class<actor> BaseClass, out actor Actor );

/* BasedActors() returns all actors based on the current actor (slow, like AllActors)
*/
//native(306) final iterator function BasedActors   ( class<actor> BaseClass, out actor Actor );

/* TouchingActors() returns all actors touching the current actor (fast)
*/
//native(307) final iterator function TouchingActors( class<actor> BaseClass, out actor Actor );

/* TraceActors() return all actors along a traced line.  Reasonably fast (like any trace)
*/
//native(309) final iterator function TraceActors   ( class<actor> BaseClass, out actor Actor, out vector HitLoc, out vector HitNorm, vector End, optional vector Start, optional vector Extent );

/* RadiusActors() returns all actors within a give radius.  Slow like AllActors().  Use CollidingActors() or VisibleCollidingActors() instead if desired actor types are visible
(not bHidden) and in the collision hash (bCollideActors is true)
*/
//native(310) final iterator function RadiusActors  ( class<actor> BaseClass, out actor Actor, float Radius, optional vector Loc );

/* VisibleActors() returns all visible (not bHidden) actors within a radius
for which a trace from Loc (which defaults to caller's Location) to that actor's Location does not hit the world.
Slow like AllActors(). Use VisibleCollidingActors() instead if desired actor types are in the collision hash (bCollideActors is true)
*/
//native(311) final iterator function VisibleActors ( class<actor> BaseClass, out actor Actor, optional float Radius, optional vector Loc );

/* VisibleCollidingActors() returns all colliding (bCollideActors==true) actors within a certain radius
for which a trace from Loc (which defaults to caller's Location) to that actor's Location does not hit the world.
Much faster than AllActors() since it uses the collision hash
*/
//native(312) final iterator function VisibleCollidingActors ( class<actor> BaseClass, out actor Actor, float Radius, optional vector Loc, optional bool bIgnoreHidden );

/* CollidingActors() returns colliding (bCollideActors==true) actors within a certain radius.
Much faster than AllActors() for reasonably small radii since it uses the collision hash
*/
//native(321) final iterator function CollidingActors ( class<actor> BaseClass, out actor Actor, float Radius, optional vector Loc );

defaultproperties
{
}

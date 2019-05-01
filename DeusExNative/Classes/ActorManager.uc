class ActorManager extends Object abstract native transient
		dependson(Actor);


native static function bool IsBasedOn(Actor ActorA, Actor ActorB);

// Used for State Sitting (for ScriptedPawn).
native static function bool IsOverlapping(Actor ActorA, Actor ActorB);

native static function int GetActorIndex(Level Level, Actor Actor);

// Advanced version of SetPhysics().
native static function SetPhysicsEx(Actor Actor, Actor.EPhysics NewPhysics, optional Actor NewFloor, optional vector NewFloorVector);

// For footstepping and checking BSP surface flags.
native final static iterator function TraceTexture(Actor Actor, Class<Actor> BaseClass, out Actor HitActor, out name TexName, out name TexGroup, out int TexFlags, out vector HitLoc, out vector HitNorm, vector TraceEnd, optional vector TraceStart, optional vector TraceExtent);

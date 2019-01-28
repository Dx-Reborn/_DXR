class ActorManager extends Object abstract native transient
		dependson(Actor);


native static function SetPhysicsEx(Actor Actor, Actor.EPhysics NewPhysics, optional Actor NewFloor, optional vector NewFloorVector);

native final static iterator function TraceTexture(Actor Actor, Class<Actor> BaseClass, out Actor HitActor, out name TexName, out name TexGroup, out int TexFlags, out vector HitLoc, out vector HitNorm, vector TraceEnd, optional vector TraceStart, optional vector TraceExtent);

native static function bool IsOverlapping(Actor ActorA, Actor ActorB);

native static function bool IsBasedOn(Actor ActorA, Actor ActorB);

native static function int GetActorIndex(Level Level, Actor Actor);


//=============================================================================
// Scout used for path generation.
//=============================================================================
class Scout extends Pawn
	native
	notplaceable;

var const float MaxLandingVelocity;

simulated function PreBeginPlay()
{
	Destroy(); //scouts shouldn't exist during play
}

defaultproperties
{
	 RemoteRole=ROLE_None
     AccelRate=+00001.000000
//     CollisionRadius=+00052.000000
//     CollisionHeight=+00078.000000

    CollisionRadius=52.00
    CollisionHeight=50.00

// 	 CrouchHeight=+15.0
//	 CrouchRadius=+12.0

     bCollideActors=False
     bCollideWorld=False
     bBlockActors=False
     bProjTarget=False
	 bPathColliding=True
}

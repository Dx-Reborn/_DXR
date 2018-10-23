//=============================================================================
// Liquor40oz.
//=============================================================================
class FireExtinguisherInv extends DeusExPickupInv;

function Timer()
{
	Destroy();
}

state Activated
{
	function Activate()
	{
		// can't turn it off
	}

	function BeginState()
	{
		local ProjectileGenerator gen;
		local Vector loc;
		local Rotator rot;

		Super.BeginState();

		// force-extinguish the player
		if (DeusExPlayer(Owner) != None)
			if (DeusExPlayer(Owner).bOnFire)
				DeusExPlayer(Owner).ExtinguishFire();

		// spew halon gas
		rot = Pawn(Owner).GetViewRotation();
		loc = Vector(rot) * Owner.CollisionRadius;
		loc.Z += Owner.CollisionHeight * 0.9;
		loc += Owner.Location;
		gen = Spawn(class'ProjectileGenerator', None,, loc, rot);
		if (gen != None)
		{
			gen.ProjectileClass = class'HalonGas';
			gen.SetBase(Owner);
			gen.LifeSpan = 3;
			gen.ejectSpeed = 300;
			gen.projectileLifeSpan = 1.5;
			gen.frequency = 0.9;
			gen.checkTime = 0.1;
			gen.bAmbientSound = True;
			gen.AmbientSound = sound'SteamVent2';
			gen.SoundVolume = 192;
			gen.SoundPitch = 32;
		}

		// blast for 3 seconds, then destroy
		SetTimer(3.0, False);
	}
Begin:
}


state DeActivated
{
}


defaultproperties
{
    bActivatable=True

    Description="A chemical fire extinguisher."
    beltDescription="FIRE EXT"
    ItemName="Fire Extinguisher"
    PlayerViewOffset=(X=30.00,Y=0.00,Z=-12.00)
    Icon=Texture'DeusExUI.Icons.BeltIconFireExtinguisher'
    largeIcon=Texture'DeusExUI.Icons.LargeIconFireExtinguisher'
    largeIconWidth=25
    largeIconHeight=49
    PickupClass=class'FireExtinguisher'

    Mesh=Mesh'DeusExItems.FireExtinguisher'
    PickupViewMesh=Mesh'DeusExItems.FireExtinguisher'
    FirstPersonViewMesh=Mesh'DeusExItems.FireExtinguisher'

    CollisionRadius=8.000000
    CollisionHeight=10.27
    Mass=10.000000
    Buoyancy=8.000000
}

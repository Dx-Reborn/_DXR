//=============================================================================
// Human.
//=============================================================================
class Human extends DeusExPlayer
	abstract;

function PlayDyingSound()
{
	if (PhysicsVolume.bWaterVolume)
		PlaySound(sound'MaleWaterDeath', SLOT_Pain,,,, RandomPitch());
	else
		PlaySound(die, SLOT_Pain,,,, RandomPitch());
}

event PlayDying(class<DamageType> DamageType, vector HitLoc)
{
	local Vector X, Y, Z;
	local float dotp;

//	ClientMessage("PlayDying()");
	GetAxes(GetViewRotation(), X, Y, Z);
	dotp = (Location - HitLoc) dot X;

	if (PhysicsVolume.bWaterVolume)
	{
		PlayAnim('WaterDeath',,0.1);
	}
	else
	{
		// die from the correct side
		if (dotp < 0.0)		// shot from the front, fall back
			PlayAnim('DeathBack',,0.1);
		else				// shot from the back, fall front
			PlayAnim('DeathFront',,0.1);
	}
	PlayDyingSound();
}




exec function spd() // то есть SavePlayerData()
{
  DeusExGameInfo(Level.game).SavePlayerData();
}

exec function rpd() // RestorePlayerData
{
  DeusExGameInfo(Level.game).RestorePlayerData("..\\Saves");
}

// ----------------------------------------------------------------------
// Dumps the inventory grid to the log file.  Useful for debugging only.
// ----------------------------------------------------------------------
exec function DumpInventoryGrid()
{
	local int slotsCol;
	local int slotsRow;
	local String gridRow;

	log("DumpInventoryGrid()");
	log("_____________________________________________________________");
	
	log("        1 2 3 4 5");
	log("-----------------");


	for(slotsRow=0; slotsRow < maxInvRows; slotsRow++)
	{
		gridRow = "Row #" $ slotsRow $ ": ";

		for (slotsCol=0; slotsCol < maxInvCols; slotsCol++)
		{
			if ( invSlots[(slotsRow * maxInvCols) + slotsCol] == 1)
				gridRow = gridRow $ "X ";
			else
				gridRow = gridRow $ "  ";
		}
		
		log(gridRow);
	}
	log("_____________________________________________________________");
}


defaultproperties
{
//    bIsHuman=True
    WaterSpeed=300.00
    AirSpeed=4000.00
    AccelRate=1000.00
    JumpZ=300.00
    BaseEyeHeight=40.00
    UnderWaterTime=20.00
    CollisionRadius=20.00
    CollisionHeight=47.50
    Mass=150.00
    Buoyancy=155.00
    RotationRate=(Pitch=4096,Yaw=50000,Roll=3072)
}


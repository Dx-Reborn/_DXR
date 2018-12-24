//=============================================================================
// Human.
// ��� ������� ���������� � DeusExPlayer, ���� ����� ������ � �������� ��� 
// �������������.
//=============================================================================
class Human extends DeusExPlayer
	abstract;

exec function spd() // �� ���� SavePlayerData()
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


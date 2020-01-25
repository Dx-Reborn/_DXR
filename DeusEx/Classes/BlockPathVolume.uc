/*
  Для устранения ненужных подводок.
*/

class BlockPathVolume extends BlockingVolume;

function PostBeginPlay()
{
	Super.PostBeginPlay();
	Destroy();
}

defaultproperties
{
     bStatic=False
     bNoDelete=False
     bBlockZeroExtentTraces=True
     bPathColliding=True
}
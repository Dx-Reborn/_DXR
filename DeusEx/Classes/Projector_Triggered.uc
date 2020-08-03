/*

*/

class Projector_Triggered extends Projector;

var() bool bInitialyOn;
var   bool bIsOn;

event PostBeginPlay()
{
  AttachProjector();
  if (bProjectActor)
      SetCollision(True,False,False);
  bIsOn = bInitialyOn;
  if (!bIsOn)
  {
    DetachProjector(True);
    DetachAllActors();
  }
}


function Trigger(actor Other,pawn Instigator)
{
  bIsOn = !bIsOn;
  if (bIsOn)
  {
    AttachProjector();
    ReattachAllActors();
  }
  else
  {
    DetachProjector(True);
    DetachAllActors();
  }
}

function DetachAllActors()
{
  local actor A;

  foreach TouchingActors(Class'Actor',A)
  {
    DetachActor(A);
  }
}

function ReattachAllActors()
{
  local actor A;

  foreach TouchingActors(Class'Actor',A)
  {
    AttachActor(A);
  }
}

event Touch(Actor Other)
{
  if (bIsOn)
      AttachActor(Other);
}

event Untouch(Actor Other)
{
  DetachActor(Other);
}

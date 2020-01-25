//=============================================================================
// MiniSub.
//=============================================================================
class MiniSub extends Vehicles;

var(Special) bool bIsSpecial; // Для перехода в затопленную лабораторию.
var(Special) Name FlagToCheck; // проверить флаг

function frob(Actor Frobber, inventory FrobWith)
{
  if (bIsSpecial)
  {
    if (GetFlagBase().GetBool(FlagToCheck))
       Super.Frob(Frobber, FrobWith);
  else
  return;
  }
  else 
  Super.Frob(Frobber, FrobWith);
}

function Trigger(actor Other, pawn EventInstigator)
{
 bIsSpecial= !bIsSpecial; // Перевернуть
}


defaultproperties
{
     FlagToCheck=doors_open
     ItemName="Mini-Submarine"
     mesh=mesh'DeusExDeco.MiniSub'
     CollisionRadius=110.629997
     CollisionHeight=53.439999
     Mass=10000.000000
     Buoyancy=10000.000000
     Skins(0)=Shader'DeusExDeco_EX.Shader.MiniSubTex1_SH'
     Skins(1)=Shader'DeusExDeco_EX.Shader.MiniSubTex1_SH'
     Skins(2)=Shader'DeusExDeco_EX.Shader.MiniSubTex1_SH'
     Skins(3)=Shader'DeusExDeco_EX.Shader.MiniSubTex1_SH'
     Skins(4)=Shader'DeusExStaticMeshes.Glass.GlassSH1'
}

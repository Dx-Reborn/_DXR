//
// �������� ��������� ��������� ��� ��������
//
// ����������� �� �������� �����-������.
// ��� ������������� �����
// �������������� ������� �������� (�� ������ ��� ���������)
//


Class DeusExLadderVolume extends LadderVolume;

var() bool bIsWoodLadder; // ������� ������ ����� �� "����������". ������� ����������� ����� DeusExPlayer/Controller.
var() bool bHideInHand;
var private Inventory SavedInHand;

simulated event PawnEnteredVolume(Pawn P)
{
	Super.PawnEnteredVolume(P);

 if (P.IsA('DeusExPlayer'))
 {
  if ((bHideInHand) && (DeusExPlayer(P).InHand != none))
  {
   if (DeusExPlayer(P).InHand != none && SavedInHand == none)
   SavedInHand = DeusExPlayer(P).InHand;

	  if (DeusExPlayer(P).InHand.IsA('SkilledToolInv'))
	  {
	    DeusExPlayer(P).InHand.GoToState('DownItem');
      DeusExPlayer(P).PutInHand(none);
	  }
  }
 }
}

simulated event PawnLeavingVolume(Pawn P)
{
	Super.PawnLeavingVolume(P);

 if (P.IsA('DeusExPlayer'))
 {
   if ((bHideInHand) && (DeusExPlayer(P).InHand != none))
   {
	   if (DeusExPlayer(P).InHand == none && SavedInHand != none)
     {
	     DeusExPlayer(P).PutInHand(SavedInHand);
     }
   }
	SavedInHand = none;
 }
}



defaultproperties
{
	bAllowLadderStrafing=true
	bAutoPath=false
	bNoPhysicalLadder=false
	bIsWoodLadder=false
	bHideInHand=true
}
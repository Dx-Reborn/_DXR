/*
   ����������� ����� bBlockZeroExtentTraces � bBlockNonZeroExtentTraces.
   ��. ����� � ������ ���� ��� ������ ��� �������������.
*/

class ToggleTraces extends DeusExTrigger;

function Trigger(actor Other, pawn EventInstigator)
{
    local actor A;

    if(Event != '')
    {
       foreach AllActors(class 'Actor', A, Event)
       {
          A.bBlockZeroExtentTraces = !A.bBlockZeroExtentTraces; // block zero extent actors/traces
          A.bBlockNonZeroExtentTraces = !A.bBlockNonZeroExtentTraces; // block non-zero extent actors/traces
       }
    }
}

/*
   ����������: ���������� ���������� ����� ���� � ������, �� �������� ����� ����������.
   ���� ����� ������ ���� ����������� �� NavigationPoint.
   �������� ��� �������� ������ ��� ������ (���������� ���� �������� DXRJumpPad).
   ������ ����� �������������� ��� ������ ���������� JumpZModifier (1.1, 1.2, � �.�.).

   �������� �����, ������������� ���������� ���� ���.
*/

class DXRJumpPad extends JumpPad
                         placeable;

var(JumpPad) bool bDoNotAffectPlayer; // �� ������������� ������, ������ ��� ��
var(JumpPad) Name ordersWhenTouched;
var(JumpPad) Name ordersTagWhenTouched;


/*event Touch(Actor Other)
{
   Super.Touch(Other);
} */

event PostTouch(Actor Other)
{
   if ((bDoNotAffectPlayer) && (Other.IsA('PlayerPawn')))
       return;
   else
       Super.PostTouch(Other);

   if (Other.IsA('ScriptedPawn'))
       StartPatrolling(ScriptedPawn(Other));
}

function StartPatrolling(ScriptedPawn P)
{
    P.SetOrders(ordersWhenTouched, ordersTagWhenTouched, true);
//    log("SetOrders from "$self$":"$ ordersWhenTouched $", ordersTag="$ordersTagWhenTouched);
}


defaultproperties
{
    bDoNotAffectPlayer=true
    ordersWhenTouched="Standing"
}
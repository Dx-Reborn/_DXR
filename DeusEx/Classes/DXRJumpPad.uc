/*
   Примечание: Необходимо установить жёлтые пути к актору, до которого нужно допрыгнуть.
   Этот актор должен быть унаследован от NavigationPoint.
   Редактор сам выставит кривую для прыжка (появляется если выделить DXRJumpPad).
   Кривую можно корректировать при помощи переменной JumpZModifier (1.1, 1.2, и т.п.).

   Тестовый актор, практического применения пока нет.
*/

class DXRJumpPad extends JumpPad
                         placeable;

var(JumpPad) bool bDoNotAffectPlayer; // Не перебрасывать игрока, только для ИИ
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
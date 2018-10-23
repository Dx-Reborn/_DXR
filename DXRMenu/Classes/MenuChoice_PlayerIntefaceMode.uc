/* 
   Поведение игры при открытии интерфейса игрока (Инвентарь, Приращения...).
   Paused : приостановить (пауза).
   Slow : замедлить в 10 раз.
   RealTime : ничего не делать.
*/


class MenuChoice_PlayerIntefaceMode extends DXREnumButton;

var String englishEnumText[3];

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
defaultproperties
{
	englishEnumText(0)="Paused"
	englishEnumText(1)="Slow"
	englishEnumText(2)="RealTime"

	EnumText(0)="Paused"
	EnumText(1)="Slow"
	EnumText(2)="Realtime"
}

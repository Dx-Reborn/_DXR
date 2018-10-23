/*-----------------------------------------------------------------------------
  DeusExSaveInfo
  Содержит информацию о сохранениии.
  Назначение функции UpdateTimeStamp() из оригинала не очень понятно,
  обычно время файла меняется при записи в него. 
-----------------------------------------------------------------------------*/
class DeusExSaveInfo extends object;
//	native;

const HoldDataName="SaveInfo.dxs";

var int Year;				// Year.
var int Month;				// Month.
var int Day;				// Day of month.
var int Hour;				// Hour.
var int Minute;				// Minute.
var int Second;				// Second.

var int DirectoryIndex;		// File Index (if saved already, otherwise -1)
var String Description;		// User entered description
var String MissionLocation;	// Mission Location
var String MapName;			// Map Filename Имя карты. Самый важный параметр. При загрузке сохранения будет выполнен переход на эту карту?load
var Texture Snapshot;		// Snapshot of game when saved
var int saveCount;			// Number of times saved
var int saveTime;			// Duration of play, in seconds. Берется из DeusExPlayer
var bool bCheatsEnabled;    // Set to TRUE If Cheats were enabled!!

//native(3075) final function UpdateTimeStamp();

/* Подсказка
    Year=2011
    Month=7
    Day=6
    Hour=21
    Minute=40
    Second=17
    DirectoryIndex=-1
    Description="Описание"
    MissionLocation="Расположение (Нью-Йорк и т.п.)"
    MapName="НомерМиссии_ИмяКартыИз_DeusExLevelInfo"
    Snapshot=Texture'Texture5' Скриншот
    saveCount=65281
*/

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
}

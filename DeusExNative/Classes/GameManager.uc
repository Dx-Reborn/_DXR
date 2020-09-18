class GameManager extends Object native transient;


var Object GlobalObject;


native static function GameManager GetGameManager();

native static function SaveLevel(Level Level, string Path);

native static function string GetGameLanguage();
native static function SetGameLanguage(string NewLanguage);

native static function SetGameIniString(string Section, String Parameter, string NewValue);

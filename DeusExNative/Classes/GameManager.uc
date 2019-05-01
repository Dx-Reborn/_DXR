class GameManager extends Object native transient;

var Object GlobalObject;

// See DeusEx\DeusExGlobals.uc for details.
native static function GameManager GetGameManager();

native static function SaveLevel(Level Level, string Path);

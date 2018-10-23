class GameFlags extends Object abstract native transient;


struct native Flag {
	var string Id;
	var int Value;
	var int ExpireLevel;
};


native static function SetFlag(Flag Flag);
native static function bool GetFlag(string Id, out Flag Flag);
native static function DeleteFlag(string Id);
native static function DeleteAllFlags();
native static function DeleteExpiredFlags(int Level);
native static function Array<string> GetAllFlagIds(bool bKeepOriginalCase);

native static function Array<byte> ExportFlagsToArray();
native static function ImportFlagsFromArray(Array<byte> SerializedFlags);

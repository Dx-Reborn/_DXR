class Times extends Object abstract native transient;


struct native FileTime {
	var int LowDateTime;
	var int HighDateTime;
};

struct native OleTime {
	var int LowDateTime;
	var int HighDateTime;
};

struct native SystemTime {
	var int Year;
	var int Month;
	var int DayOfWeek;
	var int Day;
	var int Hour;
	var int Minute;
	var int Second;
	var int Milliseconds;
};

// Converts date and time. See DeusEx\DxUtil.uc for examples.
native static function bool FileTimeToLocalFileTime(FileTime UtcFileTime, out FileTime LocalFileTime);

native static function bool LocalFileTimeToFileTime(FileTime LocalFileTime, out FileTime UtcFileTime);

native static function bool FileTimeToSystemTime(FileTime FileTime, out SystemTime SystemTime);

native static function bool OleTimeToSystemTime(OleTime OleTime, out SystemTime SystemTime);
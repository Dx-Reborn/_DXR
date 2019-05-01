class FileManager extends Object abstract native transient
		dependson(Times);


enum FileMoveMethod {
	FileBegin, FileCurrent, FileEnd
};

// Returns UT2004\System directory.
native static function string GetSystemDirectory();

native static function bool MakeDirectory(string Path, bool bMakeTree);
native static function bool DeleteDirectory(string Path, bool bFailIfNotExist, bool bRemoveTree);

native static function bool CopyFile(string Path, string DestPath, bool bReplace, bool bReplaceReadOnly);
native static function bool MoveFile(string Path, string DestPath, bool bReplace, bool bReplaceReadOnly);
native static function bool DeleteFile(string Path, bool bFailIfNotExist, bool bDeleteReadOnly);

native static function Array<string> FindFiles(string Path, bool bListFiles, bool bListDirs);
native static function int FileSize(string Path);
native static final function bool FileTime(string Path, out Times.FileTime UtcFileTime);

// See DeusEx\DxUtil.uc GetFileAsArray() for examples.
native static function int FileOpen(string Path, bool bFailIfNotExist, bool bOpenForWriting);
native static function int FileSeek(int Handle, int Position, FileMoveMethod MoveMethod);
native static function int FileRead(int Handle, Array<byte> Data, int Offset, int Size);
native static function int FileWrite(int Handle, Array<byte> Data, int Offset, int Size);
native static function FileClose(int Handle);

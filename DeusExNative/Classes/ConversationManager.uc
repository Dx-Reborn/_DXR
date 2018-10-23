class ConversationManager extends Object abstract native transient
		dependson(Times);


native static function int RegisterConFile(string ConFileName, Array<byte> ConFileData);

native static function int GetConversations(Array<ConDialogue> Dialogs, int MissionNumber, optional string OwnerName, optional string Name);

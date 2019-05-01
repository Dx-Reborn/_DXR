class ConEventCheckObject extends ConEvent native transient;


var string ObjectName;
var string FailLabel;


// #ifdef REFACTOR_ME
// TODO: Содержимое REFACTOR_ME-блока не хранится в файлах диалогов, лучше вынести в классы для работы с диалогами в DeusEx.u

var class<Inventory> checkObject;		// Object to check for

// #endif // #ifdef REFACTOR_ME

defaultproperties {
	EventType = ET_CheckObject
}

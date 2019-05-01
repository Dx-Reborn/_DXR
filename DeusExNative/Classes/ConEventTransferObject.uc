class ConEventTransferObject extends ConEvent native transient;


var string ObjectName;
var int TransferCount;
var string FromName;
var string ToName;
var string FailLabel;



// #ifdef REFACTOR_ME
// TODO: Содержимое REFACTOR_ME-блока не хранится в файлах диалогов, лучше вынести в классы для работы с диалогами в DeusEx.u

var Class<Inventory> giveObject;		// Object to transfer
var Actor  FromActor;					// Actor transfering from
var Actor ToActor;						// Actor transfering to

// #endif // #ifdef REFACTOR_ME


defaultproperties {
	EventType = ET_TransferObject
}

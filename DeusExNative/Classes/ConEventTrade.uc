class ConEventTrade extends ConEvent native transient;


var string EventOwnerName;


// #ifdef REFACTOR_ME
// TODO: Содержимое REFACTOR_ME-блока не хранится в файлах диалогов, лучше вынести в классы для работы с диалогами в DeusEx.u

var Actor eventOwner;				// Actor who initiates Trade

// #endif // #ifdef REFACTOR_ME

defaultproperties {
	EventType = ET_Trade
}

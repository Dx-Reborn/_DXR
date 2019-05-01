class ConEventRandom extends ConEvent native transient;


var() Array<string> Labels;
var bool bCycleEvents;
var bool bCycleOnce;
var bool bCycleRandom;


// #ifdef REFACTOR_ME
// TODO: Содержимое REFACTOR_ME-блока не хранится в файлах диалогов, лучше вынести в классы для работы с диалогами в DeusEx.u

var int  cycleIndex;
var bool bLabelsCycled;

// #endif // #ifdef REFACTOR_ME

defaultproperties {
	EventType = ET_Random
}

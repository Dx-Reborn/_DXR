class ConEvent extends ConBase native transient;


var EEventType EventType;
var string Label;


// #ifdef REFACTOR_ME
// TODO: Содержимое REFACTOR_ME-блока не хранится в файлах диалогов, лучше вынести в классы для работы с диалогами в DeusEx.u

var string INV_END; // This will be added to inventory item's name, for example WeaponCombatKnife -> WeaponCombatKnifeInv.
                    // For compatibility with maps from original game.
var localized string CheckTransferObjectPackage; // To allow mod authors use package other than "DeusEx."
var conEvent NextEvent;

defaultproperties {
	INV_END = "Inv"
	CheckTransferObjectPackage = "DeusEx."
}

// #endif // #ifdef REFACTOR_ME

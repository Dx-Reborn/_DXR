class ConChoice extends ConBase native transient;


var string ChoiceText;
var string SkillName;
var bool bDisplayAsSpeech;
var int SkillLevelNeeded;
var string ChoiceLabel;
var string SoundPath;
var() Array<ConFlagRef> FlagRefList;


// #ifdef REFACTOR_ME
// TODO: Содержимое REFACTOR_ME-блока не хранится в файлах диалогов, лучше вынести в классы для работы с диалогами в DeusEx.u

// TODO: Не хранятся в файлах диалогов, лучше вынести в классы для работы с диалогами в DeusEx.u
var class skillNeeded;					// Skill required for this choice

// #endif // #ifdef REFACTOR_ME

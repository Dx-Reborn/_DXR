class ConChoice extends ConBase native transient;


var string ChoiceText;
var string SkillName;
var bool bDisplayAsSpeech;
var int SkillLevelNeeded;
var string ChoiceLabel;
var string SoundPath;
var() Array<ConFlagRef> FlagRefList;

var class skillNeeded;					// Skill required for this choice

class ConBase extends Object native transient;


// Possible Event Actions
enum EEventAction {
	EA_NextEvent,
	EA_JumpToLabel,
	EA_JumpToConversation,
	EA_WaitForInput,
	EA_WaitForSpeech,
	EA_PlayAnim,
	EA_ConTurnActors,
	EA_End
};

// Various and sundry Event Types
enum EEventType {
	ET_Speech,
	ET_Choice,
	ET_SetFlag,
	ET_CheckFlag,
	ET_CheckObject,
	ET_TransferObject,
	ET_MoveCamera,
	ET_Animation,
	ET_Trade,
	ET_Jump,
	ET_Random,
	ET_Trigger,
	ET_AddGoal,
	ET_AddNote,
	ET_AddSkillPoints,
	ET_AddCredits,
	ET_CheckPersona,
	ET_Comment,
	ET_End
};

// Camera Types
enum ECameraType {
	CT_Predefined,
	CT_Speakers,
	CT_Actor,
	CT_Random,
};

// Predefined Camera Positions
enum ECameraPosition {
	CP_SideTight,
	CP_SideMid,
	CP_SideAbove,
	CP_SideAbove45,
	CP_ShoulderLeft,
	CP_ShoulderRight,
	CP_HeadShotTight,
	CP_HeadShotMid,
	CP_HeadShotLeft,
	CP_HeadShotRight,
	CP_HeadShotSlightRight,
	CP_HeadShotSlightLeft,
	CP_StraightAboveLookingDown,
	CP_StraightBelowLookingUp,
	CP_BelowLookingUp
};

// Camera transitions
enum ECameraTransition {
	CR_Jump,
	CR_Spline
};

// Speech fonts
enum ESpeechFont {
	SF_Normal,
	SF_Computer
};

// Animation modes
enum EAnimationMode {
	AM_Loop,
	AM_Once
};

// Conditions for Persona checks
enum ECondition {
	EC_Less,
	EC_LessEqual,
	EC_Equal,
	EC_GreaterEqual,
	EC_Greater
};

// Event Persona types
enum EPersonaType {
	EP_Credits,
	EP_Health,
	EP_SkillPoints
};

/*
    Blocks AI Controlled creatures (inherited from DeusExNative.DeusExNPCPawn)
    Replaces BlockMonsters actor.

    Does not blocks AI paths, so use BlockPathVolume when required.
*/

class NPCBlockingVolume extends BlockingVolume;

defaultproperties
{
    bClassBlocker=True
    BlockedClasses(0)=Class'DeusEx.ScriptedPawn'
}
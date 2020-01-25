//=============================================================================
// ComputerPublic.
//=============================================================================
class ComputerPublic extends Computers;

var() name bulletinTag;
var() bool bUseRandomMessages;
var() localized array<string> extraMessages; // Дополнительные сообщения если список пуст.
                                             // Обрабатывается в ComputerScreenBulletins.uc

defaultproperties
{
    terminalType=Class'NetworkTerminalPublic'
    BindName="ComputerPublic"
    ItemName="Public Computer Terminal"
    Physics=PHYS_None
    mesh=mesh'DeusExDeco.ComputerPublic'
    ScaleGlow=2.000000
    CollisionHeight=49.139999

    bUseRandomMessages=false
		extraMessages(0)="No Bulletins Today! Or <PLAYERNAME> hacked this terminal..."
		extraMessages(1)="Error! Someone forgot to add extra messages!"
		extraMessages(2)="Place any text you like, and it will be printed if terminal is empty. Can be in Russian too ))"
		extraMessages(3)="Bad command or filename"
}

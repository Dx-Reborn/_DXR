//=============================================================================
// ElectronicDevices.
//=============================================================================
class ElectronicDevices extends DeusExDecoration
                                        abstract;

function int NumUsers();
function string GetUserName(int userIndex);

defaultproperties
{
     bInvincible=True
     FragType=Class'DeusEx.PlasticFragment'
     bPushable=False
     Mesh=None
}

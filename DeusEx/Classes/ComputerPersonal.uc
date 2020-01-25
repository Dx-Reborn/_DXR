//=============================================================================
// ComputerPersonal.
//=============================================================================
class ComputerPersonal extends Computers;

defaultproperties
{
     terminalType=Class'NetworkTerminalPersonal'
     lockoutDelay=60.000000
     UserList(0)=(userName="USER",Password="USER")
     BindName="ComputerPersonal"
     ItemName="Personal Computer Terminal"
     mesh=mesh'DeusExDeco.ComputerPersonal'
     CollisionRadius=36.000000
     CollisionHeight=7.400000
     Skins(0)=Shader'DeusExDeco_EX.Shader.ComputerPersonal_SH'
}

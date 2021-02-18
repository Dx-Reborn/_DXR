//=============================================================================
// Keypad2.
//=============================================================================
class Keypad2a extends Keypad;

defaultproperties
{
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DXR_Keypads.Scripted.keypad2a_HD'
     Skins(0)=Shader'DXR_Keypads.Skins.Keypad2a_HD_SH'
//     mesh=mesh'DeusExDeco.Keypad2'
     CollisionRadius=4.440000
     CollisionHeight=7.410000

     StateLamps[0]=Shader'DXR_Keypads.Skins.Keypad2a_Idle_SH'
     StateLamps[1]=Shader'DXR_Keypads.Skins.Keypad2a_Idle_SH'
     StateLamps[2]=Shader'DXR_Keypads.Skins.Keypad2a_Denied_SH'
     StateLamps[3]=Shader'DXR_Keypads.Skins.Keypad2a_Granted_SH'
}

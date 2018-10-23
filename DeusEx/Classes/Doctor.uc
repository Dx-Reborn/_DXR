//=============================================================================
// Doctor.
//=============================================================================
class Doctor extends HumanCivilian;

defaultproperties
{
     BindName="Doctor"
     FamiliarName="Doctor"
     UnfamiliarName="Doctor"
     CarcassType=Class'DeusEx.DoctorCarcass'
     WalkingSpeed=0.213333
     BaseAssHeight=-23.000000
     GroundSpeed=180.000000
     Mesh=mesh'DeusExCharacters.GM_Trench'
     skins(0)=Texture'DeusExCharacters.Skins.DoctorTex0'
     skins(1)=Texture'DeusExCharacters.Skins.LabCoatTex1'
     skins(2)=Texture'DeusExCharacters.Skins.PantsTex1'
     skins(3)=Texture'DeusExCharacters.Skins.DoctorTex0'
     skins(4)=Texture'DeusExCharacters.Skins.DoctorTex1'
     skins(5)=Texture'DeusExCharacters.Skins.LabCoatTex1'

     skins(6)=Material'DeusExCharacters.Skins.SH_FramesTex1'
     skins(7)=Material'DeusExCharacters.Skins.FB_LensesTex2'

//     skins(6)=Texture'DeusExCharacters.Skins.FramesTex1'
//     skins(7)=Texture'DeusExCharacters.Skins.LensesTex2'
     CollisionRadius=20.000000
     CollisionHeight=47.500000
}

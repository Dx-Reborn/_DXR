/*
   Для сцены на дороге (JC Denton в кабине на месте пассажира)
*/

class FakePassenger extends ScaledSprite;

event PostBeginPlay()
{
   LoopAnim('SitBreathe');
}

event PostLoadSavedGame()
{
   LoopAnim('SitBreathe');
}


defaultproperties
{
     DrawType=DT_Mesh
     Mesh=mesh'DeusExCharacters.GM_Trench'
     skins(0)=Texture'DeusExCharacters.Skins.JCDentonTex0'
     skins(1)=Texture'DeusExCharacters.Skins.JCDentonTex2'
     skins(2)=Texture'DeusExCharacters.Skins.JCDentonTex3'
     skins(3)=Texture'DeusExCharacters.Skins.JCDentonTex0'
     skins(4)=Texture'DeusExCharacters.Skins.JCDentonTex1'
     skins(5)=Texture'DeusExCharacters.Skins.JCDentonTex2'
     skins(6)=Material'DeusExCharacters.Skins.SH_FramesTex4'
     skins(7)=Material'DeusExCharacters.Skins.FB_LensesTex5'
     CollisionRadius=20.000000
     CollisionHeight=43.000000

     bLightingVisibility=false
     bDramaticLighting=false
}


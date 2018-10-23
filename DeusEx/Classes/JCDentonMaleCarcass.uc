//=============================================================================
// JCDentonMaleCarcass.
//=============================================================================
class JCDentonMaleCarcass extends DeusExCarcass;

// ----------------------------------------------------------------------
// PostPostBeginPlay()
// ----------------------------------------------------------------------


// ----------------------------------------------------------------------
// SetSkin()
// ----------------------------------------------------------------------
function SetSkin(DeusExPlayer player)
{
	if (player != None)
	{
		switch(player.PlayerSkin)
		{
			case 0:	Skins[0] = Texture'JCDentonTex0'; break;
			case 1:	Skins[0] = Texture'JCDentonTex4'; break;
			case 2:	Skins[0] = Texture'JCDentonTex5'; break;
			case 3:	Skins[0] = Texture'JCDentonTex6'; break;
			case 4:	Skins[0] = Texture'JCDentonTex7'; break;
		}
	}
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     Mesh2=mesh'DeusExCharacters.GM_Trench_CarcassB'
     Mesh3=mesh'DeusExCharacters.GM_Trench_CarcassC'
     Mesh=mesh'DeusExCharacters.GM_Trench_Carcass'
     skins(0)=Texture'DeusExCharacters.Skins.JCDentonTex0'
     skins(1)=Texture'DeusExCharacters.Skins.JCDentonTex2'
     skins(2)=Texture'DeusExCharacters.Skins.JCDentonTex3'
     skins(3)=Texture'DeusExCharacters.Skins.JCDentonTex0'
     skins(4)=Texture'DeusExCharacters.Skins.JCDentonTex1'
     skins(5)=Texture'DeusExCharacters.Skins.JCDentonTex2'

     skins(6)=Material'DeusExCharacters.Skins.SH_FramesTex4'
     skins(7)=Material'DeusExCharacters.Skins.FB_LensesTex5'

//     skins(6)=Texture'DeusExCharacters.Skins.FramesTex4'
//     skins(7)=Texture'DeusExCharacters.Skins.LensesTex5'
     CollisionRadius=40.000000
}

//=============================================================================
// PaulDentonCarcass.
//=============================================================================
class PaulDentonCarcass extends DeusExCarcass;

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
			case 0:	Skins[0] = Texture'PaulDentonTex0';
					Skins[3] = Texture'PaulDentonTex0';
					break;
			case 1:	Skins[0] = Texture'PaulDentonTex4';
					Skins[3] = Texture'PaulDentonTex4';
					break;
			case 2:	Skins[0] = Texture'PaulDentonTex5';
					Skins[3] = Texture'PaulDentonTex5';
					break;
			case 3:	Skins[0] = Texture'PaulDentonTex6';
					Skins[3] = Texture'PaulDentonTex6';
					break;
			case 4:	Skins[0] = Texture'PaulDentonTex7';
					Skins[3] = Texture'PaulDentonTex7';
					break;
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
     skins(0)=Texture'DeusExCharacters.Skins.PaulDentonTex0'
     skins(1)=Texture'DeusExCharacters.Skins.PaulDentonTex2'
     skins(2)=Texture'DeusExCharacters.Skins.PantsTex8'
     skins(3)=Texture'DeusExCharacters.Skins.PaulDentonTex0'
     skins(4)=Texture'DeusExCharacters.Skins.PaulDentonTex1'
     skins(5)=Texture'DeusExCharacters.Skins.PaulDentonTex2'
     skins(6)=Texture'DeusExItems.Skins.GrayMaskTex'
     skins(7)=Texture'DeusExItems.Skins.BlackMaskTex'
     CollisionRadius=40.000000
}

//=============================================================================
// JCDouble.
//=============================================================================
class JCDouble extends HumanMilitary;

//
// JC's cinematic stunt double!
//
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

function ImpartMomentum(Vector momentum, Pawn instigatedBy)
{
	// to ensure JC's understudy doesn't get impact momentum from damage...
}

function AddVelocity( vector NewVelocity)
{
}




// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     BindName="JCDouble"
     FamiliarName="JC Denton"
     UnfamiliarName="JC Denton"
     WalkingSpeed=0.120000
     bInvincible=True
     BaseAssHeight=-23.000000
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
//     CollisionHeight=47.500000
}

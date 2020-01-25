//=============================================================================
// HKHangingLantern2.
//=============================================================================
class HKHangingLantern2 extends HangingDecoration;

enum ESkinColor
{
	SC_RedGreen,
	SC_YellowBlue,
	SC_BluePurple
};

var() ESkinColor SkinColor;

function BeginPlay()
{
	Super.BeginPlay();

	switch (SkinColor)
	{
		case SC_RedGreen:		Skins[0] = Texture'HKHangingLantern2Tex1'; break;
		case SC_YellowBlue:	Skins[0] = Texture'HKHangingLantern2Tex2'; break;
		case SC_BluePurple:	Skins[0] = Texture'HKHangingLantern2Tex3'; break;
	}
}


defaultproperties
{
     FragType=Class'DeusEx.PaperFragment'
     ItemName="Paper Lantern"
     mesh=mesh'DeusExDeco.HKHangingLantern2'
//     PrePivot=(Z=11.000000)
     CollisionRadius=7.000000
     CollisionHeight=11.000000
     Mass=20.000000
     Buoyancy=5.000000
}

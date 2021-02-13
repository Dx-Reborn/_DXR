//=============================================================================
// AmmoSabot.
//=============================================================================
class AmmoSabot extends DeusExAmmo;

defaultproperties
{
     largeIcon=Texture'DeusExUI.Icons.LargeIconAmmoSabot'
     largeIconWidth=35
     largeIconHeight=46
     Description="A 12 gauge shotgun shell surrounding a solid core of tungsten that can punch through all but the thickest hardened steel armor at close range; however, its ballistic profile will result in minimal damage to soft targets."
     beltDescription="SABOT"
     bShowInfo=True
     AmmoAmount=12
     MaxAmmo=96
     ItemName="12 Gauge Sabot Shells"
     Icon=Texture'DeusExUI.Icons.BeltIconAmmoSabot'
//     Skins[0]=Texture'DeusExItems.Skins.AmmoShellTex2'
     Skins[0]=Shader'DXR_Ammo.Skins.AmmoSabot_HD_SH'
     StaticMesh=StaticMesh'DXR_Ammo.AmmoShell_HD'
     DrawType=DT_StaticMesh
//     Mesh=Mesh'DeusExItems.AmmoShell'
     CollisionRadius=9.300000
//     CollisionHeight=10.210000
     CollisionHeight=6.50
     bCollideActors=True
     DrawScale=0.66
}

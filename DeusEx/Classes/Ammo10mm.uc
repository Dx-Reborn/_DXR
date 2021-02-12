//=============================================================================
// Ammo10mm.
//=============================================================================
class Ammo10mm extends DeusExAmmo;

defaultproperties
{
     largeIcon=Texture'DeusExUI.Icons.LargeIconAmmo10mm'
     largeIconWidth=44
     largeIconHeight=31
     Description="With their combination of high stopping power and low recoil, pistols chambered for the 10mm round have become the sidearms of choice for paramilitary forces around the world."
     beltDescription="10MM AMMO"
     bShowInfo=True
     AmmoAmount=6
     MaxAmmo=150
     ItemName="10mm Ammo"
     Icon=Texture'DeusExUI.Icons.BeltIconAmmo10mm'
//     Mesh=Mesh'DeusExItems.Ammo10mm'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DXR_Ammo.Ammo10mm_HD'
     CollisionRadius=8.500000
     CollisionHeight=3.770000
     bCollideActors=True
}

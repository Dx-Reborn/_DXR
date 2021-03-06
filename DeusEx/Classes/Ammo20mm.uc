//=============================================================================
// Ammo20mm.
//=============================================================================
class Ammo20mm extends DeusExAmmo;

defaultproperties
{
     largeIcon=Texture'DeusExUI.Icons.LargeIconAmmo20mm'
     largeIconWidth=47
     largeIconHeight=37
     Description="The 20mm high-explosive round complements the standard 7.62x51mm assault rifle by adding the capability to clear small rooms, foxholes, and blind corners using an underhand launcher."
     beltDescription="20MM AMMO"
     bShowInfo=True
     AmmoAmount=4
     MaxAmmo=32
     ItemName="20mm HE Ammo"
     Icon=Texture'DeusExUI.Icons.BeltIconAmmo20mm'
//     Mesh=Mesh'DeusExItems.Ammo20mm'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DXR_Ammo.Ammo20mm_HD'
     CollisionRadius=9.500000
     CollisionHeight=4.750000
     bCollideActors=True
     LandSound=Sound'DeusExSounds.Generic.MetalHit1'
}


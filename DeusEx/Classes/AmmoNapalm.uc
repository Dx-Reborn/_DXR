//=============================================================================
// AmmoNapalm.
//=============================================================================
class AmmoNapalm extends DeusExAmmo;

defaultproperties
{
     largeIcon=Texture'DeusExUI.Icons.LargeIconAmmoNapalm'
     largeIconWidth=46
     largeIconHeight=42
     Description="A pressurized canister of jellied gasoline for use with flamethrowers.|n|n<UNATCO OPS FILE NOTE SC080-BLUE> The canister is double-walled to minimize accidental detonation caused by stray bullets during a firefight. -- Sam Carter <END NOTE>"
     beltDescription="NAPALM"
     bShowInfo=True
     AmmoAmount=100
     MaxAmmo=400
     ItemName="Napalm Canister"
     Icon=Texture'DeusExUI.Icons.BeltIconAmmoNapalm'
//     Mesh=Mesh'DeusExItems.AmmoNapalm'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DXR_Ammo.AmmoNapalm_HD'
     CollisionRadius=3.130000
     CollisionHeight=11.480000
     bCollideActors=True
     LandSound=Sound'DeusExSounds.Generic.GlassDrop'
}



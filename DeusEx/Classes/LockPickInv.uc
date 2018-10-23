//=============================================================================
// Lockpick.
//=============================================================================
class LockpickInv extends SkilledToolInv;




defaultproperties
{
	 AttachmentClass=class'EmptyAttachment'
   PickupClass=class'LockPick'
 	 UseSound=Sound'DeusExSounds.Generic.LockpickRattling'
   maxCopies=20
   Description="A disposable lockpick. The tension wrench is steel, but appropriate needles are formed from fast congealing polymers.||<UNATCO OPS FILE NOTE AJ006-BLACK> Here's what they don't tell you: despite the product literature, you can use a standard lockpick to bypass all but the most high-class nanolocks. -- Alex Jacobson <END NOTE>"
   ItemName="Lockpick"
   beltDescription="LOCKPICK"
   PlayerViewOffset=(X=15.00,Y=10.00,Z=-15.00)

   Icon=Texture'DeusExUI.Icons.BeltIconLockPick'
   largeIcon=Texture'DeusExUI.Icons.LargeIconLockPick'
   largeIconWidth=45
   largeIconHeight=44

   Mesh=Mesh'DeusExItems.Lockpick'
   PickupViewMesh=Mesh'DeusExItems.Lockpick'
   FirstPersonViewMesh=Mesh'DeusExItems.LockpickPOV'

   CollisionRadius=11.750000
   CollisionHeight=1.900000
   Mass=20.000000
   Buoyancy=10.000000
}
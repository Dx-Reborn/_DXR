//=============================================================================
// Multitool.
//=============================================================================
class MultitoolInv extends SkilledToolInv;

defaultproperties
{
   AttachmentClass=class'EmptyAttachment'
   PickupClass=class'MultiTool'

   UseSound=Sound'DeusExSounds.Generic.MultitoolUse'
   LandSound=Sound'DeusExSounds.Generic.PlasticHit2'

   maxCopies=20
   PlayerViewOffset=(X=19.000000,Y=15.000000,Z=-15.000000)
   Description="A disposable electronics tool. By using electromagnetic resonance detection and frequency modulation to dynamically alter the flow of current through a circuit, skilled agents can use the multitool to manipulate code locks, cameras, autogun turrets, alarms, or other security systems."
   ItemName="Multitool"
   beltDescription="MULTITOOL"

   Icon=Texture'DeusExUI.Icons.BeltIconMultitool'
   largeIcon=Texture'DeusExUI.Icons.LargeIconMultitool'
   largeIconWidth=28
   largeIconHeight=46

   Mesh=Mesh'DeusExItems.Multitool'
   PickupViewMesh=Mesh'DeusExItems.Multitool'
   FirstPersonViewMesh=Mesh'DeusExItems.MultitoolPOV'

   CollisionRadius=4.800000
   CollisionHeight=0.860000
   Mass=20.000000
   Buoyancy=10.000000
   inventorygroup=10

   FirstPersonViewSkins[0]=Texture'DeusExItems.Skins.MultitoolPOVTex1'
   FirstPersonViewSkins[1]=Texture'DeusExItems.Skins.WeaponHandsTex'
   FirstPersonViewSkins[2]=Texture'DeusExItems.Skins.MultitoolPOVTex1'
   FirstPersonViewSkins[3]=Shader'DeusExItemsEx.EXSkins.MultiToolWaves_SH' // текстура волн
   FirstPersonViewSkins[4]=Texture'DeusExItems.Skins.MultitoolPOVTex1'
   FirstPersonViewSkins[5]=Texture'DeusExItems.Skins.WeaponHandsTex'
}
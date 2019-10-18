//=============================================================================
// The Ball-and-Socket joint class.
//=============================================================================

#exec Texture Import File=Textures\S_KBSJoint.tga Name=S_KBSJoint Mips=Off MASKED=true ALPHA=true

class KBSJoint extends KConstraint
    native
    placeable;

defaultproperties
{
    Texture=S_KBSJoint
}
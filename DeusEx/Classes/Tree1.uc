//=============================================================================
// Tree1.
//=============================================================================
class Tree1 extends Tree;

enum ESkinColor
{
	SC_Tree1,
	SC_Tree2,
	SC_Tree3
};

var() ESkinColor SkinColor;

defaultproperties
{
     mesh=mesh'DeusExDeco.Tree1'
     CollisionRadius=10.000000
     CollisionHeight=125.000000
}

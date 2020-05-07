class Mop extends DeusExDecoration;


defaultproperties
{
    ItemName="A mop"
    DrawType=DT_StaticMesh
    StaticMesh=StaticMesh'DeusExStaticMeshes10.Scripted.Mop_a'
    CollisionRadius=1.200000
    CollisionHeight=37.500000
    Mass=10.000000
    Buoyancy=30.000000
    Skins[0]=Texture'DeusExStaticMeshes9.Wood.CableWheel_a_Tex1'
    FragType=Class'DeusEx.WoodFragment'

    Begin Object Class=KarmaParams Name=KarmaParams1
        KStartEnabled=True
        bKAllowRotate=True
        KFriction=1.000000
        KRestitution=1.000000
        KImpactThreshold=0.000000
    End Object
    KParams=KarmaParams'KarmaParams1'
}


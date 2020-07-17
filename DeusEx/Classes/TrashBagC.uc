class TrashBagC extends TrashBags;

defaultproperties
{
    DrawType=DT_StaticMesh
    StaticMesh=StaticMesh'DXR_TrashBags.TrashBag_F'
    CollisionRadius=14.00
    CollisionHeight=20.00
    bGenerateTrash=True
    HitPoints=10
    FragType=Class'DeusEx.PaperFragment'
    bGenerateFlies=True
    ItemName="Trashbag"
    Mass=30.000000
    Buoyancy=40.000000
    skins[0]=Shader'DXR_TrashBags.Plastic.TrashBag_F_SH'
}
/*

*/


class MailLetter extends TrashObjects;

event Landed(vector HitNormal)
{
    SetCollision(true, true);
}

defaultproperties
{
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DXR_TrashObjects.Scripted.MailLetter_a'
     ItemName="Mail letter"
     CollisionRadius=4.000000
     CollisionHeight=2.000000
     mass=1.0
     buoyancy=1.0
     HitPoints=2
     fragtype=class'PaperFragment'
     bCollideActors=false
}
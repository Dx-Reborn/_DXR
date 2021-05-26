//=============================================================================
// CigarettesFortyFive
//=============================================================================
class CigarettesFortyFive extends Cigarettes;

state Activated
{
    function Activate()
    {
        // can't turn it off
    }

    function BeginState()
    {
        local Pawn P;
        local vector loc;
        local rotator rot;
        local EM_CigSmoke puff;
        //local SmokeTrail puff;
        
        Super.BeginState();

        P = Pawn(Owner);
        if (P != None)
        {
            P.TakeDamage(5, P, P.Location, vect(0,0,0), class'DM_PoisonGas');
            loc = Owner.Location;
            rot = Owner.Rotation;
            //loc += 2.0 * Owner.CollisionRadius * vector(P.GetViewRotation());
            loc += Owner.CollisionRadius * vector(P.GetViewRotation());
            loc.Z += Owner.CollisionHeight * 0.9;
            puff = Spawn(class'EM_CigSmoke', Owner,, loc, rot);
            //puff = Spawn(class'SmokeTrail', Owner,, loc, rot);
            /*if (puff != None)
            {
                puff.SetDrawScale(1.0);
                puff.origScale = puff.DrawScale;
            } */
            PlaySound(sound'MaleCough');
        }

        UseOnce();
    }
Begin:
}


defaultproperties
{
    maxCopies=20
    PlayerViewOffset=(X=30.00,Y=0.00,Z=-12.00)
    Description="'COUGHING NAILS -- when you've just got to have a cigarette.'"
    ItemName="Cigarettes"
    beltDescription="CIGS"
    Icon=Texture'DeusExUI.Icons.BeltIconCigarettes'
    largeIcon=Texture'DeusExUI.Icons.LargeIconCigarettes'
    largeIconWidth=29
    largeIconHeight=43

    DrawType=DT_StaticMesh
    StaticMesh=StaticMesh'DXR_Pickups.Stogie_HD_Pickup'
    PickupViewStaticMesh=StaticMesh'DXR_Pickups.Stogie_HD_Pickup'
    FirstPersonViewStaticMesh=StaticMesh'DXR_Pickups.Stogie_HD'
    bUseFirstPersonStaticMesh=true
    bUsePickupViewStaticMesh=true
}




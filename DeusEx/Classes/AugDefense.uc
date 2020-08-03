//=============================================================================
// AugDefense.
//=============================================================================
class AugDefense extends Augmentation;

state Active
{
    event Timer()
    {
        local DeusExProjectile proj, minproj;
        local float dist, mindist;

        // find the projectile closest to us
        mindist = 999999;
        minproj = None;
        foreach DynamicActors(class'DeusExProjectile', proj) // DXR: Replaced to DynamicActors
        {
            if (!proj.IsA('Cloud') && !proj.IsA('Tracer') &&
                !proj.IsA('GreaselSpit') && !proj.IsA('GraySpit'))
            {
                // make sure we don't own it
                if (proj.Owner != Player)
                {
                    // make sure it's moving fast enough
                    if (VSize(proj.Velocity) > 100)
                    {
                        dist = VSize(Player.Location - proj.Location);
                        if (dist < mindist)
                        {
                            mindist = dist;
                            minproj = proj;
                        }
                    }
                }
            }
        }

        // if we have a valid projectile, send it to the aug display window
        if (minproj != None)
        {
            DeusExHud(DeusExPlayerController(Level.GetLocalPlayerController()).myHUD).bDefenseActive = True;
            DeusExHud(DeusExPlayerController(Level.GetLocalPlayerController()).myHUD).defenseLevel = CurrentLevel;
            DeusExHud(DeusExPlayerController(Level.GetLocalPlayerController()).myHUD).defenseTarget = minproj;

            // play a warning sound
            Player.PlaySound(sound'GEPGunLock', SLOT_None,,,, 2.0);

            if (mindist < LevelValues[CurrentLevel])
            {
                minproj.Explode(minproj.Location, vect(0,0,1));
                Player.PlaySound(sound'ProdFire', SLOT_None,,,, 2.0);
            }
        }
        else
        {
            DeusExHud(DeusExPlayerController(Level.GetLocalPlayerController()).myHUD).bDefenseActive = False;
            DeusExHud(DeusExPlayerController(Level.GetLocalPlayerController()).myHUD).defenseTarget = None;
        }
    }

Begin:
    SetTimer(0.1, True);
}

function Deactivate()
{
    Super.Deactivate();

    SetTimer(0.1, False);
    DeusExHud(DeusExPlayerController(Level.GetLocalPlayerController()).myHUD).bDefenseActive = False;
    DeusExHud(DeusExPlayerController(Level.GetLocalPlayerController()).myHUD).defenseTarget = None;
}





defaultproperties
{
     EnergyRate=10.000000
     Icon=Texture'DeusExUI.UserInterface.AugIconDefense'
     smallIcon=Texture'DeusExUI.UserInterface.AugIconDefense_Small'
     InternalAugmentationName="Aggressive_Defense_System"
     AugmentationName="Aggressive Defense System"
     Description="Aerosol nanoparticles are released upon the detection of objects fitting the electromagnetic threat profile of missiles and grenades; these nanoparticles will prematurely detonate such objects prior to reaching the agent.||TECH ONE: The range at which incoming rockets and grenades are detonated is short.||TECH TWO: The range at which detonation occurs is increased slightly.||TECH THREE: The range at which detonation occurs is increased moderately.||TECH FOUR: Rockets and grenades are detonated almost before they are fired."
     LevelValues(0)=160.000000
     LevelValues(1)=320.000000
     LevelValues(2)=480.000000
     LevelValues(3)=800.000000
}

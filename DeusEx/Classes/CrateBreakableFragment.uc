/*
   Обломки ящиков с хабаром.
*/

class CrateBreakableFragment extends DeusExFragment;

var string SM_Fragments[3];

function PostSetInitialState()
{
   SetDrawType(DT_StaticMesh);
   SetStaticMesh(StaticMesh(DynamicLoadObject(SM_Fragments[rand(3)], class'StaticMesh', false)));
   bUnlit = false;
   PlaySound(Sound'WoodBreakLarge');
   Velocity *= 1.5;
}


defaultproperties
{
    SM_Fragments[0]="DXR_Crates.Fragments.CrateBreakableFragA"
    SM_Fragments[1]="DXR_Crates.Fragments.CrateBreakableFragB"
    SM_Fragments[2]="DXR_Crates.Fragments.CrateBreakableFragC"
    bAcceptsProjectors=false
}
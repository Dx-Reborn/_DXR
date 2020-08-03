//=============================================================================
// Carcass.
//=============================================================================
class Carcass extends Decoration
        placeable;

// DEUS_EX AMSD Added to make vision aug run faster.  If true, the vision aug needs to check this object more closely.
// Used for heat sources as well as things that blind.
var bool bVisionImportant;


// Variables.
var bool bPlayerCarcass;
var() byte flies;
var() byte rats;
var() bool bReducedHeight;
var bool bDecorative;
var bool bSlidingCarcass;
var int CumulativeDamage;
var PlayerReplicationInfo PlayerOwner;
var bool bBobbing;

function Initfor(actor Other);
            
function ChunkUp(int Damage)
{
        destroy();
}
    
static function bool AllowChunk(int N, name A)
{
    return true;
}

function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<damageType> damageType)
{
    if ( !bDecorative )
        {
            bBobbing = false;
            SetPhysics(PHYS_Falling);
        }
        if ( (Physics == PHYS_None) && (Momentum.Z < 0) )
            Momentum.Z *= -1;
        Velocity += 3 * momentum/(Mass + 200);
        if (DamageType == class'DM_shot')
            Damage *= 0.4;
        CumulativeDamage += Damage;
        if ( (((Damage > 30) || !IsAnimating()) && (CumulativeDamage > 0.8 * Mass)) || (Damage > 0.4 * Mass) 
            || ((Velocity.Z > 150) && !IsAnimating()) )
            ChunkUp(Damage);
        if ( bDecorative )
            Velocity = vect(0,0,0);
}

auto state Dying
{
    ignores TakeDamage;

Begin:
    Sleep(0.2);
    GotoState('Dead');
}
    
state Dead 
{
    event Timer()
    {
        if (!PlayerCanSeeMe())
            Destroy();
            else
        SetTimer(2.0, false);   
    }
    
    function AddFliesAndRats()
    {
    }

    function CheckZoneCarcasses()
    {
    }
    
    function BeginState()
    {
        if ( bDecorative )
            lifespan = 0.0;
        else
            SetTimer(18.0, false);
    }

Begin:
    FinishAnim();
    Sleep(5.0);
    CheckZoneCarcasses();
    Sleep(7.0);
    if (!bDecorative && !bHidden && !PhysicsVolume.bWaterVolume && !PhysicsVolume.bPainCausing)
        AddFliesAndRats();  
}

defaultproperties
{
    bDecorative=true
    bStatic=False
    bStasis=False
    Physics=PHYS_Falling
    LifeSpan=0.0
    DrawType=DT_MESH
    Texture=Texture'Engine.S_Pawn'
    CollisionRadius=18.00
    CollisionHeight=4.00
    bCollideActors=True
    bCollideWorld=True
    bProjTarget=True
    Mass=180.00
    Buoyancy=105.00

    bLightingVisibility=false
    bDramaticLighting=true
}

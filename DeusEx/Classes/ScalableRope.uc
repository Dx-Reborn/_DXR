/*
    Changes DrawScale.Z of specified StaticMesh.
*/

class ScalableRope extends ScaledSprite
                              placeable;

var() float InitialScaleZ, FinalScaleZ, ChangeTime;
var float tTime;
var bool bScalingInProcess;
var vector finalVector;
var float finalValue;
var bool bScalingUp;


event Tick(float deltaTime)
{
   if (bScalingUp)
   {
       ScaleUp(deltaTime);
//       log(drawScale3D);
       return;
   }
   else if (!bScalingUp)
   {
       ScaleDown(deltaTime);
//       log(drawScale3D);
       return;
   }
}

function ScaleUp(float deltaTime)
{
   if (!bScalingInProcess)
       return;

   tTime += deltaTime;

   if (tTime <= ChangeTime)
   {
       finalvector.X = DrawScale3D.X;
       finalvector.Y = DrawScale3D.Y;
       finalValue = 1 + (ChangeTime * tTime / ChangeTime);
       finalvector.Z = finalValue;

       SetDrawScale3D(finalVector);

       if (DrawScale3D.Z >= FinalScaleZ)
           bScalingInProcess = false;
   }
}

function ScaleDown(float deltaTime)
{

//        SetDrawScale(FMax(0.01, DrawScale - Default.DrawScale * DeltaTime));

   if (!bScalingInProcess)
       return;

   tTime += deltaTime;

   if (tTime <= ChangeTime)
   {
       finalvector.X = DrawScale3D.X;
       finalvector.Y = DrawScale3D.Y;
       finalValue = fMax(1.0, DrawScale3D.Z - InitialScaleZ * DeltaTime);
       finalvector.Z = finalValue;

       SetDrawScale3D(finalVector);

       if (DrawScale3D.Z <= InitialScaleZ)
           bScalingInProcess = false;
   }
}

event Trigger(actor Other, pawn EventInstigator)
{
    tTime = 0;

    if (DrawScale3D.Z >= FinalScaleZ)
    {
        bScalingInProcess = true;
        bScalingUp = false;
    }
    else 
    if (DrawScale3D.Z <= InitialScaleZ)
    {
        bScalingInProcess = true;
        bScalingUp = true;
}   }

defaultproperties
{
    StaticMesh=StaticMesh'DeusExStaticMeshes0.SecurityCamera_a'
    DrawType=DT_StaticMesh
    bScalingInProcess=false
    ChangeTime=5.00
    InitialScaleZ=1.00
    FinalScaleZ=5.00

    bStatic=false
}
class EM_BlinkingCorona extends DeusExEmitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=SpriteEmitter1
        UseColorScale=True
        UniformSize=True
        AutomaticInitialSpawning=False
        ColorScale(0)=(Color=(R=232))
        ColorScale(1)=(RelativeTime=0.800000)
        ColorScale(2)=(RelativeTime=1.000000)
        CoordinateSystem=PTCS_Relative
        MaxParticles=4
        StartSizeRange=(X=(Min=50.000000,Max=50.000000))
        InitialParticlesPerSecond=3000.000000
        DrawStyle=PTDS_Brighten
        Texture=Texture'Effects.Corona.Corona_A'
        LifetimeRange=(Min=0.500000,Max=0.500000)
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter1'
}




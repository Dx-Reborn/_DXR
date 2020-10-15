class NewExplosionB extends Emitter;

simulated function PostBeginPlay()
{
	local PlayerController PC;
	local float dist;
		
	PC = Level.GetLocalPlayerController();
	if ( PC.ViewTarget == None )
		dist = 10000;
	else
		dist = VSize(PC.ViewTarget.Location - Location);
	if ( dist > 4000 ) 
	{
		LightType = LT_None;
		bDynamicLight = false;
		if ( dist > 7000 )
			Emitters[1].Disabled = true;
	}
	else if ( Level.bDropDetail )
		LightRadius = 7;	
}

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=SpriteEmitter1
        InitialParticlesPerSecond=10.000000
        AutomaticInitialSpawning=False
        MaxParticles=3
        RespawnDeadParticles=False
        StartLocationShape=PTLS_Sphere
        SphereRadiusRange=(Min=0.000000,Max=24.000000)
        SpinParticles=True
        StartSpinRange=(X=(Max=1.000000))
		StartSizeRange=(X=(Min=60,Max=80),Y=(Min=60,Max=80),Z=(Min=60,Max=80))
        UniformSize=false
        Texture=Texture'ExplosionTex.exp1_frames'
        TextureUSubdivisions=2
        TextureVSubdivisions=4
        BlendBetweenSubdivisions=True
        LifetimeRange=(Min=0.400000,Max=0.600000)
        SecondsBeforeInactive=0
        Name="SpriteEmitter1"
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter1'


    Begin Object Class=SpriteEmitter Name=SpriteEmitter0
        Acceleration=(Z=20.000000)
        UseColorScale=True
        MaxParticles=15
        ColorScale(0)=(Color=(B=255,G=255,R=255))
        ColorScale(1)=(RelativeTime=0.125000,Color=(B=255,G=255,R=255))
        ColorScale(2)=(RelativeTime=0.330000,Color=(B=255,G=255,R=255,A=255))
        ColorScale(3)=(RelativeTime=0.750000,Color=(B=128,G=128,R=128,A=255))
        ColorScale(4)=(RelativeTime=1.000000,Color=(B=64,G=64,R=64))
        RespawnDeadParticles=False
        StartLocationShape=PTLS_Polar
        StartLocationPolarRange=(Y=(Min=-32768.000000,Max=32768.000000),Z=(Min=10.000000,Max=10.000000))
        UseRotationFrom=PTRS_Actor
        SpinParticles=True
        RotationOffset=(Yaw=-16384)
        SpinsPerSecondRange=(X=(Max=0.100000))
        StartSpinRange=(X=(Max=1.000000))
        UseSizeScale=True
        UseRegularSizeScale=False
        SizeScale(0)=(RelativeSize=0.200000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=0.500000)
        UniformSize=True
        InitialParticlesPerSecond=500.000000
        AutomaticInitialSpawning=False
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'ExplosionTex.Framed.SmokeReOrdered'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        BlendBetweenSubdivisions=True
        UseRandomSubdivision=True
        LifetimeRange=(Min=2.000000,Max=2.000000)
        StartVelocityRadialRange=(Min=200.000000,Max=200.000000)
        GetVelocityDirectionFrom=PTVD_AddRadial
        UseVelocityScale=True
        VelocityScale(0)=(RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.000000))
        VelocityScale(1)=(RelativeTime=0.300000,RelativeVelocity=(X=0.100000,Y=0.100000,Z=0.100000))
        VelocityScale(2)=(RelativeTime=1.000000)
        Name="SpriteEmitter0"
    End Object
    Emitters(1)=SpriteEmitter'SpriteEmitter0'
    
    bNoDelete=false
    AutoDestroy=true
    RemoteRole=ROLE_None

    bDynamicLight=true
    LightEffect=LE_QuadraticNonIncidence
    LightType=LT_FadeOut
    LightBrightness=255
    LightHue=28
    LightSaturation=90
    LightRadius=9
    LightPeriod=32
    LightCone=128
}
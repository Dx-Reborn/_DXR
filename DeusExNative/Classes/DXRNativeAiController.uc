class DXRNativeAiController extends AIController
                                    native;


native final iterator function CycleActors(class<actor> BaseClass, out Actor OutActor, out int OutIndex);

// replaces TraceVisibleActors()
native final iterator function TraceActorsExt(class<actor> BaseClass, out actor OutActor, out vector HitLoc, out vector HitNorm, vector End, optional vector Start, optional vector Extent, optional int Trace_Flags);

//var bool bUseAlterDest;

//event AlterDest();
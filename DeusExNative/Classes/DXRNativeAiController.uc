class DxrNativeAiController extends AIController abstract native;


var() bool bUseAlterDest;

cpptext
{
	virtual UBOOL UseAlterDest() {
		return bUseAlterDest;
	}

	void SetUseAlterDest(UBOOL bUseAlterDest) {
		this->bUseAlterDest = bUseAlterDest;
	}
}

native final iterator function CycleActors(class<Actor> BaseClass, out Actor OutActor, out int OutIndex);

event AlterDest();


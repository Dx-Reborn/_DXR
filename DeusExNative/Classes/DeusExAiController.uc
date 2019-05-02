class DeusExAiController extends AIController native;


var() bool bUseAlterDest;

event AlterDest();


native final iterator function CycleActors(class<Actor> BaseClass, out Actor OutActor, out int OutIndex);


cpptext
{
	virtual UBOOL UseAlterDest() {
		return bUseAlterDest;
	}

	void SetUseAlterDest(UBOOL bUseAlterDest) {
		this->bUseAlterDest = bUseAlterDest;
	}
}
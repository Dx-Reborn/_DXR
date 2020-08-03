class CatController extends AnimalController;

state Attacking
{
    event Tick(float deltaSeconds)
    {
        Super.Tick(deltaSeconds);
        if (Enemy != None)
            GotoState('Fleeing');
    }
}
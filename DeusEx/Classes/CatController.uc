class CatController extends AnimalController;

state Attacking
{
    function Tick(float deltaSeconds)
    {
        Super.Tick(deltaSeconds);
        if (Enemy != None)
            GotoState('Fleeing');
    }
}
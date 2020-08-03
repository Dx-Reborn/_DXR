//=============================================================================
// NetworkTerminalPublic.
//=============================================================================
class NetworkTerminalPublic extends NetworkTerminal;

// ----------------------------------------------------------------------
// CloseScreen()
// ----------------------------------------------------------------------

function CloseScreen(String action)
{
    Super.CloseScreen(action);

    // Based on the action, proceed!
    if (action == "LOGOUT")
        Super.CloseScreen("EXIT");
}

function bool OnCanClose(optional Bool bCancelled)
{
   return true;
}

event Timer()
{
   local bool bDone;

   if (!bDone)
       Controller.CloseMenu();
   bDone = true;
}



// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
defaultproperties
{
    FirstScreen=Class'ComputerScreenBulletins'
    bUsesHackWindow=False
}

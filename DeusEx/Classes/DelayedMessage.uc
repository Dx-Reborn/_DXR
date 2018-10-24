/* -------------------------------------------------
  ќтложенные сообщение (используетс€ после диалога)
------------------------------------------------- */

class DelayedMessage extends Actor
                             notplaceable
                             transient;

const lifeTime = 1.0;
var int counter;

struct sDelayedMsg
{
  var string Message;
  var sound MsgSound;
};

var array<sDelayedMsg> messages;
var DeusExPlayer player;

function SetPlayer(DeusExPlayer p)
{
   player = p;
   GoToState('DelayedMessages');
}


state DelayedMessages
{
  function IncreaseCounter()
  {
    counter++;
  }

  function Timer()
  {
    player.clientMessage(messages[counter].Message);
    player.playSound(messages[counter].MsgSound);
    GoToState('DelayedMessages','Restart');
  }
Begin:
SetTimer(lifeTime, false);

Restart:
SetTimer(lifeTime, false);
}

defaultproperties
{
   messages(0)=(Message="Test message",MsgSound=sound'LogNoteAdded')
   messages(1)=(Message="Test message Two",MsgSound=sound'LogGoalAdded')
}
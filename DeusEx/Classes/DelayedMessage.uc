/*
  Отложенные сообщения (используется после диалога).
  В DeusEx для этой цели использовался таймер, этот
  вариант выглядит проще.

  Как использовать:
    События и связанные звуки накапливаются в буфере. Ничего не происходит.
    После вызова функции Activate(), каждые lifeTime выводится новое сообщение
    и связанный с ним звук.
  Когда сообщения закончились, этот актор самоуничтожается.

  ---------------------------------------------------------

  Delayed messages (used after conversation).
  DeusEx uses timer in HUD windows for this, but this version looks simpler.

  How to use:
    Messages and related sounds are added to array. Nothing happens for now.
    After calling Activate(), each message is displayed with delay (lifeTime)
    and associated sound is played.
  This actor destroys yourself when no messages left.

*/

class DelayedMessage extends Actor
                             notplaceable
                             transient;

const lifeTime = 0.7; // Time for each message (in seconds).
var int counter;

struct sDelayedMsg
{
  var() string Message;
  var() sound MsgSound;
};

var() editconst array<sDelayedMsg> messages;
var DeusExPlayer player;

function AddMessage(coerce string Text, optional sound snd)
{
  local int x;

  x = messages.Length;
  messages.Length = x + 1;
  messages[x].Message = Text;
  messages[x].MsgSound = snd;

//  log("added message:"@text$" with sound: "$snd);
}

function SetPlayer(DeusExPlayer p)
{
   player = p;
}

function Activate()
{
   if (messages.length > 0)
   GoToState('DelayedMessages');
}


state DelayedMessages
{
   function IncreaseCounter()
   {
      counter++;
      if (counter >= messages.length) // No messages left?
          Destroy(); // ... then destroy yourself.
   }

  event Timer()
  {
    player.clientMessage(messages[counter].Message);

    if (messages[counter].MsgSound != none)
        player.playSound(messages[counter].MsgSound);

    IncreaseCounter();
    GoToState('DelayedMessages','Restart'); // Restart timer and fire next message.
  }

Begin:
SetTimer(lifeTime, false);

Restart:
SetTimer(lifeTime, false);
}

defaultproperties
{
//   messages(0)=(Message="Test message",MsgSound=sound'LogNoteAdded')
//   messages(1)=(Message="Test message Two",MsgSound=sound'LogGoalAdded')
}

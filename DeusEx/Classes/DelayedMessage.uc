/*
  ���������� ��������� (������������ ����� �������).
  � DeusEx ��� ���� ���� ������������� ������, ����
  ������� �������� �����.

  ��� ������������:
    ������� � ��������� ����� ������������� � ������. ������ �� ����������.
    ����� ������ ������� Activate(), ������ lifeTime ��������� ����� ���������
    � ��������� � ��� ����.
  ����� ��������� �����������, ���� ����� ����������������.
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

  function Timer()
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

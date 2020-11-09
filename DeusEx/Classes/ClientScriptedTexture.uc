// ���� �� UT, �� 㬮�砭�� ��� ����� ��������� � Deus Ex

class ClientScriptedTexture extends Info;

var() ScriptedTexture ScriptedTexture;

simulated function BeginPlay()
{
  if (ScriptedTexture != None)
      ScriptedTexture.Client = Self;
}

simulated function Destroyed()
{
  if (ScriptedTexture != None)
      ScriptedTexture.Client = None;
}

defaultproperties
{
    bNoDelete=True
    bAlwaysRelevant=True
    RemoteRole=2
}

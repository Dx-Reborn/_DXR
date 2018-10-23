cd text
dir /B *.txt | makeimport.exe > ..\classes\AllDeusExText.uc

echo checking for non-closed tags...
find /c /i /n "P" ..\classes\AllDeusExText.uc

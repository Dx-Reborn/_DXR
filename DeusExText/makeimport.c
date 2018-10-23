#include <stdio.h>
#include <string.h>

int main(int argc, char *argv[])
{
	fpos_t pos;
	char buf[16384], inbuf[256], linebuf[256], subname[256];
	char *sptr, *extptr;
	FILE *infile;
	int x, r=0, ctr=0;
	size_t numread;

	printf("class AllDeusExText extends Object abstract;\n\n");
	printf("var array<ExtString> allText;\n\n");
	printf("defaultproperties\n");
	printf("{\n");
	sptr = fgets(linebuf, sizeof(linebuf), stdin);
	while(sptr != NULL)
	{
		sscanf(linebuf, "%s\n", inbuf); 
		infile = fopen(inbuf,"r");
		numread = fread(buf, 1, 16384, infile);
		fclose(infile);
		extptr = strrchr(inbuf, '.');
		extptr[0] = '\0';

		for(x=0; x<numread; x++)
		{
			if(buf[x] == '"')
			{				
				memmove(&buf[x+1], &buf[x], numread-x);
				buf[x] = '\\';
				numread++;
				x++;
			}
			else if(buf[x] == '\\')
			{				
				memmove(&buf[x+1], &buf[x], numread-x);
				buf[x] = '\\';
				numread++;
				x++;
			}
		}
		buf[numread-1]='\0';

		printf("\tBegin Object Class=Extension.ExtString Name=%s\n", inbuf);
		ctr=0;
		sptr = strtok(buf, "\n");
		while(sptr != NULL)
		{
			printf("\t\ttext(%d)=\"%s\"\n", ctr, sptr);
			sptr = strtok(NULL, "\n");
			ctr++;
		}
		 
		printf("\tEnd Object\n");
		printf("\tallText(%d)=%s\n", r, inbuf);
		r++;
				
		sptr = fgets(linebuf, sizeof(linebuf), stdin);
	}
	printf("}\n");
}
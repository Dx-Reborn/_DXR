#include <stdio.h>
#include <string.h>

int ReadCompactInteger(FILE *infile)
{
	unsigned char x;
    int output=0, bSigned=0, i;
    for(i=0; i < 5; i++)
    {
        x = (unsigned char)getc(infile);
        // First byte
        if(i == 0)
        {
            // Bit: X0000000
            if((x & 0x80) > 0)
                bSigned = 1;
            // Bits: 00XXXXXX
            output |= (x & 0x3F);
            // Bit: 0X000000
            if((x & 0x40) == 0)
                break;
        }
        // Last byte
        else if(i == 4)
        {
            // Bits: 000XXXXX -- the 0 bits are ignored
            // (hits the 32 bit boundary)
            output |= (x & 0x1F) << (6 + (3 * 7));
        }
        // Middle bytes
        else
        {
            // Bits: 0XXXXXXX
            output |= (x & 0x7F) << (6 + ((i - 1) * 7));
            // Bit: X0000000
            if((x & 0x80) == 0)
                break;
        }
    }
    // multiply by negative one here, since the first 6+ bits could be 0
    if(bSigned == 1)
	{
        output *= -1;
	}

    return(output);
}

int main(int argc, char *argv[])
{
	fpos_t pos;
	char buf[16384], inbuf[256], linebuf[256];
	char *sptr;
	FILE *infile;
	int x, r;
	size_t numread;

	sptr = fgets(linebuf, sizeof(linebuf), stdin);
	while(sptr != NULL)
	{
		sscanf(linebuf, "%s\n", inbuf); 
		infile = fopen(inbuf,"r");

		//useless byte
		r = getc(infile);

		//each ExtString contains a CompactINT at the front
		r = ReadCompactInteger(infile);
		
		//all remaining bytes are pure text
		numread = fread(buf, 1, 16384, infile);
		fclose(infile);

		infile = fopen(inbuf,"w");
		fwrite(buf, 1, numread, infile);
		fclose(infile);

		sptr = fgets(linebuf, sizeof(linebuf), stdin);
	}
}
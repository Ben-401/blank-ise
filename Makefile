all:
	./compile.sh

prog:
	fpgajtag -a ./sdcard-files/bit*.bit*

clean:
	( cd src ; make clean )

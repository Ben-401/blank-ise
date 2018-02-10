# ########################################################################
vgagen_tb_files=../vgasettings.vhdl \
		../tilerom.vhdl \
		../vgagen.vhdl \
		vgagen_tb.vhdl \

vgagen_tb:         $(vgagen_tb_files)
	ghdl -a -v $(vgagen_tb_files)
	ghdl -e -v vgagen_tb
	ghdl -r -v vgagen_tb --stop-time=1ms --vcd=vgagen_tb.vcd
	gtkwave -a                              -f vgagen_tb.vcd
#	gtkwave -a vgagen_tb.gtkw               -f vgagen_tb.vcd

# ########################################################################
clean:
	rm -f *.vcd
	rm -f work*.cf

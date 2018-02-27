library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

library work;

--
entity tilerom is
  port (
    clk  : in std_logic;
    addr : in std_logic_vector(7 downto 0); -- x=(3..0) , y=(7..4)
    we   : in std_logic; -- will be DEASSERTED
    di   : in std_logic_vector(7 downto 0); -- does not write
    do   : out std_logic_vector(7 downto 0)
  );
end tilerom;

architecture Behavioral of tilerom is

  subtype byte_t is std_logic_vector(7 downto 0);
  type ram_t is array (0 to 255) of byte_t;
  signal myram : ram_t := (
x"1F",x"0F",x"00",x"00", x"01",x"01",x"01",x"01", x"02",x"02",x"02",x"02", x"03",x"03",x"03",x"03",
x"1F",x"0F",x"00",x"00", x"01",x"01",x"01",x"01", x"02",x"02",x"02",x"02", x"03",x"03",x"03",x"03",
x"10",x"00",x"00",x"00", x"01",x"01",x"01",x"01", x"02",x"02",x"02",x"02", x"03",x"03",x"03",x"03",
x"10",x"00",x"00",x"00", x"01",x"01",x"01",x"01", x"02",x"02",x"02",x"02", x"03",x"03",x"03",x"03",
x"14",x"04",x"04",x"04", x"05",x"05",x"05",x"05", x"06",x"06",x"06",x"06", x"07",x"07",x"07",x"07",
x"14",x"04",x"04",x"04", x"05",x"05",x"05",x"05", x"06",x"06",x"06",x"06", x"07",x"07",x"07",x"07",
x"14",x"04",x"04",x"04", x"05",x"05",x"05",x"05", x"06",x"06",x"06",x"06", x"07",x"07",x"07",x"07",
x"14",x"04",x"04",x"04", x"05",x"05",x"05",x"05", x"06",x"06",x"06",x"06", x"07",x"07",x"07",x"07",
x"08",x"08",x"08",x"08", x"09",x"09",x"09",x"09", x"0A",x"0A",x"0A",x"0A", x"0B",x"0B",x"0B",x"0B",
x"08",x"08",x"08",x"08", x"09",x"09",x"09",x"09", x"0A",x"0A",x"0A",x"0A", x"0B",x"0B",x"0B",x"0B",
x"08",x"08",x"08",x"08", x"09",x"09",x"09",x"09", x"0A",x"0A",x"0A",x"0A", x"0B",x"0B",x"0B",x"0B",
x"08",x"08",x"08",x"08", x"09",x"09",x"09",x"09", x"0A",x"0A",x"0A",x"0A", x"0B",x"0B",x"0B",x"0B",
x"0C",x"0C",x"0C",x"0C", x"0D",x"0D",x"0D",x"0D", x"0E",x"0E",x"0E",x"0E", x"0F",x"0F",x"0F",x"0F",
x"0C",x"0C",x"0C",x"0C", x"0D",x"0D",x"0D",x"0D", x"0E",x"0E",x"0E",x"0E", x"0F",x"0F",x"0F",x"0F",
x"0C",x"0C",x"0C",x"0C", x"0D",x"0D",x"0D",x"0D", x"0E",x"0E",x"0E",x"0E", x"0F",x"0F",x"00",x"00",
x"0C",x"0C",x"0C",x"0C", x"0D",x"0D",x"0D",x"0D", x"0E",x"0E",x"0E",x"0E", x"0F",x"0F",x"00",x"00");

  attribute ram_style: string;
  attribute ram_style of myram : signal is "block";

begin

  process(clk, myram, addr)
  begin
    if rising_edge(clk) then
      if we = '1' then
        myram(to_integer(unsigned(addr))) <= di;
      end if;
      do <= myram(to_integer(unsigned(addr)));-- after SIMDELAY;
    end if;
  end process;

end Behavioral;

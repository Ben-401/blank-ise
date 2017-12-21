----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:30:37 12/10/2013 
-- Design Name: 
-- Module Name:    container - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use Std.TextIO.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity container is
  port(
    clk_in     : in  std_logic;
    signal_out : out std_logic
        );
end container;

architecture behavioral of container is

  -- buffered external OSC 100mhz
  signal clk100buf : std_logic;
  
  signal counter : std_logic_vector(3 downto 0) := (others => '0');

begin

  -- input global clock buffer on the external 100M osc
  clkin_buf : IBUFG
  port map (
    I => clk_in,
    O => clk100buf
    );
	 
  -- generate a clock-divider
  process (clk100buf) is
    variable count_var : integer range 0 to 15 := 0; -- 4-bits
  begin
    if rising_edge(clk100buf) then
	   count_var := count_var + 1;
      counter <= std_logic_vector(to_unsigned(count_var,4));
    end if;
  end process;

  signal_out <= counter(3);  

end Behavioral;

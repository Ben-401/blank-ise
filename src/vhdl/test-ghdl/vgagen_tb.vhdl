LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
--use work.settings.all;
 
ENTITY vgagen_tb IS
END vgagen_tb;
 
ARCHITECTURE behavior OF vgagen_tb IS 

-- Component Declaration for the Unit Under Test (UUT)
-- change entity to component

component vgagen is
  port (
    sysclk        : in std_logic;
--    reset_S       : in std_logic;
    reset_L       : in std_logic;
     
    vsync    : out  STD_LOGIC;
    hsync    : out  STD_LOGIC;

    disp_en : out std_logic;
    xpix    : out std_logic_vector(10 downto 0);
    ypix    : out std_logic_vector(9 downto 0);

    vgared   : out  std_logic_vector(3 downto 0);
    vgagreen : out  std_logic_vector(3 downto 0);
    vgablue  : out  std_logic_vector(3 downto 0)
    );
end component;

-- TB local (aka ports)

  -- Clock period definitions
  constant CLK_period : time := 31 ns; -- approx
  signal clk		: std_logic;
  signal reset : std_logic := '0';

  signal vicVSync : std_logic;-- := '0';
  signal vicHSync : std_logic;-- := '0';

  signal disp_en : std_logic := '0';
  signal xpix : std_logic_vector(10 downto 0);
  signal ypix : std_logic_vector(9 downto 0);

  signal vgar : std_logic_vector(3 downto 0);
  signal vgag : std_logic_vector(3 downto 0);
  signal vgab : std_logic_vector(3 downto 0);

BEGIN

  uut1vgagen : vgagen
  port map (
    sysclk  => clk,
--    reset_S => reset,
    reset_L => reset,

    vsync => vicVSync,
    hsync => vicHSync,

    disp_en => disp_en,

    xpix => xpix,
    ypix => ypix,

    vgared   => vgar,
    vgagreen => vgag,
    vgablue  => vgab
  );

  -- Clock process definitions
  clk_process : process
  begin
    clk <= '1';
    wait for CLK_period/2;
    clk <= '0';
    wait for CLK_period/2;
  end process;

  -- Clock process definitions
  reset_process : process
  begin
    reset <= '1';
    wait for CLK_period * 18;
    wait for 10 ns;
    reset <= '0';
    wait;
  end process;

END;

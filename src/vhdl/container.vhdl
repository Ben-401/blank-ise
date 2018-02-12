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
-- no vga now, just the lcd
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
    clk_in         : in  STD_LOGIC; -- Nexys4 DDR has 100Mhz system clock
    btnCpuReset_in : in  STD_LOGIC; -- normally high, active low

    vsync : out  STD_LOGIC;
    hsync : out  STD_LOGIC;
    vgared   : out std_logic_vector(3 downto 0);
    vgagreen : out std_logic_vector(3 downto 0);
    vgablue  : out std_logic_vector(3 downto 0);
    
    pmodja01 : out std_logic;
    pmodja02 : out std_logic;
    pmodja03 : out std_logic;
    pmodja04 : out std_logic;
    pmodja07 : out std_logic;
    pmodja08 : out std_logic;
    pmodja09 : out std_logic;
    pmodja10 : out std_logic;

    pmodjb01 : out std_logic;
    pmodjb02 : out std_logic;
    pmodjb03 : out std_logic;
    pmodjb04 : out std_logic;
    pmodjb07 : out std_logic;
    pmodjb08 : out std_logic;
    pmodjb09 : out std_logic;
    pmodjb10 : out std_logic;

    pmodjc01 : out std_logic;
    pmodjc02 : out std_logic;
    pmodjc03 : out std_logic;
    pmodjc04 : out std_logic;
    pmodjc07 : out std_logic;
    pmodjc08 : out std_logic;
    pmodjc09 : out std_logic;
    pmodjc10 : out std_logic;
    
    btn : in std_logic_vector(1 downto 0)
  );
end container;

architecture behavioral of container is

  -- buffered external OSC 100mhz
  signal clk100buf : std_logic;
  
  -- toplevel reset signals (clk100buf domain)
  signal reset_int_A : std_logic;
  signal reset_int_B : std_logic;
  signal mrst_s_common_async : std_logic;
  signal mrst_l_common_async : std_logic;


  -- reset synchroniser (for clk0 domain)
  signal CLK0mrst_s : std_logic_vector(1 downto 0);
  signal CLK0mrst_l : std_logic_vector(1 downto 0);
  signal CLK0mrst_s_out : std_logic;
  signal CLK0mrst_l_out : std_logic;


  -- internal locked signal from MMCM
  signal locked_int : std_logic;

  -- buffered internal CLK from MMCM-CLK0
  signal CLK0int : std_logic;

  -- vga
  signal hsync_int : std_logic;
  signal vsync_int : std_logic;
  --
  signal vgar_int : std_logic_vector(3 downto 0);
  signal vgag_int : std_logic_vector(3 downto 0);
  signal vgab_int : std_logic_vector(3 downto 0);

  -- lcd
  signal lcdr : std_logic_vector(3 downto 0);
  signal lcdg : std_logic_vector(3 downto 0);
  signal lcdb : std_logic_vector(3 downto 0);
  signal lcden : std_logic;
  signal lcdclk : std_logic;
  --
  signal disp_en_int : std_logic;
  signal xpix: std_logic_vector(10 downto 0);
  signal ypix: std_logic_vector(9 downto 0);

  -- other
  signal button : std_logic_vector(1 downto 0) := (others => '0');
  constant PWMBITS : integer := 18;
  signal pwmcnt : std_logic_vector(PWMBITS-1 downto 0) := (others => '0');
  signal pwmset : std_logic_vector(PWMBITS-1 downto 0) := (others => '0');
  signal pwmout : std_logic;

  signal devnull : std_logic;
  signal vgadevnull : std_logic;

begin

  -- input global clock buffer on the external 100M osc
  clkin_buf : IBUFG
  port map (
    I => clk_in,
    O => clk100buf
    );

  -- insert our clock/reset handling component
  clkgen0: entity work.clkgen
  port map (
    clk_in       => clk100buf,
    reset_ext_in => btnCpuReset_in,
    clk0_out     => clk0int,
--    clk1_out     => open,
    locked_out  => locked_int, -- see below for description
    reset_out_A => reset_int_A,
    reset_out_B => reset_int_B
  );

  -- combine the three reset sources
  -- all are ACTIVE-HIGH and should be considered as asynchronous
  mrst_s_common_async <= (not locked_int) or reset_int_A or reset_int_B;
  mrst_l_common_async <= (not locked_int) or reset_int_B;

  -- ######
  -- ## CLK0 domain
  -- ######

  -- sync resets to clk0 clock domain
  -- using async assert, and sync deassert
  --
  -- short-press
  process(CLK0int, mrst_s_common_async) is
  begin
    if (mrst_s_common_async = '1') then
      CLK0mrst_s <= (others => '1'); -- assert reset
    else
      if rising_edge(CLK0int) then
        CLK0mrst_s(1) <= '0'; -- deassert
        CLK0mrst_s(0) <= CLK0mrst_s(1);
      end if;
    end if;
  end process;
  --
  -- long-press
  process(CLK0int, mrst_l_common_async) is
  begin
    if (mrst_l_common_async = '1') then
      CLK0mrst_l <= (others => '1'); -- assert reset
    else
      if rising_edge(CLK0int) then
        CLK0mrst_l(1) <= '0'; -- deassert
        CLK0mrst_l(0) <= CLK0mrst_l(1);
      end if;
    end if;
  end process;
  --
  -- ensure both 's' and 'l' resets are released synchronously on the same edge
  process(CLK0int, CLK0mrst_s, CLK0mrst_l) is
  begin
    if rising_edge(CLK0int) then
      CLK0mrst_s_out <= CLK0mrst_l(0) or CLK0mrst_s(0); -- 's' is asserted while 'l' is asserted
      CLK0mrst_l_out <= CLK0mrst_l(0);
    end if;
  end process;

  -- generate a clock-divider
  process (CLK0int, CLK0mrst_l_out) is
    variable count_var : integer range 0 to (2**PWMBITS)-1 := 0;
    variable pwm_var   : integer range 0 to (2**PWMBITS)-1 := 0;
  begin
    if CLK0mrst_l_out = '1' then -- reset clause, wait for MMCM to lock
      count_var := 0;
      pwm_var   := 2**PWMBITS-2; -- initialise to about 50%
    elsif rising_edge(CLK0int) then
    
      count_var := count_var + 1;

      if (btn(1) = '1') and (count_var < 40) then
        pwm_var := pwm_var + 1;
      else if (btn(0) = '1') and (count_var < 40)  then
        pwm_var := pwm_var - 1;
        end if;
      end if;

      if (count_var < pwm_var)
      then
        pwmout <= '1';
      else
        pwmout <= '0';
      end if;

      pwmcnt <= std_logic_vector(to_unsigned(count_var,PWMBITS));
      
    end if;
  end process;

  vgagen0: entity work.vgagen
  port map (
    sysclk      => CLK0int,
--    sysclkdiv02 => CLK0div2_en,
--    reset_S => CLK0mrst_s_out, -- normally low, reset=1
    reset_L => CLK0mrst_l_out, -- normally low, reset=1

    vsync   => vsync_int,
    hsync   => hsync_int,
    disp_en => disp_en_int,
    xpix => xpix,
    ypix => ypix,
    vgared   => vgar_int,
    vgagreen => vgag_int,
    vgablue  => vgab_int,
    devnull => vgadevnull
  );
  
  -- vga outputs
  hsync <= hsync_int;
  vsync <= vsync_int;
  vgared   <= vgar_int;
  vgagreen <= vgag_int;
  vgablue  <= vgab_int;

  -- lcd outputs
  lcdr <= vgar_int;--"0000";
  lcdg <= vgag_int;--"0000";
  lcdb <= vgab_int;--"1111";

  pmodja01 <= lcdb(0);--'0';--b4
  pmodja02 <= lcdb(1);--'0';--b5
  pmodja03 <= lcdb(2);--'0';--b6
  pmodja04 <= lcdb(3);--'0';--b7

  pmodja07 <= lcdr(0);--'0';--r4
  pmodja08 <= lcdr(1);--'0';--r5
  pmodja09 <= lcdr(2);--'0';--r6
  pmodja10 <= lcdr(3);--'0';--r7

  pmodjb01 <= lcdg(0);--'0';--g4
  pmodjb02 <= lcdg(1);--'0';--g5
  pmodjb03 <= lcdg(2);--'0';--g6
  pmodjb04 <= lcdg(3);--'0';--g7
  pmodjb07 <= CLK0int;--lcdclk/white
  pmodjb08 <= hsync_int;--hs/purple
  pmodjb09 <= vsync_int;--vs/blue
  pmodjb10 <= disp_en_int;--de/yellow
  
  pmodjc01 <= pwmout;
  pmodjc02 <= '0';
  pmodjc03 <= '0';
  pmodjc04 <= '0';
  pmodjc07 <= '0';
  pmodjc08 <= '0';
  pmodjc09 <= '0';
  pmodjc10 <= devnull;

  -- used to remove warnings due to unconnected outputs
  devnull <=
                 xpix(0) or xpix(1) or xpix(2) or xpix(3) or
                 xpix(4) or xpix(5) or xpix(6) or xpix(7) or
                 xpix(8) or xpix(9) or xpix(10) or
                 
                 ypix(0) or ypix(1) or ypix(2) or ypix(3) or
                 ypix(4) or ypix(5) or ypix(6) or ypix(7) or
                 ypix(8) or ypix(9) or
                 
                 -- surely we can do the PWM another way without having this
                 -- internal counter not accepted as purely internal logic.
                 pwmcnt(0)  or pwmcnt(1)  or pwmcnt(2)  or pwmcnt(3) or
                 pwmcnt(4)  or pwmcnt(5)  or pwmcnt(6)  or pwmcnt(7) or
                 pwmcnt(8)  or pwmcnt(9)  or pwmcnt(10) or pwmcnt(11) or
                 pwmcnt(12) or pwmcnt(13) or pwmcnt(14) or pwmcnt(15) or
                 pwmcnt(16) or pwmcnt(17) or
                 
                 vgadevnull or
                 
                 CLK0mrst_s_out;

end Behavioral;

----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use ieee.std_logic_arith.all; -- dont use this
--use ieee.std_logic_unsigned.all;
use Std.TextIO.all;


--library UNISIM;
--use UNISIM.VComponents.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

library work;
use work.vgasettings.all;

-- ####### ####### ####### ####### ####### ####### ####### ####### ####### ####

entity vgagen is
  port (
    sysclk        : in std_logic;
--    reset_S       : in std_logic;
    reset_L       : in std_logic;
     
    vsync    : out  STD_LOGIC;
    hsync    : out  STD_LOGIC;

    disp_en : out std_logic;
    xpix    : out std_logic_vector(10 downto 0);
    ypix    : out std_logic_vector(9  downto 0);

    vgared   : out  std_logic_vector(3 downto 0);
    vgagreen : out  std_logic_vector(3 downto 0);
    vgablue  : out  std_logic_vector(3 downto 0);
    
    devnull : out std_logic
    );
end vgagen;

-- ####### ####### ####### ####### ####### ####### ####### ####### ####### ####

architecture behavioral of vgagen is

  -- refer to settings.vhdl for timing constants
  -- (optional) can be used to over-ride the values in settings.vhdl
--  constant h_pixels : integer:=8;--horizontal display area
--  constant h_fp     : integer:=3;--h. front porch
--  constant h_bp     : integer:=4;--h. back porch
--  constant h_pulse  : integer:=5;--h. retrace
--  --
--  constant v_pixels : integer:=9;--vertical display area
--  constant v_fp     : integer:=4;--v. front porch
--  constant v_bp     : integer:=5;--v. back porch
--  constant v_pulse  : integer:=6;--v. retrace
--  --
--  constant h_period : INTEGER := h_pulse + h_bp + h_pixels + h_fp;  --total number of pixel clocks in a row
--  constant v_period : INTEGER := v_pulse + v_bp + v_pixels + v_fp;  --total number of rows in column

  
   signal h_count_reg0: std_logic_vector(10 downto 0);
   signal v_count_reg0: std_logic_vector(9 downto 0);
   signal h_count_reg1: std_logic_vector(10 downto 0);
   signal v_count_reg1: std_logic_vector(9 downto 0);
   signal h_count_reg2: std_logic_vector(10 downto 0);
   signal v_count_reg2: std_logic_vector(9 downto 0);
   signal h_count_reg3: std_logic_vector(10 downto 0);
   signal v_count_reg3: std_logic_vector(9 downto 0);
   signal h_count_reg4: std_logic_vector(10 downto 0);
   signal v_count_reg4: std_logic_vector(9 downto 0);

   signal h_sync_reg1: std_logic;
   signal v_sync_reg1: std_logic;
   signal h_sync_reg2: std_logic;
   signal v_sync_reg2: std_logic;
   signal h_sync_reg3: std_logic;
   signal v_sync_reg3: std_logic;
   signal h_sync_reg4: std_logic;
   signal v_sync_reg4: std_logic;

   signal disp_ena_reg1: std_logic;
   signal disp_ena_reg2: std_logic;
   signal disp_ena_reg3: std_logic;
   signal disp_ena_reg4: std_logic;

   signal vgar_reg3 : std_logic_vector(3 downto 0);
   signal vgag_reg3 : std_logic_vector(3 downto 0);
   signal vgab_reg3 : std_logic_vector(3 downto 0);
   signal vgar_reg4 : std_logic_vector(3 downto 0);
   signal vgag_reg4 : std_logic_vector(3 downto 0);
   signal vgab_reg4 : std_logic_vector(3 downto 0);

   signal tileromdata_reg2 : std_logic_vector(7 downto 0);

   signal framecounter : std_logic_vector(9 downto 0);

  

-- timing constants
  constant hperiod : real := real(h_period) / real(33333333) * real(1000) * real(1000);
  constant hfreq   : real := real(1000) / real(hperiod);
  constant vperiod : real := real(hperiod) * real(525) / real(1000);
  constant vfreq   : real := real(1000) / real(vperiod);

-- ####### ####### ####### #######
begin
-- ####### ####### ####### #######

  assert false report "h_pulse=" & integer'IMAGE(h_pulse) severity note;
  assert false report "h_bp="    & integer'IMAGE(h_bp)    severity note;
  assert false report "h_fp="    & integer'IMAGE(h_fp)    severity note;
  assert false report "h_pol="   & std_logic'IMAGE(h_pol) severity note;

  assert false report "v_pulse=" & integer'IMAGE(v_pulse) severity note;
  assert false report "v_bp="    & integer'IMAGE(v_bp)    severity note;
  assert false report "v_fp="    & integer'IMAGE(v_fp)    severity note;
  assert false report "v_pol="   & std_logic'IMAGE(v_pol) severity note;

  assert false report "h_period=" & integer'IMAGE(h_period)
                   & " h_pixels=" & integer'IMAGE(h_pixels) severity note;
  assert false report "v_period=" & integer'IMAGE(v_period)
                   & " v_pixels=" & integer'IMAGE(v_pixels) severity note;

  assert false report "->H period="     & real'IMAGE(hperiod) & "us" severity note;
  assert false report "  ->H freq="     & real'IMAGE(hfreq) & "Khz" severity note;
  assert false report "->V period="     & real'IMAGE(vperiod) & "ms" severity note;
  assert false report "  ->V freq="     & real'IMAGE(vfreq) & "Hz" severity note;

  -- output ports
  hsync <= h_sync_reg4;
  vsync <= v_sync_reg4;

  disp_en <= disp_ena_reg4;

  xpix <= h_count_reg4; -- delayed version
  ypix <= v_count_reg4; -- delayed version

  vgared   <= vgar_reg4;
  vgagreen <= vgag_reg4;
  vgablue  <= vgab_reg4;

-- ####### ####### ####### #######
-- pipeline stage-0
  PROCESS(sysclk, reset_L)
    VARIABLE h_count  :  INTEGER RANGE 0 TO h_period - 1 := 0;  --horizontal counter (counts the columns)
    VARIABLE v_count  :  INTEGER RANGE 0 TO v_period - 1 := 0;  --vertical counter (counts the rows)
    VARIABLE f_count  :  INTEGER RANGE 0 TO 1024 - 1      := 0;  --frame counter (counts the frames)
  BEGIN
  
    IF(reset_L = '1') THEN  --reset ASSERTED

      h_count := 0;         --reset horizontal counter
      v_count := 0;         --reset vertical counter
      f_count := 0;         --reset frame counter

      h_count_reg0 <= (others => '0');
      v_count_reg0 <= (others => '0');

    ELSIF(sysclk'EVENT AND sysclk = '1') THEN

      --counters
      IF(h_count < h_period - 1) THEN    --horizontal counter
        h_count := h_count + 1;
      ELSE
        h_count := 0;
        IF(v_count < v_period - 1) THEN  --veritcal counter
          v_count := v_count + 1;
        ELSE
          v_count := 0;
          f_count := f_count + 1;
        END IF;
      END IF;

      h_count_reg0 <= std_logic_vector(to_unsigned(h_count, h_count_reg0'length));
      v_count_reg0 <= std_logic_vector(to_unsigned(v_count, v_count_reg0'length));
      
      framecounter <= std_logic_vector(to_unsigned(f_count, framecounter'length));

    end if;
  end process;

-- ####### ####### ####### #######
-- pipeline stage-1 (reads/uses stage-0)
  PROCESS(sysclk, reset_L)
  BEGIN
  
    IF(reset_L = '1') THEN  --reset ASSERTED

      h_sync_reg1 <= NOT h_pol;  --deassert horizontal sync
      v_sync_reg1 <= NOT v_pol;  --deassert vertical sync

      disp_ena_reg1 <= '0';      --disable display

      -- pipeline
      h_count_reg1 <= (others => '0');
      v_count_reg1 <= (others => '0');

    ELSIF(sysclk'EVENT AND sysclk = '1') THEN

      --horizontal sync signal
      if (h_count_reg0 <  std_logic_vector(to_unsigned((h_pixels+h_fp)        , h_count_reg0'length))) or 
         (h_count_reg0 >= std_logic_vector(to_unsigned((h_pixels+h_fp+h_pulse), h_count_reg0'length))) then
        h_sync_reg1 <= NOT h_pol;    --deassert horiztonal sync pulse
      ELSE
        h_sync_reg1 <= h_pol;        --assert horiztonal sync pulse
      END IF;
    
      --vertical sync signal
      if (v_count_reg0 <  std_logic_vector(to_unsigned((v_pixels+v_fp)        , v_count_reg0'length))) or 
         (v_count_reg0 >= std_logic_vector(to_unsigned((v_pixels+v_fp+v_pulse), v_count_reg0'length))) then
        v_sync_reg1 <= NOT v_pol;    --deassert vertical sync pulse
      ELSE
        v_sync_reg1 <= v_pol;        --assert vertical sync pulse
      END IF;
      
      --set display-enable output
      if (h_count_reg0 <  std_logic_vector(to_unsigned((h_pixels), h_count_reg0'length))) AND
         (v_count_reg0 <  std_logic_vector(to_unsigned((v_pixels), v_count_reg0'length)))
      then
        disp_ena_reg1 <= '1';                                  --enable display
      ELSE                                                --blanking time
        disp_ena_reg1 <= '0';                                  --disable display
      END IF;

      -- pipeline
      h_count_reg1 <= h_count_reg0;
      v_count_reg1 <= v_count_reg0;

    END IF;
  END PROCESS;

-- ####### ####### ####### #######
-- pipeline stage-2 (reads/uses stage-1)

  tilerom0: entity work.tilerom
  port map (
    clk          => sysclk,
    addr(7 downto 4) => v_count_reg1(3 downto 0),
    addr(3 downto 0) => h_count_reg1(3 downto 0),
    do => tileromdata_reg2
  );
  
  PROCESS(sysclk, reset_L)
  BEGIN
  
    IF(reset_L = '1') THEN  --reset ASSERTED
      -- pipeline
      h_sync_reg2 <= NOT h_pol;  --deassert horizontal sync
      v_sync_reg2 <= NOT v_pol;  --deassert vertical sync
      disp_ena_reg2 <= '0';      --disable display
      h_count_reg2 <= (others => '0');
      v_count_reg2 <= (others => '0');
      
    ELSIF(sysclk'EVENT AND sysclk = '1') THEN

      -- pipeline
      h_sync_reg2 <= h_sync_reg1;
      v_sync_reg2 <= v_sync_reg1;
      disp_ena_reg2 <= disp_ena_reg1;
      h_count_reg2 <= h_count_reg1;
      v_count_reg2 <= v_count_reg1;

    END IF;
  END PROCESS;

-- ####### ####### ####### #######
-- pipeline stage-3 (reads/uses stage-2)

  PROCESS(sysclk, reset_L)
  BEGIN
  
    IF(reset_L = '1') THEN  --reset ASSERTED

      vgar_reg3 <= (others => '0');
      vgag_reg3 <= (others => '0');
      vgab_reg3 <= (others => '0');

      -- pipeline
      h_sync_reg3 <= NOT h_pol;  --deassert horizontal sync
      v_sync_reg3 <= NOT v_pol;  --deassert vertical sync
      disp_ena_reg3 <= '0';      --disable display
      h_count_reg3 <= (others => '0');
      v_count_reg3 <= (others => '0');
      
    ELSIF(sysclk'EVENT AND sysclk = '1') THEN

      if (disp_ena_reg2 = '1')
      then
      
        if (framecounter(9) = '1') then
          -- source color data from the rom
          vgar_reg3 <= tileromdata_reg2(3 downto 0);
          vgag_reg3 <= tileromdata_reg2(3 downto 0);
          vgab_reg3 <= tileromdata_reg2(3 downto 0);
        else
          -- generate rainbow colors
          vgar_reg3 <= h_count_reg2(3 downto 0);
          vgag_reg3 <= v_count_reg2(5 downto 2);
          vgab_reg3 <= v_count_reg2(7 downto 4);
        end if;

      ELSE                                                --blanking time
        vgar_reg3 <= (others => '0');
        vgag_reg3 <= (others => '0');
        vgab_reg3 <= (others => '0');
      END IF;

      -- pipeline
      h_sync_reg3 <= h_sync_reg2;
      v_sync_reg3 <= v_sync_reg2;
      disp_ena_reg3 <= disp_ena_reg2;
      h_count_reg3 <= h_count_reg2;
      v_count_reg3 <= v_count_reg2;

    END IF;
  END PROCESS;

-- ####### ####### ####### #######
-- pipeline stage-4 (reads/uses stage-3)

  PROCESS(sysclk, reset_L)
  BEGIN
  
    IF(reset_L = '1') THEN  --reset ASSERTED

      vgar_reg4 <= (others => '0');
      vgag_reg4 <= (others => '0');
      vgab_reg4 <= (others => '0');

      -- pipeline
      h_sync_reg4 <= NOT h_pol;  --deassert horizontal sync
      v_sync_reg4 <= NOT v_pol;  --deassert vertical sync
      disp_ena_reg4 <= '0';      --disable display
      h_count_reg4 <= (others => '0');
      v_count_reg4 <= (others => '0');
      
    ELSIF(sysclk'EVENT AND sysclk = '1') THEN

      if (disp_ena_reg3 = '1') and
         (framecounter(5) = '0') and (
         (h_count_reg3 = std_logic_vector(to_unsigned(0,          h_count_reg3'length))) or 
         (h_count_reg3 = std_logic_vector(to_unsigned(h_pixels-1, h_count_reg3'length))) or
         (h_count_reg3(5 downto 0) = "111111") or
         (v_count_reg3 = std_logic_vector(to_unsigned(0,          v_count_reg3'length))) or
         (v_count_reg3 = std_logic_vector(to_unsigned(v_pixels-1, v_count_reg3'length))) or
         (v_count_reg3(5 downto 0) = "111111")
         )
      then
        -- white border
        vgar_reg4 <= "1111";
        vgag_reg4 <= "1111";
        vgab_reg4 <= "1111";
      else
        vgar_reg4 <= vgar_reg3;
        vgag_reg4 <= vgag_reg3;
        vgab_reg4 <= vgab_reg3;
      end if;

      -- pipeline
      h_sync_reg4 <= h_sync_reg3;
      v_sync_reg4 <= v_sync_reg3;
      disp_ena_reg4 <= disp_ena_reg3;
      h_count_reg4 <= h_count_reg3;
      v_count_reg4 <= v_count_reg3;

    END IF;
  END PROCESS;

-- ####### ####### ####### #######
  devnull <= 
      framecounter(0) or framecounter(1) or framecounter(2) or framecounter(3) or 
      framecounter(4) or                    framecounter(6) or framecounter(7) or
      framecounter(8) or

      tileromdata_reg2(4) or tileromdata_reg2(5) or
      tileromdata_reg2(6) or tileromdata_reg2(7);

  
end Behavioral;


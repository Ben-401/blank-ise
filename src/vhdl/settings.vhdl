library ieee;
use ieee.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

package settings is

  --       CONST_MMCM_CLKIN     external clock input freq (Mhz)
  constant CONST_MMCM_CLKIN     : INTEGER := 100; -- (10..800 Mhz)
  --       CONST_MMCM_INDIV     inclock divider
  constant CONST_MMCM_INDIV     : INTEGER := 4; -- (1..106)

  constant CONST_MMCM_MULT_F    : REAL := 25.175; -- inclock multiplier
  constant CONST_MMCM_CLK0DIV_F : REAL := 25.0;   -- clock0 multiplier

--  -- 800x600 / 32mhz (NON STANDARD)
--  constant  h_pulse  :  INTEGER   :=   102;   --horiztonal sync pulse width in pixels
--  constant  h_bp     :  INTEGER   :=   70;   --horiztonal back porch width in pixels
--  constant  h_pixels :  INTEGER   :=   640;  --horiztonal display width in pixels
--  constant  h_fp     :  INTEGER   :=   32;   --horiztonal front porch width in pixels
--  constant  h_pol    :  STD_LOGIC := '0';   --horizontal sync pulse polarity (1 = positive, 0 = negative)
--  constant  v_pulse  :  INTEGER   :=  4;     --vertical sync pulse width in rows
--  constant  v_bp     :  INTEGER   :=  23;    --vertical back porch width in rows
--  constant  v_pixels :  INTEGER   :=  604;  --vertical display width in rows
--  constant  v_fp     :  INTEGER   :=  1;     --vertical front porch width in rows
--  constant  v_pol    :  STD_LOGIC := '1';  --vertical sync pulse polarity (1 = positive, 0 = negative)
--  -- 844
--  CONSTANT  h_period  :  INTEGER := h_pulse + h_bp + h_pixels + h_fp;  --total number of pixel clocks in a row
--  -- 632
--  CONSTANT  v_period  :  INTEGER := v_pulse + v_bp + v_pixels + v_fp;  --total number of rows in column

  -- 800x600 / 64mhz (NON STANDARD)
--  constant  h_pulse  :  INTEGER   :=  205;   --horiztonal sync pulse width in pixels
--  constant  h_bp     :  INTEGER   :=  140;   --horiztonal back porch width in pixels
--  constant  h_pixels :  INTEGER   := 1280;  --horiztonal display width in pixels
--  constant  h_fp     :  INTEGER   :=   64;   --horiztonal front porch width in pixels
--  constant  h_pol    :  STD_LOGIC := '0';   --horizontal sync pulse polarity (1 = positive, 0 = negative)
--  constant  v_pulse  :  INTEGER   :=    4;     --vertical sync pulse width in rows
--  constant  v_bp     :  INTEGER   :=   23;    --vertical back porch width in rows
--  constant  v_pixels :  INTEGER   :=  600;  --vertical display width in rows
--  constant  v_fp     :  INTEGER   :=    1;     --vertical front porch width in rows
--  constant  v_pol    :  STD_LOGIC := '1';  --vertical sync pulse polarity (1 = positive, 0 = negative)
--  -- 1689
--  CONSTANT  h_period  :  INTEGER := h_pulse + h_bp + h_pixels + h_fp;  --total number of pixel clocks in a row
--  -- 628
--  CONSTANT  v_period  :  INTEGER := v_pulse + v_bp + v_pixels + v_fp;  --total number of rows in column

--  -- 800x480 / 40mhz
--  constant  h_pulse  :  INTEGER   :=  40; --horiztonal sync pulse width in pixels
--  constant  h_bp     :  INTEGER   :=  46;   --horiztonal back porch width in pixels
--  constant  h_pixels :  INTEGER   := 800;  --horiztonal display width in pixels
--  constant  h_fp     :  INTEGER   := 210;   --horiztonal front porch width in pixels
--  constant  h_pol    :  STD_LOGIC := '0';   --horizontal sync pulse polarity (1 = positive, 0 = negative)
--  constant  v_pulse  :  INTEGER   :=  20;     --vertical sync pulse width in rows
--  constant  v_bp     :  INTEGER   :=  23;    --vertical back porch width in rows
--  constant  v_pixels :  INTEGER   := 480;  --vertical display width in rows
--  constant  v_fp     :  INTEGER   :=  22;     --vertical front porch width in rows
--  constant  v_pol    :  STD_LOGIC := '0';  --vertical sync pulse polarity (1 = positive, 0 = negative)
--  CONSTANT  h_period  :  INTEGER := h_pulse + h_bp + h_pixels + h_fp;  --total number of pixel clocks in a row
--  CONSTANT  v_period  :  INTEGER := v_pulse + v_bp + v_pixels + v_fp;  --total number of rows in column

  -- 800x600 @ 60hz (40mhz)
  constant  h_pulse  :  INTEGER   :=  128; --horiztonal sync pulse width in pixels
  constant  h_bp     :  INTEGER   :=   88;   --horiztonal back porch width in pixels
  constant  h_pixels :  INTEGER   :=  800;  --horiztonal display width in pixels
  constant  h_fp     :  INTEGER   :=   40;   --horiztonal front porch width in pixels
  constant  h_pol    :  STD_LOGIC :=  '1';   --horizontal sync pulse polarity (1 = positive, 0 = negative)
  constant  v_pulse  :  INTEGER   :=    4;     --vertical sync pulse width in rows
  constant  v_bp     :  INTEGER   :=   23;    --vertical back porch width in rows
  constant  v_pixels :  INTEGER   :=  600;  --vertical display width in rows
  constant  v_fp     :  INTEGER   :=    1;     --vertical front porch width in rows
  constant  v_pol    :  STD_LOGIC :=  '1';  --vertical sync pulse polarity (1 = positive, 0 = negative)
  CONSTANT  h_period  :  INTEGER := h_pulse + h_bp + h_pixels + h_fp;  --total number of pixel clocks in a row
  CONSTANT  v_period  :  INTEGER := v_pulse + v_bp + v_pixels + v_fp;  --total number of rows in column


  -- 640x480 @ 60hz (25.175mhz = 100, 4,  25.172, 25.0) CONFD
  constant  h_pulse  :  INTEGER   :=  96; --horiztonal sync pulse width in pixels
  constant  h_bp     :  INTEGER   :=  48;   --horiztonal back porch width in pixels
  constant  h_pixels :  INTEGER   := 640;  --horiztonal display width in pixels
  constant  h_fp     :  INTEGER   :=  16;   --horiztonal front porch width in pixels
  constant  h_pol    :  STD_LOGIC := '0';   --horizontal sync pulse polarity (1 = positive, 0 = negative)
  constant  v_pulse  :  INTEGER   :=   2;     --vertical sync pulse width in rows
  constant  v_bp     :  INTEGER   :=  33;    --vertical back porch width in rows
  constant  v_pixels :  INTEGER   := 480;  --vertical display width in rows
  constant  v_fp     :  INTEGER   :=  10;     --vertical front porch width in rows
  constant  v_pol    :  STD_LOGIC := '0';  --vertical sync pulse polarity (1 = positive, 0 = negative)
  CONSTANT  h_period  :  INTEGER := h_pulse + h_bp + h_pixels + h_fp;  --total number of pixel clocks in a row
  CONSTANT  v_period  :  INTEGER := v_pulse + v_bp + v_pixels + v_fp;  --total number of rows in column

-- ################################################################

  CONSTANT SIMDELAY : time := 12 ns;

end settings;

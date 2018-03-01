library ieee;
use ieee.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

package vgasettings is

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

--  -- 800x600 / 64mhz (NON STANDARD)
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

  -- 800x(600-120) @ 50hz -> works on VGA-Monitor and LCD-Screen
  constant  h_pulse  :  INTEGER   :=  128; --horiztonal sync pulse width in pixels
  constant  h_bp     :  INTEGER   :=   88;   --horiztonal back porch width in pixels
  constant  h_pixels :  INTEGER   :=  800;  --horiztonal display width in pixels
  constant  h_fp     :  INTEGER   :=   40;   --horiztonal front porch width in pixels
  constant  h_pol    :  STD_LOGIC :=  '1';   --horizontal sync pulse polarity (1 = positive, 0 = negative)
  constant  v_pulse  :  INTEGER   :=    4;     --vertical sync pulse width in rows
  constant  v_bp     :  INTEGER   :=   23+60+1;   --vertical back porch width in rows
  constant  v_pixels :  INTEGER   :=  600-120;  --vertical display width in rows
  constant  v_fp     :  INTEGER   :=    1+60;     --vertical front porch width in rows
  constant  v_pol    :  STD_LOGIC :=  '1';  --vertical sync pulse polarity (1 = positive, 0 = negative)

  -- 640x480 @ 60hz (25.175mhz = 100, 4,  25.175, 25.0) CONFD for VGA, LCD does not like
--  constant  h_pulse  :  INTEGER   :=  96; --horiztonal sync pulse width in pixels
--  constant  h_bp     :  INTEGER   :=  48;   --horiztonal back porch width in pixels
--  constant  h_pixels :  INTEGER   := 640;  --horiztonal display width in pixels
--  constant  h_fp     :  INTEGER   :=  16;   --horiztonal front porch width in pixels
--  constant  h_pol    :  STD_LOGIC := '0';   --horizontal sync pulse polarity (1 = positive, 0 = negative)
--  constant  v_pulse  :  INTEGER   :=   2;     --vertical sync pulse width in rows
--  constant  v_bp     :  INTEGER   :=  33;    --vertical back porch width in rows
--  constant  v_pixels :  INTEGER   := 480;  --vertical display width in rows
--  constant  v_fp     :  INTEGER   :=  10;     --vertical front porch width in rows
--  constant  v_pol    :  STD_LOGIC := '0';  --vertical sync pulse polarity (1 = positive, 0 = negative)

  -- 1017,25 good
  -- 1016,25 flicker
  -- 1015,25 good
  -- XXX x480 @ 60hz NON-STD-CLK (40mhz = 100, 1, 8.0, 20) CONFD but has 5x-H-jitter
--  constant  h_pulse  :  INTEGER   :=  152; --horiztonal sync pulse width in pixels
--  constant  h_bp     :  INTEGER   :=   77;   --horiztonal back porch width in pixels
--  constant  h_pixels :  INTEGER   := 1017;  --horiztonal display width in pixels
--  constant  h_fp     :  INTEGER   :=   25;   --horiztonal front porch width in pixels
--  constant  h_pol    :  STD_LOGIC := '0';   --horizontal sync pulse polarity (1 = positive, 0 = negative)
--  constant  v_pulse  :  INTEGER   :=   2;     --vertical sync pulse width in rows
--  constant  v_bp     :  INTEGER   :=  33;    --vertical back porch width in rows
--  constant  v_pixels :  INTEGER   := 480;  --vertical display width in rows
--  constant  v_fp     :  INTEGER   :=  10;     --vertical front porch width in rows
--  constant  v_pol    :  STD_LOGIC := '0';  --vertical sync pulse polarity (1 = positive, 0 = negative)

--  -- LCD 800x480 @ 60hz NON-STD-CLK (40mhz = 100, 1, 8.0, 20) CONFD but has 5x-H-jitter
--  constant  h_pulse  :  INTEGER   :=  30; --horiztonal sync pulse width in pixels
--  constant  h_bp     :  INTEGER   :=  46-30;   --horiztonal back porch width in pixels
--  constant  h_pixels :  INTEGER   := 883;  --horiztonal display width in pixels
--  constant  h_fp     :  INTEGER   := 340;   --horiztonal front porch width in pixels
--  constant  h_pol    :  STD_LOGIC := '0';   --horizontal sync pulse polarity (1 = positive, 0 = negative)
--  constant  v_pulse  :  INTEGER   :=  17;     --vertical sync pulse width in rows
--  constant  v_bp     :  INTEGER   :=  33-17;    --vertical back porch width in rows
--  constant  v_pixels :  INTEGER   := 480;  --vertical display width in rows
--  constant  v_fp     :  INTEGER   :=  12;     --vertical front porch width in rows
--  constant  v_pol    :  STD_LOGIC := '0';  --vertical sync pulse polarity (1 = positive, 0 = negative)

  -- yes works for LCD
  -- LCD 800x480 @ 60hz NON-STD-CLK (33.3mhz = 100, 1, 9.0, 27.0) CONFD-LCD
--  constant  h_pulse  :  INTEGER   :=  40; --horiztonal sync pulse width in pixels
--  constant  h_bp     :  INTEGER   :=  46-40;   --horiztonal back porch width in pixels
--  constant  h_pixels :  INTEGER   := 800;  --horiztonal display width in pixels
--  constant  h_fp     :  INTEGER   := 213;   --horiztonal front porch width in pixels
--  constant  h_pol    :  STD_LOGIC := '0';   --horizontal sync pulse polarity (1 = positive, 0 = negative)
--  constant  v_pulse  :  INTEGER   :=  17;     --vertical sync pulse width in rows
--  constant  v_bp     :  INTEGER   :=  23-17;  --vertical back porch width in rows
--  constant  v_pixels :  INTEGER   := 480;     --vertical display width in rows
--  constant  v_fp     :  INTEGER   := 22;     --vertical front porch width in rows
--  constant  v_pol    :  STD_LOGIC := '0';  --vertical sync pulse polarity (1 = positive, 0 = negative)

  -- LCD 800x480 @ 60hz NON-STD-CLK (33.3mhz = 100, 1, 9.0, 27.0) CONFD-LCD
--  constant  h_pulse  :  INTEGER   :=  40; --horiztonal sync pulse width in pixels
--  constant  h_bp     :  INTEGER   :=  46-40;   --horiztonal back porch width in pixels
--  constant  h_pixels :  INTEGER   := 800;  --horiztonal display width in pixels
--  constant  h_fp     :  INTEGER   := 210;   --horiztonal front porch width in pixels
--  constant  h_pol    :  STD_LOGIC := '0';   --horizontal sync pulse polarity (1 = positive, 0 = negative)
--  constant  v_pulse  :  INTEGER   :=  17;     --vertical sync pulse width in rows
--  constant  v_bp     :  INTEGER   :=  23-17;  --vertical back porch width in rows
--  constant  v_pixels :  INTEGER   := 480;     --vertical display width in rows
--  constant  v_fp     :  INTEGER   := 128;     --vertical front porch width in rows
--  constant  v_pol    :  STD_LOGIC := '0';  --vertical sync pulse polarity (1 = positive, 0 = negative)

-- ################################################################

  CONSTANT  h_period  :  INTEGER := h_pulse + h_bp + h_pixels + h_fp;  --total number of pixel clocks in a row
  CONSTANT  v_period  :  INTEGER := v_pulse + v_bp + v_pixels + v_fp;  --total number of rows in column

-- ################################################################

  CONSTANT SIMDELAY : time := 12 ns;

end vgasettings;

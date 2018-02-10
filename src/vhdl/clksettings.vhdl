library ieee;
use ieee.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

package clksettings is

  constant CONST_MMCM_CLKIN     : INTEGER := 100;-- (10..800 Mhz)
  constant CONST_MMCM_INDIV     : INTEGER :=   1;-- (1..106)
  constant CONST_MMCM_MULT_F    : REAL    := 9.0;-- (2.0..64.0)
  constant CONST_MMCM_CLK0DIV_F : REAL    :=27.0;-- (1.0..128.0)
  
  -- 40.0:     100,  1,   8.0,   20.0
  -- 33.333:   100,  1,   9.0,   27.0
  -- 25.175:   100,  4,  25.175, 25.0

-- ################################################################

  CONSTANT SIMDELAY : time := 12 ns;

end clksettings;

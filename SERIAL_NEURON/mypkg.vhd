library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.math_real."log2";

package mypkg is

    constant N : integer := 4;          --Number of Inputs
    constant M : integer := 3;
	constant data_width : integer := 8;
    constant intBits : integer := 3;
    constant fracBits : integer := data_width - intBits;

    type X_array is array (0 to N-1) of signed(data_width-1 downto 0);   --depth=N+1 (N inputs + 1 bias)
    type W_array is array (0 to N-1) of signed(data_width-1 downto 0);
	type W_deep_array is array (0 to M*(N-1)*(N-1)) of signed(data_width-1 downto 0);
	type Bias_array is array (0 to M-1) of signed(data_width -1 downto 0);

end package;
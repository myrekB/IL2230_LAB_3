library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.mypkg.all;

entity relu is 
    port (
        din   : in signed(data_width-1 downto 0);
        dout  : out signed(data_width-1 downto 0)
    );
end relu;

architecture Behavioral of relu is
    constant zero : signed(data_width-1 downto 0) := (others => '0');

begin
    --If MSB = 1, then number < 0
    dout <= zero when (din(data_width-1) = '1') else din;

end Behavioral;
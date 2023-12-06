library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.mypkg.all;

entity MAC is
	port (a		: in signed(data_width-1 downto 0);
		  b		: in signed(data_width-1 downto 0);
		  c		: in signed(data_width-1 downto 0);
		  res 	: out signed(data_width-1 downto 0)
    );
end MAC;

architecture Behavioral of MAC is
	signal tMul : signed(2*data_width-1 downto 0); 
    
    begin
        tMul <= a * b;
        res <= tMul(2*data_width-intBits-1 downto fracBits) + c;

end Behavioral;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.mypkg.all;

entity parallelRelu is 
    port (
        clk    : in std_logic;
        n_rst  : in std_logic;
        x      : in X_array;
        w      : in W_array;
        bias   : in signed(data_width-1 downto 0);
        y      : out signed(data_width-1 downto 0);
        valout : out std_logic
    );
end parallelRelu;

architecture Behavioral of parallelRelu is

    component MAC
        port (a		: in signed(data_width-1 downto 0);
		      b		: in signed(data_width-1 downto 0);
		      c		: in signed(data_width-1 downto 0);
		      res 	: out signed(data_width-1 downto 0)
    );
    end component;

    component relu
        port (din   : in signed(data_width-1 downto 0);
              dout  : out signed(data_width-1 downto 0)
        );
    end component;

    constant one : signed(data_width-1 downto 0) := (fracBits => '1', others => '0');
    
    type data is array(0 to N) of signed(data_width-1 downto 0);
    signal inputs, weights : data;
    type t_res is array(0 to N+1) of signed(data_width-1 downto 0);
    signal results : t_res;
    signal temp_out_1, temp_out_2 : signed(data_width-1 downto 0);

begin

    inputs(0) <= bias;
    weights(0) <= one;
    results(0) <= (others => '0');  
    data_assignment : for i in 1 to N generate
        inputs(i) <= x(i-1);
        weights(i) <= w(i-1);
    end generate;

    MAC_generator : for i in 0 to N generate
    begin
        MAC_chain : MAC
        port map (
            a => inputs(i),
            b => weights(i),
            c => results(i),
            res => results(i+1)
        );
    end generate;
    
    temp_out_1 <= results(N+1);

    activation_function : relu 
        port map (
            din => temp_out_1,
            dout => temp_out_2
        );

    process(clk, n_rst) is
    begin
        if (n_rst = '0') then
            y <= (others => '0');
            valout <= '0';
        elsif rising_edge(clk) then
            y <= temp_out_2;
            valout <= '1';
        end if;
    end process;


end Behavioral;

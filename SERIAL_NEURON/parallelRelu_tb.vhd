library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real."log2";
use work.mypkg.all;

entity parallelRelu_tb is
end;

architecture bench of parallelRelu_tb is

    component parallelRelu is 
        port (
            clk    : in std_logic;
            n_rst  : in std_logic;
            x      : in X_array;
            w      : in W_array;
            bias   : in signed(data_width-1 downto 0);
            y      : out signed(data_width-1 downto 0);
            valout : out std_logic
        );
    end component;

    signal clk : std_logic := '0';
    signal n_rst : std_logic := '0';
    signal w : W_array;
    signal x : X_array;
    signal bias : signed(data_width-1 downto 0);
    signal y : signed(data_width-1 downto 0);
    signal valout : std_logic;

    constant clock_period: time := 10 ns;

    begin 
    
    dut: parallelRelu 
            port map (clk => clk,
                      n_rst  => n_rst,
                      x      => x,
                      w      => w,
                      bias   => bias,
                      y      => y,
                      valout => valout);   

    x <= ("00101100", "01010000", "10101000", "00010100");    --bias = 1.25, x[1.375,   2.5, -2.75,  0.625]
    w <= ("00010000", "11110000", "00100100", "00011000");    --w0   = 1,    w[0.5,    -0.5,  1.125, 0.75]  
    
    clk <= not clk after clock_period/2;

    stimulus: process
    begin
        n_rst <= '0';
        wait for 10 ns;
        n_rst <= '1';
        bias <= "00101000";
        wait; 
    end process;

end;


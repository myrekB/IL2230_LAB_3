library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.mypkg.all;


entity NEURON_SERIAL is 
	port(clk : 			in std_logic;
		 reset : 		in std_logic;
		 data_input : 	in X_array;
		 weights : 		in W_deep_array;
		 bias : 		in Bias_array;
		 data_output : 	out X_array
		 );
		 
end NEURON_SERIAL;



architecture rtl of NEURON_SERIAL is
	type state_type is (IDLE,CALC_FIRST,CALC_LAYER,OUTPUT);
	signal state : state_type := IDLE;
	
	component parallelRelu
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
	
	
	--Here we can put some extra inter signals if we need
	-- Set to zero from the begining
	signal x_int : X_array;
	signal w_int : W_array;
	signal bias_int  : signed(data_width-1 downto 0);
	signal y_int     : signed(data_width-1 downto 0);
	signal valout_int: std_logic;
	
	
	signal counter_neuron : integer range 0 to N := 0;
	signal counter_layer  : integer range 0 to M := 1;
	
	-- All the memory to be used within the serial-neuron
	signal data_memory : X_array;
	signal bias_memory : Bias_array;
	signal weight_memory : W_deep_array;
	
	
	begin
	
	U1 : parallelRelu port map(clk => clk,
				  n_rst => reset,
				  x => x_int,
				  w => w_int,
				  bias => bias_int,
				  y => y_int,
				  valout => valout_int);
	

	P1 : process(clk, reset) is
		begin
			if reset = '1' then
				state <= IDLE;
				
				
			elsif rising_edge(clk) then
				case state is
					when IDLE =>
						state <= CALC_FIRST;
						counter_neuron <= 0;
					    counter_layer  <= 1;
					
					
					when CALC_FIRST =>
						if counter_neuron = N then
							state <= CALC_LAYER;
							
						else
							state <= CALC_FIRST;
							counter_neuron <= counter_neuron +1;
						end if;
							
					when CALC_LAYER =>
						if (counter_layer = M and counter_neuron = N) then
							state <= OUTPUT;
						elsif counter_neuron = N then
							counter_neuron <= 0;
							counter_layer <= counter_layer +1;
						else
							counter_neuron <= counter_neuron +1;
						end if;
							
					when OUTPUT =>
						state <= IDLE;
						
					when others =>
						state <= IDLE;
				end case;
			end if;
		end process;
					
	-- Dont forget to put signals into the sensitivity list						
	--P2 : process(state,) is
	--	begin
	--		case state is 
	--			when IDLE
						
	
end architecture;
			  

	

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use work.my_pkg.arrAB;

entity test is end entity;

architecture Behavioral of test is
signal clk : std_logic := '1';
signal rst : std_logic;
signal input_data : arrAB;
signal input_valid : std_logic;
signal ready_recieve : std_logic ;

signal ready_recieve_input : std_logic;
signal out_valid : std_logic;
signal out_data : unsigned(15 downto 0);
signal out_dividend : unsigned(15 downto 0);
signal out_divisor : unsigned(15 downto 0);

begin

G : entity work.test_data port map(clk => clk, 
                                    rst => rst, 
                                    input_data =>input_data, 
                                    input_valid => input_valid,
                                    ready_recieve_input => ready_recieve_input
                                    );
                                    
S : entity work.source port map(clk => clk, 
                                    rst => rst, 
                                    input_data =>input_data, 
                                    input_valid => input_valid,
                                    ready_recieve_input => ready_recieve_input,
                                    ready_recieve => ready_recieve,
                                    out_valid => out_valid,
                                    out_data => out_data,
                                    out_dividend => out_dividend,
                                    out_divisor => out_divisor
                                    );                                 
 R : entity work.receiver port map (clk => clk, 
                                    rst => rst, 
                                    ready_recieve => ready_recieve,
                                    out_valid => out_valid,
                                    out_data => out_data,
                                    out_dividend => out_dividend,
                                    out_divisor => out_divisor);
process is 
begin 
    clk <= not clk;
    wait for 5ns;
end process;

rst <= '0';

end Behavioral;

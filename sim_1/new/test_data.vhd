library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use work.my_pkg.arrAB;

entity test_data is
port(
clk, rst : in std_logic;
ready_recieve_input : in std_logic;

input_data : out arrAB;
signal input_valid : out std_logic := '0'
);
end test_data;

architecture Bechavioural of test_data is  

procedure delay(signal clk : in std_logic) is 
begin
    wait until clk'event and clk = '1';
end delay;

begin
process is
begin
    delay(clk);
    for a in 100 to 136 loop
        for b in 23 to 30 loop       
            if ready_recieve_input = '1' then    
                input_valid <= '1';    
                input_data(0) <= to_unsigned(a,16);
                input_data(1) <= to_unsigned(b,16);
                delay(clk);
        end if;
      end loop;
    end loop;
    
end process;

end Bechavioural;
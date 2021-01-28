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
signal count : integer range 0 to 8 := 0;

procedure delay(signal clk : in std_logic) is 
begin
    wait until clk'event and clk = '1';    
end delay;

begin

process(clk) is
begin
if clk'event and clk = '1' then
    if count = 8 then 
        count <= 0;
    else
        count <= count + 1;
    end if;
end if;
end process;

process(clk) is 
begin
if clk'event and clk = '1' then
    if count = 4 then
        input_valid <= '0';
    else 
        input_valid <= '1';
    end if;
end if;
end process;

process is
begin
    for a in 100 to 136 loop
        for b in 23 to 30 loop       
            wait until ready_recieve_input = '1'and clk'event and clk = '1' and count /= 4;  
                input_data(0) <= to_unsigned(a,16);
                input_data(1) <= to_unsigned(b,16);              
      end loop;
    end loop;
    
end process;

end Bechavioural;
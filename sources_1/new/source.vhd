library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

package my_pkg is
        type arrAB is array(1 downto 0) of unsigned(15 downto 0);
        type registers is array (16 downto 0) of unsigned(15 downto 0);
        type arrShifts  is array (16 downto 0) of integer range -2 to 15;        
end package;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use work.my_pkg.all;

entity source is
Port (
clk, rst : in std_logic;
input_data : in arrAB;
input_valid : in std_logic;
ready_recieve : in std_logic ;

ready_recieve_input : out std_logic;
out_valid : out std_logic := '0';
out_data : out unsigned(15 downto 0);
out_dividend : out unsigned(15 downto 0);
out_divisor : out unsigned(15 downto 0)
);
end source;

architecture Behavioral of source is
signal arrDivisors : registers := (others => to_unsigned(0, 16));
signal arrDividends : registers := (others => to_unsigned(0, 16));
signal arrOriginalDividends : registers := (others => to_unsigned(0, 16));
signal arrQuotients : registers := (others => to_unsigned(0, 16));
signal shifts : arrShifts := (others => -2);

begin

process(clk) is
variable shiftedUnit : unsigned(15 downto 0);
begin

if clk'event and clk = '1'  then

    if ready_recieve = '1' then
        ready_recieve_input <= '1';
    else 
        ready_recieve_input <= '0';
    end if; 
    
if input_valid = '1' and ready_recieve = '1' then 
        --store new data
        arrDividends(0) <= input_data(0);
        arrOriginalDividends(0) <= input_data(0);
        arrDivisors(0) <= input_data(1);
        arrQuotients(0) <= to_unsigned(0, 16);
        
        --calculate initial shift of divisor to value 1 << 15
        for pos in 15 downto 0 loop
            shiftedUnit := shift_left(to_unsigned(1, 16) , pos);
            if (std_logic_vector(input_data(1)) and std_logic_vector(shiftedUnit)) /=  std_logic_vector(to_unsigned(0, 16)) then
                shifts(0) <= 15 - pos;
                exit;
            end if;
        end loop;
    -- produce one iteration of division    
    for i in 15 downto 0 loop
   
        arrOriginalDividends(i + 1) <= arrOriginalDividends(i); 
        arrDivisors(i + 1) <= arrDivisors(i);
        if shifts(i) = -1  or shifts(i) = -2 then        
            -- division completed - do nothing or iti s staff
            arrDividends(i + 1) <= arrDividends(i);
            arrQuotients(i + 1) <= arrQuotients(i);
            shifts(i + 1) <=  shifts(i);
          next;
         end if; 
           
        if arrDividends(i) >= shift_left(arrDivisors(i), shifts(i)) then
            -- place 1 at shift(i) + 1 place in quotient
            -- and reduce dividend
            arrDividends(i + 1) <= (arrDividends(i) - shift_left(arrDivisors(i), shifts(i)));
            arrQuotients(i + 1) <= unsigned(std_logic_vector(arrQuotients(i)) or 
            std_logic_vector(shift_left(to_unsigned(1, 16), shifts(i))));
        else
            arrDividends(i + 1) <= arrDividends(i);
            arrQuotients(i + 1) <= arrQuotients(i);
        end if;

        shifts(i + 1) <= shifts(i) - 1;
       
    end loop;
    end if;
    
    if shifts(16) = -1 then
        out_valid <= '1';
    else
        out_valid <= '0';
end if;
    
    out_data <= arrQuotients(16);   
    out_dividend <= arrOriginalDividends(16);
    out_divisor <= arrDivisors(16);
end if;
    
end process;
end Behavioral;
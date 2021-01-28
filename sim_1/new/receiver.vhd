library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use work.my_pkg.arrAB;

entity receiver is
Port ( 
clk, rst : in std_logic;
out_valid : in std_logic;
out_data : in unsigned(15 downto 0);
out_dividend : in unsigned(15 downto 0);
out_divisor : in unsigned(15 downto 0);

ready_recieve : out std_logic := '1'
);
end receiver;

architecture Behavioral of receiver is
signal count : integer range 0 to 8 := 0;

signal rcvdRes : unsigned(15 downto 0);
signal targetRes : unsigned(15 downto 0);
signal targetValid : std_logic := '0';

procedure divide(signal a : in unsigned(15 downto 0);
                 signal b : in unsigned(15 downto 0);
                 signal res : out unsigned(15 downto 0);
                 signal res_valid : out std_logic
                 ) is 
                 
   variable tmp : signed(15 downto 0);
   
   begin
   tmp := signed(a)/signed(b);
   res <= unsigned(tmp);
   res_valid <= '1';
   end divide;
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

    if out_valid = '1' and count /= 6 then
    rcvdRes <= out_data;
    divide(out_dividend, out_divisor, targetRes, targetValid);
    if targetValid = '1' then
        assert targetRes = rcvdRes report "FAILURE";
    end if;
    end if;
end if;
end process;

process(clk) is 
begin
if clk'event and clk = '1' then
    if count = 6 then
        ready_recieve <= '0';
    else 
        ready_recieve <= '1';
    end if;
end if;
end process;

end Behavioral;

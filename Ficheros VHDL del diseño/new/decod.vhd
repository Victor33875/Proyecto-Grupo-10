library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decod is
Port (     
        inputdecod: in STD_LOGIC_VECTOR(2 downto 0);
        outputdecod: out STD_LOGIC_VECTOR (6 downto 0)
           );		
end decod;

architecture Behavioral of decod is

begin

    with inputdecod select
          outputdecod <= 
                 "0000001" when "000",   --A
                 "0000010" when "001",   --B
                 "0000100" when "010",   --C
                 "0001000" when "011",   --D
                 "0000001" when "100",   --A
                 "0100000" when "101",   --F
                 "0010000" when "110",   --E
                 "0001000" when "111",   --D
                 "0000000" when others;

end Behavioral;


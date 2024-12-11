library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Mux is
    Port ( input1 : in STD_Logic;
           input2 : in STD_LOGIC;
           input3: in std_logic;
           selector : in STD_LOGIC_vector (1 downto 0);
           output : out STD_LOGIC
           );
end Mux;

architecture Behavioral of Mux is
begin
process (input1,input2,input3,selector)
    begin
        case selector is
            when "00" =>
                output <= input1;
            when "01" =>
                output <= input2;
            when "10" =>
              output <= input3;
            when others =>
                
            
        end case;
    end process;

end Behavioral;

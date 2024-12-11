----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.12.2024 10:44:18
-- Design Name: 
-- Module Name: mux2a1 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mux2a1 is
    Port ( input1, input2 : in STD_LOGIC;
           selector : in STD_LOGIC;
           output : out STD_LOGIC 
           ); 
end mux2a1;

architecture Behavioral of mux2a1 is

begin
process (input1, input2, selector)
    begin
        case selector is
            when '0' =>
                output <= input1;
            when '1' =>
                output <= input2;
            when others =>
                output <= input1;
        end case;
    end process;

end Behavioral;

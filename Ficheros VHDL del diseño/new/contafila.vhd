library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity contador_up_down is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           up_down : in STD_LOGIC; -- 1 para contar hacia arriba, 0 para abajo
           count : out STD_LOGIC_VECTOR (3 downto 0)); -- Contador de 4 bits
end contador_up_down;

architecture Behavioral of contador_up_down is
    signal temp_count : STD_LOGIC_VECTOR (3 downto 0) := "0000";
begin
    process(clk, reset)
    begin
        if reset = '1' then
            temp_count <= "0000"; -- Reiniciar el contador
        elsif rising_edge(clk) then
            if up_down = '1' then
                temp_count <= temp_count + 1; -- Contar hacia arriba
            else
                temp_count <= temp_count - 1; -- Contar hacia abajo
            end if;
        end if;
    end process;

    count <= temp_count; -- Salida del contador
end Behavioral;
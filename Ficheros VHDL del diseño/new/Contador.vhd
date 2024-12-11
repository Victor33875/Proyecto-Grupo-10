library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Contador is
 generic(
   N_BITS : integer:=8; 
   MAX_VALOR : integer:=10;
   cuenta_inicial : integer := 0
   
      );
 port (
   clk : in std_logic;
   rst : in std_logic;
   enable: in std_logic ;
   up_down : in std_logic;
   cuenta : out std_logic_vector(N_BITS-1 downto 0); --8 bits
   f_cuenta : out std_logic
   
 );
end Contador;

architecture Behavioral of Contador is
 signal counter_reg : unsigned(N_BITS-1 downto 0);--

begin
 process(clk, rst,enable)
 begin
   if rst = '1' then
     counter_reg <= to_unsigned(cuenta_inicial, N_BITS); -- (others => '0'); --reinicia el contador
   elsif rising_edge(clk) and enable='1' then

     if to_integer(counter_reg) = (MAX_VALOR - 1) then --si la cuenta llega a Max valor entonces...
       counter_reg <= (others => '0'); -- Reinicia al alcanzar el valor máximo
     else
         if up_down = '1' then
            counter_reg <= counter_reg + 1;
        else
            counter_reg <= counter_reg - 1; -- Decrementar
        end if;
     end if;
   end if;
 end process;

 cuenta <= std_logic_vector(counter_reg); -- Asignar el valor del contador a la salida
 f_cuenta <= '1' when to_integer(unsigned(counter_reg)) = (MAX_VALOR - 1) else '0'; -- Señal de finalización (f cuenta es 1 cuando counter_reg llega a 9)
end Behavioral;
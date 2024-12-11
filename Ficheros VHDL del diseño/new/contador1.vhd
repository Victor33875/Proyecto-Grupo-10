library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Contadorgen is
 generic(
   N_BITS : integer:=8; 
   MAX_VALOR : integer:=10
   
      );
 port (
   clk : in std_logic;
   rst : in std_logic;
   enable: in std_logic := '1';
   cuenta : out std_logic_vector(N_BITS-1 downto 0); --8 bits
   f_cuenta : out std_logic
 );
end Contadorgen;

architecture Behavioral of Contadorgen is
 signal counter_reg : std_logic_vector(N_BITS-1 downto 0);--
begin
 process(clk, rst)
 begin
   if rst = '1' then
     counter_reg <= (others => '0'); --reinicia el contador
   elsif rising_edge(clk)then
    if enable='1' then
     if to_integer(unsigned(counter_reg)) = (MAX_VALOR - 1) then --si la cuenta llega a Max valor entonces...
       counter_reg <= (others => '0'); -- Reinicia al alcanzar el valor máximo
     else
       counter_reg <= std_logic_vector(unsigned(counter_reg) + 1); -- Incrementa el contador
     end if;
     end if;
   end if;
 end process;

 cuenta <= counter_reg; -- Asignar el valor del contador a la salida
 f_cuenta <= '1' when to_integer(unsigned(counter_reg)) = (MAX_VALOR - 1) else '0'; -- Señal de finalización (f cuenta es 1 cuando counter_reg llega a 9)
end Behavioral;


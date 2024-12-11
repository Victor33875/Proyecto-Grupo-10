library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity movimientopacman is
    Port (
        clk           : in  STD_LOGIC;               -- Reloj
        reset         : in  STD_LOGIC;               -- Reset 
        s100ms         : in STD_LOGIC;
        up            : in  STD_LOGIC;               -- Pulsador para mover hacia arriba
        down          : in  STD_LOGIC;               -- Pulsador para mover hacia abajo
        left          : in  STD_LOGIC;               -- Pulsador para mover hacia la izquierda
        right         : in  STD_LOGIC;               -- Pulsador para mover hacia la derecha
        conteofil    : out std_logic;                 -- Contador para la fila (Y)
        conteocol     : out std_logic;                 -- Contador para la columna (X)
        updownfil   : out std_logic;                 -- Salida del contador de fila
        updowncol     : out std_logic;                 -- Salida del contador de columna
        col           : in  STD_LOGIC_VECTOR(5 downto 0); -- Entrada de 6 bits para columna
        fila           : in  STD_LOGIC_VECTOR(5 downto 0)  -- Entrada de 6 bits para fila
    );
end movimientopacman;
 
architecture Behavioral of movimientopacman is

signal up_s, down_s, left_s, right_s : std_logic;
begin

 
    process(reset, clk) -- Lista de sensibilidades
    begin
        if reset = '1' then
            up_s <= '0';
            down_s <= '0';
            left_s <= '0';
            right_s <= '0';
        elsif clk'event and clk='1' then
            if s100ms = '1' then
                up_s <= up;
                down_s <= down;
                left_s <= left;
                right_s <= right;

            end if;
        end if;
    end process;
    
    process(fila, col, up_s, down_s, left_s, right_s)   -- Lista de sensibilidades
    begin
 
        conteofil<='0';     --contadores desactivados
        conteocol<='0';
        updownfil<='0';
        updowncol<='0';
       
        if up_s = '1' and unsigned(fila) > to_unsigned(0,6) then
           conteofil <= '1';    --activacion del contador
           updownfil <= '0';    --cuenta descendente
           
        elsif down_s = '1' and unsigned(fila) < to_unsigned(29,6) then
           conteofil <= '1';    --activacion del contador
           updownfil <= '1';    --cuenta ascendente    
 
        elsif left_s = '1' and unsigned(col) > to_unsigned(0,6) then
           conteocol<= '1';     --activacion del contador
           updowncol<= '0';     --cuenta descendente
           
        elsif right_s = '1' and unsigned(col) < to_unsigned(31,6) then
           conteocol<= '1';     --activacion del contador
           updowncol<= '1';     --cuenta ascendente
        end if;
    end process;
 
end Behavioral;





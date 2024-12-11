library IEEE;
 
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;  -- Usar numeric_std para conversiones
entity movimientofantasma is
 
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           fila: in UNSIGNED(5 downto 0);  -- Cambiado a UNSIGNED
           col: in UNSIGNED(5 downto 0);   -- Cambiado a UNSIGNED
           conteofil: out STD_LOGIC;       -- Habilitacion contador filas
           conteocol : out STD_LOGIC;       -- Habilitacion contador columnas
           updownfil: out STD_LOGIC;            --Sentido de la cuenta de filas
           updowncol: out STD_LOGIC         -- Sentido de la cuenta de columnas
           );
 
end movimientofantasma;
architecture Behavioral of movimientofantasma is
    type state_type is (derecha_abajo, izquierda_abajo, derecha_arriba, izquierda_arriba);
    signal e_act, e_sig : state_type;
begin
    -- Proceso para la máquina de estados
 
    process(clk, reset)-- Lista de sensibilidades
 
    begin
        if reset = '1' then
            e_act <= derecha_abajo; 
 
        elsif rising_edge(clk) then
            e_act <= e_sig;  
 
        end if;
 
    end process;
    -- Proceso para el movimiento del fantasma
 
    process(e_act,col,fila)-- Lista de sensibilidades
    begin

     e_sig <= e_act;

          case e_act is
            when derecha_abajo =>                       -- el fantasma se desplaza diagonalmente hacia derecha y abajo
                 if to_integer((col)) = 31 then
                        e_sig <= izquierda_abajo;       -- cambio de estado cuando llegue a la columna 31
                    elsif to_integer((fila)) = 29 then
                        e_sig <= derecha_arriba;        -- cambio de estado cuando llegue a la fila 29
                    end if;

            when izquierda_abajo =>                     -- el fantasma se desplaza diagonalmente hacia izquierda y abajo
                if to_integer((col)) = 0 then
                        e_sig <= derecha_abajo;         -- cambio de estado cuando llegue a la columna 0
                    elsif to_integer((fila)) = 29 then
                        e_sig <= izquierda_arriba;      -- cambio de estado cuando llegue a la fila 29
                   end if;

            when derecha_arriba =>                      -- el fantasma se desplaza diagonalmente hacia derecha y arriba
                if to_integer((col)) = 31 then
                        e_sig <= izquierda_arriba;      -- cambio de estado cuando llegue a la columna 31
                    elsif to_integer((fila)) = 0 then
                        e_sig <= derecha_abajo;         -- cambio de estado cuando llegue a la fila 0
                   end if;

            when izquierda_arriba =>                    -- el fantasma se desplaza diagonalmente hacia izquierda y arriba
                if to_integer((col)) = 0 then
                        e_sig <= derecha_arriba;        -- cambio de estado cuando llegue a la columna 0
                    elsif to_integer((fila)) = 0 then
                        e_sig <= izquierda_abajo;       -- cambio de estado cuando llegue a la fila 0
                   end if;
          end case;        
    end process;
    
    -- Proceso para los contadores
    process(e_act) -- Lista de sensibilidades
    begin
                conteocol <= '0';  
                conteofil <= '0';
                 case e_act is 
                   when derecha_abajo =>
                        conteofil <= '1';       --habilitacion de contador filas
                        conteocol <= '1';       --habilitacion de contador columnas
                        updowncol <= '1';       --cuenta ascendente de columnas
                        updownfil <= '1';       --cuenta ascendente de filas
                   when izquierda_abajo =>
                        conteofil <= '1';       --habilitacion de contador filas   
                        conteocol <= '1';       --habilitacion de contador columnas
                        updowncol <= '0';       --cuenta descendente de columnas    
                        updownfil <= '1';       --cuenta ascendente de filas       
                when derecha_arriba =>
                        conteofil <= '1';       --habilitacion de contador filas   
                        conteocol <= '1';       --habilitacion de contador columnas
                        updowncol <= '1';       --cuenta ascendente de columnas    
                        updownfil <= '0';       --cuenta descendente de filas       
                when izquierda_arriba =>
                        conteofil <= '1';       --habilitacion de contador filas         
                        conteocol <= '1';       --habilitacion de contador columnas 
                        updowncol <= '0';       --cuenta descendente de columnas     
                        updownfil <= '0';       --cuenta descendente de filas        
                   end case;       

 
                end process;
 
end Behavioral;



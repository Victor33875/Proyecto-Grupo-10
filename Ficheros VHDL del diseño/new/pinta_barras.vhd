library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
 

entity pinta_barras is
  Port (
    -- In ports
    visible      : in std_logic;
    col          : in unsigned(10-1 downto 0);
    fila         : in unsigned(10-1 downto 0);
    poscol_pacman: in std_logic_vector (5 downto 0);
    posfila_pacman: in  std_logic_vector (5 downto 0);
    poscol_fantasma: in  std_logic_vector (5 downto 0);
    posfila_fantasma: in  std_logic_vector (5 downto 0);
    dato_mem_pacman: in std_logic_vector (15 downto 0);
    dato_mem_fantasma: in std_logic_vector (15 downto 0);
    dato_mem_circuito: in std_logic_vector (31 downto 0);
    -- Out ports
    rojo         : out std_logic_vector(8-1 downto 0);
    verde        : out std_logic_vector(8-1 downto 0);
    azul         : out std_logic_vector(8-1 downto 0);
    adrr_mem_fantasma: out std_logic_vector (7 downto 0);
    adrr_mem_circuito: out std_logic_vector (4 downto 0);
    adrr_mem_pacman: out std_logic_vector (7 downto 0)
  );
end pinta_barras;
architecture Behavioral of pinta_barras is
  constant c_bar_width : natural := 64;
  signal dato_mem_pxl : std_logic;
  signal dato_mem_px2 : std_logic;
begin
  P_pinta: Process (visible, col, fila)
  begin
    rojo   <= (others=>'0');
    verde  <= (others=>'0');
    azul   <= (others=>'0');
    -- si visible está activado
    if visible = '1' then
        adrr_mem_circuito <= std_logic_vector(fila(8 downto 4)); -- Dirección de memoria basada en la fila
     if unsigned(col (9 downto 4)) > 31 then -- Si cuadrícula columna > 31, pinto de negro
        rojo   <= (others=>'0');
        verde  <= (others=>'0');
        azul   <= (others=>'0');
-------- Pinto linea blanca en los bordes
      -- Los primeros 4 bits nos dicen informacion del interior de la cuadrícula, al ser cada cuadrícula 16x16 bits
      elsif col (3 downto 0) = "0000" OR fila(3 downto 0) = "0000"  then
        rojo   <= (others=>'1');
        verde  <= (others=>'1');
        azul   <= (others=>'1');
----------Pinto circuito-------------
        elsif dato_mem_circuito(to_integer(col(9 downto 4))) = '1' then -- Si el bit correspondiente es '1'
        rojo   <= (others=>'1'); -- Color blanco (todos los canales activados)
        verde  <= (others=>'1');
        azul   <= (others=>'1');
        else -- Si el bit correspondiente es '0'
        rojo   <= (others=>'0'); -- Color negro (todos los canales apagados)
        verde  <= (others=>'0');
        azul   <= (others=>'0');
       -- end if;
end if;
 
        
-------- Pinto fantasma -----------     
      if (col(9 downto 4) = unsigned(poscol_fantasma)) and (fila(9 downto 4) = unsigned(posfila_fantasma)) then
          adrr_mem_fantasma<= "0100" & std_logic_vector(fila(3 downto 0));
          dato_mem_pxl <= dato_mem_fantasma(to_integer(col (3 downto 0)));
        if dato_mem_pxl = '0' then 
            rojo   <= (others=>'0');
            verde  <= (others=>'1');
            azul   <= (others=>'0');
        else 
            rojo   <= (others=>'0');
            verde  <= (others=>'0');
            azul   <= (others=>'0');
        end if;
       end if;
 
-------- Pinto pacman -----------     
      if (col(9 downto 4) = unsigned(poscol_pacman)) and (fila(9 downto 4) = unsigned(posfila_pacman)) then
          adrr_mem_pacman<="0011" & std_logic_vector(fila(3 downto 0));
          dato_mem_pxl <= dato_mem_pacman(to_integer(col (3 downto 0)));
        if dato_mem_pxl='0' then 
            rojo   <= (others=>'1');
            verde  <= (others=>'1');
            azul   <= (others=>'0');
        else 
            rojo   <= (others=>'0');
            verde  <= (others=>'0');
            azul   <= (others=>'0');
        end if;
      end if; 

    end if;
  end process;
 
end Behavioral;
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.12.2024 11:18:11
-- Design Name: 
-- Module Name: sim_movPacman - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sim_movPacman is
--  Port ( );
end sim_movPacman;

architecture Behavioral of sim_movPacman is

    component movimientopacman is
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
end component;

component Contador
  -- Genéricos
   generic(
   N_BITS : integer:= 8;
   MAX_VALOR : integer:= 10;
   cuenta_inicial : integer := 0
   );
   Port (clk : in std_logic;
        rst : in std_logic;
        enable: in std_logic;
        up_down : in std_logic;
        cuenta : out std_logic_vector(N_BITS-1 downto 0); 
        f_cuenta : out std_logic
    );
 end component;

signal clk, rst, s100ms, up, down, left, right : std_logic;
signal conteofil, conteocol, ud_fil, ud_col: std_logic;
signal col, fila : std_logic_vector(5 downto 0);
signal enableupdowncol_pacman : std_logic;
signal enableupdownfila_pacman : std_logic;
signal fcuenta_fila_pacman : std_logic;


begin
    -- Instancio Up down col pacman
     contaupdowncol_pacman:Contador
     generic map (
     N_BITS => 6, -- Para un reloj de 125 MHz: 
     MAX_VALOR => 34, -- Cuenta hasta 62.5 millones
     cuenta_inicial=>7
        )
     port map(
     clk => clk, -- Conexión al reloj principal
     rst=>rst,
     enable => enableupdowncol_pacman, -- Conexión al reset
     up_down=> ud_col,
     cuenta=>col
     );
     
      -- Instancio UP Down fila del pacman
     contaupdownfila_pacman:Contador
     generic map (
     N_BITS => 6, -- Para un reloj de 125 MHz: 
     MAX_VALOR => 32, -- Cuenta hasta 62.5 millones
     cuenta_inicial=>4
        )
     port map(
     clk => clk, -- Conexión al reloj principal
     rst=>rst,
     enable =>enableupdownfila_pacman , -- Conexión al reset
     up_down=> ud_fil,
     cuenta=> fila
     );
     
     
     -- Instancio contador 100 mili pacman
     conta100milipacman:Contador
     generic map (
     N_BITS => 24, -- Para un reloj de 125 MHz: 
     MAX_VALOR => 100, -- Cuenta hasta 62.5 millones
     cuenta_inicial=>0
        )
     port map (
     clk => clk, -- Conexión al reloj principal
     rst => rst, -- Conexión al reset
     up_down=>'1',
     enable => '1' , -- Habilitación del contador a la salida del botón
     f_cuenta => fcuenta_fila_pacman  -- Señal de "done" cuando se cuenta un segundo
     );
     enableupdowncol_pacman<= conteocol and fcuenta_fila_pacman;
     enableupdownfila_pacman<=conteofil and fcuenta_fila_pacman;
     
     
     -- Instancio maquina de estados moviemiento pacman
     movimientopacman1: movimientopacman
     port map (
     s100ms => fcuenta_fila_pacman,
     up => up,
     down => down,
     right => right,
     left =>left,
     clk => clk, -- Conexión al reloj principal
     reset => rst, -- Conexión al reset
     fila=>(fila) , 
     col=> (col) , 
     conteofil=> conteofil ,
     conteocol => conteocol ,
     updownfil=>ud_col,
     updowncol=>ud_fil
     );
     
     process
     begin
     clk <= '0';
     wait for 4 ns;
     clk <= '1';
     wait for 4 ns;
     end process;
     
     rst <= '1', '0' after 60 ns;
     
     s100ms <= fcuenta_fila_pacman;
     
     up <= '0', '1' after 200 ns, '0' after 508ns, '1' after 2000 ns, '0' after 3508ns;
     down <= '0', '1' after 700 ns, '0' after 908ns;
     right <= '0', '1' after 1200 ns, '0' after 1508ns;
     left <= '0', '1' after 1800 ns, '0' after 1908ns;

end Behavioral;

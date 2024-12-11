----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.12.2024 11:48:40
-- Design Name: 
-- Module Name: sim_movFantasma - Behavioral
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

entity sim_movFantasma is
--  Port ( );
end sim_movFantasma;



architecture Behavioral of sim_movFantasma is

component movimientofantasma
    Port ( clk : in std_logic; -- Reloj principal
           reset : in std_logic ;-- Señal de reset );
           fila: in UNSIGNED(5 downto 0);  -- Cambiado a UNSIGNED
           col: in UNSIGNED(5 downto 0);   -- Cambiado a UNSIGNED
           conteofil: out STD_LOGIC;
           conteocol : out STD_LOGIC;
           updownfil: out STD_LOGIC;
           updowncol: out STD_LOGIC
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
signal enablecol_fantasma : std_logic;
signal enableupfila_fantasma : std_logic;
signal fcuenta_col_fantasma : std_logic;
begin
 -- Instancio UP Down fila del pacman
  
     
     movimientofantasma1: movimientofantasma
     port map (
     clk => clk, -- Conexión al reloj principal
     reset => rst, -- Conexión al reset
     fila=>unsigned(fila) , 
     col=> unsigned(col) , 
     conteofil=> conteofil ,
     conteocol => conteocol ,
     updownfil=>ud_fil,
     updowncol=>ud_col
     );
     
     -- Instancio UP Down fila del fantasma
     contaupdownfila_fantasma_2:Contador
     generic map (
     N_BITS => 6, -- Para un reloj de 125 MHz: 
     MAX_VALOR => 32, -- Cuenta hasta 62.5 millones
     cuenta_inicial=>6
        )
     port map(
     clk => clk, -- Conexión al reloj principal
     rst=>rst,
     enable =>enableupfila_fantasma , -- Conexión al reset
     up_down=> ud_fil,
     cuenta=> fila
     );
     
     -- Instancio Up down col fantasma
     contaupdowncol_fantasma:Contador
     generic map (
     N_BITS => 6, -- Para un reloj de 125 MHz: 
     MAX_VALOR => 34, -- Cuenta hasta 62.5 millones
     cuenta_inicial=>8
        )
     port map(
     clk => clk, -- Conexión al reloj principal
     rst=>rst,
     enable => enablecol_fantasma, -- Conexión al reset
     up_down=> ud_col,
     cuenta=>col
     );
     
     
     -- Instancio contador 100 mili
     conta100milifantasma: Contador
     generic map (
     N_BITS => 24, -- Para un reloj de 125 MHz: 
     MAX_VALOR => 100, -- Cuenta hasta 62.5 millones
     cuenta_inicial =>0
     )
     port map (
     clk => clk, -- Conexión al reloj principal
     rst => rst, -- Conexión al reset
     up_down=>'1',
     enable => '1', -- Habilitación del contador a la salida del botón
     f_cuenta => fcuenta_col_fantasma -- Señal de "done" cuando se cuenta un segundo
     );
     enablecol_fantasma<= conteocol and fcuenta_col_fantasma;
     enableupfila_fantasma<=conteofil and fcuenta_col_fantasma;
     
        process
     begin
     clk <= '0';
     wait for 4 ns;
     clk <= '1';
     wait for 4 ns;
     end process;
     
     rst <= '1', '0' after 60 ns;
     
     --s100ms <= fcuenta_fila_pacman;

end Behavioral;

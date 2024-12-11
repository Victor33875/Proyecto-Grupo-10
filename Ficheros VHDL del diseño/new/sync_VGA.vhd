----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.11.2024 12:10:01
-- Design Name: 
-- Module Name: sync_VGA - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

entity SYNC_VGA is
    Port (
        clk        : in  STD_LOGIC;
        rst        : in  STD_LOGIC;
        hsync      : out STD_LOGIC;
        vsync      : out STD_LOGIC;
        visible    : out STD_LOGIC;
        col : out unsigned ( 9 downto 0);
        fila: out unsigned (9 downto 0)
    );
end SYNC_VGA;

architecture Behavioral of SYNC_VGA is

    -- Señales internas
    signal h_count : std_logic_vector(9 downto 0);  -- Contador de columnas
    signal v_count : std_logic_vector(9 downto 0);  -- Contador de filas
    signal new_line : std_logic;
    signal new_frame: std_logic;
    signal pxl_visible : std_logic;
    signal line_visible: std_logic;

begin

    -- Instancia del contador para columnas (conta_cols)
    Contador_Cols: entity work.Contador
        generic map (
            N_BITS    => 10,
            MAX_VALOR => 800,
            cuenta_inicial=>0
            
        )
        port map (
            clk      => clk,
            rst      => rst,
            enable   => '1',
            up_down => '1',
            cuenta   => h_count,
            f_cuenta => new_line
        );

    -- Instancia del contador para filas (conta_filas)
    Contador_Filas: entity work.Contador
        generic map (
            N_BITS    => 10,
            MAX_VALOR => 525,
            cuenta_inicial => 0
        )
        port map (
            clk      => clk,
            rst      => rst,
            enable   => new_line,
            up_down  => '1',
            cuenta   => v_count,
            f_cuenta => new_frame
        );

    -- Generación de HSYNC
    hsync <= '0' when (to_integer(unsigned(h_count)) >= 656 and to_integer(unsigned(h_count)) < 752) else '1';

    -- Generación de VSYNC
    vsync <= '0' when (to_integer(unsigned(v_count)) >= 490 and to_integer(unsigned(v_count)) < 492) else '1';

    -- Señal de píxeles visibles (pxl_visible)
    pxl_visible <= '1' when (to_integer(unsigned(h_count)) < 640) else '0';

    -- Señal de líneas visibles (line_visible)
    line_visible <= '1' when (to_integer(unsigned(v_count)) < 480) else '0';

    -- Señal de zona visible
    visible <= pxl_visible and line_visible;

    -- Asignación de salidas
    col <= unsigned( h_count);
    fila <= unsigned(v_count);

end Behavioral;










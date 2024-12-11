library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TB_SYNC_VGA is
end TB_SYNC_VGA;

architecture Behavioral of TB_SYNC_VGA is

    -- Señales internas del testbench
    signal clk        : std_logic := '0';
    signal rst        : std_logic := '0';
    signal hsync      : std_logic;
    signal vsync      : std_logic;
    signal visible    : std_logic;
    signal col        : unsigned(9 downto 0);
    signal fila       : unsigned(9 downto 0);

    -- Parámetro del reloj
    constant CLK_PERIOD : time := 40 ns;  -- Frecuencia de 25 MHz

begin

    -- Instancia del módulo SYNC_VGA
    uut: entity work.SYNC_VGA
        port map (
            clk     => clk,
            rst     => rst,
            hsync   => hsync,
            vsync   => vsync,
            visible => visible,
            col     => col,
            fila    => fila
        );

    -- Generación de la señal de reloj
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for CLK_PERIOD / 2;
            clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process;

    -- Generación de la señal de reset
    rst_process : process
    begin
        rst <= '1';
        wait for 100 ns;
        rst <= '0';
        wait;
    end process;

    -- Proceso de monitoreo
    monitor_process : process
    begin
        wait for CLK_PERIOD;
        report "Columna: " & integer'image(to_integer(col)) &
               " | Fila: " & integer'image(to_integer(fila)) &
               " | HSYNC: " & std_logic'image(hsync) &
               " | VSYNC: " & std_logic'image(vsync) &
               " | Visible: " & std_logic'image(visible);
    end process;

end Behavioral;


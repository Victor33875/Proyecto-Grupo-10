library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library xil_defaultlib;
use xil_defaultlib.racetrack_pkg.ALL;

entity top is
    Port (
        clk     : in  STD_LOGIC;
        rst     : in  STD_LOGIC;
        up      : in  STD_LOGIC;
        down    : in  STD_LOGIC;
        left    : in  STD_LOGIC;
        right   : in  STD_LOGIC;
        clk_p   : out STD_LOGIC;
        clk_n   : out STD_LOGIC;
        data_p  : out STD_LOGIC_VECTOR(2 downto 0);
        data_n  : out STD_LOGIC_VECTOR(2 downto 0)
    );
end top;
 
architecture Behavioral of top is
 
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
    
     component movimientopacman
    Port ( clk : in std_logic; -- Reloj principal
           reset : in std_logic ;-- Señal de reset );
           s100ms : in STD_LOGIC;
           up : in std_logic;
           down : in std_logic;
           left : in std_logic;
           right : in std_logic;
           fila: in UNSIGNED(5 downto 0);  -- Cambiado a UNSIGNED
           col: in UNSIGNED(5 downto 0);   -- Cambiado a UNSIGNED
           conteofil: out STD_LOGIC;
           conteocol : out STD_LOGIC;
           updownfil: out STD_LOGIC;
           updowncol: out STD_LOGIC
     );
    end component;
    
      component ROM1b_1f_imagenes16_16x16_bn
    Port ( clk : in std_logic; -- Reloj principal
           addr : in  std_logic_vector(8-1 downto 0);
           dout : out std_logic_vector(16-1 downto 0) 
     );
     end component;
        component ROM1b_1f_racetrack_1
    Port ( clk : in std_logic; -- Reloj principal
           addr : in  std_logic_vector(5-1 downto 0);
           dout : out std_logic_vector(32-1 downto 0) 
     );
        
    end component;
    
        component mux2a1
    Port ( input1, input2 : in STD_LOGIC;
           selector : in STD_LOGIC;
           output : out STD_LOGIC 
     );
        
    end component;
    -- Señales internas
    signal clk0        : std_logic;  -- Reloj 125 MHz
    signal clk1        : std_logic;  -- Reloj 25 MHz
    signal hsync       : std_logic;
    signal vsync       : std_logic;
    signal visible     : std_logic;
    signal col :  unsigned ( 10-1 downto 0);
    signal fila:  unsigned (10-1 downto 0);
    signal rojo :  std_logic_vector(8-1 downto 0);
    signal verde :  std_logic_vector(8-1 downto 0);
    signal azul : std_logic_vector(8-1 downto 0);
    signal VDataRGB : std_logic_vector(23 downto 0);
    signal video_active: std_logic;
    signal fcuenta_col_pacman : std_logic;
    signal fcuenta_fila_pacman : std_logic;
    signal fcuenta_col_fantasma : std_logic;
    signal fcuenta_fila_fantasma : std_logic;
    signal dato1_s: std_logic_vector(15 downto 0);
    signal dato2_s: std_logic_vector(15 downto 0);
    signal dato3_s: std_logic_vector(31 downto 0);
    signal adrr1_s: std_logic_vector(7 downto 0);
    signal adrr2_s: std_logic_vector(7 downto 0);
    signal adrr3_s: std_logic_vector(4 downto 0);
    signal updowncol_fantasma: std_logic;
    signal updownfila_fantasma: std_logic;
    signal updowncol_pacman: std_logic;
    signal updownfila_pacman: std_logic;
    signal enablecol_fantasma: std_logic;
    signal enablefil_fantasma: std_logic;
    signal enablecol_pacman: std_logic;
    signal enablefil_pacman: std_logic;
    signal enableupdowncol_fantasma: std_logic;
    signal enableupdownfila_fantasma: std_logic;
    signal enableupdowncol_pacman: std_logic;
    signal enableupdownfila_pacman: std_logic;
    signal col_fantasma_s: std_logic_vector(5 downto 0);
    signal fila_fantasma_s: std_logic_vector(5 downto 0);
    signal col_pacman_s: std_logic_vector(5 downto 0);
    signal fila_pacman_s: std_logic_vector(5 downto 0);
    signal s500ms: std_logic;
    signal jug_en_pista: std_logic;
    signal mux_s: std_logic;

begin
 
    -- Instancia del generador de reloj (PLL)
    u_clock_gen: entity work.clock_gen
        port map (
            clk  => clk,
            rst  => rst,
            clk0 => clk0,  -- 125 MHz
            clk1 => clk1   -- 25 MHz
        );
 
    -- Instancia del módulo SYNC_VGA
    u_sync_VGA: entity work.SYNC_VGA
        port map (
            clk        => clk1,  -- 25 MHz
            rst        => rst,
            hsync      => hsync,
            vsync      => vsync,
            visible    => visible,
            col => col,
            fila => fila
        );
 
    -- Instancia del módulo PINTA (pinta_barras)
    u_pinta_barras: entity work.pinta_barras
        port map (
            poscol_pacman=> col_pacman_s,
            posfila_pacman=>fila_pacman_s,
            poscol_fantasma=>col_fantasma_s,
            posfila_fantasma=>fila_fantasma_s,
            dato_mem_fantasma=>dato1_s,
            dato_mem_pacman=>dato2_s,
            dato_mem_circuito=>dato3_s,
            adrr_mem_fantasma=>adrr1_s,
            adrr_mem_pacman=>adrr2_s, 
            adrr_mem_circuito=>adrr3_s, 
            col => col,
            fila => fila,
            visible => visible,
            rojo=>rojo,
            verde=>verde,
            azul=>azul
        );
    VDataRGB<= rojo & verde & azul;       
 
    -- Señal de actividad de video (video_active)
    video_active <= visible;
 
    -- Instancia del módulo HDMI RGB2TMDS
    u_hdmi_rgb2tmds: entity work.hdmi_rgb2tmds
        port map (
            pixelclock   => clk1,    -- 25 MHz
            serialclock  => clk0,    -- 125 MHz
            rst          => rst,
            video_data   => VDataRGB,
            video_active => video_active,
            hsync        => hsync,
            vsync        => vsync,
            clk_p        => clk_p,
            clk_n        => clk_n,
            data_p       => data_p,
            data_n       => data_n
        ); 
        
     -- Instancia contador 100 mili
     conta100milifantasma: Contador
     generic map (
     N_BITS => 24, -- Para un reloj de 125 MHz: 
     MAX_VALOR => 12500000, -- Cuenta hasta 62.5 millones
     cuenta_inicial =>0
     )
     port map (
     clk => clk, -- Conexión al reloj principal
     rst => rst, -- Conexión al reset
     up_down=>'1',
     enable => '1', -- Habilitación del contador a la salida del botón
     f_cuenta => fcuenta_col_fantasma -- Señal de "done" cuando se cuenta un segundo
     );
     enableupdowncol_fantasma<= enablecol_fantasma and fcuenta_col_fantasma;
     enableupdownfila_fantasma<=enablefil_fantasma and fcuenta_col_fantasma;
 
     
    -- Instancio contador 100 mili pacman
     conta100milipacman:Contador
     generic map (
     N_BITS => 24, -- Para un reloj de 125 MHz: 
     MAX_VALOR => 12500000, -- Cuenta hasta 62.5 millones
     cuenta_inicial=>0
        )
     port map (
     clk => clk, -- Conexión al reloj principal
     rst => rst, -- Conexión al reset
     up_down=>'1',
     enable => '1' , -- Habilitación del contador a la salida del botón
     f_cuenta => fcuenta_fila_pacman  -- Señal de "done" cuando se cuenta un segundo
     );
     enableupdowncol_pacman<= enablecol_pacman and mux_s;
     enableupdownfila_pacman<=enablefil_pacman and mux_s;
     
     -- Instancio contador 500 mili pacman
     conta500mili:Contador
     generic map (
     N_BITS => 26, -- Para un reloj de 125 MHz: 
     MAX_VALOR => 62500000, -- Cuenta hasta 62.5 millones
     cuenta_inicial=>0
        )
     port map (
     clk => clk, -- Conexión al reloj principal
     rst => rst, -- Conexión al reset
     up_down=>'1',
     enable => '1' , -- Habilitación del contador a la salida del botón
     f_cuenta => s500ms  -- Señal de "done" cuando se cuenta un segundo
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
     enable => enableupdowncol_fantasma, -- Conexión al reset
     up_down=> updowncol_fantasma,
     cuenta=>col_fantasma_s
     );
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
     up_down=> updowncol_pacman,
     cuenta=>col_pacman_s
     );
     -- Instancio UP Down fila del fantasma
     contaupdownfila_fantasma:Contador
     generic map (
     N_BITS => 6, -- Para un reloj de 125 MHz: 
     MAX_VALOR => 32, -- Cuenta hasta 62.5 millones
     cuenta_inicial=>0
        )
     port map(
     clk => clk, -- Conexión al reloj principal
     rst=>rst,
     enable =>enableupdownfila_fantasma , -- Conexión al reset
     up_down=> updownfila_fantasma,
     cuenta=> fila_fantasma_s
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
     up_down=> updownfila_pacman,
     cuenta=> fila_pacman_s
     );
     -- Instancio Maquina de estado movimiento fantasma
     movimientofantasma1: movimientofantasma
     port map (
     clk => clk, -- Conexión al reloj principal
     reset => rst, -- Conexión al reset
     fila=>unsigned(fila_fantasma_s) , 
     col=> unsigned(col_fantasma_s) , 
     conteofil=> enablefil_fantasma ,
     conteocol => enablecol_fantasma ,
     updownfil=>updownfila_fantasma,
     updowncol=>updowncol_fantasma
     );
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
     fila=>unsigned(fila_pacman_s) , 
     col=> unsigned(col_pacman_s) , 
     conteofil=> enablefil_pacman ,
     conteocol => enablecol_pacman ,
     updownfil=>updownfila_pacman,
     updowncol=>updowncol_pacman
     );
     Mem1: ROM1b_1f_imagenes16_16x16_bn
     port map (
     clk => clk, -- Conexión al reloj principal
     addr=>adrr1_s,
     dout=>dato1_s
     );
     Mem2: ROM1b_1f_imagenes16_16x16_bn
     port map (
     clk => clk, -- Conexión al reloj principal
     addr=>adrr2_s,
     dout=>dato2_s
     );
    Mem3: ROM1b_1f_racetrack_1 
     port map (
     clk => clk, -- Conexión al reloj principal
     addr=>adrr3_s,
     dout=>dato3_s
     );
     
     mux: mux2a1
     port map (
     input1 => s500ms , -- Conexión al reloj principal
     input2=>fcuenta_fila_pacman,
     selector=>jug_en_pista,
     output=>mux_s
     );
     jug_en_pista <= pista (to_integer(unsigned(fila_pacman_s)))(to_integer(unsigned(col_pacman_s)));

end Behavioral;
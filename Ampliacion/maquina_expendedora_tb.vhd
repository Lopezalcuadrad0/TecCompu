library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity testbench is
end testbench;

architecture bench of testbench is 
    component VendingMachine
        Port (
            CLOCK : in std_logic;
            RESET : in std_logic;
            COIN_IN : in std_logic_vector(2 downto 0);
            COIN_OUT : out std_logic_vector(2 downto 0);
            LATA : out std_logic;
            EMPTY : out std_logic;
            RESTOCK : in std_logic
        );
    end component;

    signal CLOCK : std_logic := '0';
    signal RESET : std_logic := '0';
    signal COIN_IN : std_logic_vector(2 downto 0) := (others => '0');
    signal COIN_OUT : std_logic_vector(2 downto 0) := (others => '0');
    signal LATA : std_logic := '0';
    signal EMPTY : std_logic := '0';
    signal RESTOCK : std_logic := '0';

    constant clk_period : time := 100 ns;

begin
    uut: VendingMachine port map (
        CLOCK => CLOCK,
        RESET => RESET,
        COIN_IN => COIN_IN,
        COIN_OUT => COIN_OUT,
        LATA => LATA,
        EMPTY => EMPTY,
        RESTOCK => RESTOCK
    );

    clock_process: process
    begin
        while true loop
            CLOCK <= '0';
            wait for clk_period / 2;
            CLOCK <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    stimulus_process: process
    begin
        -- Inicialización
        RESET <= '1';
        wait for 100 ns;
        RESET <= '0';
        wait for 1000 ns;

        -- Caso 1: Comprar una lata con 2 euros
        COIN_IN <= "010"; -- Inserta 2€
        wait for 100 ns;
        COIN_IN <= "000";
        wait for 3000 ns; -- Espera a que se dispense la lata

        -- Caso 2: Insertar un billete de 5 euros
        COIN_IN <= "100"; -- Inserta 5€
        wait for 100 ns;
        COIN_IN <= "000";
        wait for 3000 ns; -- Espera a que se devuelva el cambio

        -- Caso 3: Comprar otra lata con dos monedas de 1 euro
        COIN_IN <= "001"; -- Inserta 1€
        wait for 100 ns;
        COIN_IN <= "000";
        wait for 3000 ns; -- Espera un momento
        COIN_IN <= "001"; -- Inserta otro 1€
        wait for 100 ns;
        COIN_IN <= "000";
        wait for 3000 ns; -- Espera a que se dispense la lata

        -- Comprobación final de EMPTY
        wait for 1000 ns; -- Espera a que se procese todo y verifica que EMPTY se activa

        -- Caso 4: Insertar un billete de 5 euros
        COIN_IN <= "100"; -- Inserta 5€
        wait for 100 ns;
        COIN_IN <= "000";
        wait for 3000 ns; -- Espera a que se devuelva el cambio

        -- Caso 5: Refill del inventario de latas
        RESTOCK <= '1'; -- Refill
        wait for 200 ns;
        RESTOCK <= '0';
        wait for 1000 ns;

        -- Caso 7: Comprar una lata con 2 euros
        COIN_IN <= "010"; -- Inserta 2€
        wait for 100 ns;
        COIN_IN <= "000";
        wait for 3000 ns; -- Espera a que se dispense la lata

        -- Caso 8: Insertar otro billete de 5 euros
        COIN_IN <= "100"; -- Inserta 5€
        wait for 100 ns;
        COIN_IN <= "000";
        wait for 3000 ns; -- Espera a que se devuelva el cambio
        
        COIN_IN <= "001"; -- Inserta 1€
        wait for 100 ns;
        COIN_IN <= "000";
        wait for 100 ns;
        RESET <= '1'; -- Activa RESET
        wait for 100 ns;
        RESET <= '0';
        wait for 3000 ns; -- Espera a que se devuelva todo el dinero


        wait;
    end process;

end bench;

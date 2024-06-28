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
            LATA : out std_logic
        );
    end component;

    signal CLOCK : std_logic := '0';
    signal RESET : std_logic := '0';
    signal COIN_IN : std_logic_vector(2 downto 0) := (others => '0');
    signal COIN_OUT : std_logic_vector(2 downto 0) := (others => '0');
    signal LATA : std_logic := '0';

    constant clk_period : time := 100 ns;

begin
    uut: VendingMachine port map (
        CLOCK => CLOCK,
        RESET => RESET,
        COIN_IN => COIN_IN,
        COIN_OUT => COIN_OUT,
        LATA => LATA
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
        RESET <= '1';
        wait for 100 ns;
        RESET <= '0';
        wait for 1000 ns;

        COIN_IN <= "010";
        wait for 100 ns;
        COIN_IN <= "000";
        wait for 3000 ns;
        
        COIN_IN <= "001";
        wait for 100 ns;
        COIN_IN <= "000";
        wait for 100 ns;
        COIN_IN <= "010";
        wait for 100 ns;
        COIN_IN <= "000";
        wait for 3000 ns;

        COIN_IN <= "100";
        wait for 100 ns;
        COIN_IN <= "000";
        wait for 3000 ns;

        COIN_IN <= "001";
        wait for 100 ns;
        COIN_IN <= "000";
        wait for 3000 ns;
        COIN_IN <= "001";
        wait for 100 ns;
        COIN_IN <= "000";
        wait for 3000 ns;

        wait for 1000 ns;

        COIN_IN <= "100";
        wait for 100 ns;
        COIN_IN <= "000";
        wait for 3000 ns;

        wait;
    end process;

end bench;

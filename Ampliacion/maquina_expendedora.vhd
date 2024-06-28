library ieee;
use ieee.std_logic_1164.all;

entity VendingMachine is
    Port (
        CLOCK : in std_logic;
        RESET : in std_logic;
        COIN_IN : in std_logic_vector(2 downto 0); -- 000 para ninguna moneda, 001 para 1€, 010 para 2€, 100 para 5€
        COIN_OUT : out std_logic_vector(2 downto 0); -- Similar a COIN_IN
        LATA : out std_logic;
        EMPTY : out std_logic; -- Señal que indica si la máquina está vacía
        RESTOCK : in std_logic -- Señal para reponer latas
    );
end VendingMachine;

architecture Behavioral of VendingMachine is
    type State_Type is (Inicio, Waiting, Cambio, darLata, Resetting, Vacio);
    signal currentState, nextState: State_Type := Inicio;
    signal total_money : integer := 0;  -- Almacena el total de dinero recibido
    signal coin_out_temp : std_logic_vector(2 downto 0) := "000"; -- Almacena temporalmente el valor de COIN_OUT
    signal latas_disponibles : integer := 3; -- Inventario inicial de latas

    -- Función para convertir COIN_IN a un valor entero
    function convert_to_integer(signal value : std_logic_vector) return integer is
    begin
        if value = "001" then
            return 1;
        elsif value = "010" then
            return 2;
        elsif value = "100" then
            return 5;
        else
            return 0;
        end if;
    end function;    
begin
    process(CLOCK)
    begin
        if rising_edge(CLOCK) then
            if RESET = '1' then
                nextState <= Resetting; -- Cambia al estado de reset
            else
                currentState <= nextState; -- Actualiza el estado actual
                COIN_OUT <= coin_out_temp; -- Actualiza COIN_OUT con coin_out_temp en cada ciclo de reloj

                case currentState is
                    when Inicio =>
                        LATA <= '0'; -- No dispensa lata
                        coin_out_temp <= "000"; -- Resetea el valor temporal de COIN_OUT
                        EMPTY <= '0'; -- Inicializa EMPTY a 0
                        if COIN_IN /= "000" then
                            total_money <= total_money + convert_to_integer(COIN_IN);
                            nextState <= Waiting;
                        else
                            nextState <= Inicio;
                        end if;

                    when Waiting =>
                        if total_money = 2 then
                            nextState <= darLata;
                        elsif total_money > 2 then
                            nextState <= Cambio;
                        elsif COIN_IN /= "000" then  -- Si se introduce más dinero
                            total_money <= total_money + convert_to_integer(COIN_IN);
                            if total_money > 2 then
                                nextState <= Cambio;
                            elsif total_money = 2 then
                                nextState <= darLata;
                            else
                                nextState <= Waiting;
                            end if;
                        else
                            nextState <= Waiting;
                        end if;

                    when Cambio =>
                        if total_money = 2 then
                            nextState <= darLata;
                        elsif total_money > 2 then
                            if total_money = 3 then
                                coin_out_temp <= "001"; -- Dispensa una moneda de 1€
                                total_money <= 2;
                            elsif total_money > 3 then
                                coin_out_temp <= "010"; -- Dispensa una moneda de 2€
                                total_money <= total_money - 2;
                            end if;
                            nextState <= Cambio; -- Sigue en el estado de cambio hasta que el total sea 2
                        end if;

                    when darLata =>
                        if latas_disponibles > 0 then
                            LATA <= '1'; -- Dispensa la lata
                            latas_disponibles <= latas_disponibles - 1; -- Decrementa el inventario de latas
                            if latas_disponibles - 1 = 0 then
                                EMPTY <= '1'; -- Indica que la máquina está vacía
                                nextState <= Vacio; -- Cambia al estado de Vacío
                            else
                                nextState <= Inicio; -- Regresa al estado inicial para la próxima transacción
                            end if;
                        else
                            LATA <= '0'; -- No dispensa lata si no hay inventario
                            nextState <= Vacio; -- Cambia al estado de Vacío
                        end if;
                        total_money <= 0; -- Reinicia el total de dinero

                    when Resetting =>
                        if total_money = 0 then
                            coin_out_temp <= "000"; -- Asegura que no hay salida de moneda
                            LATA <= '0'; -- Asegura que no hay salida de lata
                            nextState <= Inicio; -- Regresa al estado inicial
                        elsif total_money >= 2 then
                            coin_out_temp <= "010"; -- Devuelve una moneda de 2€
                            total_money <= total_money - 2;
                            nextState <= Resetting; -- Permanece en el estado de reset hasta que todo el dinero sea devuelto
                        elsif total_money = 1 then
                            coin_out_temp <= "001"; -- Devuelve una moneda de 1€
                            total_money <= 0;
                            nextState <= Resetting; -- Permanece en el estado de reset hasta que todo el dinero sea devuelto
                        end if;

                    when Vacio =>
                        if RESTOCK = '1' then    
                            latas_disponibles <= 3; -- Restablece el inventario de latas a 3
                            EMPTY <= '0'; -- Indica que la máquina ya no está vacía
                            coin_out_temp <= "000"; -- Resetea el valor temporal de COIN_OUT después del restock
                            nextState <= Inicio; -- Cambia al estado inicial
                        elsif COIN_IN /= "000" then
                            coin_out_temp <= COIN_IN; -- Devuelve cualquier moneda que se inserte
                            nextState <= Vacio; -- Permanece en el estado de Vacío
                        else
                            coin_out_temp <= "000"; -- Resetea el valor temporal de COIN_OUT si no se inserta ninguna moneda
                            nextState <= Vacio; -- Permanece en el estado de Vacío
                        end if;

                end case;
            end if;
        end if;
    end process;
end Behavioral;

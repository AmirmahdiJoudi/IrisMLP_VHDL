LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY layerTest IS
END layerTest;

ARCHITECTURE behavioral OF layerTest IS
    SIGNAL clk : std_logic := '0';
    SIGNAL rst : std_logic := '0';
    SIGNAL start : std_logic := '0';
    SIGNAL inBus : std_logic_vector (31 DOWNTO 0);
    SIGNAL done : std_logic := '0';
    SIGNAL outBus : std_logic_vector (159 DOWNTO 0);
BEGIN

    clk <= NOT clk AFTER 10 ns;
    rst <= '1', '0' AFTER 30 ns;

    DUT : ENTITY WORK.layer (behavioral)
        GENERIC MAP (
            size        => 8,
            layerSize   => 10,
            inputSize   => 4,
            layerName   => "L1"
        )
        PORT MAP (
            clk    => clk,
            rst    => rst,
            sel    => '1',
            start  => start,
            inBus  => inBus,
            done   => done,
            outBus => outBus
        );

    SIMULATION : PROCESS
    BEGIN
        WAIT UNTIL (rst = '0');

        start  <= '1';
        WAIT FOR 20 ns;
        start  <= '0';
        inBus <= X"01010101";
        WAIT UNTIL (done = '1');
        WAIT UNTIL (done = '0');

        start  <= '1';
        WAIT FOR 20 ns;
        start  <= '0';
        inBus <= X"02020202";
        WAIT UNTIL (done = '1');
        WAIT UNTIL (done = '0');

        start  <= '1';
        WAIT FOR 20 ns;
        start  <= '0';
        inBus <= X"04030201";
        WAIT UNTIL (done = '1');
        WAIT UNTIL (done = '0');

        WAIT;
    END PROCESS;

END ARCHITECTURE behavioral;
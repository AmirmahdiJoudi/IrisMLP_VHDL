LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY neuron IS
    GENERIC (
        size: INTEGER := 8
    );
    PORT (
        clk     : IN STD_LOGIC;
        rst     : IN STD_LOGIC;
        initN   : IN STD_LOGIC;
        ldR1    : IN STD_LOGIC;
        ldR2    : IN STD_LOGIC;
        weight  : IN STD_LOGIC_VECTOR (size-1 DOWNTO 0);
        dataIn  : IN STD_LOGIC_VECTOR (size-1 DOWNTO 0);
        bias    : IN STD_LOGIC_VECTOR (size-1 DOWNTO 0);
        dataOut : OUT STD_LOGIC_VECTOR (2*size-1 DOWNTO 0)
    );
END ENTITY neuron;

ARCHITECTURE behavioral OF neuron IS
    SIGNAL multOut : STD_LOGIC_VECTOR (2*size-1 DOWNTO 0);
    SIGNAL add1Out : STD_LOGIC_VECTOR (2*size-1 DOWNTO 0);
    SIGNAL add2Out : STD_LOGIC_VECTOR (2*size-1 DOWNTO 0);
    SIGNAL reg1Out : STD_LOGIC_VECTOR (2*size-1 DOWNTO 0);
    SIGNAL reg2Out : STD_LOGIC_VECTOR (2*size-1 DOWNTO 0);
    SIGNAL extBias : STD_LOGIC_VECTOR (2*size-1 DOWNTO 0);
BEGIN
--------------------------------------------------- Multiplier
    multiplier : ENTITY WORK.multiplier (behavioral)
        GENERIC MAP (
            size => size
        )
        PORT MAP (
            inA     => weight,
            inB     => dataIn,
            outY    => multOut
        );
--------------------------------------------------- Adder 1
    adder1 : ENTITY WORK.adder (behavioral)
        GENERIC MAP (
            size => 2*size
        )
        PORT MAP (
            inA     => multOut,
            inB     => reg1Out,
            outY    => add1Out
        );
--------------------------------------------------- Register 1
    reg1 : ENTITY WORK.normalRegister (behavioral)
        GENERIC MAP (
            size => 2*size
        )
        PORT MAP (
            clk     => clk,
            rst     => rst,
            pLoad   => add1Out,
            load    => ldR1,
            init    => initN,
            dOut    => reg1Out
        );
--------------------------------------------------- Adder 2
    extBias (2*size-1 DOWNTO size) <= (OTHERS => bias(size-1));
    extBias (size-1 DOWNTO 0) <= bias;
    adder2 : ENTITY WORK.adder (behavioral)
        GENERIC MAP (
            size => 2*size
        )
        PORT MAP (
            inA     => extBias,
            inB     => reg1Out,
            outY    => add2Out
        );
--------------------------------------------------- Register 2
    reg2 : ENTITY WORK.normalRegister (behavioral)
        GENERIC MAP (
            size => 2*size
        )
        PORT MAP (
            clk     => clk,
            rst     => rst,
            pLoad   => add2Out,
            load    => ldR2,
            init    => initN,
            dOut    => reg2Out
        );
    dataOut <= reg2Out;
END ARCHITECTURE behavioral;
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.math_real.ALL;

ENTITY layer IS
    GENERIC (
        size:       INTEGER := 8;
        layerSize:  INTEGER := 10;
        inputSize:  INTEGER := 4;
        layerName:  STRING
    );
    PORT (
        clk    : IN  STD_LOGIC;
        rst    : IN  STD_LOGIC;
        sel    : IN  STD_LOGIC;
        start  : IN  STD_LOGIC;
        inBus  : IN  STD_LOGIC_VECTOR (size*inputSize-1 DOWNTO 0);
        done   : OUT STD_LOGIC;
        outBus : OUT STD_LOGIC_VECTOR (2*size*layerSize-1 DOWNTO 0)
    );
END ENTITY layer;

ARCHITECTURE behavioral OF layer IS
    SIGNAL initN        : STD_LOGIC;
    SIGNAL CntEN        : STD_LOGIC;
    SIGNAL ldR1         : STD_LOGIC;
    SIGNAL ldR2         : STD_LOGIC;
    SIGNAL co           : STD_LOGIC;

BEGIN
    datapath : ENTITY WORK.layerDataPath (behavioral)
        GENERIC MAP (
            size      => size,
            layerSize => layerSize,
            inputSize => inputSize,
            layerName => layerName
        )
        PORT MAP (
            clk     => clk,
            rst     => rst,
            sel     => sel,
            initN   => initN,
            CntEN   => CntEN,
            ldR1    => ldR1,
            ldR2    => ldR2,
            dataIn  => inBus,
            co      => co,
            dataOut => outBus
        );

    controller : ENTITY WORK.layerController (behavioral)
        PORT MAP (
            clk       => clk,
            rst       => rst,
            start     => start,
            co        => co,
            initN     => initN,
            CntEN     => CntEN,
            ldR1      => ldR1,
            ldR2      => ldR2,
            done      => done
        );

END ARCHITECTURE behavioral;
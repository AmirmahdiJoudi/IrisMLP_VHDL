LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_unsigned.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.math_real."ceil";
USE IEEE.math_real."log2";

ENTITY layerDataPath IS
    GENERIC (
        size:       INTEGER := 8;
        layerSize:  INTEGER := 10;
        inputSize:  INTEGER := 4;
        layerName:  STRING
    );
    PORT (
        clk     : IN STD_LOGIC;
        rst     : IN STD_LOGIC;
        sel     : IN STD_LOGIC;
        initN   : IN STD_LOGIC;
        CntEN   : IN STD_LOGIC;
        ldR1    : IN STD_LOGIC;
        ldR2    : IN STD_LOGIC;
        dataIn  : IN STD_LOGIC_VECTOR (size*inputSize-1 DOWNTO 0);
        co      : OUT STD_LOGIC;
        dataOut : OUT STD_LOGIC_VECTOR (2*size*layerSize-1 DOWNTO 0)
    );
END ENTITY layerDataPath;

ARCHITECTURE behavioral OF layerDataPath IS
    SIGNAL ADD      : STD_LOGIC_VECTOR (INTEGER(ceil(log2(real(inputSize+1))))-1 DOWNTO 0);
    SIGNAL weigth_i : STD_LOGIC_VECTOR (size*layerSize-1 DOWNTO 0);
    SIGNAL nOut_i   : STD_LOGIC_VECTOR (2*size*layerSize-1 DOWNTO 0);
    SIGNAL dIn_i    : STD_LOGIC_VECTOR (size-1 DOWNTO 0);
    SIGNAL muxIn    : STD_LOGIC_VECTOR (size*inputSize+size-1 DOWNTO 0);
    SIGNAL dtOut    : STD_LOGIC_VECTOR (2*size*layerSize-1 DOWNTO 0);
BEGIN
    --------------------------------------------------- MUX
    muxIn (size*inputSize+size-1 DOWNTO size*inputSize-1) <= (OTHERS => '0');
    muxIn (size*inputSize-1 DOWNTO 0) <= dataIn;
    mux : ENTITY WORK.mux (behavioral)
        GENERIC MAP (
            size       => size,
            num        => inputSize+1
        )
        PORT MAP (
            inA      => muxIn,
            sel      => ADD,
            outY     => dIn_i
        );
    --------------------------------------------------- Counter
    counter : ENTITY WORK.counter (behavioral)
        GENERIC MAP (
            size => INTEGER(ceil(log2(real(inputSize+1))))
        )
        PORT MAP (
            clk       => clk,
            rst       => rst,
            initCnt   => initN,
            Cnt       => CntEN,
            CntOut    => ADD
        );
    co <= '1' WHEN (ADD = STD_LOGIC_VECTOR(TO_UNSIGNED(inputSize-1, INTEGER(ceil(log2(real(inputSize+1))))))) ELSE '0';
    --------------------------------------------------- Iterations
    neurons: FOR i IN 0 TO (layerSize-1) GENERATE
    --------------------------------------------------- ROM_i
        rom_i : ENTITY WORK.rom (behavioral)
            GENERIC MAP (
                dataWidth       => size,
                addressWidth    => INTEGER(ceil(log2(real(inputSize+1)))),
                blockSize       => 2**INTEGER(ceil(log2(real(inputSize+1)))),
                filename        => layerName & INTEGER'image(i)
            )
            PORT MAP (
                addressBus   => ADD,
                dataBus      => weigth_i(size*(i+1) - 1 DOWNTO size*i)
            );
    --------------------------------------------------- Neuron_i
        neuron_i : ENTITY WORK.neuron (behavioral)
            GENERIC MAP (
                size => size
            )
            PORT MAP (
                clk     => clk,
                rst     => rst,
                initN   => initN,
                ldR1    => ldR1,
                ldR2    => ldR2,
                weight  => weigth_i(size*(i+1) - 1 DOWNTO size*i),
                dataIn  => dIn_i,
                bias    => weigth_i(size*(i+1) - 1 DOWNTO size*i),
                dataOut => nOut_i(2*size*(i+1) - 1 DOWNTO 2*size*i)
            );
    --------------------------------------------------- ReLU_i
        ReLUi : ENTITY WORK.ReLU (behavioral)
            GENERIC MAP (
                size => 2*size
            )
            PORT MAP (
                inA     => nOut_i(2*size*(i+1) - 1 DOWNTO 2*size*i),
                outY    => dtOut(2*size*(i+1) - 1 DOWNTO 2*size*i)
            );
    END GENERATE neurons;
    dataOut <= dtOut WHEN (sel = '1') ELSE nOut_i;
END ARCHITECTURE behavioral;
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.math_real.ALL;
USE WORK.ARR_TYPE.ALL;

ENTITY MLP IS
    GENERIC (
        size:       INTEGER := 8;
        layersNum:  INTEGER := 4;
        layersSize: ARR
    );
    PORT (
        clk           : IN  STD_LOGIC;
        rst           : IN  STD_LOGIC;
        start         : IN  STD_LOGIC;
        inBus         : IN  STD_LOGIC_VECTOR (size*layersSize(0)-1 DOWNTO 0);
        done          : OUT STD_LOGIC;
        outBus        : OUT STD_LOGIC_VECTOR (size*layersSize(layersNum-1)-1 DOWNTO 0)
    );
END ENTITY MLP;

ARCHITECTURE behavioral OF MLP IS
    SIGNAL done_i         : STD_LOGIC_VECTOR (layersNum DOWNTO 0);
    SIGNAL out_i          : ARR_STD (layersNum DOWNTO 0);
    SIGNAL out_modified   : ARR_STD (layersNum-1 DOWNTO 0);
BEGIN

    done_i(0) <= start;
    out_i(0)(size*layersSize(0)-1 DOWNTO 0) <= inBus;
    ------------------------------------------------------------------------------------------------------ Hidden Layers
    layers: FOR i IN 1 TO (layersNum-2) GENERATE
        Li : ENTITY WORK.layer (behavioral)
            GENERIC MAP (
                size       => size,
                layerSize  => layersSize(i),
                inputSize  => layersSize(i-1),
                layerName  => "L" & INTEGER'image(i)
            )
            PORT MAP (
                clk    => clk,
                rst    => rst,
                sel    => '1',
                start  => done_i(i-1),
                inBus  => out_i(i-1)(size*layersSize(i-1)-1 DOWNTO 0),
                done   => done_i(i),
                outBus => out_modified(i-1)(2*size*layersSize(i)-1 DOWNTO 0)
            );
        out_i_modifying: FOR j IN 1 TO (layersSize(i)) GENERATE
            out_i(i)(size*j-1 DOWNTO size*j-size) <= out_modified(i-1)(2*size*j-1-1-1 DOWNTO 2*size*j-size-1-1);
        END GENERATE out_i_modifying;
    END GENERATE layers;

    ------------------------------------------------------------------------------------------------------ Output Layer
    Li : ENTITY WORK.layer (behavioral)
        GENERIC MAP (
            size       => size,
            layerSize  => layersSize(layersNum-1),
            inputSize  => layersSize(layersNum-1-1),
            layerName  => "L" & INTEGER'image(layersNum-1)
        )
        PORT MAP (
            clk    => clk,
            rst    => rst,
            sel    => '0',
            start  => done_i(layersNum-1-1),
            inBus  => out_i(layersNum-1-1)(size*layersSize(layersNum-1-1)-1 DOWNTO 0),
            done   => done_i(layersNum-1),
            outBus => out_modified(layersNum-1-1)(2*size*layersSize(layersNum-1)-1 DOWNTO 0)
        );
    out_i_modifying: FOR i IN 1 TO (layersSize(layersNum-1)) GENERATE
            out_i(layersNum-1)(size*i-1 DOWNTO size*i-size) <= out_modified(layersNum-1-1)(2*size*i-1-1-1 DOWNTO 2*size*i-size-1-1);
    END GENERATE out_i_modifying;

    done <= done_i(layersNum-1);
    outBus <= out_i(layersNum-1)(size*layersSize(layersNum-1)-1 DOWNTO 0);

END ARCHITECTURE behavioral;
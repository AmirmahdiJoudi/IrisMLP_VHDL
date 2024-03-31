LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY layerController IS
    PORT
    (
        clk        : IN  STD_LOGIC;
        rst        : IN  STD_LOGIC;
        start      : IN  STD_LOGIC;
        co         : IN  STD_LOGIC;
        initN      : OUT STD_LOGIC;
        CntEN      : OUT STD_LOGIC;
        ldR1       : OUT STD_LOGIC;
        ldR2       : OUT STD_LOGIC;
        done       : OUT STD_LOGIC
    );
END ENTITY layerController;
--
ARCHITECTURE behavioral OF layerController IS
    TYPE state IS (WAITING, INIT, CNTING, FINISHING, DONING);
    SIGNAL pstate, nstate : state;
BEGIN
    PROCESS (pstate, start, co) BEGIN
        nstate <= WAITING;
        CASE pstate IS
            WHEN WAITING =>
                IF (start = '1') THEN
                    nstate <= INIT;
                ELSE
                    nstate <= WAITING;
                END IF;
            WHEN INIT =>
                nstate <= CNTING;
            WHEN CNTING =>
                IF (co = '1') THEN
                    nstate <= FINISHING;
                ELSE
                    nstate <= CNTING;
                END IF;
            WHEN FINISHING =>
                nstate <= DONING;
            WHEN DONING =>
                nstate <= WAITING;
            WHEN OTHERS =>
                nstate <= WAITING;
        END CASE;
    END PROCESS;

    PROCESS (pstate, start, co) BEGIN

        initN     <= '0';
        CntEN     <= '0';
        ldR1      <= '0';
        ldR2      <= '0';
        done      <= '0';
        CASE pstate IS
            WHEN WAITING =>
            WHEN INIT =>
                initN   <= '1';
            WHEN CNTING =>
                CntEN <= '1';
                ldR1  <= '1';
            WHEN FINISHING =>
                ldR2 <= '1';
            WHEN DONING =>
                done <= '1';
            WHEN OTHERS =>
                initN     <= '0';
                CntEN     <= '0';
                ldR1      <= '0';
                ldR2      <= '0';
                done      <= '0';
        END CASE;
    END PROCESS;

    sequential : PROCESS (clk, rst) BEGIN
        IF rst = '1' THEN
            pstate <= WAITING;
        ELSIF (clk = '1' AND clk'EVENT) THEN
            pstate <= nstate;
        END IF;
    END PROCESS sequential;

END ARCHITECTURE behavioral;
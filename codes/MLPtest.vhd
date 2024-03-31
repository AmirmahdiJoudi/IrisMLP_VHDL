LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.std_logic_unsigned.ALL;
USE IEEE.std_logic_textio.ALL;
USE STD.textio.ALL;
USE WORK.ARR_TYPE.ALL;
use std.env.all;

ENTITY MLPtest IS
END MLPtest;

ARCHITECTURE behavioral OF MLPtest IS
    TYPE mem_type IS ARRAY (0 TO 150 - 1) OF STD_LOGIC_VECTOR (32 - 1 DOWNTO 0);
    SIGNAL clk : std_logic := '0';
    SIGNAL rst : std_logic := '0';
    SIGNAL start : std_logic := '0';
    SIGNAL inBus : std_logic_vector (31 DOWNTO 0);
    SIGNAL done : std_logic := '0';
    SIGNAL outBus : std_logic_vector (24-1 DOWNTO 0);
    SIGNAL SETOSA : std_logic := '0';
    SIGNAL VERSICOLOR : std_logic := '0';
    SIGNAL VIRGINICA : std_logic := '0';
    SIGNAL SETOSAorg : std_logic := '0';
    SIGNAL VERSICOLORorg : std_logic := '0';
    SIGNAL VIRGINICAorg : std_logic := '0';
    SIGNAL mistakes     : std_logic_vector (7 DOWNTO 0);

    PROCEDURE MemLoad (buffermem : OUT mem_type) IS
        VARIABLE memline   : LINE;
        VARIABLE offset    : INTEGER := 0;
        VARIABLE err_check : FILE_OPEN_STATUS;
        VARIABLE hexcode_v : STD_LOGIC_VECTOR (32 - 1 DOWNTO 0);
        FILE fle           : TEXT;
    BEGIN
        buffermem := (OTHERS => (OTHERS => '0'));
        FILE_OPEN (err_check, fle, ("inputs.hex"), READ_MODE);
        IF err_check = OPEN_OK THEN
            WHILE NOT ENDFILE (fle) LOOP
                READLINE (fle, memline);
                HREAD (memline, hexcode_v);
                buffermem (offset) := hexcode_v;
                offset             := offset + 1;
            END LOOP;
            FILE_CLOSE (fle);
        END IF;
    END MemLoad;
BEGIN

    clk <= NOT clk AFTER 10 ns;

    DUT : ENTITY WORK.MLP (behavioral)
        GENERIC MAP (
            size        => 8,
            layersNum   => 4,
            layersSize  => (4,10,8,3)
        )
        PORT MAP (
            clk    => clk,
            rst    => rst,
            start  => start,
            inBus  => inBus,
            done   => done,
            outBus => outBus
        );

    SETOSA <= '1' WHEN (signed(outBus(7 DOWNTO 0)) > signed(outBus(15 DOWNTO 8))) AND signed(outBus(7 DOWNTO 0)) > signed(outBus(23 DOWNTO 16)) ELSE '0';
    VERSICOLOR <= '1' WHEN (signed(outBus(15 DOWNTO 8)) > signed(outBus(7 DOWNTO 0))) AND signed(outBus(15 DOWNTO 8)) > signed(outBus(23 DOWNTO 16)) ELSE '0';
    VIRGINICA <= '1' WHEN (signed(outBus(23 DOWNTO 16)) > signed(outBus(7 DOWNTO 0))) AND signed(outBus(23 DOWNTO 16)) > signed(outBus(15 DOWNTO 8)) ELSE '0';

    SIMULATION : PROCESS
        VARIABLE buffermem : mem_type := (OTHERS => (OTHERS => '0'));
    BEGIN
        MemLoad (buffermem);
        rst <= '1';
        WAIT FOR 20 ns;
        rst    <= '0';

        testing: FOR j IN 0 TO (150-1) LOOP
            IF ( j < 50) THEN
                SETOSAorg <= '1';
                VERSICOLORorg <='0';
                VIRGINICAorg <= '0';
            ELSIF (j < 100) THEN
                SETOSAorg <= '0';
                VERSICOLORorg <='1';
                VIRGINICAorg <= '0';
            ELSE
                SETOSAorg <= '0';
                VERSICOLORorg <='0';
                VIRGINICAorg <= '1';
            END IF;
            start  <= '1';
            WAIT FOR 20 ns;
            start  <= '0';
            inBus <= buffermem(j);
            WAIT UNTIL (done = '1');
            WAIT UNTIL (done = '0');
        END LOOP testing;

        SETOSAorg <= '0';
        VERSICOLORorg <='0';
        VIRGINICAorg <= '0';
        rst <= '1';
        WAIT FOR 20 ns;
        rst    <= '0';

        WAIT FOR 10000 ns;
        STOP(0);
    END PROCESS;

    EVALUATION : PROCESS (clk, rst)
    BEGIN
        IF (rst = '1') THEN
            mistakes <= (OTHERS => '0');
        ELSIF (clk = '0' AND clk'EVENT) THEN
            IF (done = '1') THEN
                IF ((SETOSAorg /= SETOSA) OR (VERSICOLORorg /= VERSICOLOR) OR (VIRGINICAorg /= VIRGINICA)) THEN
                    mistakes <= mistakes + 1;
                END IF;
            END IF;
        END IF;
    END PROCESS;


END ARCHITECTURE behavioral;
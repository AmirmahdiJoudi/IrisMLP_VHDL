LIBRARY IEEE;
LIBRARY STD;
USE IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.all;
USE IEEE.std_logic_textio.ALL;
USE STD.textio.ALL;

ENTITY rom IS
    GENERIC
    (
        dataWidth       : INTEGER := 8;
        addressWidth    : INTEGER := 16;
        blockSize       : INTEGER := 2 ** 16;
        filename        : STRING
    );
    PORT
    (
        addressBus      : IN  STD_LOGIC_VECTOR (addressWidth - 1 DOWNTO 0);
        dataBus         : OUT STD_LOGIC_VECTOR (dataWidth - 1 DOWNTO 0)
    );
END rom;

ARCHITECTURE behavioral OF rom IS
    TYPE mem_type IS ARRAY (0 TO blockSize - 1) OF STD_LOGIC_VECTOR (dataWidth - 1 DOWNTO 0);
    SIGNAL address : STD_LOGIC_VECTOR (addressWidth - 1 DOWNTO 0);
---------------------------------------------------------------------------- MemLoad Procedure
    PROCEDURE MemLoad (buffermem : OUT mem_type) IS
        VARIABLE memline   : LINE;
        VARIABLE offset    : INTEGER := 0;
        VARIABLE err_check : FILE_OPEN_STATUS;
        VARIABLE hexcode_v : STD_LOGIC_VECTOR (dataWidth - 1 DOWNTO 0);
        FILE fle           : TEXT;
    BEGIN
        buffermem := (OTHERS => (OTHERS => '0'));
        FILE_OPEN (err_check, fle, (filename & ".hex"), READ_MODE);
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
---------------------------------------------------------------------------- main
BEGIN

    ADD : PROCESS(addressBus)
    BEGIN
        address <= addressBus;
    END PROCESS;

    READ : PROCESS
        VARIABLE buffermem         : mem_type := (OTHERS => (OTHERS => '0'));
        VARIABLE addressBusInteger : INTEGER;
        VARIABLE memLoadedNum      : INTEGER := 1;
        VARIABLE init              : BOOLEAN := true;
    BEGIN
        IF (init = true) THEN
            MemLoad (buffermem);
            memLoadedNum := 1;
            init         := false;
            dataBus <= (OTHERS => 'Z');
        END IF;
        WAIT FOR 0 ns;
        addressBusInteger := to_integer(unsigned(address));
        dataBus <= buffermem (addressBusInteger);
        WAIT ON address;
    END PROCESS;
END behavioral;


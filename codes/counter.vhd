LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY counter IS
    GENERIC (
        size : INTEGER := 4
    );
    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        initCnt : IN STD_LOGIC;
        Cnt : IN STD_LOGIC;
        CntOut : OUT STD_LOGIC_VECTOR (size-1 DOWNTO 0)
    );
END ENTITY counter;

ARCHITECTURE behavioral OF counter IS
    SIGNAL cnt_t : STD_LOGIC_VECTOR(size-1 DOWNTO 0);
BEGIN

    PROCESS (clk, rst)
    BEGIN
        IF (rst = '1') THEN
            cnt_t <= (OTHERS => '0');
        ELSIF (clk = '1' AND clk'EVENT) THEN
            IF (initCnt = '1') THEN
                cnt_t <= (OTHERS => '0');
            ELSIF (Cnt = '1') THEN
                cnt_t <= cnt_t + 1;
            END IF;
        END IF;
    END PROCESS;
    CntOut <= cnt_t;

END ARCHITECTURE behavioral;
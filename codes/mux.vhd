LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.math_real.ALL;
USE IEEE.math_real."ceil";
USE IEEE.math_real."log2";

ENTITY mux IS
    GENERIC (
        size : INTEGER := 8;
        num : INTEGER := 10
    );
    PORT (
        inA  : IN STD_LOGIC_VECTOR (size*num-1 DOWNTO 0);
        sel  : IN STD_LOGIC_VECTOR (INTEGER(ceil(log2(real(num+1))))-1 DOWNTO 0);
        outY : OUT STD_LOGIC_VECTOR (size-1 DOWNTO 0)
    );
END ENTITY mux;

ARCHITECTURE behavioral OF mux IS
BEGIN
    PROCESS (inA, sel)
    BEGIN
        outY <= inA ((size*to_integer(unsigned(sel)) + size - 1) DOWNTO size*to_integer(unsigned(sel)));
    END PROCESS;

END ARCHITECTURE behavioral;
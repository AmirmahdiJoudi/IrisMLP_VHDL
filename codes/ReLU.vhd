LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY ReLU IS
    GENERIC (
        size :INTEGER := 8
    );
    PORT (
        inA : IN STD_LOGIC_VECTOR (size-1 DOWNTO 0);
        outY : OUT STD_LOGIC_VECTOR (size-1 DOWNTO 0)
    );
END ENTITY ReLU;

ARCHITECTURE behavioral OF ReLU IS
BEGIN

    outY <= inA WHEN (inA(size-1) = '0') ELSE (OTHERS => '0');

END ARCHITECTURE behavioral;
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY multiplier IS
    GENERIC (
        size :INTEGER := 8
    );
    PORT (
        inA : IN STD_LOGIC_VECTOR (size-1 DOWNTO 0);
        inB : IN STD_LOGIC_VECTOR (size-1 DOWNTO 0);
        outY : OUT STD_LOGIC_VECTOR (2*size-1 DOWNTO 0)
    );
END ENTITY multiplier;

ARCHITECTURE behavioral OF multiplier IS
BEGIN

    outY <= STD_LOGIC_VECTOR (SIGNED(inA) * SIGNED(inB));

END ARCHITECTURE behavioral;
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY vote_c IS
PORT(vote_in: IN BIT_VECTOR(0 TO 2);
y:OUT BIT);
END ENTITY vote_c;
ARCHITECTURE choose OF vote_c IS
BEGIN
WITH vote_in SELECT
y<='0' WHEN "000",
'0' WHEN "001",
'0' WHEN "010",
'0' WHEN "100",
'1' WHEN OTHERS;
END choose;
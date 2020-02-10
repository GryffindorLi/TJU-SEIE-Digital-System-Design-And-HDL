LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY vote_condit IS
PORT (vote: IN BIT_VECTOR(0 TO 2);
y: OUT BIT);
END ENTITY vote_condit;

Architecture condition OF vote_condit IS
BEGIN
y<='0' WHEN vote="000" ELSE
'0' WHEN vote="001" ELSE
'0' WHEN vote="010" ELSE
'1' WHEN VOTE="011" ELSE
'0' WHEN VOTE="100" ELSE
'1' WHEN VOTE="101" ELSE
'1' WHEN VOTE="110" ELSE
'1';
END condition;
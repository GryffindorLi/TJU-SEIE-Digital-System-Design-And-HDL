LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
ENTITY vote_case IS
PORT (in_vote: IN STD_LOGIC_VECTOR(0 TO 2);
Y: OUT STD_LOGIC);
END ENTITY vote_case;

ARCHITECTURE one OF vote_case IS
BEGIN
PROCESS(in_vote)
BEGIN
case in_vote IS
WHEN "000" => Y <='0';
WHEN "001" => Y <='0';
WHEN "010" => Y <='0';
WHEN "011" => Y <='1';
WHEN "100" => Y <='0';
WHEN "101" => Y <='1';
WHEN "110" => Y <='1';
WHEN "111" => Y <='1';
END case;
END PROCESS;
END one;
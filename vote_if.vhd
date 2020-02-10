LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY vote_if IS
	port(invote: IN STD_LOGIC_VECTOR(0 TO 2);
			y: OUT STD_LOGIC);
END ENTITY vote_if;

Architecture behave OF vote_if IS
begin
	process(invote)
		begin
IF(invote="000") THEN
y<='0';
ELSIF(invote="001") THEN
y<='0';
ELSIF(invote="010") THEN
y<='0';
ELSIF(invote="011") THEN
y<='1';
ELSIF(invote="100") THEN
y<='0';
ELSIF(invote="101") THEN
y<='1';
ELSIF(invote="110") THEN
y<='1';
ELSIF(invote="111") THEN
y<='1';
END IF;
END PROCESS;
END behave;

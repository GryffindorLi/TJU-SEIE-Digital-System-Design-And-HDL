LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL; 
ENTITY div_sec IS
PORT(              
clk: IN STD_LOGIC;
clk1: OUT STD_LOGIC);              
END div_sec;

ARCHITECTURE count OF div_sec IS 
SIGNAL cnt_f : INTEGER RANGE 0 TO 6;
SIGNAL Q : STD_LOGIC;

BEGIN
PROCESS(clk)   ----50M分频得到1Hz的频率（假设系统频率为50MHz）
BEGIN             
IF clk'EVENT AND clk='1' THEN
IF cnt_f = 6 THEN
Q <=NOT Q;
cnt_f <= 0;
ELSE cnt_f <= cnt_f+1;
END IF;
END IF;
END PROCESS;
clk1 <= Q;
END;
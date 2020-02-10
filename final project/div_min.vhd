LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL; 
ENTITY clk_min IS
PORT(              
clk: IN STD_LOGIC;
clk_out: OUT STD_LOGIC);              
END CLK_Div;

ARCHITECTURE count OF clk_min IS 
SIGNAL cnt_f : INTEGER RANGE 0 TO 2999999999;
SIGNAL Q : STD_LOGIC;

BEGIN
PROCESS(clk)   ----50M分频得到1/60Hz的频率（假设系统频率为50MHz）
BEGIN             
IF clk'EVENT AND clk='1' THEN
IF cnt_f = 2999999999 THEN
Q <=NOT Q;
cnt_f <= 0;
ELSE cnt_f <= cnt_f+1;
END IF;
END IF;
END PROCESS;
clk_out <= Q;
END;
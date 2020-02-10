LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL; 
ENTITY CLK_Div IS
PORT(              CLK: IN STD_LOGIC;
						 CLK_1: OUT STD_LOGIC);              
END CLK_Div;

ARCHITECTURE BEHAV OF CLK_Div IS 
  SIGNAL A : INTEGER RANGE 0 TO 49999999;
  SIGNAL Q : STD_LOGIC;

  BEGIN
    PROCESS(CLK)   ----50M分频得到1Hz的频率（假设系统频率为50MHz）
    BEGIN             
      IF CLK'EVENT AND CLK='1' THEN
        IF A = 49999999 THEN
		     Q <=NOT Q;
			  A <= 0;
		  ELSE A <= A+1;
		  END IF;
      END IF;
    END PROCESS;
	 CLK_1 <= Q;
  END;
    
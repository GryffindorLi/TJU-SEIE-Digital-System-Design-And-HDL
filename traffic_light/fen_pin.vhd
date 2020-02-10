LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL; 
ENTITY fen_pin IS
PORT(          CLK : IN  STD_LOGIC;
             CLK_1 : OUT STD_LOGIC ); 
END fen_pin;

ARCHITECTURE BEHAV OF fen_pin IS 
  SIGNAL  A : INTEGER RANGE 0 TO 2499;
  SIGNAL  Q : STD_LOGIC;

  BEGIN
    PROCESS(CLK)   ----5000分频得到1Hz的频率（假设系统频率为5KHz）
    BEGIN             
      IF CLK'EVENT AND CLK='1' THEN
        IF A=2499 THEN
              Q <= NOT Q;
              A <= 0;
        ELSE  A <= A+1;END IF;
      END IF;
    END PROCESS;

  CLK_1 <= Q;
 END;      

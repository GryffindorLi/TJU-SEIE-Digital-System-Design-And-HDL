LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL; 
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
ENTITY kong_zhi IS
PORT(              CLK: IN STD_LOGIC;
						 CLK_1: INOUT STD_LOGIC;
               NUM1,NUM2 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
                  LIGHT1 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);--A通道交通灯
                  LIGHT2 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)); --B通道交通灯
END kong_zhi;

ARCHITECTURE BEHAV OF kong_zhi IS 
  SIGNAL  A : INTEGER RANGE 0 TO 2499;
  SIGNAL  Q : STD_LOGIC;

  TYPE   STATES IS (S0,S1,S2,S3,S4,S5);
  SIGNAL STATE : STATES;
  SIGNAL COUNT : INTEGER RANGE 0 TO 99;

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
    
	 PROCESS(CLK_1)   
    BEGIN
    IF(CLK_1'EVENT AND CLK_1='1')THEN
          IF COUNT = 0 THEN
            COUNT <= 39;
          ELSE COUNT <= COUNT-1;
          END IF;
        END IF;
    END PROCESS;

    PROCESS(COUNT)
    VARIABLE Q1,Q2 : INTEGER RANGE 0 TO 9;
    BEGIN
             IF(COUNT >= 33)THEN STATE <= S0;
        ELSE IF(COUNT >= 30 AND COUNT <= 32)THEN STATE <= S1;
        ELSE IF(COUNT >= 23 AND COUNT <= 29)THEN STATE <= S2;
        ELSE IF(COUNT >= 20 AND COUNT <= 22)THEN STATE <= S1;
		  ELSE IF(COUNT >= 13 AND COUNT <= 19)THEN STATE <= S3;
		  ELSE IF(COUNT >= 10 AND COUNT <= 12)THEN STATE <= S4;
		  ELSE IF(COUNT >= 3 AND COUNT <= 9)THEN STATE <= S5;
		  ELSE IF(COUNT >= 0 AND COUNT <= 2)THEN STATE <= S4;
        END IF;
        END IF;
        END IF;
        END IF;
        END IF;
        END IF;
        END IF;
        END IF;		  
		  
      CASE STATE IS
        WHEN S0 => LIGHT1 <= "0010";---状态S0，A道直行，B道禁行
                   LIGHT2 <= "1000";
        WHEN S1 => LIGHT1 <= "0001";---状态S1，A道黄灯，B道禁行
                   LIGHT2 <= "1000";
        WHEN S2 => LIGHT1 <= "0100";---状态S2，A道左转，B道禁行
                   LIGHT2 <= "1000";
        WHEN S3 => LIGHT1 <= "1000";---状态S3，A道禁行，B道直行
                   LIGHT2 <= "0010";
		  WHEN S4 => LIGHT1 <= "1000";---状态S4，A道禁行，B道黄灯
						 LIGHT2 <= "0001";
        WHEN S5 => LIGHT1 <= "1000";---状态S5，A道禁行，B道左转
						 LIGHT2 <= "0100";
      END CASE;

      Q1 := COUNT/10;
      Q2 := COUNT REM 10;
      NUM1 <= CONV_STD_LOGIC_VECTOR(Q1, 4); ---将COUNT计数器十位数转换成二进制数输出
      NUM2 <= CONV_STD_LOGIC_VECTOR(Q2, 4); ---将COUNT计数器个位数转换成二进制数输出
    END PROCESS;                              ----经七段译码器显示在数码管上

 END;

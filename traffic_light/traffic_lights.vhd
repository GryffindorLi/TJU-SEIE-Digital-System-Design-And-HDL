LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL; 
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY Traffic_Lights IS
PORT(              CLK: IN STD_LOGIC;
						 CLK_1: BUFFER STD_LOGIC;
               NUM1,NUM2 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
                  LIGHT1 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);--A通道交通灯
                  LIGHT2 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)); --B通道交通灯
END Traffic_Lights;

ARCHITECTURE BEHAV OF Traffic_Lights IS 

	COMPONENT CLK_Div IS
		PORT( CLK: IN STD_LOGIC;
				CLK_1: OUT STD_LOGIC);
	END COMPONENT ;

  TYPE   STATES IS (S0,S1,S2,S3,S4,S5);
  SIGNAL STATE : STATES;
  SIGNAL COUNT : INTEGER RANGE 0 TO 39;
  --SIGNAL CLK_1 :STD_LOGIC;
	
	
  BEGIN
     C_DIV : CLK_Div port map(CLK=>CLK,CLK_1=>CLK_1);
	  
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
	 VARIABLE Q3,Q4 : STD_LOGIC_VECTOR(3 DOWNTO 0);
	 VARIABLE Q5,Q6 : STD_LOGIC_VECTOR(6 DOWNTO 0);
    
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
        WHEN S0 => LIGHT1 <= "0010";---状态S0(39~33)，A道直行，B道禁行
                   LIGHT2 <= "1000";
        WHEN S1 => LIGHT1 <= "0001";---状态S1(32~30,22~20)，A道黄灯，B道禁行
                   LIGHT2 <= "1000";
        WHEN S2 => LIGHT1 <= "0100";---状态S2(29~23)，A道左转，B道禁行
                   LIGHT2 <= "1000";
        WHEN S3 => LIGHT1 <= "1000";---状态S3(19~13)，A道禁行，B道直行
                   LIGHT2 <= "0010";
		  WHEN S4 => LIGHT1 <= "1000";---状态S4(12~10,2~0)，A道禁行，B道黄灯
						 LIGHT2 <= "0001";
        WHEN S5 => LIGHT1 <= "1000";---状态S5(9~3)，A道禁行，B道左转
						 LIGHT2 <= "0100";
      END CASE;

      Q1 := COUNT/10;
      Q2 := COUNT REM 10;
      Q3 := CONV_STD_LOGIC_VECTOR(Q1, 4); ---将COUNT计数器十位数转换成二进制数
      Q4 := CONV_STD_LOGIC_VECTOR(Q2, 4); ---将COUNT计数器个位数转换成二进制数
		
--------七段译码器--------		
      CASE Q3 IS
        WHEN "0000" => Q5 := "1000000";---0
        WHEN "0001" => Q5 := "1111001";---1
        WHEN "0010" => Q5 := "0100100";---2
        WHEN "0011" => Q5 := "0110000";---3
		  WHEN "0100" => Q5 := "0011001";---4
        WHEN "0101" => Q5 := "0010010";---5
        WHEN "0110" => Q5 := "0000010";---6
        WHEN "0111" => Q5 := "1111000";---7
        WHEN "1000" => Q5 := "0000000";---8
        WHEN "1001" => Q5 := "0010000";---9
        WHEN "1010" => Q5 := "0001000";---A
        WHEN "1011" => Q5 := "0000011";---B
        WHEN "1100" => Q5 := "1000110";---C
        WHEN "1101" => Q5 := "0100001";---D
        WHEN "1110" => Q5 := "0000110";---E
        WHEN "1111" => Q5 := "0001110";---F

      END CASE;		
		
		CASE Q4 IS
        WHEN "0000" => Q6 := "1000000";---0
        WHEN "0001" => Q6 := "1111001";---1
        WHEN "0010" => Q6 := "0100100";---2
        WHEN "0011" => Q6 := "0110000";---3
		  WHEN "0100" => Q6 := "0011001";---4
        WHEN "0101" => Q6 := "0010010";---5
        WHEN "0110" => Q6 := "0000010";---6
        WHEN "0111" => Q6 := "1111000";---7
        WHEN "1000" => Q6 := "0000000";---8
        WHEN "1001" => Q6 := "0010000";---9
        WHEN "1010" => Q6 := "0001000";---A
        WHEN "1011" => Q6 := "0000011";---B
        WHEN "1100" => Q6 := "1000110";---C
        WHEN "1101" => Q6 := "0100001";---D
        WHEN "1110" => Q6 := "0000110";---E
        WHEN "1111" => Q6 := "0001110";---F


      END CASE;		
		
		NUM1 <= Q5;
		NUM2 <= Q6;
		
		
    END PROCESS;                            

 END;

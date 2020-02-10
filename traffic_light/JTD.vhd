LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
ENTITY JTD IS
    PORT (CLK1KHZ  : IN  STD_LOGIC;  --1KHZ输入
            KEY      : IN  STD_LOGIC;  --1KHZ输入
            Y1,G1,R1 : OUT STD_LOGIC;  --东西向灯
            R2,Y2,G2 : OUT STD_LOGIC;  --南北向灯
            MOTOR    : OUT STD_LOGIC;  --MOTOR
            PWM      : OUT STD_LOGIC;  --MOTOR
            WOK,RESET: IN  STD_LOGIC;  --复位和管制          
            SEG      : OUT STD_LOGIC_VECTOR (6 DOWNTO 0) := "0000000";--段选
            CSG      : OUT STD_LOGIC_VECTOR (2 DOWNTO 0) := "111";    --位选
         RRCK,RSI,RSCK,GRCK,GSI,GSCK : OUT STD_LOGIC;  --红绿控制位
            RCK1,SI1,SCK1,RCK2,SI2,SCK2 : OUT STD_LOGIC;  --12io位
            RCK3,SI3,SCK3,RCK4,SI4,SCK4 : OUT STD_LOGIC;  --34io位
            Q    : OUT STD_LOGIC_VECTOR (15 DOWNTO 0));    --流水灯
    END;
	 ARCHITECTURE DECL OF JTD IS 
    SIGNAL CLK1HZ  : STD_LOGIC:= '0';           --分频1HZ
    SIGNAL CLK10HZ : STD_LOGIC:= '0';           --分频HZ
    SIGNAL CLK100HZ : STD_LOGIC:= '0';           --分频HZ
    SIGNAL STATUS  : INTEGER RANGE 1 TO 19 := 1;--数码管计时秒
    SIGNAL STAWE   : INTEGER RANGE 0 TO 35 := 0;--交通灯一轮计时36秒
    SIGNAL STATUS1 : STD_LOGIC_VECTOR(1 DOWNTO 0) := "00";
    SIGNAL EW      : STD_LOGIC_VECTOR(7 DOWNTO 0) := "00011000";
    SIGNAL NS      : STD_LOGIC_VECTOR(7 DOWNTO 0) := "00010101";
		PROCESS(CLK1KHZ)
        VARIABLE COUNT : INTEGER RANGE 0 TO 1000 := 1;
        VARIABLE COUNT1: INTEGER RANGE 0 TO 100  := 1;
        VARIABLE COUNT2: INTEGER RANGE 0 TO 10   := 1;
        BEGIN
            IF(RISING_EDGE(CLK1KHZ)) THEN
                IF (COUNT >= 1000) THEN COUNT  := 1; CLK1HZ  <= NOT CLK1HZ; --分频1hz
                ELSE COUNT := COUNT + 1;
                END IF;
                IF (COUNT1 >= 100) THEN COUNT1 := 1; CLK10HZ <= NOT CLK10HZ;--分频10HZ
                ELSE COUNT1 := COUNT1 + 1;
                END IF;
                IF (COUNT2 >= 10) THEN COUNT2 := 1; CLK100HZ <= NOT CLK100HZ;--分频100HZ
                ELSE COUNT2 := COUNT2 + 1;
                END IF;
            END IF;
    END PROCESS;

------36秒轮回一次交通灯计时
   PROCESS(CLK1HZ,WOK,STAWE,RESET)
        BEGIN
        IF (WOK = '0') THEN               --按下工作键
        IF(RISING_EDGE(CLK1HZ)) THEN    --一次1hz时钟上升沿
                STAWE <= STAWE + 1;                
                END IF;
                IF STAWE = 36 THEN STAWE <= 0; END IF;   
        END IF;
       IF (RESET = '0') THEN STAWE <= 1; END IF;    --按下复位键那么时间归零，黄灯亮起
    END PROCESS;

  PROCESS(CLK10HZ,WOK)
        VARIABLE QS : STD_LOGIC_VECTOR (15 DOWNTO 0);
    BEGIN
      IF RISING_EDGE (CLK10HZ) THEN
            IF QS = 0 THEN QS := "1000000000000000";
            ELSIF QS  = "1111111111111111" THEN 
                  QS := "0000000000000000";
            ELSE  QS (14 DOWNTO 0) := QS (15 DOWNTO 1); --移位操作
           END IF;
      END IF;
    Q<=QS;
   END PROCESS;

    -----STATUS状态计时
   PROCESS(CLK1HZ,WOK,RESET)
    BEGIN    
       IF (WOK = '0') THEN   
           IF (RESET = '0') THEN STATUS <= 1;        
            ELSIF(RISING_EDGE(CLK1HZ)) THEN
                CASE STATUS IS
                    WHEN 1  => EW <= "00011000"; NS <= "00010101";  STATUS <= STATUS + 1;
                    WHEN 2  => EW <= "00010111"; NS <= "00010100";  STATUS <= STATUS + 1;
                    WHEN 3  => EW <= "00010110"; NS <= "00010011";  STATUS <= STATUS + 1;
                    WHEN 4  => EW <= "00010101"; NS <= "00010010";  STATUS <= STATUS + 1;
                    WHEN 5  => EW <= "00010100"; NS <= "00010001";  STATUS <= STATUS + 1;
                    WHEN 6  => EW <= "00010011"; NS <= "00010000";  STATUS <= STATUS + 1;
                    WHEN 7  => EW <= "00010010"; NS <= "00001001";  STATUS <= STATUS + 1;
                    WHEN 8  => EW <= "00010001"; NS <= "00001000";  STATUS <= STATUS + 1;
                    WHEN 9  => EW <= "00010000"; NS <= "00000111";  STATUS <= STATUS + 1;
                    WHEN 10 => EW <= "00001001"; NS <= "00000110";  STATUS <= STATUS + 1;
                    WHEN 11 => EW <= "00001000"; NS <= "00000101";  STATUS <= STATUS + 1;
                    WHEN 12 => EW <= "00000111"; NS <= "00000100";  STATUS <= STATUS + 1;
                    WHEN 13 => EW <= "00000110"; NS <= "00000011";  STATUS <= STATUS + 1;
                    WHEN 14 => EW <= "00000101"; NS <= "00000010";  STATUS <= STATUS + 1;
                    WHEN 15 => EW <= "00000100"; NS <= "00000001";  STATUS <= STATUS + 1;
                    WHEN 16 => EW <= "00000011"; NS <= "00010101";  STATUS <= STATUS + 1;
                    WHEN 17 => EW <= "00000010"; NS <= "00011000";  STATUS <= STATUS + 1;
                    WHEN 18 => EW <= "00000001"; NS <= "00010111";  STATUS <= STATUS + 1;
                    WHEN OTHERS => STATUS <= 1;
                END CASE;
            END IF;
      ELSE STATUS  <= 1;
       END IF;
   END PROCESS;
    
    -------数码管
    PROCESS(EW,NS,CLK1KHZ)
        VARIABLE Q1 : STD_LOGIC_VECTOR(3 DOWNTO 0);
        BEGIN
        IF(RISING_EDGE(CLK1KHZ)) THEN
            CASE STATUS1 IS
                WHEN "00" => Q1 := EW(7 DOWNTO 4); CSG <= "110"; STATUS1 <= STATUS1 + 1;WHEN "01" => Q1 := EW(3 DOWNTO 0); CSG <= "111"; STATUS1 <= STATUS1 + 1;
                WHEN "10" => Q1 := NS(7 DOWNTO 4); CSG <= "000"; STATUS1 <= STATUS1 + 1;WHEN "11" => Q1 := NS(3 DOWNTO 0); CSG <= "001"; STATUS1 <= "00";
                WHEN OTHERS => Q1 := EW(7 DOWNTO 4); CSG <= "110"; STATUS1 <= "00";
            END CASE;
            CASE Q1 IS
                WHEN "0000" => SEG <= "0111111"; WHEN "0001" => SEG <= "0000110"; WHEN "0010" => SEG <= "1011011"; WHEN "0011" => SEG <= "1001111"; --3
                WHEN "0100" => SEG <= "1100110"; WHEN "0101" => SEG <= "1101101"; WHEN "0110" => SEG <= "1111101"; WHEN "0111" => SEG <= "0000111"; --7
                WHEN "1000" => SEG <= "1111111"; WHEN "1001" => SEG <= "1101111"; WHEN OTHERS => SEG <= "0000000"; 
            END CASE;
        END IF;
    END PROCESS;

PROCESS(CLK1HZ,STAWE,WOK)
    BEGIN
        IF (WOK = '0') THEN--工作键工作
            IF RISING_EDGE(CLK1HZ) THEN
                IF (STAWE < 36 ) AND (STAWE >= 18) THEN Y1 <= '0'; R1 <= '0';G1 <= '1';--35-18秒绿灯
                ELSIF (STAWE < 18) AND (STAWE >=4) THEN Y1 <= '0'; R1 <= '1';G1 <= '0';--4 -17秒红灯
                ELSE  Y1 <= '1'; R1 <= '0';G1 <= '0';                                  --0 - 3秒黄灯
                END IF;
                --南北向灯差4秒                                                                       
                IF (STAWE < 32 ) AND (STAWE >= 14)  THEN Y2 <= '0'; R2 <= '0';G2 <= '1';--31-14秒绿灯
                ELSIF (STAWE < 14) AND (STAWE >= 0) THEN Y2 <= '0'; R2 <= '1';G2 <= '0';--0 -13秒红灯
                ELSE  Y2 <= '1'; R2 <= '0';G2 <= '0';                                   --32-35秒黄灯
                END IF;
            END IF;
        ELSE Y2 <= '0'; R2 <= '1';G2 <= '0';Y1 <= '0'; R1 <= '1';G1 <= '0';--交通管制红灯全亮
        END IF;     
   END PROCESS;    

    PROCESS(WOK)
    BEGIN
        IF (WOK= '1') THEN--工作键工作
         MOTOR<='1';PWM<='1';
         ELSE  MOTOR<='0'; PWM<='0';                                --32-35秒黄灯
         END IF;
   END PROCESS;
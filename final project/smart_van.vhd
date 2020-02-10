LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY SMART_van IS
PORT(
reset: IN STD_LOGIC;
  --重置，相当于重启，回到初始档位
clk: IN STD_LOGIC;
  --系统时钟
clk1: BUFFER STD_LOGIC;
  --时钟信号，以秒计时
--clk2: BUFFER STD_LOGIC;
  --时钟信号，以分钟计时
change_power: IN STD_LOGIC;
  --切换档位，按一下就下一档，低中高三挡
timer: IN STD_LOGIC_VECTOR (3 DOWNTO 0);
  --定时器，有30,60,90,120秒四个档位（为了方便将分钟改为了秒）
  --'0000'no timing,'0001'30 sec,'0010'60 sec,'0100'90 sec,'1000'120 sec
turning: IN BIT;
 --摇头功能，仅有LED显示

light_power: OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
  --显示工作档位
--time_light: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
  --显示定位时间
turning_light: OUT STD_LOGIC;
  --是否摇头
num1,num2,num3: OUT STD_LOGIC_VECTOR(6 DOWNTO 0));
  --计时倒计时
END smaRT_van;

ARCHITECTURE van OF smaRT_van IS
COMPONENT div_sec IS
PORT(
clk: IN STD_LOGIC;
clk1: OUT STD_LOGIC);
END COMPONENT;

TYPE state IS (s0,s1,s2);  --低中高三种风力
SIGNAL current_st, next_st: state;
SIGNAL rst_inside: STD_LOGIC;  --内部清零信号，用于定时器上
SIGNAL cnt: INTEGER RANGE 0 TO 120;

BEGIN

div : div_sec port map(clk=>clk,clk1=>clk1);

set_time:PROCESS(timer,clk1,reset)
VARIABLE hun,ten,ge: INTEGER RANGE 0 TO 9;
VARIABLE bi_hun,bi_ten,bi_ge: STD_LOGIC_VECTOR(2 DOWNTO 0); 
VARIABLE BCD_hun,BCD_ten,BCD_ge: STD_LOGIC_VECTOR(6 DOWNTO 0);  --对应BCD的vector
BEGIN
IF (reset='1') THEN 
rst_inside<='1';  --计时器清零，退出计时时的所有的工作状态
ELSIF clk1='1' AND clk1'EVENT THEN
	CASE timer IS
		WHEN "0000" => RST_inside<='0';
		WHEN ("0001") => cnt<=3;
			IF cnt=0 THEN rst_inside<='1';
			ELSE cnt<=cnt-1;
		END IF;
		WHEN "0010" => cnt<=6;
			IF cnt=0 THEN rst_inside<='1';
			ELSE cnt<=cnt-1;
		END IF;
		WHEN "0100" => cnt<=9;
			IF cnt=0 THEN rst_inside<='1';
			ELSE cnt<=cnt-1;
		END IF;
		WHEN "1000" => cnt<=12;
			IF cnt=0 THEN rst_inside<='1';
			ELSE cnt<=cnt-1;
		END IF;
		WHEN OTHERS => null;
	END CASE;
END IF;
hun:=cnt/100;
ten:=(cnt REM 100)/10;
ge:=(cnt REM 100) REM 10;
bi_hun:=CONV_STD_LOGIC_VECTOR(hun, 4);
bi_ten:=CONV_STD_LOGIC_VECTOR(ten, 4);
bi_ge:=CONV_STD_LOGIC_VECTOR(ge, 4);

--------七段译码器--------		
CASE bi_hun IS
	WHEN "0000" => BCD_hun := "1000000";---0
   WHEN "0001" => BCD_hun := "1111001";---1
   WHEN "0010" => BCD_hun := "0100100";---2
   WHEN "0011" => BCD_hun := "0110000";---3
	WHEN "0100" => BCD_hun := "0011001";---4
   WHEN "0101" => BCD_hun := "0010010";---5
   WHEN "0110" => BCD_hun := "0000010";---6
   WHEN "0111" => BCD_hun := "1111000";---7
   WHEN "1000" => BCD_hun := "0000000";---8
   WHEN "1001" => BCD_hun := "0010000";---9
   WHEN "1010" => BCD_hun := "0001000";---A
   WHEN "1011" => BCD_hun := "0000011";---B
   WHEN "1100" => BCD_hun := "1000110";---C
   WHEN "1101" => BCD_hun := "0100001";---D
   WHEN "1110" => BCD_hun := "0000110";---E
   WHEN "1111" => BCD_hun := "0001110";---F

END CASE;		
		
CASE bi_ten IS
	WHEN "0000" => BCD_ten := "1000000";---0
   WHEN "0001" => BCD_ten := "1111001";---1
   WHEN "0010" => BCD_ten := "0100100";---2
   WHEN "0011" => BCD_ten := "0110000";---3
	WHEN "0100" => BCD_ten := "0011001";---4
	WHEN "0101" => BCD_ten := "0010010";---5
   WHEN "0110" => BCD_ten := "0000010";---6
   WHEN "0111" => BCD_ten := "1111000";---7
   WHEN "1000" => BCD_ten := "0000000";---8
   WHEN "1001" => BCD_ten := "0010000";---9
   WHEN "1010" => BCD_ten := "0001000";---A
   WHEN "1011" => BCD_ten := "0000011";---B
   WHEN "1100" => BCD_ten := "1000110";---C
   WHEN "1101" => BCD_ten := "0100001";---D
   WHEN "1110" => BCD_ten := "0000110";---E
   WHEN "1111" => BCD_ten := "0001110";---F

END CASE;		

CASE bi_ge IS
   WHEN "0000" => BCD_ge := "1000000";---0
   WHEN "0001" => BCD_ge := "1111001";---1
   WHEN "0010" => BCD_ge := "0100100";---2
   WHEN "0011" => BCD_ge := "0110000";---3
	WHEN "0100" => BCD_ge := "0011001";---4
   WHEN "0101" => BCD_ge := "0010010";---5
   WHEN "0110" => BCD_ge := "0000010";---6
   WHEN "0111" => BCD_ge := "1111000";---7
   WHEN "1000" => BCD_ge := "0000000";---8
   WHEN "1001" => BCD_ge := "0010000";---9
   WHEN "1010" => BCD_ge := "0001000";---A
   WHEN "1011" => BCD_ge := "0000011";---B
   WHEN "1100" => BCD_ge := "1000110";---C
   WHEN "1101" => BCD_ge := "0100001";---D
   WHEN "1110" => BCD_ge := "0000110";---E
   WHEN "1111" => BCD_ge := "0001110";---F

END CASE;		

num1<=BCD_hun;
num2<=BCD_ten;
num3<=BCD_ge;
--time_light<=timer;
END PROCESS set_time;


REG:PROCESS(reset, change_power,rst_inside)   --状态控制台，reset恢复初始档位，change_power按一下就切换下一档位
BEGIN
IF (reset='1') THEN current_st<=s0;
ELSIF (rst_inside='1') THEN current_st<=s0;
ELSIF (change_power='1') AND change_power'EVENT THEN current_st<=next_st;
END IF;
END PROCESS REG;

COM:PROCESS(current_st)   --状态转换进程
BEGIN
CASE current_st IS
	WHEN s0=>next_st<=s1;
		light_power<="100";
	WHEN s1=>next_st<=s2;
		light_power<="010";
	WHEN s2=>next_st<=s0;
		light_power<="001";
END CASE;
END PROCESS COM;

turn:PROCESS(turning)  --摇头功能的提示
BEGIN
IF turning='1' THEN turning_light<='1';
ELSE turning_light<='0';
END IF;
END PROCESS turn;
END ARCHITECTURE van;
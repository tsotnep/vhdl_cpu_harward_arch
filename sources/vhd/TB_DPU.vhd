--***************************************************************************************************
 --*	Author: Tsotne Putkaradze, tsotnep@gmail.com
 --*	Professor: Peeter Ellervee
 --*	Lab Assitant: Siavoosh Payandeh Azad, Muhammad Adeel Tajammul
 --*	University: Tallinn Technical University, subject: IAY0340
 --*	Board: Nexys 2, Nexys 3
 --*	Manual of Board nexys 2: http://www.pld.ttu.ee/~alsu/DE_Nexys2.pdf
 --*	Manual of Board nexys 3: http://www.pld.ttu.ee/~alsu/DE_Nexys3.pdf
 --*	Description of Software:
 --*		Harvard architecture based CPU - test bench for data path of cpu
 --*
 --***************************************************************************************************/

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use std.textio.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY TB_DPU IS
END TB_DPU;
 
ARCHITECTURE behavior OF TB_DPU IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT DPU
    PORT(
         D_FrC_Data : IN  std_logic_vector(7 downto 0);
         D_FrM_Data : IN  std_logic_vector(7 downto 0);
         D_FrC_Command : IN  std_logic_vector(4 downto 0);
         D_FrC_MuxConData : IN  std_logic_vector(1 downto 0);
         D_FrC_RW : IN  std_logic;
         D_FrC_Address : IN  std_logic_vector(7 downto 0);
         D_ToC_FlagZ : OUT  std_logic;
         D_ToC_FlagOV : OUT  std_logic;
         D_ToC_JUMP : OUT  std_logic_vector(7 downto 0);
         D_ToM_Data : OUT  std_logic_vector(7 downto 0);
         D_ToM_Address : OUT  std_logic_vector(7 downto 0);
         D_ToM_RW : OUT  std_logic;
         rst : IN  std_logic;
         clk : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal D_FrC_Data : std_logic_vector(7 downto 0) := (others => '0');
   signal D_FrM_Data : std_logic_vector(7 downto 0) := (others => '0');
   signal D_FrC_Command : std_logic_vector(4 downto 0) := (others => '0');
   signal D_FrC_MuxConData : std_logic_vector(1 downto 0) := (others => '0');
   signal D_FrC_RW : std_logic := '0';
   signal D_FrC_Address : std_logic_vector(7 downto 0) := (others => '0');
   signal rst : std_logic := '0';
   signal clk : std_logic := '0';
	
 	--Outputs
   signal D_ToC_FlagZ : std_logic;
   signal D_ToC_FlagOV : std_logic;
   signal D_ToC_JUMP : std_logic_vector(7 downto 0);
   signal D_ToM_Data : std_logic_vector(7 downto 0);
   signal D_ToM_Address : std_logic_vector(7 downto 0);
   signal D_ToM_RW : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: DPU PORT MAP (
          D_FrC_Data => D_FrC_Data,
          D_FrM_Data => D_FrM_Data,
          D_FrC_Command => D_FrC_Command,
          D_FrC_MuxConData => D_FrC_MuxConData,
          D_FrC_RW => D_FrC_RW,
          D_FrC_Address => D_FrC_Address,
          D_ToC_FlagZ => D_ToC_FlagZ,
          D_ToC_FlagOV => D_ToC_FlagOV,
          D_ToC_JUMP => D_ToC_JUMP,
          D_ToM_Data => D_ToM_Data,
          D_ToM_Address => D_ToM_Address,
          D_ToM_RW => D_ToM_RW,
          rst => rst,
          clk => clk
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 10 ns;
		rst <= '1';
		wait for 10 ns;
		rst <= '0';
		wait for 10 ns;
		
	D_FrC_Data <= "00000000";
	D_FrM_Data <= "00000000";
	D_FrC_Command <= "00000";
	D_FrC_MuxConData <= "00";
	D_FrC_RW <= '0';
	D_FrC_Address <= "00000000";
	wait for 10 ns;
	wait for 5 ns;	
	
      -- insert stimulus here 
		
			-- START Arithmetic and Logic Shift Left
			D_FrC_Data <= "10011001"; -- writing numb in B
			D_FrC_Command <= "00001"; -- adding B to ACC
			wait for 10 ns;
			
--			D_FrC_Command <= "01111"; -- shifting it right, arithmetically
--			wait for 10 ns;
			D_FrC_Command <= "01110"; -- shifting it left, arithmetically
			wait for 10 ns;

--			D_FrC_Command <= "01100"; -- shifting it right, logically
--			wait for 10 ns;
--			D_FrC_Command <= "01101"; -- shifting it left, logically
--			wait for 10 ns;
			
			
			D_FrC_Command <= "00000"; -- NOP
			wait for 10 ns;
			-- END
--
--
-- just UNCOMMENT Tests one by one, in the beginning you will see test description
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-----------------------------WORKING STUFF/TESTS----------------------------------
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------

--			--START testing Increment/Decrement/FlagOV/FlagZ  - WORKING
--			-- at the begining zero flag should show us 1 cuz ACC is reseted zero
--			D_FrC_Data <= "01111111"; -- send data (127) in DPU from CU (control unit)		
--			D_FrC_MuxConData <= "00"; -- turn B as data-mediator of CU (it means, it receivs data from CU)
--			D_FrC_Command <= "00001"; -- adding B to ACC				(!!!!!OVerflow FLAG SHOULD SHOW US '0')
--			wait for 10 ns; 				-- ACC is 127
--			--assert (D_ToM_Data =  "01111111") report "ACC 1 OK" severity note;
--			assert (D_ToC_FlagOV = '0' ) report "Flag OV 1 OK" severity note;
--			
--			D_FrC_MuxConData <= "10"; -- turn B as Increment (1)
--			D_FrC_Command <= "00001"; -- add B to ACC 				(!!!!!OVerflow FLAG SHOULD SHOW US '1')
--			wait for 10 ns; 				-- ACC is -128
--			--assert (D_ToM_Data =  "10000000") report "ACC 2 OK" severity note;
--			assert (D_ToC_FlagOV = '1' ) report "Flag OV 2 OK" severity note;
--			
--			D_FrC_Command <= "00001"; -- add B to ACC again 		(!!!!!OVerflow FLAG SHOULD SHOW US '0')
--			wait for 10 ns;				-- ACC is -127
--			--assert (D_ToM_Data =  "10000001") report "ACC 3 OK" severity note;
--			assert (D_ToC_FlagOV = '0' ) report "Flag OV 3 OK" severity note;
--			
--			D_FrC_MuxConData <= "11"; -- turn B as Decrement (-1)
--			D_FrC_Command <= "00001"; -- add B to ACC					(!!!!!OVerflow FLAG SHOULD SHOW US '0')
--			wait for 10 ns;				-- ACC is -128
--			--assert (D_ToM_Data =  "10000000") report "ACC 4 OK" severity note;
--			assert (D_ToC_FlagOV = '0' ) report "Flag OV 4 OK" severity note;
--			
--			D_FrC_Command <= "00001"; -- add B to ACC again 		(!!!!!OVerflow FLAG SHOULD SHOW US '1')
--			wait for 10 ns;				-- ACC is 127
--			--assert (D_ToM_Data =  "01111111") report "ACC 5 OK final" severity note;
--			assert (D_ToC_FlagOV = '1' ) report "Flag OV 5 OK final" severity note;
--			
--			D_FrC_Command <= "10001"; -- clear ACC 					(!!!!!ZERO FLAG SHOULD SHOW US '1')
--			wait for 10 ns;
--			assert (D_ToC_FlagZ = '1' ) report "Flag Z 1 OK" severity error;		
--			
--			D_FrC_Data <= "00000001"; -- send data (1) in DPU from CU	
--			D_FrC_MuxConData <= "00"; -- turn B as data-mediator of CU
--			D_FrC_Command <= "00001"; -- add B to ACC 				(!!!!!ZERO FLAG SHOULD SHOW US '0')
--			wait for 10 ns;
--			assert (D_ToC_FlagZ = '0' ) report "Flag Z 2 OK" severity error;
--			
--			D_FrC_MuxConData <= "11"; -- turn B as Decrement (-1)
--			D_FrC_Command <= "00001"; -- add B to ACC 				(!!!!!ZERO FLAG SHOULD SHOW US '1')
--			wait for 10 ns;
--			assert (D_ToC_FlagZ = '1' ) report "Flag Z 3 OK" severity error;
--			
--			D_FrC_Command <= "00001"; -- add B to ACC again			(!!!!!ZERO FLAG SHOULD SHOW US '0')
--			wait for 10 ns;
--			assert (D_ToC_FlagZ = '0' ) report "Flag Z 4 OK" severity error;
--			
--			D_FrC_Command <= "00000"; -- no operation
--			wait for 10 ns;
----			END 


--			-- START BYPASSING "B" - WORKING
--			D_FrC_Data <= "00000011"; -- writing numb in B
--			D_FrC_Command <= "00001"; -- adding B to ACC
--			wait for 10 ns;
--			D_FrC_Command <= "11011"; -- writing ACC in B / bypassing
--			wait for 10 ns;
--			-- END


			
--			-- START NOT then XOR - WORKING
--			D_FrC_Data <= "00000011"; -- sending logic vector to B
--			D_FrC_Command <= "00001"; -- adding B to ACC
--			wait for 10 ns;
--			D_FrC_Command <= "01010"; -- NOT-ing ACC it will be "11111100"
--			wait for 10 ns;
--			D_FrC_Data <= "00001111"; -- sending another logic vector to B
--			D_FrC_Command <= "01001"; -- XORing B and ACC (ACC should be "11110011")
--			wait for 10 ns;
--			D_FrC_Command <= "00000"; -- NOP
--			wait for 10 ns;
--			-- END
			
      wait;
   end process;

END;

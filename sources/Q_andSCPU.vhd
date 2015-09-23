--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:29:17 12/17/2014
-- Design Name:   
-- Module Name:   C:/Users/Tsotne/Desktop/Tsotne_CPU_DONE_fixed_01.12.2014/CPU_Tsotne_DONE_1.12.2014-3clockPIPE/Q_andSCPU.vhd
-- Project Name:  CPU
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Control
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY Q_andSCPU IS
END Q_andSCPU;
 
ARCHITECTURE behavior OF Q_andSCPU IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Control
    PORT(
         output : OUT  std_logic_vector(7 downto 0);
         OUTLeft3bit : OUT  std_logic_vector(2 downto 0);
         AN : OUT  std_logic_vector(3 downto 0);
         SS : OUT  std_logic_vector(7 downto 0);
         rst : IN  std_logic;
         realCLK : IN  std_logic;
         clkBtn : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal rst : std_logic := '1';
   signal realCLK : std_logic := '0';
   signal clkBtn : std_logic := '0';

 	--Outputs
   signal output : std_logic_vector(7 downto 0);
   signal OUTLeft3bit : std_logic_vector(2 downto 0);
   signal AN : std_logic_vector(3 downto 0);
   signal SS : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant realCLK_period : time := 10 ns;
   constant clkBtn_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Control PORT MAP (
          output => output,
          OUTLeft3bit => OUTLeft3bit,
          AN => AN,
          SS => SS,
          rst => rst,
          realCLK => realCLK,
          clkBtn => clkBtn
        );

   -- Clock process definitions
   realCLK_process :process
   begin
		realCLK <= '0';
		wait for realCLK_period/2;
		realCLK <= '1';
		wait for realCLK_period/2;
   end process;
 
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		rst <=	'0';

		clkBtn <= '1'; 
		wait for 400 ns;
		clkBtn <= '0'; 
		wait for 400 ns;

		clkBtn <= '1'; 
		wait for 400 ns;
		clkBtn <= '0'; 
		wait for 400 ns;

		clkBtn <= '1'; 
		wait for 400 ns;
		clkBtn <= '0'; 
		wait for 400 ns;

		clkBtn <= '1'; 
		wait for 400 ns;
		clkBtn <= '0'; 
		wait for 400 ns;

		clkBtn <= '1'; 
		wait for 400 ns;
		clkBtn <= '0'; 
		wait for 400 ns;

		clkBtn <= '1'; 
		wait for 400 ns;
		clkBtn <= '0'; 
		wait for 400 ns;

		clkBtn <= '1'; 
		wait for 400 ns;
		clkBtn <= '0'; 
		wait for 400 ns;

		clkBtn <= '1'; 
		wait for 400 ns;
		clkBtn <= '0'; 
		wait for 400 ns;

		clkBtn <= '1'; 
		wait for 400 ns;
		clkBtn <= '0'; 
		wait for 400 ns;

		clkBtn <= '1'; 
		wait for 400 ns;
		clkBtn <= '0'; 
		wait for 400 ns;

		clkBtn <= '1'; 
		wait for 400 ns;
		clkBtn <= '0'; 
		wait for 400 ns;

		clkBtn <= '1'; 
		wait for 400 ns;
		clkBtn <= '0'; 
		wait for 400 ns;

		clkBtn <= '1'; 
		wait for 400 ns;
		clkBtn <= '0'; 
		wait for 400 ns;

		clkBtn <= '1'; 
		wait for 400 ns;
		clkBtn <= '0'; 
		wait for 400 ns;

		clkBtn <= '1'; 
		wait for 400 ns;
		clkBtn <= '0'; 
		wait for 400 ns;

		clkBtn <= '1'; 
		wait for 400 ns;
		clkBtn <= '0'; 
		wait for 400 ns;

		clkBtn <= '1'; 
		wait for 400 ns;
		clkBtn <= '0'; 
		wait for 400 ns;

		clkBtn <= '1'; 
		wait for 400 ns;
		clkBtn <= '0'; 
		wait for 400 ns;

		clkBtn <= '1'; 
		wait for 400 ns;
		clkBtn <= '0'; 
		wait for 400 ns;

		clkBtn <= '1'; 
		wait for 400 ns;
		clkBtn <= '0'; 
		wait for 400 ns;

		clkBtn <= '1'; 
		wait for 400 ns;
		clkBtn <= '0'; 
		wait for 400 ns;

		clkBtn <= '1'; 
		wait for 400 ns;
		clkBtn <= '0'; 
		wait for 400 ns;

		clkBtn <= '1'; 
		wait for 400 ns;
		clkBtn <= '0'; 
		wait for 400 ns;

		clkBtn <= '1'; 
		wait for 400 ns;
		clkBtn <= '0'; 
		wait for 400 ns;

		clkBtn <= '1'; 
		wait for 400 ns;
		clkBtn <= '0'; 
		wait for 400 ns;

		clkBtn <= '1'; 
		wait for 400 ns;
		clkBtn <= '0'; 
		wait for 400 ns;

		clkBtn <= '1'; 
		wait for 400 ns;
		clkBtn <= '0'; 
		wait for 400 ns;

		clkBtn <= '1'; 
		wait for 400 ns;
		clkBtn <= '0'; 
		wait for 400 ns;

		clkBtn <= '1'; 
		wait for 400 ns;
		clkBtn <= '0'; 
		wait for 400 ns;

		clkBtn <= '1'; 
		wait for 400 ns;
		clkBtn <= '0'; 
		wait for 400 ns;

		clkBtn <= '1'; 
		wait for 400 ns;
		clkBtn <= '0'; 
		wait for 400 ns;

		clkBtn <= '1'; 
		wait for 400 ns;
		clkBtn <= '0'; 
		wait for 400 ns;

		clkBtn <= '1'; 
		wait for 400 ns;
		clkBtn <= '0'; 
		wait for 400 ns;

		clkBtn <= '1'; 
		wait for 400 ns;
		clkBtn <= '0'; 
		wait for 400 ns;

		clkBtn <= '1'; 
		wait for 400 ns;
		clkBtn <= '0'; 
		wait for 400 ns;

		clkBtn <= '1'; 
		wait for 400 ns;
		clkBtn <= '0'; 
		wait for 400 ns;

		clkBtn <= '1'; 
		wait for 400 ns;
		clkBtn <= '0'; 
		wait for 400 ns;

		clkBtn <= '1'; 
		wait for 400 ns;
		clkBtn <= '0'; 
		wait for 400 ns;

		clkBtn <= '1'; 
		wait for 400 ns;
		clkBtn <= '0'; 
		wait for 400 ns;

		clkBtn <= '1'; 
		wait for 400 ns;
		clkBtn <= '0'; 
		wait for 400 ns;

		clkBtn <= '1'; 
		wait for 400 ns;
		clkBtn <= '0'; 
		wait for 400 ns;

		clkBtn <= '1'; 
		wait for 400 ns;
		clkBtn <= '0'; 
		wait for 400 ns;

		clkBtn <= '1'; 
		wait for 400 ns;
		clkBtn <= '0'; 
		wait for 400 ns;

		clkBtn <= '1'; 
		wait for 400 ns;
		clkBtn <= '0'; 
		wait for 400 ns;

		clkBtn <= '1'; 
		wait for 400 ns;
		clkBtn <= '0'; 
		wait for 400 ns;

		clkBtn <= '1'; 
		wait for 400 ns;
		clkBtn <= '0'; 
		wait for 400 ns;

		clkBtn <= '1'; 
		wait for 400 ns;
		clkBtn <= '0'; 
		wait for 400 ns;

		clkBtn <= '1'; 
		wait for 400 ns;
		clkBtn <= '0'; 
		wait for 400 ns;

		clkBtn <= '1'; 
		wait for 400 ns;
		clkBtn <= '0'; 
		wait for 400 ns;

		clkBtn <= '1'; 
		wait for 400 ns;
		clkBtn <= '0'; 
		wait for 400 ns;

		clkBtn <= '1'; 
		wait for 400 ns;
		clkBtn <= '0'; 
		wait for 400 ns;

		clkBtn <= '1'; 
		wait for 400 ns;
		clkBtn <= '0'; 
		wait for 400 ns;

		clkBtn <= '1'; 
		wait for 400 ns;
		clkBtn <= '0'; 
		wait for 400 ns;

		clkBtn <= '1'; 
		wait for 400 ns;
		clkBtn <= '0'; 
		wait for 400 ns;

		clkBtn <= '1'; 
		wait for 400 ns;
		clkBtn <= '0'; 
		wait for 400 ns;

		clkBtn <= '1'; 
		wait for 400 ns;
		clkBtn <= '0'; 
		wait for 400 ns;

		clkBtn <= '1'; 
		wait for 400 ns;
		clkBtn <= '0'; 
		wait for 400 ns;

		clkBtn <= '1'; 
		wait for 400 ns;
		clkBtn <= '0'; 
		wait for 400 ns;

		clkBtn <= '1'; 
		wait for 400 ns;
		clkBtn <= '0'; 
		wait for 400 ns;

		clkBtn <= '1'; 
		wait for 400 ns;
		clkBtn <= '0'; 
		wait for 400 ns;

		clkBtn <= '1'; 
		wait for 400 ns;
		clkBtn <= '0'; 
		wait for 400 ns;

		clkBtn <= '1'; 
		wait for 400 ns;
		clkBtn <= '0'; 
		wait for 400 ns;

		clkBtn <= '1'; 
		wait for 400 ns;
		clkBtn <= '0'; 
		wait for 400 ns;

		clkBtn <= '1'; 
		wait for 400 ns;
		clkBtn <= '0'; 
		wait for 400 ns;

		clkBtn <= '1'; 
		wait for 400 ns;
		clkBtn <= '0'; 
		wait for 400 ns;

		clkBtn <= '1'; 
		wait for 400 ns;
		clkBtn <= '0'; 
		wait for 400 ns;

		clkBtn <= '1'; 
		wait for 400 ns;
		clkBtn <= '0'; 
		wait for 400 ns;

		clkBtn <= '1'; 
		wait for 400 ns;
		clkBtn <= '0'; 
		wait for 400 ns;

		clkBtn <= '1'; 
		wait for 400 ns;
		clkBtn <= '0'; 
		wait for 400 ns;

		clkBtn <= '1'; 
		wait for 400 ns;
		clkBtn <= '0'; 
		wait for 400 ns;

		clkBtn <= '1'; 
		wait for 400 ns;
		clkBtn <= '0'; 
		wait for 400 ns;

		clkBtn <= '1'; 
		wait for 400 ns;
		clkBtn <= '0'; 
		wait for 400 ns;

		clkBtn <= '1'; 
		wait for 400 ns;
		clkBtn <= '0'; 
		wait for 400 ns;

		clkBtn <= '1'; 
		wait for 400 ns;
		clkBtn <= '0'; 
		wait for 400 ns;

		clkBtn <= '1'; 
		wait for 400 ns;
		clkBtn <= '0'; 
		wait for 400 ns;
		

		clkBtn <= '1'; 
		wait for 400 ns;
		clkBtn <= '0'; 
		wait for 400 ns;

		clkBtn <= '1'; 
		wait for 400 ns;
		clkBtn <= '0'; 
		wait for 400 ns;

		clkBtn <= '1'; 
		wait for 400 ns;
		clkBtn <= '0'; 
		wait for 400 ns;

		clkBtn <= '1'; 
		wait for 400 ns;
		clkBtn <= '0'; 
		wait for 400 ns;

		clkBtn <= '1'; 
		wait for 400 ns;
		clkBtn <= '0'; 
		wait for 400 ns;

		clkBtn <= '1'; 
		wait for 400 ns;
		clkBtn <= '0'; 
		wait for 400 ns;

		clkBtn <= '1'; 
		wait for 400 ns;
		clkBtn <= '0'; 
		wait for 400 ns;

		clkBtn <= '1'; 
		wait for 400 ns;
		clkBtn <= '0'; 
		wait for 400 ns;

		clkBtn <= '1'; 
		wait for 400 ns;
		clkBtn <= '0'; 
		wait for 400 ns;

		clkBtn <= '1'; 
		wait for 400 ns;
		clkBtn <= '0'; 
		wait for 400 ns;

		clkBtn <= '1'; 
		wait for 400 ns;
		clkBtn <= '0'; 
		wait for 400 ns;

		clkBtn <= '1'; 
		wait for 400 ns;
		clkBtn <= '0'; 
		wait for 400 ns;

		clkBtn <= '1'; 
		wait for 400 ns;
		clkBtn <= '0'; 
		wait for 400 ns;

		clkBtn <= '1'; 
		wait for 400 ns;
		clkBtn <= '0'; 
		wait for 400 ns;

		clkBtn <= '1'; 
		wait for 400 ns;
		clkBtn <= '0'; 
		wait for 400 ns;
		
      wait;
   end process;

END;

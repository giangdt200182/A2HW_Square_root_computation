
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_nios_system_e is

-------------------------------------------------------------------------------
--							 Port Declarations							 --
-------------------------------------------------------------------------------
port (
	-- Inputs
	CLOCK_50			: in std_logic;
	KEY				  	: in std_logic_vector (3 downto 0);
	SW				   	: in std_logic_vector (9 downto 0);

	--  Communication
	UART_RXD			: in std_logic;

	-- Bidirectionals
	GPIO_0				: inout std_logic_vector (31 downto 0);
	GPIO_1				: inout std_logic_vector (31 downto 0);

	--  Memory (SRAM)
	SRAM_DQ				: inout std_logic_vector (15 downto 0);
		
	-- Memory (SDRAM)
	DRAM_DQ				: inout std_logic_vector (15 downto 0);

	-- Outputs
	--  Simple
	LEDG				: out std_logic_vector (7 downto 0);
	LEDR				: out std_logic_vector (9 downto 0);

	HEX0				: out std_logic_vector (7 downto 0);
	HEX1				: out std_logic_vector (7 downto 0);
	HEX2				: out std_logic_vector (7 downto 0);
	HEX3				: out std_logic_vector (7 downto 0);
	
	--  Memory (SRAM)
	SRAM_ADDR			: out std_logic_vector (17 downto 0);
	SRAM_CE_N			: out std_logic;
	SRAM_LB_N			: out std_logic;
	SRAM_UB_N			: out std_logic;
	SRAM_OE_N			: out std_logic;
	SRAM_WE_N			: out std_logic;

	--  Communication
	UART_TXD			: out std_logic;
	
	-- Memory (SDRAM)
	DRAM_ADDR			: out std_logic_vector (11 downto 0);
	DRAM_BA_1			: buffer std_logic;
	DRAM_BA_0			: buffer std_logic;
	DRAM_CAS_N			: out std_logic;
	DRAM_RAS_N			: out std_logic;
	DRAM_CLK			: out std_logic;
	DRAM_CKE			: out std_logic;
	DRAM_CS_N			: out std_logic;
	DRAM_WE_N			: out std_logic;
	DRAM_UDQM			: buffer std_logic;
	DRAM_LDQM			: buffer std_logic

	);
end top_nios_system;


architecture top_nios_system_rtl of top_nios_system_e is

-------------------------------------------------------------------------------
--						   Subentity Declarations						  --
-------------------------------------------------------------------------------
      component NIOS_SYSTEM_e is
        port (
            clk_clk       : in    std_logic                     := 'X';             -- clk
            reset_reset_n : in    std_logic                     := 'X';             -- reset_n
            sram_DQ       : inout std_logic_vector(15 downto 0) := (others => 'X'); -- DQ
            sram_ADDR     : out   std_logic_vector(17 downto 0);                    -- ADDR
            sram_LB_N     : out   std_logic;                                        -- LB_N
            sram_UB_N     : out   std_logic;                                        -- UB_N
            sram_CE_N     : out   std_logic;                                        -- CE_N
            sram_OE_N     : out   std_logic;                                        -- OE_N
            sram_WE_N     : out   std_logic;                                        -- WE_N
            sdram_clk_clk : out   std_logic;                                        -- clk
            pio_0_export  : in    std_logic_vector(9 downto 0)  := (others => 'X'); -- export
            pio_1_export  : out   std_logic_vector(9 downto 0);                     -- export
            sdram_addr    : out   std_logic_vector(11 downto 0);                    -- addr
            sdram_ba      : out   std_logic_vector(1 downto 0);                     -- ba
            sdram_cas_n   : out   std_logic;                                        -- cas_n
            sdram_cke     : out   std_logic;                                        -- cke
            sdram_cs_n    : out   std_logic;                                        -- cs_n
            sdram_dq      : inout std_logic_vector(15 downto 0) := (others => 'X'); -- dq
            sdram_dqm     : out   std_logic_vector(1 downto 0);                     -- dqm
            sdram_ras_n   : out   std_logic;                                        -- ras_n
            sdram_we_n    : out   std_logic                                         -- we_n
        );
    end component NIOS_SYSTEM_e;
	
-- component sqrt

		-- generic(nb_bits : natural:=16); -- Number of bits of the square root result
		-- port(	X : in std_logic_vector(31 downto 0);
				-- start : in std_logic;
				-- clk, reset : in std_logic;
				-- Result : out std_logic_vector(15 downto 0);
				-- done : out std_logic);

-- end component;

-------------------------------------------------------------------------------
--						   Parameter Declarations						  --
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
--				 Internal Wires and Registers Declarations				 --
-------------------------------------------------------------------------------
-- Internal Wires
-- Used to connect the Nios 2 system clock to the non-shifted output of the PLL
signal			 system_clock : STD_LOGIC;

signal sig_X : std_logic_vector(31 downto 0);
signal sig_Res : std_logic_vector(15 downto 0);
signal sig_done, sig_start, sig_reset : std_logic;


-- Used to concatenate some SDRAM control signals

signal			 DRAM_BA	: STD_LOGIC_VECTOR(1 DOWNTO 0);
signal			 DRAM_DQM	: STD_LOGIC_VECTOR(1 DOWNTO 0);


-- Internal Registers

-- State Machine Registers

begin

-------------------------------------------------------------------------------
--						 Finite State Machine(s)						   --
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
--							 Sequential Logic							  --
-------------------------------------------------------------------------------
	
-------------------------------------------------------------------------------
--							Combinational Logic							--
-------------------------------------------------------------------------------


DRAM_BA_1	<= DRAM_BA(1);
DRAM_BA_0	<= DRAM_BA(0);
DRAM_UDQM	<= DRAM_DQM(1);
DRAM_LDQM	<= DRAM_DQM(0);

-------------------------------------------------------------------------------
--							  Internal Modules							 --
-------------------------------------------------------------------------------

	u0 : component NIOS_SYSTEM_e
        port map (
            clk_clk       => CLOCK_50,       --       clk.clk
            reset_reset_n => KEY(0), --     reset.reset_n
            sram_DQ       => sram_DQ,       --      sram.DQ
            sram_ADDR     => sram_ADDR,     --          .ADDR
            sram_LB_N     => sram_LB_N,     --          .LB_N
            sram_UB_N     => sram_UB_N,     --          .UB_N
            sram_CE_N     => sram_CE_N,     --          .CE_N
            sram_OE_N     => sram_OE_N,     --          .OE_N
            sram_WE_N     => sram_WE_N,     --          .WE_N
            sdram_clk_clk => DRAM_CLK, -- sdram_clk.clk
            pio_0_export  => SW,  --     pio_0.export
            pio_1_export  => LEDR,  --     pio_1.export
            sdram_addr    => dram_addr,    --     sdram.addr
            sdram_ba      => dram_ba,      --          .ba
            sdram_cas_n   => dram_cas_n,   --          .cas_n
            sdram_cke     => dram_cke,     --          .cke
            sdram_cs_n    => dram_cs_n,    --          .cs_n
            sdram_dq      => dram_dq,      --          .dq
            sdram_dqm     => dram_dqm,     --          .dqm
            sdram_ras_n   => dram_ras_n,   --          .ras_n
            sdram_we_n    => dram_we_n     --          .we_n
        );

--square_root: sqrt
--	generic map (nb_bits => 16)
--	port map (X => sig_X,
--				start => sig_start,
--				clk => CLOCK_50,
--				reset => sig_reset,
--				Result => sig_Res,
--				done => sig_done
--	);
--	
--	sig_reset <= not KEY(0); -- if reset is active high, else sig_reset <= KEY(0);

end top_nios_system_rtl;


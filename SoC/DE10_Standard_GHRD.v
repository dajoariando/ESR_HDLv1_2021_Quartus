/*
	The SPI bus of the ADC-AD9276 has problems, i.e. cannot drive the CSB (chip select pin) with driver, but it works without anything connected. The pin itself is driven low by the pull-down resistor in the PCB, so according to datasheet, the SPI is always on by default even without driving CSB. Problem arises when the chip is tried to be driven LOW by the FPGA SPI. This problem might be fixed (not tested, though) by having high-Z state when the chip is supposed to be driven LOW, instead of hard-LOW, by the FPGA. 
*/

`define ENABLE_HPS
//`define ENABLE_HSMC

module DE10_Standard_GHRD(

	///////// CLOCK /////////
	input              CLOCK2_50,
	input              CLOCK3_50,
	input              CLOCK4_50,
	input              CLOCK_50,

	///////// KEY /////////
	input    [ 3: 0]   KEY,

	///////// SW /////////
	input    [ 9: 0]   SW,

	///////// LED /////////
	output   [ 9: 0]   LEDR,

	///////// Seg7 /////////
	output   [ 6: 0]   HEX0,
	output   [ 6: 0]   HEX1,
	output   [ 6: 0]   HEX2,
	output   [ 6: 0]   HEX3,
	output   [ 6: 0]   HEX4,
	output   [ 6: 0]   HEX5,

	///////// SDRAM /////////
	output             DRAM_CLK,
	output             DRAM_CKE,
	output   [12: 0]   DRAM_ADDR,
	output   [ 1: 0]   DRAM_BA,
	inout    [15: 0]   DRAM_DQ,
	output             DRAM_LDQM,
	output             DRAM_UDQM,
	output             DRAM_CS_N,
	output             DRAM_WE_N,
	output             DRAM_CAS_N,
	output             DRAM_RAS_N,

	///////// Video-In /////////
	input              TD_CLK27,
	input              TD_HS,
	input              TD_VS,
	input    [ 7: 0]   TD_DATA,
	output             TD_RESET_N,

	///////// VGA /////////
	output             VGA_CLK,
	output             VGA_HS,
	output             VGA_VS,
	output   [ 7: 0]   VGA_R,
	output   [ 7: 0]   VGA_G,
	output   [ 7: 0]   VGA_B,
	output             VGA_BLANK_N,
	output             VGA_SYNC_N,

	///////// Audio /////////
	inout              AUD_BCLK,
	output             AUD_XCK,
	inout              AUD_ADCLRCK,
	input              AUD_ADCDAT,
	inout              AUD_DACLRCK,
	output             AUD_DACDAT,

	///////// PS2 /////////
	inout              PS2_CLK,
	inout              PS2_CLK2,
	inout              PS2_DAT,
	inout              PS2_DAT2,

	///////// ADC /////////
	output             ADC_SCLK,
	input              ADC_DOUT,
	output             ADC_DIN,
	output             ADC_CONVST,

	///////// I2C for Audio and Video-In /////////
	output             FPGA_I2C_SCLK,
	inout              FPGA_I2C_SDAT,

	///////// GPIO /////////
	inout    [35: 0]   GPIO,


`ifdef ENABLE_HPS
	///////// HPS /////////
	inout              HPS_CONV_USB_N,
	output      [14:0] HPS_DDR3_ADDR,
	output      [2:0]  HPS_DDR3_BA,
	output             HPS_DDR3_CAS_N,
	output             HPS_DDR3_CKE,
	output             HPS_DDR3_CK_N,
	output             HPS_DDR3_CK_P,
	output             HPS_DDR3_CS_N,
	output      [3:0]  HPS_DDR3_DM,
	inout       [31:0] HPS_DDR3_DQ,
	inout       [3:0]  HPS_DDR3_DQS_N,
	inout       [3:0]  HPS_DDR3_DQS_P,
	output             HPS_DDR3_ODT,
	output             HPS_DDR3_RAS_N,
	output             HPS_DDR3_RESET_N,
	input              HPS_DDR3_RZQ,
	output             HPS_DDR3_WE_N,
	output             HPS_ENET_GTX_CLK,
	inout              HPS_ENET_INT_N,
	output             HPS_ENET_MDC,
	inout              HPS_ENET_MDIO,
	input              HPS_ENET_RX_CLK,
	input       [3:0]  HPS_ENET_RX_DATA,
	input              HPS_ENET_RX_DV,
	output      [3:0]  HPS_ENET_TX_DATA,
	output             HPS_ENET_TX_EN,
	inout       [3:0]  HPS_FLASH_DATA,
	output             HPS_FLASH_DCLK,
	output             HPS_FLASH_NCSO,
	inout              HPS_GSENSOR_INT,
	inout              HPS_I2C1_SCLK,
	inout              HPS_I2C1_SDAT,
	inout              HPS_I2C2_SCLK,
	inout              HPS_I2C2_SDAT,
	inout              HPS_I2C_CONTROL,
	inout              HPS_KEY,
	inout              HPS_LCM_BK,
	inout              HPS_LCM_D_C,
	inout              HPS_LCM_RST_N,
	output             HPS_LCM_SPIM_CLK,
	output             HPS_LCM_SPIM_MOSI,
	output             HPS_LCM_SPIM_SS,
	input				HPS_LCM_SPIM_MISO,
	inout              HPS_LED,
	inout              HPS_LTC_GPIO,
	output             HPS_SD_CLK,
	inout              HPS_SD_CMD,
	inout       [3:0]  HPS_SD_DATA,
	output             HPS_SPIM_CLK,
	input              HPS_SPIM_MISO,
	output             HPS_SPIM_MOSI,
	inout              HPS_SPIM_SS,
	input              HPS_UART_RX,
	output             HPS_UART_TX,
	input              HPS_USB_CLKOUT,
	inout       [7:0]  HPS_USB_DATA,
	input              HPS_USB_DIR,
	input              HPS_USB_NXT,
	output             HPS_USB_STP,
`endif /*ENABLE_HPS*/

	///////// IR /////////
	output             IRDA_TXD,
	input              IRDA_RXD

);
	
	// default signaling
	wire  hps_fpga_reset_n;
	wire [3:0] KEY_debounced;
	wire [2:0]  hps_reset_req;
	wire        hps_cold_reset;
	wire        hps_warm_reset;
	wire        hps_debug_reset;
	wire [27:0] stm_hw_events;





  
	// System-on-Chip
	soc_system u0 (      
		.clk_clk                               (CLOCK_50),                             //                clk.clk
		.reset_reset_n                         (1'b1),                                 //                reset.reset_n
		//HPS ddr3
		.memory_mem_a                          ( HPS_DDR3_ADDR),                       //                memory.mem_a
		.memory_mem_ba                         ( HPS_DDR3_BA),                         //                .mem_ba
		.memory_mem_ck                         ( HPS_DDR3_CK_P),                       //                .mem_ck
		.memory_mem_ck_n                       ( HPS_DDR3_CK_N),                       //                .mem_ck_n
		.memory_mem_cke                        ( HPS_DDR3_CKE),                        //                .mem_cke
		.memory_mem_cs_n                       ( HPS_DDR3_CS_N),                       //                .mem_cs_n
		.memory_mem_ras_n                      ( HPS_DDR3_RAS_N),                      //                .mem_ras_n
		.memory_mem_cas_n                      ( HPS_DDR3_CAS_N),                      //                .mem_cas_n
		.memory_mem_we_n                       ( HPS_DDR3_WE_N),                       //                .mem_we_n
		.memory_mem_reset_n                    ( HPS_DDR3_RESET_N),                    //                .mem_reset_n
		.memory_mem_dq                         ( HPS_DDR3_DQ),                         //                .mem_dq
		.memory_mem_dqs                        ( HPS_DDR3_DQS_P),                      //                .mem_dqs
		.memory_mem_dqs_n                      ( HPS_DDR3_DQS_N),                      //                .mem_dqs_n
		.memory_mem_odt                        ( HPS_DDR3_ODT),                        //                .mem_odt
		.memory_mem_dm                         ( HPS_DDR3_DM),                         //                .mem_dm
		.memory_oct_rzqin                      ( HPS_DDR3_RZQ),                        //                .oct_rzqin
		//HPS ethernet		
		.hps_0_hps_io_hps_io_emac1_inst_TX_CLK ( HPS_ENET_GTX_CLK),       //                             hps_0_hps_io.hps_io_emac1_inst_TX_CLK
		.hps_0_hps_io_hps_io_emac1_inst_TXD0   ( HPS_ENET_TX_DATA[0] ),   //                             .hps_io_emac1_inst_TXD0
		.hps_0_hps_io_hps_io_emac1_inst_TXD1   ( HPS_ENET_TX_DATA[1] ),   //                             .hps_io_emac1_inst_TXD1
		.hps_0_hps_io_hps_io_emac1_inst_TXD2   ( HPS_ENET_TX_DATA[2] ),   //                             .hps_io_emac1_inst_TXD2
		.hps_0_hps_io_hps_io_emac1_inst_TXD3   ( HPS_ENET_TX_DATA[3] ),   //                             .hps_io_emac1_inst_TXD3
		.hps_0_hps_io_hps_io_emac1_inst_RXD0   ( HPS_ENET_RX_DATA[0] ),   //                             .hps_io_emac1_inst_RXD0
		.hps_0_hps_io_hps_io_emac1_inst_MDIO   ( HPS_ENET_MDIO ),         //                             .hps_io_emac1_inst_MDIO
		.hps_0_hps_io_hps_io_emac1_inst_MDC    ( HPS_ENET_MDC  ),         //                             .hps_io_emac1_inst_MDC
		.hps_0_hps_io_hps_io_emac1_inst_RX_CTL ( HPS_ENET_RX_DV),         //                             .hps_io_emac1_inst_RX_CTL
		.hps_0_hps_io_hps_io_emac1_inst_TX_CTL ( HPS_ENET_TX_EN),         //                             .hps_io_emac1_inst_TX_CTL
		.hps_0_hps_io_hps_io_emac1_inst_RX_CLK ( HPS_ENET_RX_CLK),        //                             .hps_io_emac1_inst_RX_CLK
		.hps_0_hps_io_hps_io_emac1_inst_RXD1   ( HPS_ENET_RX_DATA[1] ),   //                             .hps_io_emac1_inst_RXD1
		.hps_0_hps_io_hps_io_emac1_inst_RXD2   ( HPS_ENET_RX_DATA[2] ),   //                             .hps_io_emac1_inst_RXD2
		.hps_0_hps_io_hps_io_emac1_inst_RXD3   ( HPS_ENET_RX_DATA[3] ),   //                             .hps_io_emac1_inst_RXD3
		//HPS QSPI  
		.hps_0_hps_io_hps_io_qspi_inst_IO0     ( HPS_FLASH_DATA[0]    ),     //                               .hps_io_qspi_inst_IO0
		.hps_0_hps_io_hps_io_qspi_inst_IO1     ( HPS_FLASH_DATA[1]    ),     //                               .hps_io_qspi_inst_IO1
		.hps_0_hps_io_hps_io_qspi_inst_IO2     ( HPS_FLASH_DATA[2]    ),     //                               .hps_io_qspi_inst_IO2
		.hps_0_hps_io_hps_io_qspi_inst_IO3     ( HPS_FLASH_DATA[3]    ),     //                               .hps_io_qspi_inst_IO3
		.hps_0_hps_io_hps_io_qspi_inst_SS0     ( HPS_FLASH_NCSO    ),        //                               .hps_io_qspi_inst_SS0
		.hps_0_hps_io_hps_io_qspi_inst_CLK     ( HPS_FLASH_DCLK    ),        //                               .hps_io_qspi_inst_CLK
		//HPS SD card 
		.hps_0_hps_io_hps_io_sdio_inst_CMD     ( HPS_SD_CMD    ),           //                               .hps_io_sdio_inst_CMD
		.hps_0_hps_io_hps_io_sdio_inst_D0      ( HPS_SD_DATA[0]     ),      //                               .hps_io_sdio_inst_D0
		.hps_0_hps_io_hps_io_sdio_inst_D1      ( HPS_SD_DATA[1]     ),      //                               .hps_io_sdio_inst_D1
		.hps_0_hps_io_hps_io_sdio_inst_CLK     ( HPS_SD_CLK   ),            //                               .hps_io_sdio_inst_CLK
		.hps_0_hps_io_hps_io_sdio_inst_D2      ( HPS_SD_DATA[2]     ),      //                               .hps_io_sdio_inst_D2
		.hps_0_hps_io_hps_io_sdio_inst_D3      ( HPS_SD_DATA[3]     ),      //                               .hps_io_sdio_inst_D3
		//HPS USB 		  
		.hps_0_hps_io_hps_io_usb1_inst_D0      ( HPS_USB_DATA[0]    ),      //                               .hps_io_usb1_inst_D0
		.hps_0_hps_io_hps_io_usb1_inst_D1      ( HPS_USB_DATA[1]    ),      //                               .hps_io_usb1_inst_D1
		.hps_0_hps_io_hps_io_usb1_inst_D2      ( HPS_USB_DATA[2]    ),      //                               .hps_io_usb1_inst_D2
		.hps_0_hps_io_hps_io_usb1_inst_D3      ( HPS_USB_DATA[3]    ),      //                               .hps_io_usb1_inst_D3
		.hps_0_hps_io_hps_io_usb1_inst_D4      ( HPS_USB_DATA[4]    ),      //                               .hps_io_usb1_inst_D4
		.hps_0_hps_io_hps_io_usb1_inst_D5      ( HPS_USB_DATA[5]    ),      //                               .hps_io_usb1_inst_D5
		.hps_0_hps_io_hps_io_usb1_inst_D6      ( HPS_USB_DATA[6]    ),      //                               .hps_io_usb1_inst_D6
		.hps_0_hps_io_hps_io_usb1_inst_D7      ( HPS_USB_DATA[7]    ),      //                               .hps_io_usb1_inst_D7
		.hps_0_hps_io_hps_io_usb1_inst_CLK     ( HPS_USB_CLKOUT    ),       //                               .hps_io_usb1_inst_CLK
		.hps_0_hps_io_hps_io_usb1_inst_STP     ( HPS_USB_STP    ),          //                               .hps_io_usb1_inst_STP
		.hps_0_hps_io_hps_io_usb1_inst_DIR     ( HPS_USB_DIR    ),          //                               .hps_io_usb1_inst_DIR
		.hps_0_hps_io_hps_io_usb1_inst_NXT     ( HPS_USB_NXT    ),          //                               .hps_io_usb1_inst_NXT

		//HPS SPI0->LCDM 	
		.hps_0_hps_io_hps_io_spim0_inst_CLK    ( HPS_LCM_SPIM_CLK),    //                               .hps_io_spim0_inst_CLK
		.hps_0_hps_io_hps_io_spim0_inst_MOSI   ( HPS_LCM_SPIM_MOSI),   //                               .hps_io_spim0_inst_MOSI
		.hps_0_hps_io_hps_io_spim0_inst_MISO   ( HPS_LCM_SPIM_MISO),   //                               .hps_io_spim0_inst_MISO
		.hps_0_hps_io_hps_io_spim0_inst_SS0    ( HPS_LCM_SPIM_SS),    //                               .hps_io_spim0_inst_SS0
		//HPS SPI1 		  
		.hps_0_hps_io_hps_io_spim1_inst_CLK    ( HPS_SPIM_CLK  ),           //                               .hps_io_spim1_inst_CLK
		.hps_0_hps_io_hps_io_spim1_inst_MOSI   ( HPS_SPIM_MOSI ),           //                               .hps_io_spim1_inst_MOSI
		.hps_0_hps_io_hps_io_spim1_inst_MISO   ( HPS_SPIM_MISO ),           //                               .hps_io_spim1_inst_MISO
		.hps_0_hps_io_hps_io_spim1_inst_SS0    ( HPS_SPIM_SS ),             //                               .hps_io_spim1_inst_SS0
		//HPS UART		
		.hps_0_hps_io_hps_io_uart0_inst_RX     ( HPS_UART_RX    ),          //                               .hps_io_uart0_inst_RX
		.hps_0_hps_io_hps_io_uart0_inst_TX     ( HPS_UART_TX    ),          //                               .hps_io_uart0_inst_TX
		//HPS I2C1
		.hps_0_hps_io_hps_io_i2c0_inst_SDA     ( HPS_I2C1_SDAT    ),        //                               .hps_io_i2c0_inst_SDA
		.hps_0_hps_io_hps_io_i2c0_inst_SCL     ( HPS_I2C1_SCLK    ),        //                               .hps_io_i2c0_inst_SCL
		//HPS I2C2
		.hps_0_hps_io_hps_io_i2c1_inst_SDA     ( HPS_I2C2_SDAT    ),        //                               .hps_io_i2c1_inst_SDA
		.hps_0_hps_io_hps_io_i2c1_inst_SCL     ( HPS_I2C2_SCLK    ),        //                               .hps_io_i2c1_inst_SCL
		//HPS GPIO  
		.hps_0_hps_io_hps_io_gpio_inst_GPIO09  ( HPS_CONV_USB_N),           //                               .hps_io_gpio_inst_GPIO09
		.hps_0_hps_io_hps_io_gpio_inst_GPIO35  ( HPS_ENET_INT_N),           //                               .hps_io_gpio_inst_GPIO35
		.hps_0_hps_io_hps_io_gpio_inst_GPIO37  ( HPS_LCM_BK ),  //                               .hps_io_gpio_inst_GPIO37
		.hps_0_hps_io_hps_io_gpio_inst_GPIO40  ( HPS_LTC_GPIO ),              //                               .hps_io_gpio_inst_GPIO40
		.hps_0_hps_io_hps_io_gpio_inst_GPIO41  ( HPS_LCM_D_C ),              //                               .hps_io_gpio_inst_GPIO41
		.hps_0_hps_io_hps_io_gpio_inst_GPIO44  ( HPS_LCM_RST_N  ),  //                               .hps_io_gpio_inst_GPIO44
		.hps_0_hps_io_hps_io_gpio_inst_GPIO48  ( HPS_I2C_CONTROL),          //                               .hps_io_gpio_inst_GPIO48
		.hps_0_hps_io_hps_io_gpio_inst_GPIO53  ( HPS_LED),                  //                               .hps_io_gpio_inst_GPIO53
		.hps_0_hps_io_hps_io_gpio_inst_GPIO54  ( HPS_KEY),                  //                               .hps_io_gpio_inst_GPIO54
		.hps_0_hps_io_hps_io_gpio_inst_GPIO61  ( HPS_GSENSOR_INT),  //                               .hps_io_gpio_inst_GPIO61

		.led_pio_external_connection_export    (  ),               //                               led_pio_external_connection.export                     
		.dipsw_pio_external_connection_export  (  ),                 //                               dipsw_pio_external_connection.export
		.button_pio_external_connection_export ( KEY_debounced ),              //                               button_pio_external_connection.export 
		.hps_0_h2f_reset_reset_n               ( hps_fpga_reset_n ),                //                hps_0_h2f_reset.reset_n
		.hps_0_f2h_cold_reset_req_reset_n      (~hps_cold_reset ),      //       hps_0_f2h_cold_reset_req.reset_n
		.hps_0_f2h_debug_reset_req_reset_n     (~hps_debug_reset ),     //      hps_0_f2h_debug_reset_req.reset_n
		.hps_0_f2h_stm_hw_events_stm_hwevents  (stm_hw_events ),  //        hps_0_f2h_stm_hw_events.stm_hwevents
		.hps_0_f2h_warm_reset_req_reset_n      (~hps_warm_reset ),      //       hps_0_f2h_warm_reset_req.reset_n
		
        .general_cnt_out_export                ({
			EN_PA,
			EN_PWR2,
			EN_PWR
		}),
        .general_cnt_in_export                 ({
			dummy
		}),
		
		.fifo_sink_clk_in_clk                  (ADC_CLKOUT),                   				//   fifo_sink_clk_in.clk
		
		.fifo_sink_in_ch_a_data                ({2'b0,captured_dataA}),                   //  .data
		.fifo_sink_in_ch_a_valid               (FIFO_EN),                    					//   fifo_sink_in.valid
        .fifo_sink_in_ch_a_ready               (),                    							//  .ready
        
		.fifo_sink_in_ch_b_data                ({2'b0,captured_dataB}),                	//   fifo_sink_in_ch_b.data
        .fifo_sink_in_ch_b_valid               (FIFO_EN),               						//  .valid
        .fifo_sink_in_ch_b_ready               (),               									//  .ready
		
		.plldds_spi_MISO                       (PLL_SDO),                       //                     plldds_spi.MISO
        .plldds_spi_MOSI                       (PLL_SDI),                       //                               .MOSI
        .plldds_spi_SCLK                       (PLL_SCLK),                       //                               .SCLK
        .plldds_spi_SS_n                       (PLL_CS)                        //                               .SS_n
    
	);
	
	// Debounce logic to clean out glitches within 1ms
	debounce debounce_inst (
		.clk     	(CLK_50),
		.reset_n 	(hps_fpga_reset_n),  
		.data_in 	(KEY),
		.data_out	(KEY_debounced)
	);
	defparam debounce_inst.WIDTH = 4;
	defparam debounce_inst.POLARITY = "LOW";
	defparam debounce_inst.TIMEOUT = 50000;               // at 50Mhz this is a debounce time of 1ms
	defparam debounce_inst.TIMEOUT_WIDTH = 16;            // ceil(log2(TIMEOUT))
	  
	// Source/Probe megawizard instance
	hps_reset hps_reset_inst (
		.source_clk (CLK_50),
		.source     (hps_reset_req)
	);

	altera_edge_detector pulse_cold_reset (
		.clk       (CLK_50),
		.rst_n     (hps_fpga_reset_n),
		.signal_in (hps_reset_req[0]),
		.pulse_out (hps_cold_reset)
	);
	defparam pulse_cold_reset.PULSE_EXT = 6;
	defparam pulse_cold_reset.EDGE_TYPE = 1;
	defparam pulse_cold_reset.IGNORE_RST_WHILE_BUSY = 1;

	altera_edge_detector pulse_warm_reset (
		.clk       (CLK_50),
		.rst_n     (hps_fpga_reset_n),
		.signal_in (hps_reset_req[1]),
		.pulse_out (hps_warm_reset)
	);
	defparam pulse_warm_reset.PULSE_EXT = 2;
	defparam pulse_warm_reset.EDGE_TYPE = 1;
	defparam pulse_warm_reset.IGNORE_RST_WHILE_BUSY = 1;
	  
	altera_edge_detector pulse_debug_reset (
		.clk       (CLK_50),
		.rst_n     (hps_fpga_reset_n),
		.signal_in (hps_reset_req[2]),
		.pulse_out (hps_debug_reset)
	);
	defparam pulse_debug_reset.PULSE_EXT = 32;
	defparam pulse_debug_reset.EDGE_TYPE = 1;
	defparam pulse_debug_reset.IGNORE_RST_WHILE_BUSY = 1;
	
	wire EN_PWR;
	wire EN_PA;
	wire MASTER_RST;
	wire SYNC_OUT;
	wire SYNC_IN;
	wire DRHOLD;
	wire DRCTL;
	wire DROVER;
	wire PLL_SDO;
	wire PLL_CS;
	wire PLL_SDI;
	wire PLL_STAT;
	wire PLL_SCLK;
	wire EXT_PWR_DWN;
	wire VCTL1;
	wire EN1;
	wire VCTL2;
	wire EN2;
	wire F0, F1, F2, F3;
	wire PS0, PS1, PS2;
	wire DAC_SDO;
	wire DAC_RST;
	wire DAC_SDIN;
	wire DAC_SCLK;
	wire DAC_SYNC;
	wire DAC_LDAC;
	wire EN_PWR2;
	
	// signal assignments
	assign GPIO[0] = EN_PWR;
	assign GPIO[1] = EN_PA;
	// wire MASTER_RST;
	// wire SYNC_OUT;
	// wire SYNC_IN;
	// wire DRHOLD;
	// wire DRCTL;
	// wire DROVER;
	assign PLL_SDO = GPIO[8];
	assign GPIO[9] = PLL_CS;
	assign GPIO[10] PLL_SDI;
	assign PLL_STAT = GPIO[11];
	assign GPIO[12] = PLL_SCLK;
	// wire EXT_PWR_DWN;
	// wire VCTL1;
	// wire EN1;
	// wire VCTL2;
	// wire EN2;
	// wire F0, F1, F2, F3;
	// wire PS0, PS1, PS2;
	// wire DAC_SDO;
	// wire DAC_RST;
	// wire DAC_SDIN;
	// wire DAC_SCLK;
	// wire DAC_SYNC;
	// wire DAC_LDAC;
	assign GPIO[31] EN_PWR2;
	
	
endmodule

  
#include <stdio.h>
#include <stdlib.h>
#include "platform.h"
#include "xil_printf.h"
#include "xparameters.h"
#include "xparameters_ps.h"
#include "xaxidma.h"
#include "xtime_l.h"

#define TX_DMA_ID                 XPAR_PS2PL_DMA_DEVICE_ID
#define TX_DMA_MM2S_LENGTH_ADDR  (XPAR_PS2PL_DMA_BASEADDR + 0x28) // Reports actual number of bytes transferred from PS->PL (use Xil_In32 for report)

#define RX_DMA_ID                 XPAR_PL2PS_DMA_DEVICE_ID
#define RX_DMA_S2MM_LENGTH_ADDR  (XPAR_PL2PS_DMA_BASEADDR + 0x58) // Reports actual number of bytes transferred from PL->PS (use Xil_In32 for report)

#define TX_BUFFER (XPAR_DDR_MEM_BASEADDR + 0x10000000) // 0 + 128MByte
#define RX_BUFFER (XPAR_DDR_MEM_BASEADDR + 0x18000000) // 0 + 512MByte

/* User application global variables & defines */
int Status;
u8 *TxBufferPtr = (u8 *)TX_BUFFER;
u32 *RxBufferPtr = (u32 *)RX_BUFFER;

#define N 1024
XAxiDma AxiDma_TX;
XAxiDma AxiDma_RX;
typedef struct {
  u8 Red, Green, Blue;
} pixel; //RBG


pixel CPU_array[N+2][N+2];

int RGB(int row, int column) {
  int m_row = row % 2, m_column = column % 2;

  if (((m_row == 0) && (m_column == 0))) {
    return 1; // Green next to to blue
  }
  else if (((m_row == 1) && (m_column == 1))) {
    return 2; // Green next to to red
  }
  else if ((m_row == 0) && (m_column == 1)) {
    return 3; // Blue
  }
  else {
    return 4; // Red
  }
}

void isBlue(int row, int column) {
    CPU_array[row][column].Green = (CPU_array[row-1][column].Green + CPU_array[row+1][column].Green + CPU_array[row][column-1].Green + CPU_array[row][column+1].Green) / 4;
    CPU_array[row][column].Red = (CPU_array[row-1][column-1].Red + CPU_array[row-1][column+1].Red + CPU_array[row+1][column-1].Red + CPU_array[row+1][column+1].Red) / 4;
}

void isGreenNextBlue(int row, int column) {
    CPU_array[row][column].Blue = (CPU_array[row][column-1].Blue + CPU_array[row][column+1].Blue) / 2;
    CPU_array[row][column].Red = (CPU_array[row-1][column].Red + CPU_array[row+1][column].Red) / 2;
}

void isGreenNextRed(int row, int column) {
    CPU_array[row][column].Red = (CPU_array[row][column-1].Red + CPU_array[row][column+1].Red) / 2;
    CPU_array[row][column].Blue = (CPU_array[row-1][column].Blue + CPU_array[row+1][column].Blue) / 2;
}

void isRed(int row, int column) {
    CPU_array[row][column].Green = (CPU_array[row-1][column].Green + CPU_array[row+1][column].Green + CPU_array[row][column-1].Green + CPU_array[row][column+1].Green) / 4;
    CPU_array[row][column].Blue = (CPU_array[row-1][column-1].Blue + CPU_array[row-1][column+1].Blue + CPU_array[row+1][column-1].Blue + CPU_array[row+1][column+1].Blue) / 4;
}

void parse(int row, int column) {
    int color = RGB(row-1, column-1);

    if (color == 1) {
        isGreenNextBlue(row, column);
    }
    else if (color == 2) {
        isGreenNextRed(row, column);
    }
    else if (color == 3) {
        isBlue(row, column);
    }
    else {
        isRed(row, column);
    }
}

void filter() {

  int color = 0;
  for (int i = 0; i < N+2; i++) {
    for (int j = 0; j < N+2; j++) {
        if(i == 0 || j == 0 || i == N+1 || j == N+1) {
            CPU_array[i][j].Green = 0;
            CPU_array[i][j].Blue = 0;
            CPU_array[i][j].Red = 0;
        }
        else {
            color = RGB(i-1, j-1); // Align with -1
            if (color == 1 || color == 2) {
                CPU_array[i][j].Green = TxBufferPtr[(i-1)*N+(j-1)];
            }
            else if (color == 3) {
                CPU_array[i][j].Blue = TxBufferPtr[(i-1)*N+(j-1)];
            }
            else {
                CPU_array[i][j].Red = TxBufferPtr[(i-1)*N+(j-1)];
            }
        }
    }
  }

  for (int i = 1; i < N+1; i++) {
    for (int j = 1; j < N+1; j++) {
        parse(i, j);
    }
  }
}

float percentageError(){
	u32 tmp;
	int i, j;
	int HW_counter = 0;
	int counter = 0;
	for (i = 1; i < N+1; i++){
		for (j = 1; j < N+1; j++){
			tmp = (CPU_array[i][j].Red << 16) +(CPU_array[i][j].Green << 8) + (CPU_array[i][j].Blue);
			if (tmp != RxBufferPtr[HW_counter]) {
        counter++;
      }
			HW_counter++;
		}
	}

	return (1.0*counter)/(N*N);
}

int main()
{
	Xil_DCacheDisable();

	XTime preExecCyclesFPGA = 0;
	XTime postExecCyclesFPGA = 0;
	XTime preExecCyclesSW = 0;
	XTime postExecCyclesSW = 0;

	// User application local variables

	init_platform();
	int index = 0;
  u8 Value = 0x01;

  for(index = 0; index < N*N; index ++) {
      TxBufferPtr[index] = (u8) rand() % 0x256;
      Value = (Value + 1) & 0xFF;
  }

    // Step 1: Initialize TX-DMA Device (PS->PL)

  XAxiDma_Config *CfgPtr_TX;
	CfgPtr_TX = XAxiDma_LookupConfig(TX_DMA_ID);
  if (!CfgPtr_TX) {
      printf("No config found for %d\r\n", TX_DMA_ID);
      return XST_FAILURE;
    }
	Status = XAxiDma_CfgInitialize(&AxiDma_TX, CfgPtr_TX);
  if (Status != XST_SUCCESS) {
    printf("Initialization failed %d\r\n", Status);
    return XST_FAILURE;
  }

  if(XAxiDma_HasSg(&AxiDma_TX)){
    printf("Device configured as SG mode \r\n");
    return XST_FAILURE;
  }

	XAxiDma_IntrDisable(&AxiDma_TX, XAXIDMA_IRQ_ALL_MASK,
						XAXIDMA_DEVICE_TO_DMA);
	XAxiDma_IntrDisable(&AxiDma_TX, XAXIDMA_IRQ_ALL_MASK,
						XAXIDMA_DMA_TO_DEVICE);

  // Step 2: Initialize RX-DMA Device (PL->PS)

  XAxiDma_Config *CfgPtr_RX;
  CfgPtr_RX = XAxiDma_LookupConfig(RX_DMA_ID);
  if (!CfgPtr_RX) {
    printf("No config found for %d\r\n", RX_DMA_ID);
    return XST_FAILURE;
  }

  Status = XAxiDma_CfgInitialize(&AxiDma_RX, CfgPtr_RX);
  if (Status != XST_SUCCESS) {
    printf("Initialization failed %d\r\n", Status);
    return XST_FAILURE;
  }

  if(XAxiDma_HasSg(&AxiDma_RX)){
    printf("Device configured as SG mode \r\n");
    return XST_FAILURE;
  }

  XAxiDma_IntrDisable(&AxiDma_RX, XAXIDMA_IRQ_ALL_MASK,
            XAXIDMA_DEVICE_TO_DMA);
  XAxiDma_IntrDisable(&AxiDma_RX, XAXIDMA_IRQ_ALL_MASK,
            XAXIDMA_DMA_TO_DEVICE);

  XTime_GetTime(&preExecCyclesFPGA);

  // Step 3 : Perform FPGA processing

  //      3a: Setup RX-DMA transaction
  Status = XAxiDma_SimpleTransfer(&AxiDma_RX,(UINTPTR) RxBufferPtr,
				N*N*4, XAXIDMA_DEVICE_TO_DMA);

  if (Status != XST_SUCCESS) {
			return XST_FAILURE;
		}

  //      3b: Setup TX-DMA transaction
	Status = XAxiDma_SimpleTransfer(&AxiDma_TX,(UINTPTR) TxBufferPtr,
			N*N, XAXIDMA_DMA_TO_DEVICE);

	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}


  //      3c: Wait for TX-DMA & RX-DMA to finish
	while ((XAxiDma_Busy(&AxiDma_TX, XAXIDMA_DMA_TO_DEVICE)) ||
		(XAxiDma_Busy(&AxiDma_RX, XAXIDMA_DEVICE_TO_DMA))) {
			/* Wait */
	}

//	   printf("after polling\n");

    XTime_GetTime(&postExecCyclesFPGA);

    XTime_GetTime(&preExecCyclesSW);
    // Step 5: Perform SW processing

    filter();

    XTime_GetTime(&postExecCyclesSW);

    // Step 6: Compare FPGA and SW results
    //     6a: Report total percentage error
    float error = percentageError();
    printf("Error %.2f\n", error);

    //     6b: Report FPGA execution time in cycles (use preExecCyclesFPGA and postExecCyclesFPGA)
    u64 FPGA_execution_time = postExecCyclesFPGA - preExecCyclesFPGA;
    printf("FPGA execution time %lld\n", FPGA_execution_time);

    //     6c: Report SW execution time in cycles (use preExecCyclesSW and postExecCyclesSW)
    u64 SW_execution_time = postExecCyclesSW - preExecCyclesSW;
    printf("SW execution time %lld\n", SW_execution_time);

    // 6d: Report speedup (SW_execution_time / FPGA_execution_time)
   float speedup = (1.0*SW_execution_time) / (1.0*FPGA_execution_time);
   printf("Speedup %.2f\n", speedup);

    cleanup_platform();
    return 0;
}

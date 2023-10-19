#include <stdio.h>
#include <stdlib.h>

#define N 32

typedef struct {
  int Red, Green, Blue;
} pixel; //RBG

pixel array[N+2][N+2];

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
    array[row][column].Green = (array[row-1][column].Green + array[row+1][column].Green + array[row][column-1].Green + array[row][column+1].Green) / 4;
    array[row][column].Red = (array[row-1][column-1].Red + array[row-1][column+1].Red + array[row+1][column-1].Red + array[row+1][column+1].Red) / 4;
}

void isGreenNextBlue(int row, int column) {
    array[row][column].Blue = (array[row][column-1].Blue + array[row][column+1].Blue) / 2;
    array[row][column].Red = (array[row-1][column].Red + array[row+1][column].Red) / 2;
}

void isGreenNextRed(int row, int column) {
    array[row][column].Red = (array[row][column-1].Red + array[row][column+1].Red) / 2;
    array[row][column].Blue = (array[row-1][column].Blue + array[row+1][column].Blue) / 2;
}

void isRed(int row, int column) {
    array[row][column].Green = (array[row-1][column].Green + array[row+1][column].Green + array[row][column-1].Green + array[row][column+1].Green) / 4;
    array[row][column].Blue = (array[row-1][column-1].Blue + array[row-1][column+1].Blue + array[row+1][column-1].Blue + array[row+1][column+1].Blue) / 4;
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

int main(int argc, char const *argv[]) {
  // pixel array[N][N];

  FILE *in_file  = fopen(argv[1], "r"); // read only
  FILE *out_file = fopen(argv[2], "w"); // write only


  int color = 0;
  for (int i = 0; i < N+2; i++) {
    for (int j = 0; j < N+2; j++) {
        if(i == 0 || j == 0 || i == N+1 || j == N+1) {
            array[i][j].Green = 0;
            array[i][j].Blue = 0;
            array[i][j].Red = 0;
        }
        else {
            color = RGB(i-1, j-1); // allign with -1
            if (color == 1 || color == 2) {
                fscanf(in_file, "%d", &array[i][j].Green);
            }
            else if (color == 3) {
                fscanf(in_file, "%d", &array[i][j].Blue);
            }
            else {
                fscanf(in_file, "%d", &array[i][j].Red);
            }
        }
    }
  }


  // int Red,Green,Blue;
  for (int i = 1; i < N+1; i++) {
    for (int j = 1; j < N+1; j++) {
        parse(i, j);
        fprintf(out_file, "(");
        fprintf(out_file, "R%d ", array[i][j].Red);
        fprintf(out_file, "G%d ", array[i][j].Green);
        fprintf(out_file, "B%d", array[i][j].Blue);
        fprintf(out_file, ")");
    }
    fprintf(out_file, "\n");
  }

  fclose (in_file);
  fclose (out_file);

  return 0;
}

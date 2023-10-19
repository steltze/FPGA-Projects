#include <stdio.h>
#include <stdlib.h>

#define N 32

int array[N][N][3];

int bounds(int row, int column, int color) {
  if(row >= 0 && row < N && column >= 0 && column < N) {
    return array[row][column][color];
  }

  return 0;
}

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
    array[row][column][1] = (bounds(row-1, column, 1) + bounds(row+1, column, 1) + bounds(row, column-1, 1) + bounds(row, column+1, 1)) / 4;
    array[row][column][0] = (bounds(row-1, column-1, 0) + bounds(row-1, column+1, 0) + bounds(row+1, column-1, 0) + bounds(row+1, column+1, 0)) / 4;
}

void isGreenNextBlue(int row, int column) {
    array[row][column][2] = (bounds(row, column-1, 2) + bounds(row, column+1, 2)) / 2;
    array[row][column][0] = (bounds(row-1, column, 0) + bounds(row+1, column, 0)) / 2;
}

void isGreenNextRed(int row, int column) {
    array[row][column][0] = (bounds(row, column-1, 0) + bounds(row, column+1, 0)) / 2;
    array[row][column][2] = (bounds(row-1, column, 2) + bounds(row+1, column, 2)) / 2;
}

void isRed(int row, int column) {
    array[row][column][1] = (bounds(row-1, column, 1) + bounds(row+1, column, 1) + bounds(row, column-1, 1) + bounds(row, column+1, 1)) / 4;
    array[row][column][2] = (bounds(row-1, column-1, 2) + bounds(row-1, column+1, 2) + bounds(row+1, column-1, 2) + bounds(row+1, column+1, 2)) / 4;
}

void parse(int row, int column) {
    int color = RGB(row, column);

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
  for (int i = 0; i < N; i++) {
    for (int j = 0; j < N; j++) {
          color = RGB(i, j); // allign with -1
          if (color == 1 || color == 2) {
              fscanf(in_file, "%d", &array[i][j][1]);
          }
          else if (color == 3) {
              fscanf(in_file, "%d", &array[i][j][2]);
          }
          else {
              fscanf(in_file, "%d", &array[i][j][0]);
          }
        }
    }


  // int Red,Green,Blue;
  for (int i = 0; i < N; i++) {
    for (int j = 0; j < N; j++) {
        parse(i, j);
        fprintf(out_file, "(");
        fprintf(out_file, "R%d ", array[i][j][0]);
        fprintf(out_file, "G%d ", array[i][j][1]);
        fprintf(out_file, "B%d", array[i][j][2]);
        fprintf(out_file, ")");
    }
    fprintf(out_file, "\n");
  }

  fclose (in_file);
  fclose (out_file);

  return 0;
}

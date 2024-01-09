#include <fxcg/display.h>
#include <fxcg/keyboard.h>

// First two bytes of print string are used to determine charest
// Padding with spaces uses the default charest
#define CHARSET "  "

int main(void) {
  // X and Y indexed from 1
  PrintXY(4, 4, CHARSET "Hello, World!", TEXT_MODE_NORMAL, TEXT_COLOR_BLACK);

  int key;
  while (1) {
    GetKey(&key);
    if (key == KEY_CTRL_EXE)
      break;
  }
}

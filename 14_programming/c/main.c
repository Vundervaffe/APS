#include "platform.h"

volatile uint32_t scan_c = 0;
volatile uint8_t new_data_available = 0;

void int_handler(void) {
    scan_c = ps2_ptr->scan_code;
    new_data_available = 1;
}

char ps2_to_ASCII(uint32_t ps2){
  switch(ps2){
    case 69: return '0';
    case 22: return '1';
    case 30: return '2';
    case 38: return '3';
    case 37: return '4';
    case 46: return '5';
    case 54: return '6';
    case 61: return '7';
    case 62: return '8';
    case 70: return '9';
    case 90: return 'n';
    default:  return 0;
  }
}

int char_to_int(char* symbols, int leng){
  int n = 0;
  for (int i = 0; i < leng; i++){
    n = n * 10 + (symbols[i] - '0');
  }
  return n;
}

int enter_int(int row, int col){
  char n[10] = {0};
  int push_up_key = 0;
  char symbol;
  int j = col;
  int l = 0;
  
  new_data_available = 0;
  
  for(int i = 0; i < 10; i++){
    while (!new_data_available);
    
    symbol = ps2_to_ASCII(scan_c);
    
    if(!push_up_key){
      if (scan_c == 240){  // Код отпускания клавиши
        push_up_key = 1;
        i=i-1;
      }
      else if(scan_c == 90){  // Enter - завершить ввод
        break;
      }
      else if(symbol != 0 && symbol >= '0' && symbol <= '9'){
        vga.char_map[row*80+j] = symbol;
        n[l] = symbol; 
        l++;
        j++;
      }
    }
    else if (push_up_key){
      push_up_key = 0;
      i=i-1;
    }
    
    new_data_available = 0;
  }
  
  return char_to_int(n, l);
}

void int_to_char(int n, char* buffer) {
  int i = 0;
  

  do {
    buffer[i++] = '0' + (n % 10);
    n /= 10;
  } while (n > 0 && i < 10);
  
  buffer[i] = '\0';
  
  // Разворачиваем на месте
  for (int j = 0; j < i/2; j++) {
    char temp = buffer[j];
    buffer[j] = buffer[i - j - 1];
    buffer[i - j - 1] = temp;
  }
}

int main(){  

  for(int i = 0; i<80*30; i++) {
    vga.char_map[0*80+i] = ' ';
    vga.color_map[0*80+i] = 160;
  }

  for(volatile int i = 0; i < 1000; i++);

  // Вывод приглашения n
  char* nado_n = "Enter n: ";
  for(int i = 0; nado_n[i] != '\0'; i++) {
    vga.char_map[0*80+i] = nado_n[i];
  }
  

  for(volatile int i = 0; i < 1000; i++);
  int n = enter_int(0, 10);
  
  // Вывод приглашения b
  char* nado_b = "Enter b: ";
  for(int i = 0; nado_b[i] != '\0'; i++) {
    vga.char_map[1*80+i] = nado_b[i];
  }
  for(volatile int i = 0; i < 1000; i++);
  int b = enter_int(1, 10);
  int a = 1;
  char str[10];
  for(int i = 0; i<n; i++){
    a = a + b;
    int_to_char(a, str);
    for(int k = 0; str[k] != '\0'; k++) {
      vga.char_map[(2+i)*80+(k+1)] = str[k];
    }
  }
  return 0;
}
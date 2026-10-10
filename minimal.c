#include <banked-call.h>
#include <stdio.h>

#define CALLS_PER_REPORT 1800

volatile uint16_t bank_calls[16];

#define DEFINE_BANK_PROBE(n)                                               \
  ATARIMAX_BANK(n) void bank##n##_probe(void) { ++bank_calls[n]; }

#define CALL_BANK(n) atarimax_banked_call(n, bank##n##_probe)

DEFINE_BANK_PROBE(0)
DEFINE_BANK_PROBE(1)
DEFINE_BANK_PROBE(2)
DEFINE_BANK_PROBE(3)
DEFINE_BANK_PROBE(4)
DEFINE_BANK_PROBE(5)
DEFINE_BANK_PROBE(6)
DEFINE_BANK_PROBE(7)
DEFINE_BANK_PROBE(8)
DEFINE_BANK_PROBE(9)
DEFINE_BANK_PROBE(10)
DEFINE_BANK_PROBE(11)
DEFINE_BANK_PROBE(12)
DEFINE_BANK_PROBE(13)
DEFINE_BANK_PROBE(14)
DEFINE_BANK_PROBE(15)

int main(void) {
  for (;;) {
    for (uint16_t call = 0; call < CALLS_PER_REPORT; ++call) {
      CALL_BANK(0);
      CALL_BANK(1);
      CALL_BANK(2);
      CALL_BANK(3);
      CALL_BANK(4);
      CALL_BANK(5);
      CALL_BANK(6);
      CALL_BANK(7);
      CALL_BANK(8);
      CALL_BANK(9);
      CALL_BANK(10);
      CALL_BANK(11);
      CALL_BANK(12);
      CALL_BANK(13);
      CALL_BANK(14);
      CALL_BANK(15);
    }

    uint8_t errors = 0;
    for (uint8_t bank = 0; bank < 16; ++bank) {
      if (bank_calls[bank] != CALLS_PER_REPORT) {
        ++errors;
      }
    }

#ifdef TEST_FORCE_FAIL
    errors = 1;
#endif

    const char *status = errors == 0 ? "PASS" : "FAIL";
    printf("%s %s %s\n", status, status, status);
    printf("B0-15: %u,%u,%u,%u,%u,%u,%u,%u,%u,%u,%u,%u,%u,%u,%u,%u\n",
           (unsigned)bank_calls[0], (unsigned)bank_calls[1],
           (unsigned)bank_calls[2], (unsigned)bank_calls[3],
           (unsigned)bank_calls[4], (unsigned)bank_calls[5],
           (unsigned)bank_calls[6], (unsigned)bank_calls[7],
           (unsigned)bank_calls[8], (unsigned)bank_calls[9],
           (unsigned)bank_calls[10], (unsigned)bank_calls[11],
           (unsigned)bank_calls[12], (unsigned)bank_calls[13],
           (unsigned)bank_calls[14], (unsigned)bank_calls[15]);

    for (uint8_t bank = 0; bank < 16; ++bank) {
      bank_calls[bank] = 0;
    }
  }
}

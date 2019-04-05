#ifndef rpc_demo_app_h_
#define rpc_demo_app_h_

#include "xil_printf.h"

#if defined (__cplusplus)
extern "C" {
#endif

/* xil_printf goes directly to serial port */
#define LPRINTF(format, ...) xil_printf(format, ##__VA_ARGS__)
#define LPERROR(format, ...) LPRINTF("ERROR: " format, ##__VA_ARGS__)

void processing(void *unused_arg);

#if defined (__cplusplus)
}
#endif

#endif

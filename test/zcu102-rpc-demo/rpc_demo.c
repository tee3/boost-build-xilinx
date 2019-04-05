#include "FreeRTOS.h"
#include "task.h"

#include "rpc_demo_app.h"

static TaskHandle_t comm_task;

/*-----------------------------------------------------------------------------*
 *  Application entry point
 *-----------------------------------------------------------------------------*/
int main(void)
{
	BaseType_t stat;

	/* Create the tasks */
	stat = xTaskCreate(processing, ( const char * ) "HW2",
				1024, NULL, 2, &comm_task);
	if (stat != pdPASS) {
		LPERROR("cannot create task\n");
	} else {
		/* Start running FreeRTOS tasks */
		vTaskStartScheduler();
	}

	/* Will not get here, unless a call is made to vTaskEndScheduler() */
	while (1) ;

	/* suppress compilation warnings*/
	return 0;
}


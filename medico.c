#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "defines.h"



void Esegui_come_medico(MYSQL *conn)
{
	char options[2] = {'1','2'};
	char op;
	
	printf("Passo al ruolo di medico...\n");

	if(!parse_config("utenti/medico.json", &conf)) {
		fprintf(stderr, "Unable to load student configuration\n");
		exit(EXIT_FAILURE);
	}

	if(mysql_change_user(conn, conf.db_username, conf.db_password, conf.database)) {
		fprintf(stderr, "mysql_change_user() failed\n");
		exit(EXIT_FAILURE);
	}
	/*
	while(true) {
		printf("\033[2J\033[H");
		printf("*** What should I do for you? ***\n\n");
		printf("1) Career Report\n");
		printf("2) Quit\n");

		op = multiChoice("Select an option", options, 2);

		switch(op) {
			case '1':
				career_report(conn);
				break;
				
			case '2':
				return;
				
			default:
				fprintf(stderr, "Invalid condition at %s:%d\n", __FILE__, __LINE__);
				abort();
		}

		getchar();
	}*/
	printf("Tutto ok\n");
	fflush(stdout);
}

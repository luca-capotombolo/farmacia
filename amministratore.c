#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "defines.h"

void process_result_set(MYSQL* conn, MYSQL_RES *res_set)
{
	MYSQL_ROW row;
	unsigned int i;

	while((row=mysql_fetch_row(res_set)) != NULL)
	{
		for (i = 0; i < mysql_num_fields (res_set); i++)
		{
		
				
			printf ("%s", row[i] != NULL ? row[i] : "NULL");
			printf("\n");
		}
		
	}
	mysql_free_result(res_set);
	
}

static void info_clienti(MYSQL *conn)
{
	unsigned long length[4];
	bool is_null[4];
	bool error[4];
	MYSQL_STMT *stmt;
	MYSQL_BIND    bind[3];
	char cf[100];
	char nome[45];
	char cognome[45];
	MYSQL_RES     *prepare_meta_result;
	char*command = "call info_clienti();";
	stmt = mysql_stmt_init(conn);
	if (!stmt)
	{
  	fprintf(stderr, " mysql_stmt_init(), out of memory\n");
  	exit(0);
	}
	if (mysql_stmt_prepare(stmt, command, strlen(command)))
	{
  	fprintf(stderr, " mysql_stmt_prepare(), SELECT failed\n");
  	fprintf(stderr, " %s\n", mysql_stmt_error(stmt));
  	exit(0);
	}
	fprintf(stdout, " prepare, SELECT successful\n");

	// ------------------------------------------------------

	int param_count= mysql_stmt_param_count(stmt);
	fprintf(stdout, " total parameters in SELECT: %d\n", param_count);

	if (mysql_stmt_execute(stmt))
	{
  	fprintf(stderr, " mysql_stmt_execute(), failed\n");
  	fprintf(stderr, " %s\n", mysql_stmt_error(stmt));
  	exit(0);
	}

	/* Fetch result set meta information */
	prepare_meta_result = mysql_stmt_result_metadata(stmt);
	if (!prepare_meta_result)
	{
  	fprintf(stderr," mysql_stmt_result_metadata(), returned no meta information\n");
  	fprintf(stderr, " %s\n", mysql_stmt_error(stmt));
  	exit(0);
	}

	int column_count;
	/* Get total columns in the query */
	column_count= mysql_num_fields(prepare_meta_result);
	fprintf(stdout," total columns in SELECT statement: %d\n",column_count);

	memset(bind,0,sizeof(bind));

	bind[0].buffer_type= MYSQL_TYPE_VAR_STRING;
	bind[0].buffer= (char *)cf;
	bind[0].buffer_length= 100;
	bind[0].is_null= &is_null[0];
	bind[0].length= &length[0];
	bind[0].error= &error[0];

	bind[1].buffer_type= MYSQL_TYPE_VAR_STRING;
	bind[1].buffer= (char *)nome;
	bind[1].buffer_length= 45;
	bind[1].is_null= &is_null[1];
	bind[1].length= &length[1];
	bind[1].error= &error[1];

	bind[2].buffer_type= MYSQL_TYPE_VAR_STRING;
	bind[2].buffer= (char *)cognome;
	bind[2].buffer_length= 45;
	bind[2].is_null= &is_null[2];
	bind[2].length= &length[2];
	bind[2].error= &error[2];

	if (mysql_stmt_bind_result(stmt, bind))
	{
 	  fprintf(stderr, " mysql_stmt_bind_result() failed\n");
  	fprintf(stderr, " %s\n", mysql_stmt_error(stmt));
  	exit(0);
	}	
	
	/* Now buffer all results to client (optional step) */
	if (mysql_stmt_store_result(stmt))
	{
  	fprintf(stderr, " mysql_stmt_store_result() failed\n");
  	fprintf(stderr, " %s\n", mysql_stmt_error(stmt));
  	exit(0);
	}

	int row_count= 0;
	fprintf(stdout, "Fetching results ...\n");
	while (!mysql_stmt_fetch(stmt))
	{
		printf("Entrato.\n");
		row_count++;
  	fprintf(stdout, "  row %d\n", row_count);

  	/* column 1 */
  	fprintf(stdout, "   column1  : ");
  	if (is_null[0])
    	fprintf(stdout, " NULL\n");
  	else
    	fprintf(stdout, " %s(%ld)\n", cf, length[0]);

		fprintf(stdout, "   column2  : ");
  	if (is_null[1])
    	fprintf(stdout, " NULL\n");
  	else
    	fprintf(stdout, " %s(%ld)\n", nome, length[1]);

		/* column 3 */
  	fprintf(stdout, "   column3 (smallint) : ");
  	if (is_null[2])
    	fprintf(stdout, " NULL\n");
  	else
    	fprintf(stdout, " %s(%ld)\n", cognome, length[2]);

	}

	while(mysql_next_result(conn)){}

	/* Free the prepared result metadata */
	mysql_free_result(prepare_meta_result);

	/* Close the statement */
	if (mysql_stmt_close(stmt))
	{
  /* mysql_stmt_close() invalidates stmt, so call          */
  /* mysql_error(mysql) rather than mysql_stmt_error(stmt) */
  	fprintf(stderr, " failed while closing the statement\n");
  	fprintf(stderr, " %s\n", mysql_error(conn));
  	exit(0);
	}
	
}


static void info_ditte(MYSQL *conn)
{
	MYSQL_RES *res_set;
	
	printf("------------------------------ INFORMAZIONI DITTE ------------------------------\n");
	fflush(stdout);

	if(mysql_query(conn,"call info_ditte();") != 0)
	{
		print_error(conn,"call info_ditte() fallita...\n");
		goto uscita;
	}
	else 
	{
		res_set = mysql_store_result(conn);
		if(res_set == NULL)
		{
			print_error(conn,"mysql_store_result() fallita...\n");
			goto uscita;
		}else
		{
			process_result_set(conn,res_set);
			//mysql_free_result(res_set);
		}
	}

	while(mysql_next_result(conn)){}

	return;


uscita:
	mysql_close(conn);
	exit(EXIT_FAILURE);

	

}

void Esegui_come_amministratore(MYSQL *conn)
{
	char options[2] = {'1','2'};
	char op;
	
	printf("Switching to administrative role...\n");

	if(!parse_config("utenti/amministratore.json", &conf)) {
		fprintf(stderr, "Unable to load administrator configuration\n");
		exit(EXIT_FAILURE);
	}

	if(mysql_change_user(conn, conf.db_username, conf.db_password, conf.database)) {
		fprintf(stderr, "mysql_change_user() failed\n");
		 fprintf(stderr, "Failed to change user.  Error: %s\n",
           mysql_error(conn));
		exit(EXIT_FAILURE);
	}

	
	while(true) {
		printf("Inizio ciclo\n");
		fflush(stdout);
		printf("\033[2J\033[H");
		printf("*** Che cosa vuio fare? ***\n\n");
		printf("1) Ottieni informazioni sulle ditte\n");
		/*
		printf("2) Add new student\n");
		printf("3) Create new user\n");
		printf("4) Subscribe student to degree course\n");
		printf("5) Quit\n");*/

		op = multiChoice("Select an option", options, 2);

		switch(op) {
			case '1':
				info_ditte(conn);
				break;
			case '2':
				info_clienti(conn);
				break;				
			default:
				fprintf(stderr, "Invalid condition at %s:%d\n", __FILE__, __LINE__);
				abort();
		}
		printf("Sono qui!");
		getchar();
	}

	printf("Tutto bene sono l'amministratore!");
}

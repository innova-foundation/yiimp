
#include "stratum.h"

bool job_has_free_client()
{
	g_list_client.Enter();
	for(CLI li = g_list_client.first; li; li = li->next)
	{
		YAAMP_CLIENT *client = (YAAMP_CLIENT *)li->data;
		if(client->deleted) continue;

		if(!client->jobid_next)
		{
			g_list_client.Leave();
			return true;
		}
	}

	g_list_client.Leave();
	return false;
}

void job_reset_clients(YAAMP_JOB *job)
{
	g_list_client.Enter();
	for(CLI li = g_list_client.first; li; li = li->next)
	{
		YAAMP_CLIENT *client = (YAAMP_CLIENT *)li->data;
		if(client->deleted) continue;

		if(!job || job->id == client->jobid_next)
			client->jobid_next = 0;
	}

	g_list_client.Leave();
}

void job_relock_clients(int jobid_old, int jobid_new)
{
	if(!jobid_old || !jobid_new) return;

	g_list_client.Enter();
	for(CLI li = g_list_client.first; li; li = li->next)
	{
		YAAMP_CLIENT *client = (YAAMP_CLIENT *)li->data;
		if(client->jobid_locked != jobid_old) continue;

//		debuglog("relock job %x to %x\n", client->jobid_locked, jobid_new);
		client->jobid_locked = jobid_new;
	}

	g_list_client.Leave();
}

void job_assign_locked_clients(YAAMP_JOB *job)
{
	if(!job) return;

	job->speed = 0;
	job->count = 0;

	g_list_client.Enter();
	for(CLI li = g_list_client.first; li; li = li->next)
	{
		YAAMP_CLIENT *client = (YAAMP_CLIENT *)li->data;
		if(client->jobid_locked != job->id) continue;

//		debuglog("assign job %x %x\n", client->jobid_locked, job->id);

		client->jobid_next = job->id;
		job->remote_subids[client->extranonce1_id] = true;

		job->speed += client->speed;
		job->count++;
	}

	g_list_client.Leave();
}

void job_unlock_clients(YAAMP_JOB *job)
{
	g_list_client.Enter();
	for(CLI li = g_list_client.first; li; li = li->next)
	{
		YAAMP_CLIENT *client = (YAAMP_CLIENT *)li->data;
		if(client->deleted) continue;
		if(!client->jobid_locked) continue;
		if(client->jobid_locked == client->jobid_next) continue;
		if(job && client->jobid_locked != job->id) continue;

//		debuglog("unlock job %x %x\n", client->jobid_locked, job->id);
		client->jobid_locked = 0;
	}

	g_list_client.Leave();
}

bool job_can_mine(YAAMP_JOB *job)
{
	if(job->deleted) return false;

	if(job->remote)
		return remote_can_mine(job->remote);

	else if(job->coind)
		return coind_can_mine(job->coind);

	return false;
}







#include "stratum.h"

double client_normalize_difficulty(double difficulty)
{           // https://github.com/MicroBitcoinOrg/Yiimp
	if(difficulty < g_stratum_min_diff)
        difficulty = g_stratum_min_diff;
	else if(difficulty < 1) 
        difficulty = floor(difficulty*100000000/2)/100000000*2;
	else if(difficulty > 1) 
        difficulty = floor(difficulty/2)*2;
	if(difficulty > g_stratum_max_diff) 
        difficulty = g_stratum_max_diff;

            /* output normalized difficulty value */
    //debuglog("Difficulty amount altered by: %f\n", difficulty);
    debuglog("Difficulty amount altered by: %f - %f - %f - %f\n", difficulty, g_stratum_min_diff, g_stratum_max_diff, g_stratum_difficulty);
    return difficulty;
}

void client_record_difficulty(YAAMP_CLIENT *client)
{
    if (client->difficulty_remote) {
        client->last_submit_time = current_timestamp();
        return;
    }

    const int MIN_SUBMIT_INTERVAL_MS = 500;
    const double SMOOTHING_FACTOR = 0.95;
    const int SUBMISSIONS_PER_MINUTE = 60 * 1000;

    int time_since_last_submit = current_timestamp() - client->last_submit_time;
    if (time_since_last_submit < MIN_SUBMIT_INTERVAL_MS) {
        time_since_last_submit = MIN_SUBMIT_INTERVAL_MS;
    }

    double submissions_per_second = SUBMISSIONS_PER_MINUTE / time_since_last_submit;
    double new_shares_per_minute = (client->shares_per_minute * SMOOTHING_FACTOR
                                 + 0.05 * submissions_per_second);

    client->shares_per_minute = new_shares_per_minute;
    client->last_submit_time = current_timestamp();
    debuglog("client->shares_per_minute %f\n", new_shares_per_minute);
}



void client_change_difficulty(YAAMP_CLIENT *client, double difficulty)
{
    if (difficulty <= 0)
        return;

    difficulty = client_normalize_difficulty(difficulty);
    if (difficulty <= 0)
        return;

    debuglog("Changing difficulty to %f from %f\n", difficulty, client->difficulty_actual);

    if (difficulty == client->difficulty_actual)
        return;

    client->difficulty_actual = difficulty;
    client_send_difficulty(client, difficulty);
}

void client_adjust_difficulty(YAAMP_CLIENT *client)
{
    if (client->difficulty_remote) {
        client_change_difficulty(client, client->difficulty_remote);
        return;
    }

    double factor = 1.0;

    if (client->shares_per_minute > 100) {
        client_change_difficulty(client, client->difficulty_actual * 4);
    }
    else if (client->difficulty_fixed) {
        // do nothing
    }
    else if (client->shares_per_minute > 75) {
        client_change_difficulty(client, client->difficulty_actual * 3.5);
    }
    else if (client->shares_per_minute > 50) {
        client_change_difficulty(client, client->difficulty_actual * 3);
    }
    else if (client->shares_per_minute > 25) {
        client_change_difficulty(client, client->difficulty_actual * 2);
    }
    else if (client->shares_per_minute > 20) {
        client_change_difficulty(client, client->difficulty_actual * 1.5);
    }
    else if (client->shares_per_minute > 15) {
        client_change_difficulty(client, client->difficulty_actual * 1.2);
    }
    else if (client->shares_per_minute < 4) {
        client_change_difficulty(client, client->difficulty_actual / 2);
    }
    else if (client->shares_per_minute < 7) {
        client_change_difficulty(client, client->difficulty_actual / 1.2);
    }

    double new_difficulty = client->difficulty_actual * factor;

    if (new_difficulty >= g_stratum_difficulty && new_difficulty != client->difficulty_actual) {
        debuglog("Adjusting difficulty to %f from %f\n", new_difficulty, client->difficulty_actual);
        client_change_difficulty(client, new_difficulty);
    }
}

int client_send_difficulty(YAAMP_CLIENT *client, double difficulty)
{
    if(client->shares_per_minute <  7 || client->shares_per_minute > 15)
        client->shares_per_minute = YAAMP_SHAREPERSEC;

    char buf[64];
    if (difficulty >= 1.0) {
        snprintf(buf, sizeof(buf), "[%.3f]", difficulty);
    } else {
        snprintf(buf, sizeof(buf), "[%0.8f]", difficulty);
    }

    client_call(client, "mining.set_difficulty", buf);

    return 0;
}

void client_initialize_difficulty(YAAMP_CLIENT *client)
{
    char *p = strstr(client->password, "d=");
    char *p2 = strstr(client->password, "decred=");
    if (!p || p2)
        return;

    double diff = client_normalize_difficulty(atof(p + 2));
    uint64_t user_target = diff_to_target(diff);

    //	debuglog("%016llx target\n", user_target);
    if (user_target >= g_stratum_min_diff && user_target <= g_stratum_max_diff) {
        client->difficulty_actual = diff;
        client->difficulty_fixed = false;
    }
}

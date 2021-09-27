bool justTouchedGround[MAXPLAYERS+1];

public Action OnPlayerRunCmd(
    int client,
    int &buttons,
    int &impulse,
    float vel[3],
    float angles[3],
    int &weapon,
    int &subtype,
    int &cmdnum,
    int &tickcount,
    int &seed,
    int mouse[2]
)
{
    if (IsFakeClient(client) || !IsPlayerAlive(client))
    {
        return Plugin_Continue;
    }


    if (GetEntityFlags(client) & FL_ONGROUND)
    {
        int nOldButtons = GetEntProp(client, Prop_Data, "m_nOldButtons");

        // buttons &= ~IN_DUCK;

        nOldButtons &= ~(IN_JUMP | IN_DUCK);

        if (buttons & IN_JUMP)
        {
            buttons &= ~IN_DUCK;
            SetEntProp(client, Prop_Data, "m_nOldButtons", nOldButtons);
        }
    }
    return Plugin_Continue;
}

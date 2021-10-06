#pragma semicolon 1

#include <sourcemod>
#include <sdkhooks>
#include <sdktools>
#include <dhooks>


// THANKS TWIIKUU
public void OnPluginStart()
{
    Handle game_config = LoadGameConfigFile("tf-autohop");

    Handle detour_PreventBunnyJumping = DHookCreateFromConf(game_config, "CTFGameMovement::PreventBunnyJumping");
    if (detour_PreventBunnyJumping == INVALID_HANDLE)
    {
        LogMessage("Could not set up detour for CTFGameMovement::PreventBunnyJumping");
    }
    else if (!DHookEnableDetour(detour_PreventBunnyJumping, false, Detour_PreventBunnyJumping))
    {
        LogMessage("Coult not detour CTFGameMovement::PreventBunnyJumping");
    }
}

static MRESReturn Detour_PreventBunnyJumping(Address self)
{
    // return MRES_Ignored;
    return MRES_Supercede;
}

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

    // get our flags
    int flags = GetEntityFlags(client);

    // we're on the ground
    if (flags & FL_ONGROUND)
    {
        // we're holding jump
        if (buttons & IN_JUMP)
        {
            // get our old buttons
            int nOldButtons = GetEntProp(client, Prop_Data, "m_nOldButtons");
            // remove previous jump input to trick the game into pogoing for us
            nOldButtons &= ~(IN_JUMP | IN_DUCK);
            // set our oldbuttons
            SetEntProp(client, Prop_Data, "m_nOldButtons", nOldButtons);
            //.remove duck from current buttons so we can duck bhop
            buttons     &= ~IN_DUCK;
        }
    }
    return Plugin_Continue;
}




using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace RoundManagement
{
    public class TeamChatRoomManager : ChatRoomManager
    {
        protected override void ManageRoom(PlayerPawn localPlayer)
        {
            if (localPlayer.CrewId == null)
            {
                broadcastTrigger.RoomName = "Neutral";
                receiptTrigger.RoomName = "Neutral";
            }
            else
            {
                string team;
                if (localPlayer.CrewId.GetComponent<Crew>().Team)
                {
                    team = "Blue";
                }
                else
                {
                    team = "Red";
                }
                
                receiptTrigger.RoomName = team;
                
                broadcastTrigger.RoomName = team;
            }
        }
    }
}

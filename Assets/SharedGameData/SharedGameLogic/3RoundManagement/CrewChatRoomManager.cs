using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace RoundManagement
{
    public class CrewChatRoomManager : ChatRoomManager
    {
        protected override void ManageRoom(PlayerPawn localPlayer)
        {
            if (localPlayer.CrewId == null)
            {
                receiptTrigger.enabled = false;
                broadcastTrigger.enabled = false;
            }
            else
            {
                string team;
                if (localPlayer.CrewId.GetComponent<Crew>().Team)
                {
                    team="Blue";
                }
                else
                {
                    team = "Red";
                }
                string nb = localPlayer.CrewId.transform.GetSiblingIndex().ToString();

                receiptTrigger.enabled = true;
                receiptTrigger.RoomName = team + nb;

                broadcastTrigger.enabled = true;
                broadcastTrigger.RoomName = team + nb;


            }
        }
    }
}

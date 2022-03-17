using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Dissonance;

namespace RoundManagement
{
    
    public abstract class ChatRoomManager : MonoBehaviour
    {
        
        protected VoiceBroadcastTrigger broadcastTrigger;
        protected VoiceReceiptTrigger receiptTrigger;
        protected void Awake()
        {
            broadcastTrigger = GetComponent<VoiceBroadcastTrigger>();
            receiptTrigger = GetComponent<VoiceReceiptTrigger>();
            PlayerPawn.OnLocalPlayerChangedCrew += ManageRoom;
        }
        
        protected virtual void ManageRoom(PlayerPawn localPlayer)
        {

        }
        
    }
}

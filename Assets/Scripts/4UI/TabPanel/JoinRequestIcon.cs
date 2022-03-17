using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using Mirror;
using TMPro;
using RoundManagement;


namespace UI.TabPanel
{
    public class JoinRequestIcon : MonoBehaviour
    {
        [SerializeField] TMP_Text playerName = null;

        public NetworkIdentity requestingPlayer = null;


        private void Start()
        {

            playerName.text = requestingPlayer.gameObject.name + " wants to join your crew.";
        }

        public void AcceptOrRefuse(bool response)
        {            
            PlayerPawn.localPlayerPawn.CmdRespondJoinRequest(PlayerPawn.localPlayerPawn.CrewId, requestingPlayer, response);
        }
    }
}


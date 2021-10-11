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

        public uint requestingPlayer = 0;


        private void Start()
        {

            playerName.text = NetworkIdentity.spawned[requestingPlayer].gameObject.name + " wants to join your crew.";
        }

        public void AcceptOrRefuse(bool response)
        {            
            PlayerPawn.local.CmdRespondJoinRequest(requestingPlayer, response);
        }
    }
}


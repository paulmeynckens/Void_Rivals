using UnityEngine;
using System.Collections;
using RoundManagement;

namespace UI.TabPanel
{
    public class JoinRequestsPanel : MonoBehaviour
    {
        public static JoinRequestsPanel instance;
        



        private void Awake()
        {
            instance = this;
            /*
            PlayerCrewManager.OnJoinRequest += CreateJoinRequest;
            PlayerCrewManager.OnShoutMessage += LogPlayerMessage;
            */
        }


        
    }
}
using UnityEngine;
using System.Collections;
using TMPro;
using Mirror;
using RoundManagement;

namespace UI.TabPanel
{
    public class TeamsPanel : MonoBehaviour
    {

        public static TeamsPanel instance = null;
        private void Awake()
        {
            instance = this;
        }

        public Transform blueTeam = null;

        public Transform redTeam = null;

        public Transform noTeam = null;

        [SerializeField] TMP_Text blueTeamNB = null;
        [SerializeField] TMP_Text redTeamNB = null;

        public GameObject youNeedAShipToSpawn = null;

        private void FixedUpdate()
        {
            blueTeamNB.text = TeamsManager.instance.BlueCount.ToString();
            redTeamNB.text = TeamsManager.instance.RedCount.ToString();
            
        }

        

    }
}
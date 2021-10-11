using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using RoundManagement;

namespace UI.TabPanel
{
    public class ShipsPanel : MonoBehaviour
    {
        public static ShipsPanel instance;
        [SerializeField] GameObject shipTooBigPanel = null;
        [SerializeField] GameObject shipTooSmallPanel = null;

        private void Awake()
        {
            instance = this;
            gameObject.SetActive(false);
        }

        public void SpawnShip(string ship)
        {
            
            
            PlayerPawn.local.CmdAskSpawnShip(ship);

            if (CheckShipSize(ship))
            {
                gameObject.SetActive(false);
            }
        }

        bool CheckShipSize(string ship)
        {
            int crewSize = PlayerPawn.local.Crew.crewMembers.Count;
            int requestedShipSize = ShipsManager.instance.shipSpawners[ship].shipSize;

            if (crewSize == requestedShipSize)
            {
                
            }
            else if (requestedShipSize > crewSize)
            {
                shipTooBigPanel.SetActive(true);
            }
            else
            {
                shipTooSmallPanel.SetActive(true);
            }

            return crewSize == requestedShipSize;
        }
    }
}

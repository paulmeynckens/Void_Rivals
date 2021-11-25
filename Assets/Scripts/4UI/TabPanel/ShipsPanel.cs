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
            int requestedMaxShipCapacity = ShipsManager.instance.shipSpawners[ship].shipMaxCapacity;
            int requestedMinShipCapacity = ShipsManager.instance.shipSpawners[ship].shipMinCapacity;


            if (crewSize > requestedMaxShipCapacity)
            {
                shipTooSmallPanel.SetActive(true);
                return false;
            }

            if (crewSize < requestedMinShipCapacity )
            {
                shipTooBigPanel.SetActive(true);
                return false;
            }

            return true;
        }
    }
}

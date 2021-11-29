using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Core;
using Mirror;
using ShipsLogic;
using ShipsLogic.Holes;
using CharacterLogic;

namespace RoundManagement
{
    public class ShipDestructor : NetworkBehaviour
    {
        Structure structure=null;
        BodiesHolder bodiesHolder=null;
        private void Awake()
        {
            bodiesHolder = GetComponent<BodiesHolder>();
        }

        public override void OnStartServer()
        {
            base.OnStartServer();
            structure = GetComponent<Structure>();
            structure.OnServerDie += ServerDestroyShip;
        }

        public void ServerDespawnShip()
        {
            ServerUndockShips();

            ServerKillPlayers();

            StartCoroutine(ServerWaitAndDestroy());
        }

        void ServerDestroyShip()
        {
            ServerUndockShips();

            ServerKillPlayers();

            StartCoroutine(ServerWaitAndDestroy());
            
        }

        void ServerUndockShips()
        {
            ShipDocker[] dockedShips = GetComponentsInChildren<ShipDocker>();

            foreach (ShipDocker dockedShip in dockedShips)
            {
                if (dockedShip.transform.parent == transform)
                {
                    dockedShip.ServerEjectBeforeDestruction();
                }
            }
        }

        void ServerKillPlayers()
        {
            CharacterHealth[] characterHealths = transform.GetComponentsInChildren<CharacterHealth>();
            foreach (CharacterHealth characterHealth in characterHealths)
            {
                characterHealth.ServerPulverize();
            }
        }

        IEnumerator ServerWaitAndDestroy()
        {
            yield return new WaitForSeconds(10);
            
            NetworkServer.Destroy(this.gameObject);

        }
    }
}

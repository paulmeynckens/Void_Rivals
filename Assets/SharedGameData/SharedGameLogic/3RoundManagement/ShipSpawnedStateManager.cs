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
    public class ShipSpawnedStateManager : NetworkBehaviour
    {
        Structure structure;
        ShipDocker shipDocker;
        BodiesHolder bodiesHolder;

        #region syncvars + hooks
        bool spawned = false;
        public bool Spawned
        {
            get => spawned;
        }
        
        

        #endregion

        #region both sides
        private void Awake()
        {
            
            bodiesHolder = GetComponent<BodiesHolder>();
            shipDocker = GetComponent<ShipDocker>();
        }




        #endregion

        public override void OnStartServer()
        {
            base.OnStartServer();
            CustomVisibility.globalVisibilities.Add(netIdentity, false);
            structure = GetComponent<Structure>();
            structure.OnServerDie += ServerDestroyShip;

            gameObject.SetActive(false);

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

            //NetworkServer.Destroy(this.gameObject);

            CustomVisibility.globalVisibilities[netIdentity] = false;
            spawned = false;
            gameObject.SetActive(false);

            yield return new WaitForSeconds(1);

            shipDocker.StowShip();

            

        }

        public void ServerSpawnShip(Vector3 position, Quaternion rotation)
        {
            bodiesHolder.externalCollider.parent = null;
            bodiesHolder.externalCollider.position = position;
            bodiesHolder.externalCollider.rotation = rotation;

            CustomVisibility.globalVisibilities[netIdentity] = true;
            spawned = true;
            gameObject.SetActive(true);
            shipDocker.ServerPrepareShip();
            

            
        }
    }
}

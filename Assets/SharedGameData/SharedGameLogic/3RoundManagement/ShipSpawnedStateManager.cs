using System.Collections;
using System;
using System.Collections.Generic;
using UnityEngine;
using Core;
using Mirror;
using ShipsLogic;
using ShipsLogic.Holes;
using CharacterLogic;

namespace RoundManagement
{
    [DefaultExecutionOrder(+1000)]
    public class ShipSpawnedStateManager : NetworkBehaviour
    {
        Structure structure;
        ShipDocker shipDocker;
        
        [SerializeField] Transform externalCollider = null;
        IResettable[] resettables;

        #region syncvars + hooks

        [SyncVar(hook = nameof(ClientActivateSpawn))]bool spawned = false;
        public bool Spawned
        {
            get => spawned;
        }

        public event Action<bool> OnClientSpawnStateChanged = delegate { };
        
        void ClientActivateSpawn(bool _old, bool _new)
        {
            OnClientSpawnStateChanged(_new);
        }

        #endregion

        #region both sides
        private void Awake()
        {
            resettables = transform.parent.GetComponentsInChildren<IResettable>();
           
            shipDocker = transform.parent.GetComponentInChildren<ShipDocker>();
        }




        #endregion

        public override void OnStartServer()
        {
            base.OnStartServer();
            
            structure = GetComponent<Structure>();
            structure.OnServerDie += ServerDestroyShip;



        }



        public void ServerDespawnShip()
        {
            ServerUndockShips();

            ServerReset();                        

            shipDocker.StowShip();

            spawned=false;
        }

        void ServerDestroyShip()
        {
            ServerUndockShips();

            ServerKillPlayers();

            StartCoroutine(ServerWaitAndDespawn());
            
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
                characterHealth.ServerDespawnImmediately();
            }
        }

        IEnumerator ServerWaitAndDespawn()
        {
            yield return new WaitForSeconds(5);

            ServerReset();

            yield return new WaitForSeconds(1);

            shipDocker.StowShip();

            spawned = false;

        }

        void ServerReset()
        {
            
            foreach (IResettable resettable in resettables)
            {
                resettable.ServerReset();
            }
        }

        public void ServerSpawnShip(Vector3 position, Quaternion rotation)
        {
            externalCollider.parent = null;
            externalCollider.position = position;
            externalCollider.rotation = rotation;
            /*
            CustomVisibility.globalVisibilities[netIdentity] = true;
            
            */

            shipDocker.ServerPrepareShip();
            spawned = true;

        }
    }
}

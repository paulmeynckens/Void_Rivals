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
    [DefaultExecutionOrder(-1000)]
    public class ShipSpawnedStateManager : MonoBehaviour
    {
        [SerializeField] Transform externalCollider = null;
        NetworkIdentity[] childNetworkIdentities;

        

        public Structure Structure { get => structure;}
        Structure structure;       
        
        
        IResettable[] resettables;

        MaleDockingPort maleDockingPort;


        public ShipPawn ShipPawn { get => shipPawn;}
        ShipPawn shipPawn;

        

        #region syncvars + hooks




        bool spawned = false;
        public bool Spawned
        {
            get => spawned;
        }
        

        


        #endregion




        
        private void Awake()
        {
            transform.parent = null;

            shipPawn = GetComponentInChildren<ShipPawn>();

            structure = GetComponentInChildren<Structure>();
            
            structure.OnServerDie += ServerDestroyShip;

            resettables = GetComponentsInChildren<IResettable>();

            maleDockingPort = GetComponentInChildren<MaleDockingPort>();

            childNetworkIdentities = GetComponentsInChildren<NetworkIdentity>();

        }


        //[Server]
        private void Start()
        {
            
            
            /*
            foreach (NetworkIdentity networkIdentity in childNetworkIdentities)
            {
                NetworkServer.UnSpawn(networkIdentity.gameObject);
            }
            */
        }


        public void ServerDespawnShip()
        {
            
            ServerUndockChildShips();

            ServerReset();
            /*

            foreach (NetworkIdentity networkIdentity in childNetworkIdentities)
            {
                NetworkServer.UnSpawn(networkIdentity.gameObject);
            }
            */
            spawned =false;
        }

        void ServerDestroyShip()
        {
            ServerUndockChildShips();

            ServerKillPlayers();

            StartCoroutine(ServerWaitAndDespawn());
            
        }

        void ServerUndockChildShips()
        {
            MaleDockingPort[] dockedMales = GetComponentsInChildren<MaleDockingPort>();

            foreach (MaleDockingPort dockedMale in dockedMales)
            {
                if (dockedMale!=maleDockingPort)
                {
                    dockedMale.ServerEject();
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


            spawned = false;

            shipPawn.ServerLeaveCrew();

        }

        void ServerReset()
        {
            
            foreach (IResettable resettable in resettables)
            {
                resettable.ServerReset();
            }
        }

        public void ServerSpawnShip(Vector3 position, Quaternion rotation,NetworkIdentity crew)
        {
            
            
            maleDockingPort.ServerPrepare();
            externalCollider.position = position;
            externalCollider.rotation = rotation;

            spawned = true;

            shipPawn.ServerJoinCrew(crew);

            /*
            foreach(NetworkIdentity networkIdentity in childNetworkIdentities)
            {
                NetworkServer.Spawn(networkIdentity.gameObject);
            }
            */

        }
    }
}

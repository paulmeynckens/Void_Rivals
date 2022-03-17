using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using Core;
using Core.ServerAuthoritativeActions;
using Mirror;
using System;
using ShipsLogic;

namespace RoundManagement
{
    public class Crew : NetworkBehaviour
    {
        public bool Team { get => team; set => team = value; }

        public int CrewMinCapacity
        {
            get => crewMinCapacity;
            set => crewMinCapacity = value;
        }

        public int CrewMaxCapacity
        {
            get => crewMaxCapacity;
            set => crewMaxCapacity = value;
        }


        public NetworkIdentity ShipPawnId
        {
            get => shipPawnId;

        }

        public CrewState State { get => state; set => state = value; }




        bool team=false;

        
        

        ShipSpawnedStateManager shipSpawnedStateManager = null;

        NetworkIdentity shipPawnId = null;

        [SyncVar(hook = nameof(ClientChangeShip))] uint shipPawnNetId = 0;

        [SyncVar] string shipName = " ";

        [SyncVar] CrewState state = CrewState.Open;

        [SyncVar] int crewMinCapacity = 1;
        
        
        

        [SyncVar] int crewMaxCapacity = MAX_CREW_MEMBERS;

        [SyncVar] string shipType = " ";
        public SyncDictionary<NetworkIdentity, float> joinRequests = new SyncDictionary<NetworkIdentity, float>();
        
        
        
        public const float JOIN_CREW_REQUEST_TIMEOUT = 6f;
        public const int MAX_CREW_MEMBERS = 4;// increase this number when the maximum ship size increases


        void ClientChangeShip(uint _old, uint _new)
        {
            if (_new == 0)
            {
                shipPawnId = null;
                
            }
            else
            {
                StartCoroutine(SearchShipNetidentity(_new));
            }

        }

        IEnumerator SearchShipNetidentity(uint netId)
        {

            while (shipPawnId == null || shipPawnId.netId != netId)
            {
                yield return null;
                if (NetworkClient.spawned.TryGetValue(netId, out NetworkIdentity identity))
                {
                    shipPawnId = identity;
                    
                }

            }

        }

        private void FixedUpdate()
        {
            if (isServer)
            {
                ServerCheckJoinRequestsTimeout();
            }

        }

        public override void OnStartServer()
        {
            base.OnStartServer();
            foreach(Transform _transform in transform.GetComponentInChildren<Transform>())
            {
                Destroy(_transform.gameObject);//to avoid miscalculations of child count due to crew icon
            }
            
        }

        void ServerCheckJoinRequestsTimeout()
        {

            foreach (KeyValuePair<NetworkIdentity, float> joinRequest in joinRequests)
            {

                if (joinRequest.Value < Time.time-JOIN_CREW_REQUEST_TIMEOUT)
                {
                    joinRequests.Remove(joinRequest.Key);
                    break;
                }

            }

        }

       
        

        public void ServerSpawnShip(ShipSpawner shipSpawner)
        {

            Transform location = TeamsManager.instance.FindSpawnLocation(team);

           shipSpawnedStateManager = shipSpawner.GetAvailableShip();


            Health shipHealth = shipSpawnedStateManager.Structure;
            shipHealth.OnServerDie += ServerRemoveShip;

            shipSpawnedStateManager.ServerSpawnShip(location.position, location.rotation, netIdentity);


            shipPawnId = shipSpawnedStateManager.ShipPawn.netIdentity;
            shipPawnNetId = shipPawnId.netId;
            shipSpawnedStateManager.ShipPawn.CrewId = netIdentity;
            crewMaxCapacity = shipSpawner.shipMaxCapacity;
            crewMinCapacity = shipSpawner.shipMinCapacity;
        }

        public void ServerRemoveShip()
        {
            if (shipSpawnedStateManager == null)
            {
                return;
            }
            shipSpawnedStateManager.ServerDespawnShip();
            shipSpawnedStateManager.ShipPawn.CrewId = null;
            shipSpawnedStateManager =null;            
            shipPawnId = null;
            shipPawnNetId = 0;
            crewMaxCapacity = MAX_CREW_MEMBERS;
            crewMinCapacity = 1;
            
        }
        
        



    }



}
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
        public static List<Crew> crews = new List<Crew>();

        [SyncVar] public bool team = true;

        public event Action<uint> OnChangeCaptain;
        [SyncVar(hook = nameof(ClientNotifyChangeCaptain))] public uint captain = 0;
        void ClientNotifyChangeCaptain(uint _old, uint _new)
        {
            OnChangeCaptain?.Invoke(_new);
        }

        public NetworkIdentity Ship
        {
            get => ship;
        }
        [SyncVar]  NetworkIdentity ship = null;

        [SyncVar] public string shipName = " ";

        [SyncVar] public CrewState state = CrewState.Confirm;
        
        public int CrewMinCapacity
        {
            get => crewMinCapacity;
            set => crewMinCapacity = value;
        }
        [SyncVar] int crewMinCapacity = 0;
        
        public int CrewMaxCapacity
        {
            get => crewMaxCapacity;
            set => crewMaxCapacity = value;
        }
        [SyncVar] int crewMaxCapacity = MAX_CREW_MEMBERS;

        [SyncVar] public string shipType = " ";
        public SyncDictionary<uint, float> joinRequests = new SyncDictionary<uint, float>();
        public readonly SyncList<uint> crewMembers = new SyncList<uint>();
        
        
        public const float JOIN_CREW_REQUEST_TIMEOUT = 6f;
        public const int MAX_CREW_MEMBERS = 4;// increase this number when the maximum ship size increases



        private void Awake()
        {
            crews.Add(this);
        }
        private void FixedUpdate()
        {
            if (isServer)
            {
                ServerCheckJoinRequestsTimeout();
            }

        }

        void ServerCheckJoinRequestsTimeout()
        {

            foreach (KeyValuePair<uint, float> joinRequest in joinRequests)
            {

                if (joinRequest.Value < Time.time-JOIN_CREW_REQUEST_TIMEOUT)
                {
                    joinRequests.Remove(joinRequest.Key);
                    break;
                }

            }

        }

        public void ServerAddCrewMember(uint netId)
        {
            if (!crewMembers.Contains(netId))
            {
                
                crewMembers.Add(netId);
            }
            

        }
        public void ServerRemoveCrewMember(uint netId)
        {
            if (crewMembers.Contains(netId))
            {
                crewMembers.Remove(netId);
            }

        }

        public void ServerSpawnShip(ShipSpawner shipSpawner)
        {

            Transform location = TeamsManager.instance.FindSpawnLocation(team);

            ShipSpawnedStateManager spawnedShip = shipSpawner.GetAvailableShip();

            

            /*
            LinkToNetId shipLinkToNetId = spawnedShip.GetComponent<LinkToNetId>();
            shipLinkToNetId.netIdLink = netId;
            */

            ShipSpawnLocationHolder shipCrewManager = spawnedShip.GetComponent<ShipSpawnLocationHolder>();

            
            
            
            Health shipHealth = spawnedShip.Structure;
            shipHealth.OnServerDie += ServerRemoveShip;

            spawnedShip.ServerSpawnShip(location.position, location.rotation, netIdentity);


            ship = spawnedShip.ShipPawn.netIdentity;
            crewMaxCapacity = shipSpawner.shipMaxCapacity;
            crewMinCapacity = shipSpawner.shipMinCapacity;
        }

        void ServerRemoveShip()
        {

            ship = null;
            crewMaxCapacity = 0;
            crewMinCapacity = 0;
            
        }
        
        private void OnDestroy()
        {
            crews.Remove(this);
        }



    }



}
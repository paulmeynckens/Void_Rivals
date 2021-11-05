using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using Core;
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


        [SyncVar] public uint ship = 0;

        [SyncVar] public string shipName = " ";

        [SyncVar] public CrewState state = CrewState.Confirm;
        [SyncVar] public int shipSize =0;

        [SyncVar] public string shipType = " ";
        public SyncDictionary<uint, float> joinRequests = new SyncDictionary<uint, float>();
        public readonly SyncList<uint> crewMembers = new SyncList<uint>();
        
        
        public const float JOIN_CREW_REQUEST_TIMEOUT = 6f;
        public const int MAX_CREW_MEMBERS = 2;// increase this number when the maximum ship size increases



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
            else
            {
                
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
            GameObject spawnedShip = Instantiate(shipSpawner.prefab, location.position, location.rotation);

            LinkToNetId shipLinkToNetId = spawnedShip.GetComponent<LinkToNetId>();
            shipLinkToNetId.netIdLink = netId;

            

            NetworkServer.Spawn(spawnedShip);
            ship = spawnedShip.GetComponent<NetworkIdentity>().netId;
            Health shipHealth = spawnedShip.GetComponent<Health>();
            shipHealth.OnServerDie += ServerRemoveShip;
        }

        void ServerRemoveShip()
        {
            ship = 0;
            shipSize = 0;
            
        }
        
        private void OnDestroy()
        {
            crews.Remove(this);
        }



    }



}
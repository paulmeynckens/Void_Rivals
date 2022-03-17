using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Mirror;
using System;

namespace RoundManagement
{
    public class ShipPawn : NetworkBehaviour
    {
        // Start is called before the first frame update

        public NetworkIdentity CrewId
        {
            get => crewId;
            set
            {

                crewId = value;
                crewNetId = value.netId;
            }
        }
        

        NetworkIdentity crewId = null;

        [SyncVar(hook = nameof(ClientChangeCrew))] uint crewNetId = 0;


        public event Action<bool> OnClientSpawnStateChanged = delegate { };

        public SpawnLocationShuffler SpawnLocationShuffler { get => spawnLocationShuffler; }
        [SerializeField] SpawnLocationShuffler spawnLocationShuffler = null;




        void ClientChangeCrew(uint _old, uint _new)
        {
            if (_new == 0)
            {
                crewId = null;
                OnClientSpawnStateChanged(false);
            }
            else
            {
                StartCoroutine(SearchCrewNetidentity(_new));
            }
            
        }

        IEnumerator SearchCrewNetidentity(uint netId)
        {
            while (crewId == null || crewId.netId!= netId)
            {
                yield return null;
                if (NetworkClient.spawned.TryGetValue(netId, out NetworkIdentity identity))
                {
                    crewId = identity;
                    OnClientSpawnStateChanged(true);
                }
                    
            }
        }

        public void ServerJoinCrew(NetworkIdentity crew)
        {
            
            crewId = crew;
        }

        public void ServerLeaveCrew()
        {
            
            crewId = null;
        }
      
    }
}

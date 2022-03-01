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

        public uint ShipCrewNetId
        {
            get => shipCrewNetId;
            set => shipCrewNetId = value;
        }
        

        [SyncVar(hook = nameof(ClientChangeCrew))]uint shipCrewNetId = 0;
        NetworkIdentity crewNetworkIdentity = null;



        public event Action<bool> OnClientSpawnStateChanged = delegate { };

        public SpawnLocationShuffler SpawnLocationShuffler { get => spawnLocationShuffler; }
        [SerializeField] SpawnLocationShuffler spawnLocationShuffler = null;




        void ClientChangeCrew(uint _old, uint _new)
        {
            OnClientSpawnStateChanged(_new != 0);
            if (_new == 0)
            {
                crewNetworkIdentity=null;
            }
            else
            {
                StartCoroutine(ClientSearchAndJoinCrew(_new));
            }

        }

        IEnumerator ClientSearchAndJoinCrew(uint crewNetId)
        {
            while (crewNetworkIdentity == null)
            {
                yield return null;
                if (NetworkIdentity.spawned.TryGetValue(crewNetId,out NetworkIdentity foundCrew))
                {
                    crewNetworkIdentity = foundCrew;
                }
            }
        }

        public void ServerJoinCrew(NetworkIdentity crew)
        {
            
            shipCrewNetId = crew.netId;
        }

        public void ServerLeaveCrew()
        {
            
            shipCrewNetId = 0;
        }
      
    }
}

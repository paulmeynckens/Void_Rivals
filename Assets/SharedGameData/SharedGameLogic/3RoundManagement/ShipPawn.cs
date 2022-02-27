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

        Transform initialParent;

        public event Action<bool> OnClientSpawnStateChanged = delegate { };

        public SpawnLocationShuffler SpawnLocationShuffler { get => spawnLocationShuffler; }
        [SerializeField] SpawnLocationShuffler spawnLocationShuffler = null;

        private void Awake()
        {
            initialParent = transform.parent;
        }


        void ClientChangeCrew(uint _old, uint _new)
        {
            OnClientSpawnStateChanged(_new != 0);
            if (_new == 0)
            {
                transform.parent = initialParent;
            }
            else
            {
                StartCoroutine(ClientSearchAndJoinCrew(_new));
            }

        }

        IEnumerator ClientSearchAndJoinCrew(uint crewNetId)
        {
            while (transform.parent.GetComponent<NetworkIdentity>() == null)
            {
                yield return null;
                if (NetworkIdentity.spawned.TryGetValue(crewNetId,out NetworkIdentity foundCrew))
                {
                    transform.parent = foundCrew.transform;
                }
            }
        }

        public void ServerJoinCrew(NetworkIdentity crew)
        {
            transform.parent = crew.transform;
            shipCrewNetId = crew.netId;
        }

        public void ServerLeaveCrew()
        {
            transform.parent = initialParent;
            shipCrewNetId = 0;
        }
      
    }
}

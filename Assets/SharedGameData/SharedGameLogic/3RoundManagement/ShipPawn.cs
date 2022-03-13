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

        public NetworkIdentity ShipCrewId
        {
            get => shipCrewId;
            set => shipCrewId = value;
        }
        

        [SyncVar(hook = nameof(ClientChangeCrew))]NetworkIdentity shipCrewId = null;
        



        public event Action<bool> OnClientSpawnStateChanged = delegate { };

        public SpawnLocationShuffler SpawnLocationShuffler { get => spawnLocationShuffler; }
        [SerializeField] SpawnLocationShuffler spawnLocationShuffler = null;




        void ClientChangeCrew(NetworkIdentity _old, NetworkIdentity _new)
        {
            OnClientSpawnStateChanged(_new != null);
        }



        public void ServerJoinCrew(NetworkIdentity crew)
        {
            
            shipCrewId = crew;
        }

        public void ServerLeaveCrew()
        {
            
            shipCrewId = null;
        }
      
    }
}

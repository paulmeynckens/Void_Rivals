using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Mirror;
using Core;

namespace Core.RuntimeSpawning
{
    public class RuntimeSpawner : NetworkBehaviour
    {
        [SerializeField] PrefabAndLocation[] prefabsAndLocations=null;

        
        public override void OnStartServer()
        {
            base.OnStartServer();
            foreach(PrefabAndLocation prefabAndLocation in prefabsAndLocations)
            {
                GameObject instancied= Instantiate(prefabAndLocation.prefab);
                RuntimeSpawned runtimeSpawned = instancied.GetComponent<RuntimeSpawned>();
                runtimeSpawned.SpawnedPosition = new RuntimeSpawnedPosition { localPosition = prefabAndLocation.location.localPosition, localRotation = prefabAndLocation.location.localRotation, parentShipNetId = netId };

                NetworkServer.Spawn(instancied);
            }

        }

        
    }
}

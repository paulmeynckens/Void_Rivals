using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Mirror;

namespace ShipsLogic
{
    public class EnergyConsumer : NetworkBehaviour
    {
        [SerializeField] float capacity = 100;
        public float Capacity { get => capacity; }

        [SyncVar] float storedEnergy=0;
        public float StoredEnergy { get => storedEnergy; set => storedEnergy=value; }
    }
}


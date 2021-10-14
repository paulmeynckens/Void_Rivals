
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Mirror;

namespace ShipsLogic
{

    public interface IConsumeEnergy
    {
        float Capacity { get; set; }
        float StoredEnergy { get; set; }

        byte Index { get; set; }
    }

    public class EnergyGenerator : NetworkBehaviour
    {
        [SerializeField] float totalPower = 100;

        IConsumeEnergy[] rankedConsumers;
        IConsumeEnergy[] indexedConsumers;
        public readonly SyncList<byte> energyConsumersRanks = new SyncList<byte>();

        private void Awake()
        {
            rankedConsumers = GetComponentsInChildren<IConsumeEnergy>();
            indexedConsumers = GetComponentsInChildren<IConsumeEnergy>();
            for(int i = 0; i < indexedConsumers.Length; i++)
            {
                energyConsumersRanks.Add((byte)i);
                indexedConsumers[i].Index =(byte) i;
            }

        }

        private void FixedUpdate()
        {
            if (isServer)
            {
                ServerDistributeEnergy();
            }
            else
            {
                enabled = false;
            }
            
        }


        #region Server 
        void ServerDistributeEnergy()
        {
            float remainingFlux = totalPower*Time.fixedDeltaTime;
            for(int i = 0; i < rankedConsumers.Length; i++)
            {
                if (remainingFlux <= 0)
                {
                    return;
                }
                if(rankedConsumers[i].StoredEnergy< rankedConsumers[i].Capacity)
                {
                    
                    float energyDifference = rankedConsumers[i].Capacity - rankedConsumers[i].StoredEnergy;
                    if (energyDifference <= remainingFlux)
                    {
                        rankedConsumers[i].StoredEnergy += remainingFlux;
                        remainingFlux = 0;
                    }
                    else
                    {
                        rankedConsumers[i].StoredEnergy += energyDifference;
                        remainingFlux -= energyDifference;
                    }
                }
            }

        }
        void ServerUpdateRanksInfos()
        {
            for(int i = 0; i < rankedConsumers.Length; i++)
            {
                energyConsumersRanks[i] =(byte) rankedConsumers[i].Index;
            }
        }

        #endregion

        #region Commands
        [Command]
        public void RankUp(int rankedUpIndex)
        {
            if (rankedUpIndex == 0)
            {
                Debug.LogError("the first energy consumer can't go higher in priority");
                return;
            }

            //switching the n and n-1 index
            IConsumeEnergy decending = rankedConsumers[rankedUpIndex - 1];
            rankedConsumers[rankedUpIndex - 1] = rankedConsumers[rankedUpIndex];
            rankedConsumers[rankedUpIndex] = decending;

            ServerUpdateRanksInfos();
        }

        [Command]
        public void RankDown(int rankedDownIndex)
        {
            if (rankedDownIndex == rankedConsumers.Length-1)
            {
                Debug.LogError("the last energy consumer can't go lower in priority");
                return;
            }

            //switching the n and n+1 index
            IConsumeEnergy ascending = rankedConsumers[rankedDownIndex + 1];
            rankedConsumers[rankedDownIndex + 1] = rankedConsumers[rankedDownIndex];
            rankedConsumers[rankedDownIndex] = ascending;

            ServerUpdateRanksInfos();
        }
        #endregion
    }
}

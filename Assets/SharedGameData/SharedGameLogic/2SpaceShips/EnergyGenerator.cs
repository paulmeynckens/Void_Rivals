
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Mirror;

namespace ShipsLogic
{

    public class EnergyGenerator : NetworkBehaviour
    {
        [SerializeField] float totalPower = 100;


        [SerializeField]EnergyConsumer[] rankedConsumers;

        public readonly SyncList<byte> energyConsumersRanks = new SyncList<byte>();



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
                energyConsumersRanks[i] =(byte) rankedConsumers[i].ComponentIndex;
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

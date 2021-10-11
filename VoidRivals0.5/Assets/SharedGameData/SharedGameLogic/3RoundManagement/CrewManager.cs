using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Mirror;
using System;
using Core;

namespace RoundManagement
{
    public abstract class CrewManager : NetworkBehaviour
    {
        Crew crew = null;
        public Crew Crew
        {
            get
            {
                return crew;
            }

            set
            {
                crew = value;

                if (value == null)
                {
                    crewId = 0;
                }
                else
                {
                    crewId = value.netId;
                }
            }
        }


        public event Action OnDestroy;

        #region syncvars + hooks

        

        [SyncVar(hook = nameof(ClientSetCrew))] uint crewId = 0;

        void ClientSetCrew(uint _old, uint _new)
        {
            StopAllCoroutines();
            if (_new != 0)
            {
                
                StartCoroutine(ClientSearchCrew(_new));
            }
            else
            {
                crew=null;
            }
        }

        IEnumerator ClientSearchCrew(uint _crewId)
        {
            while (crew == null)
            {
                yield return null;
                if (NetworkIdentity.spawned.TryGetValue(_crewId, out NetworkIdentity networkIdentity))
                {
                    crew = networkIdentity.GetComponent<Crew>();
                    
                }
            }
        }

        #endregion


        public override void OnStopClient()
        {
            base.OnStopClient();
            OnDestroy?.Invoke();
        }




    }
}

using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using Mirror;

namespace Core.Interractables
{
    public class Interractable : NetworkBehaviour
    {
        float lastSelectTime = 0;
        public event Action OnRefuse;

        public bool activatedByLocalPlayer = false;

        protected virtual void Awake()
        {
            syncInterval = 0;
        }


        [TargetRpc]
        public virtual void TargetRefuseAction(NetworkConnection targetPlayer)
        {
            OnRefuse?.Invoke();
        }


        #region Server

        public virtual void ServerTryUseObject(NetworkIdentity requestingPlayer)
        {
            if (ServerCanUseObject(requestingPlayer))
            {
                ServerUseObject(requestingPlayer);
            }
        }

        protected virtual bool ServerCanUseObject(NetworkIdentity requestingPlayer)
        {
            if (Time.time - lastSelectTime > 1)
            {
                lastSelectTime = Time.time;
                return true;
            }
            else
            {
                return false;
            }
        }

        protected virtual void ServerUseObject(NetworkIdentity requestingPlayer)
        {

        }

        #endregion

    }
}


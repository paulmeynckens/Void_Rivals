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

        //public bool activatedByLocalPlayer = false;

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

        public virtual void ServerTryUseObjectE(NetworkIdentity requestingPlayer)
        {
            if (ServerCanUseObjectE(requestingPlayer))
            {
                ServerUseObjectE(requestingPlayer);
            }
        }

        protected virtual bool ServerCanUseObjectE(NetworkIdentity requestingPlayer)
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

        protected virtual void ServerUseObjectE(NetworkIdentity requestingPlayer)
        {

        }

        public virtual void ServerTryUseObjectClick(NetworkIdentity requestingPlayer)
        {
            if (ServerCanUseObjectClick(requestingPlayer))
            {
                ServerUseObjectClick(requestingPlayer);
            }
        }

        protected virtual bool ServerCanUseObjectClick(NetworkIdentity requestingPlayer)
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

        protected virtual void ServerUseObjectClick(NetworkIdentity requestingPlayer)
        {

        }

        #endregion

    }
}


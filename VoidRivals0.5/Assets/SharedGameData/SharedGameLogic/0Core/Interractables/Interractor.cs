using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;
using Mirror;
using System;

namespace Core.Interractables
{
    public class Interractor : MonoBehaviour
    {
        [SerializeField] Interractable interractable=null;

        public event Action OnClientActivated=delegate { };
        public event Action OnClientConfirm = delegate { };
        public event Action OnClientDeactivate = delegate { };
        public event Action OnClientRefuse = delegate { };
        

        private void Awake()
        {
            interractable.OnRefuse += ClientRefuseAction;
        }


        #region Server

        public void ServerInterract(NetworkIdentity requestingPlayer)
        {
            interractable.ServerTryUseObject(requestingPlayer);
        }

        #endregion

        #region Client

        public virtual void ClientActivate()
        {
            OnClientActivated();
        }

        public virtual void ClientConfirm()
        {
            OnClientConfirm();
        }

        /// <summary>
        /// This is called by the selection manager when the object is no longer hit by the selection raycast
        /// </summary>

        public virtual void ClientDeactivate()
        {
            OnClientDeactivate();
        }

        void ClientRefuseAction()
        {
            OnClientRefuse();
        }
        #endregion

    }

    
}


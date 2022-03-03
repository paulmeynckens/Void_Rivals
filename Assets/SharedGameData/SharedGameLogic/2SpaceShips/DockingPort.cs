using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Mirror;
using Core.Interractables;
using System;
using Core;

namespace ShipsLogic
{
    [DefaultExecutionOrder(+100)]
    public abstract class DockingPort : NetworkBehaviour
    {
        [Tooltip("Collider that is deactivated when the docking port is docked and activated back to prevent the players from falling outside the ship")]
        [SerializeField] protected GameObject doorCollider = null;

        public event Action<bool> OnDocked = delegate { };
        public bool IsDocked { get => isDocked;}
        

        [SyncVar(hook =nameof(ClientActivateDockingFeedback))] private bool isDocked = false;

        public Transform NonMovingBody { get => nonMovingBody; }
        Transform nonMovingBody;

        void ClientActivateDockingFeedback(bool _old, bool _new)
        {
            OnDocked(_new);
            doorCollider.SetActive(!isDocked);
        }

        protected virtual void Awake()
        {
            nonMovingBody = transform.root;
        }

        protected void ServerSetDocked(bool docked)
        {
            isDocked = docked;
            doorCollider.SetActive(!docked);
        }

        
    }
}



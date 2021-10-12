using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Mirror;
using System;
using Core;

namespace Customisation
{
    public class AllowCustomisation : NetworkBehaviour
    {

        public event Action<bool> OnCustomisationChange;
        

        [SyncVar(hook = nameof(OnCustomisationAllowed))] [HideInInspector] public bool customisationAllowed = true;
        void OnCustomisationAllowed(bool _old, bool _new)
        {
            OnCustomisationChange(_new);
        }
        public override void OnStartServer()
        {
            base.OnStartServer();
            customisationAllowed = false;
        }


        private void OnTriggerEnter(Collider other)
        {
            if (isServer && other.CompareTag("Customisation Area"))
            {
                if (!customisationAllowed)
                {
                    customisationAllowed = true;
                    NetworkIdentity[] controlledObjects = GetComponentsInChildren<NetworkIdentity>();
                    foreach (NetworkIdentity controlledObject in controlledObjects)
                    {
                        if (controlledObject.connectionToClient != null)
                        {
                            TargetNotifyEnterCustomisationArea(controlledObject.connectionToClient);
                        }

                    }
                }
            }
        }

        private void OnTriggerExit(Collider other)
        {
            if (isServer && other.CompareTag("Customisation Area"))
            {
                if (!customisationAllowed)
                {
                    customisationAllowed = false;
                    NetworkIdentity[] controlledObjects = GetComponentsInChildren<NetworkIdentity>();
                    foreach (NetworkIdentity controlledObject in controlledObjects)
                    {
                        if (controlledObject.connectionToClient != null)
                        {
                            TargetNotifyLeaveCustomisationArea(controlledObject.connectionToClient);
                        }

                    }

                }

            }

        }



        [TargetRpc]
        void TargetNotifyEnterCustomisationArea(NetworkConnection networkConnection)
        {
            
            
        }

        [TargetRpc]
        void TargetNotifyLeaveCustomisationArea(NetworkConnection networkConnection)
        {
                        
        }
    }
}




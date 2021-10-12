using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Mirror;
using Core.Interractables;
using System;
using Core;

namespace ShipsLogic
{
    public class DockingPort : MonoBehaviour
    {
        [Tooltip("Collider that is deactivated when the docking port is docked and activated back to prevent the players from falling outside the ship")]
        [SerializeField] Collider doorColider = null;

        public static readonly List<DockingPort> allDockingPorts = new List<DockingPort>();
        
        /*
        Transform femaleTransform;
        public Transform FemaleTransform
        {
            get => femaleTransform;
        }
        */
        DockingPort targetDockingPort;
        public DockingPort TargetDockingPort
        {
            get => targetDockingPort;
        }

        int index;
        public int Index
        {
            get => index;
            set
            {
                index = value;
            }
        }

        NetworkIdentity shipNetId;
        public NetworkIdentity ShipNetId
        {
            get => shipNetId;
        }

        


        DockingPort pairDockingPort = null;
        public bool IsAvailable
        {
            get => pairDockingPort == null;
        }

        public Vector3 ToParent
        {
            get => toParent;
        }
        Vector3 toParent = Vector3.zero;
        

        private void Awake()
        {
            shipNetId = GetComponentInParent<NetworkIdentity>();
            allDockingPorts.Add(this);
            toParent = transform.InverseTransformPoint(transform.parent.position);
        }

        private void OnTriggerEnter(Collider other)
        {
            DockingPort otherDockingPort = other.gameObject.GetComponent<DockingPort>();

            if (otherDockingPort != null)
            {
                targetDockingPort = otherDockingPort;
            }
        }

        private void OnTriggerExit(Collider other)
        {
            targetDockingPort = null;
        }

        public void ServerEjectDockingPort()
        {
            Undock();
        }

        public void Dock(DockingPort target)
        {

            pairDockingPort = target;

            doorColider.enabled = false;

            SphereCollider sphereCollider = GetComponent<SphereCollider>();
            sphereCollider.enabled = false;
        }
        public void Undock()
        {
            if (pairDockingPort!=null && pairDockingPort.pairDockingPort==this)
            {
                pairDockingPort.NonRecursiveUndock();
            }

            NonRecursiveUndock();
        }
        void NonRecursiveUndock()
        {
            pairDockingPort = null;

            doorColider.enabled = true;

            SphereCollider sphereCollider = GetComponent<SphereCollider>();
            sphereCollider.enabled = true;
        }

        private void OnDestroy()
        {
            allDockingPorts.Remove(this);
        }

    }
}



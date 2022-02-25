using System.Linq;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Mirror;
using Core;
using Core.ServerAuthoritativeActions;

namespace ShipsLogic
{
    public class ShipDocker : NetworkBehaviour
    {

        float lastDockedTime;
        const float MIN_DOCKING_TIME=5;

        //public GameObject inner = null;

        [SerializeField] Transform externalBody = null;
        Transform ownShipTransform;
        ShipDocker parentShip = null;

        const float DOCKING_ROTATION_SPEED = 60f;
        const float DOCKING_TRANSLATION_SPEED = 10f;
        const float DOCKING_TIMEOUT = 3f;

        [SerializeField]List<DockingPort> dockingPorts;


        private DockingPort currentlyDockedPort = null;

        public DockingPort ActiveDockingPort
        {
            get => activeDockingPort;
        }
        DockingPort activeDockingPort = null;
        DockingPort closestForeignPort = null;
        [SerializeField] float pullForce = 50000;
        [SerializeField] float maxSquaredDistance = 20;
        [SerializeField] float leverArm = 50;



        public bool IsPulling
        {
            get => isPulling;
        }
        bool isPulling = false;

        Vector3 parkingPosition = Vector3.zero;

        Rigidbody externalBodyRB = null;

        #region SyncVars+hooks

        [SyncVar(hook = nameof(ClientManageDocking))] DockingData dockingData = new DockingData { parentShipNetId = 0};
        void ClientManageDocking(DockingData _old, DockingData _new)
        {
            if (_new.parentShipNetId == 0)
            {
                UnDock();
                
                return;
            }
            else
            {
                StartCoroutine(ClientSearchAndDock(_new));
                return;
            }
        }

        
        

        #endregion


        private void Awake()
        {
            parkingPosition = transform.position;

            ownShipTransform = transform.parent;

            
            for (int i = 0; i < dockingPorts.Count; i++)
            {
                dockingPorts[i].Index = i;
            }

        }

        #region Client

        private void FixedUpdate()
        {
            isPulling = false;
            if (hasAuthority && isClient)
            {
                if (Input.GetKey(KeyBindings.Pairs[PlayerAction.dock]))
                {
                    CmdTryDockingOrUnDock();
                    PullToDockingPort();
                }

            }
        }

        IEnumerator ClientSearchAndDock(DockingData dockingData)
        {
            while (parentShip == null)
            {
                yield return null;
                if (NetworkIdentity.spawned.TryGetValue(dockingData.parentShipNetId, out NetworkIdentity foundNetworkIdentity))
                {
                    Dock(dockingData);
                }
            }
        }
        public override void OnStartClient()
        {
            base.OnStartClient();
            if (dockingData.parentPortIndex == 0)
            {
                UnDock();
            }
        }

        #endregion

        #region Both sides


        void Dock(DockingData _dockingData)
        {
            Debug.Log("docking");

            parentShip = NetworkIdentity.spawned[_dockingData.parentShipNetId].GetComponent<ShipDocker>();

            Transform parentShipTransform = parentShip.ownShipTransform;

            

            Transform ownDockingPortTransform = dockingPorts[_dockingData.ownPortIndex].transform;

            Transform targetDockingPortTransform = parentShip.dockingPorts[_dockingData.parentPortIndex].transform;

            Quaternion calculatedLocalRotation = targetDockingPortTransform.localRotation * Quaternion.Euler(0, 180, 0) * Quaternion.Inverse(ownDockingPortTransform.localRotation);

            ownShipTransform.parent = parentShipTransform;
            ownShipTransform.localScale = Vector3.one;
            ownShipTransform.localRotation = calculatedLocalRotation;

            Vector3 repeatedOwnPortFromNewInteriorPointOfView = parentShipTransform.InverseTransformPoint(ownShipTransform.TransformPoint(ownDockingPortTransform.localPosition));
            Vector3 fromOwnPortToShip = parentShipTransform.InverseTransformPoint(ownShipTransform.position) - repeatedOwnPortFromNewInteriorPointOfView;
            Vector3 calculatedLocalPosition =targetDockingPortTransform.localPosition + fromOwnPortToShip;

            ownShipTransform.localPosition = calculatedLocalPosition;

            externalBody.parent = parentShip.externalBody;
            externalBody.localPosition = calculatedLocalPosition;
            externalBody.localRotation = calculatedLocalRotation;
  

            currentlyDockedPort = dockingPorts[_dockingData.ownPortIndex];
            DockingPort parentPort = parentShip.dockingPorts[_dockingData.parentPortIndex];
            currentlyDockedPort.Dock(parentPort);
            parentPort.Dock(currentlyDockedPort);


            Destroy(externalBodyRB);
        }

        void UnDock()
        {
            
            
            externalBody.parent = null;

            parentShip = null;

            ownShipTransform.parent = null;
            ownShipTransform.position = parkingPosition;
            ownShipTransform.rotation = Quaternion.identity;
            ownShipTransform.localScale = Vector3.one;


            if (currentlyDockedPort != null)
            {
                currentlyDockedPort.Undock();

                currentlyDockedPort = null;
            }

            externalBodyRB= externalBody.gameObject.AddComponent<Rigidbody>();
            
        }

        void PullToDockingPort()
        {
            if (externalBodyRB == null)
            {
                return;
            }

            UpdateClosestDockingPorts();

            
            if (activeDockingPort!=null && closestForeignPort != null)
            {
                Debug.DrawLine(closestForeignPort.transform.position, activeDockingPort.transform.position, Color.white, Time.fixedDeltaTime);
                Transform toMatch = closestForeignPort.transform;


                Vector3 upForce = toMatch.up * pullForce;
                Vector3 upForceApplicationPoint = activeDockingPort.transform.TransformPoint(0, leverArm, 0);
                externalBodyRB.AddForceAtPosition(upForce, upForceApplicationPoint);
                externalBodyRB.AddForceAtPosition(-upForce, activeDockingPort.transform.position);

                Vector3 rightForce = -toMatch.right * pullForce;
                Vector3 rightForceApplicationPoint = activeDockingPort.transform.TransformPoint(leverArm,0, 0);
                externalBodyRB.AddForceAtPosition(rightForce, rightForceApplicationPoint);
                externalBodyRB.AddForceAtPosition(-rightForce, activeDockingPort.transform.position);

                
                Vector3 pullTowardForce = (toMatch.position - activeDockingPort.transform.position).normalized * pullForce;
                externalBodyRB.AddForceAtPosition(pullTowardForce,activeDockingPort.transform.position);

                isPulling = true;
            }
        }

        void UpdateClosestDockingPorts()
        {
            activeDockingPort = null;
            closestForeignPort = null;
            
            float closestSquareDistance = float.MaxValue;
            
            foreach(DockingPort targetDockingPort in DockingPort.allDockingPorts)
            {
                if(!dockingPorts.Contains(targetDockingPort))
                {
                    foreach (DockingPort ownDockinPort in dockingPorts)
                    {
                        float distance = MyUtils.SquaredDistance(ownDockinPort.transform.position, targetDockingPort.transform.position);
                        if (distance < maxSquaredDistance && distance < closestSquareDistance)
                        {
                            if (ownDockinPort.transform.InverseTransformPoint(targetDockingPort.transform.position).z > 0 && targetDockingPort.transform.InverseTransformPoint(ownDockinPort.transform.position).z > 0)//means the two docking ports are facing each other
                            {
                                closestSquareDistance = distance;
                                closestForeignPort = targetDockingPort;
                                activeDockingPort = ownDockinPort;
                            }
                        }
                    }

                }
            }

        }

        public void StowShip()
        {
            externalBody.parent = transform;
            externalBody.localPosition = Vector3.zero;
            externalBody.localRotation = Quaternion.identity;
        }

        #endregion

        #region Server

        public void ServerPrepareShip()
        {

            dockingData = new DockingData { parentShipNetId = 0, ownPortIndex = 0, parentPortIndex = 0 };
            
            UnDock();
        }

        
        DockingData ServerGenerateDockingData(DockingPort ownDockingPort, DockingPort targetDockingPort)
        {
            DockingData dockingData;

            dockingData.parentShipNetId = targetDockingPort.ShipNetId.netId;

            dockingData.ownPortIndex = ownDockingPort.Index;

            dockingData.parentPortIndex = targetDockingPort.Index;

            return dockingData;

        }

        public void ServerEjectBeforeDestruction()
        {
            dockingData = new DockingData { parentShipNetId = 0, parentPortIndex = 0 };
            UnDock();
        }



        #endregion

        #region Commands
        [Command(channel = Channels.Unreliable)]
        void CmdTryDockingOrUnDock()
        {
            
            if (Time.time - lastDockedTime < MIN_DOCKING_TIME)
            {
                return;
            }
            
            if (parentShip!=null)//means we are docked
            {

                lastDockedTime = Time.time;
                dockingData = new DockingData { parentShipNetId = 0, parentPortIndex = 0 };
                UnDock();
                return;

            }

            PullToDockingPort();
            RpcPull();

            //Debug.Log("trying to dock");
            if (activeDockingPort != null && activeDockingPort.TargetDockingPort != null && activeDockingPort.TargetDockingPort.IsAvailable)
            {

                dockingData = ServerGenerateDockingData(activeDockingPort, activeDockingPort.TargetDockingPort);
                Dock(dockingData);


                lastDockedTime = Time.time;

            }


        }


        #endregion

        #region Rpcs

        [ClientRpc(channel =Channels.Unreliable, includeOwner =false)]
        void RpcPull()
        {
            PullToDockingPort();
        }

        #endregion
    }


    public struct DockingData
    {
        public uint parentShipNetId;
        public int ownPortIndex;
        public int parentPortIndex;
    }
}




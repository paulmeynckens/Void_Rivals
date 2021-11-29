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

        BodiesHolder bodiesHolder;

        Rigidbody MovingBody
        {
            get
            {
                return bodiesHolder.Rigidbody;
            }
        }

        //public GameObject inner = null;
        ShipDocker parentShip = null;

        const float DOCKING_ROTATION_SPEED = 60f;
        const float DOCKING_TRANSLATION_SPEED = 10f;
        const float DOCKING_TIMEOUT = 3f;

        List<DockingPort> dockingPorts;


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

        [SyncVar(hook =nameof(ClientGoToParkingPosition))] Vector3 parkingPosition = Vector3.zero;
        void ClientGoToParkingPosition(Vector3 _old, Vector3 _new)
        {
            if (parentShip == null)
            {
                transform.position = _new;
                transform.rotation = Quaternion.identity;
            }
        }

        #endregion


        private void Awake()
        {
            
            bodiesHolder = GetComponent<BodiesHolder>();

            dockingPorts = GetComponentsInChildren<DockingPort>().ToList();
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

            Transform parentShipTransform = NetworkIdentity.spawned[_dockingData.parentShipNetId].transform;

            parentShip = parentShipTransform.GetComponent<ShipDocker>();

            Transform ownDockingPortTransform = dockingPorts[_dockingData.ownPortIndex].transform;

            Transform targetDockingPortTransform = parentShip.dockingPorts[_dockingData.parentPortIndex].transform;

            Quaternion calculatedLocalRotation = targetDockingPortTransform.localRotation * Quaternion.Euler(0, 180, 0) * Quaternion.Inverse(ownDockingPortTransform.localRotation);

            transform.parent = parentShipTransform;
            transform.localScale = Vector3.one;
            transform.localRotation = calculatedLocalRotation;

            Vector3 repeatedOwnPortFromNewInteriorPointOfView = parentShipTransform.InverseTransformPoint(transform.TransformPoint(ownDockingPortTransform.localPosition));
            Vector3 fromOwnPortToShip = parentShipTransform.InverseTransformPoint(transform.position) - repeatedOwnPortFromNewInteriorPointOfView;
            Vector3 calculatedLocalPosition =targetDockingPortTransform.localPosition + fromOwnPortToShip;

            transform.localPosition = calculatedLocalPosition;

            bodiesHolder.externalCollider.parent = parentShip.bodiesHolder.externalCollider;
            bodiesHolder.externalCollider.localPosition = calculatedLocalPosition;
            bodiesHolder.externalCollider.localRotation = calculatedLocalRotation;
  

            currentlyDockedPort = dockingPorts[_dockingData.ownPortIndex];
            DockingPort parentPort = parentShip.dockingPorts[_dockingData.parentPortIndex];
            currentlyDockedPort.Dock(parentPort);
            parentPort.Dock(currentlyDockedPort);

            bodiesHolder.DestroyRigidBody();
        }

        void UnDock()
        {
            bodiesHolder.RepopRigidBody();
            bodiesHolder.externalCollider.parent = null;

            parentShip = null;

            transform.parent = null;
            transform.position = parkingPosition;
            transform.rotation = Quaternion.identity;
            transform.localScale = Vector3.one;

            

            currentlyDockedPort.Undock();

            currentlyDockedPort = null;

        }

        void PullToDockingPort()
        {
            if (bodiesHolder.Rigidbody == null)
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
                bodiesHolder.Rigidbody.AddForceAtPosition(upForce, upForceApplicationPoint);
                bodiesHolder.Rigidbody.AddForceAtPosition(-upForce, activeDockingPort.transform.position);

                Vector3 rightForce = -toMatch.right * pullForce;
                Vector3 rightForceApplicationPoint = activeDockingPort.transform.TransformPoint(leverArm,0, 0);
                bodiesHolder.Rigidbody.AddForceAtPosition(rightForce, rightForceApplicationPoint);
                bodiesHolder.Rigidbody.AddForceAtPosition(-rightForce, activeDockingPort.transform.position);

                
                Vector3 pullTowardForce = (toMatch.position - activeDockingPort.transform.position).normalized * pullForce;
                bodiesHolder.Rigidbody.AddForceAtPosition(pullTowardForce,activeDockingPort.transform.position);

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

        private void OnDestroy()
        {
            if (parentShip != null)//to clear the docked ship's docking port when leaving
            {
                UnDock();
            }
            
        }

        #endregion

        #region Server

        public override void OnStartServer()
        {
            parkingPosition = ShipsParking.instance.GetAvailableLocation().position;
            dockingData = new DockingData { parentShipNetId = 0, ownPortIndex = 0, parentPortIndex = 0 };
            
            UnDock();

            base.OnStartServer();
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




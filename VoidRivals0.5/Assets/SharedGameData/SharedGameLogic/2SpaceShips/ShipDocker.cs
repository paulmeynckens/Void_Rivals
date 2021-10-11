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

        [SerializeField]List<DockingPort> dockingPorts;


        private DockingPort currentlyDockedPort = null;

        [SerializeField] DockingPort activeDockingPort = null;
        [SerializeField] float pullForce = 50000;
        [SerializeField] float maxSquaredDistance = 20;
        [SerializeField] float leverArm = 50;

        DelayedDestructor parentDestructor = null;

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
                bodiesHolder.interior.position = _new;
                bodiesHolder.interior.rotation = Quaternion.identity;
            }
        }

        #endregion


        private void Awake()
        {
            
            bodiesHolder = GetComponent<BodiesHolder>();


            for (int i = 0; i < dockingPorts.Count; i++)
            {
                dockingPorts[i].Index = i;
            }

        }

        #region Client

        private void FixedUpdate()
        {
            if (hasAuthority && isClient)
            {
                if (Input.GetKey(KeyBindings.Pairs[Actions.dock]))
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

            Transform shipTransform = NetworkIdentity.spawned[_dockingData.parentShipNetId].transform;

            parentShip = shipTransform.GetComponent<ShipDocker>();

            Transform ownDockingPortTransform = dockingPorts[_dockingData.ownPortIndex].transform;

            Transform targetDockingPortTransform = parentShip.dockingPorts[_dockingData.parentPortIndex].transform;

            Quaternion calculatedLocalRotation = targetDockingPortTransform.localRotation * Quaternion.Euler(0, 180, 0) * Quaternion.Inverse(ownDockingPortTransform.localRotation);

            bodiesHolder.interior.parent = parentShip.bodiesHolder.interior;
            bodiesHolder.interior.localScale = Vector3.one;
            bodiesHolder.interior.localRotation = calculatedLocalRotation;

            Vector3 repeatedOwnPortFromNewInteriorPointOfView = parentShip.bodiesHolder.interior.InverseTransformPoint(bodiesHolder.interior.TransformPoint(ownDockingPortTransform.localPosition));
            Vector3 fromOwnPortToShip = parentShip.bodiesHolder.interior.InverseTransformPoint(bodiesHolder.interior.position) - repeatedOwnPortFromNewInteriorPointOfView;
            Vector3 calculatedLocalPosition =targetDockingPortTransform.localPosition + fromOwnPortToShip;

            bodiesHolder.interior.localPosition = calculatedLocalPosition;

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
            parentShip = null;

            bodiesHolder.interior.parent = transform;
            bodiesHolder.interior.position = parkingPosition;
            bodiesHolder.interior.rotation = Quaternion.identity;
            bodiesHolder.interior.localScale = Vector3.one;

            bodiesHolder.RepopRigidBody();
            bodiesHolder.externalCollider.parent = null;

            currentlyDockedPort.Undock();

            currentlyDockedPort = null;

        }

        void PullToDockingPort()
        {
            if (bodiesHolder.Rigidbody == null)
            {
                return;
            }
            DockingPort closestPort = ClosestDockingPort();
            
            if (closestPort != null)
            {
                Debug.DrawLine(closestPort.transform.position, activeDockingPort.transform.position, Color.white, Time.fixedDeltaTime);
                Transform toMatch = closestPort.transform;


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
            }
        }

        DockingPort ClosestDockingPort()
        {
            DockingPort foundPort = null;
            float closestSquareDistance = float.MaxValue;
            foreach(DockingPort dockingPort in DockingPort.allDockingPorts)
            {
                if(!dockingPorts.Contains(dockingPort))
                {
                    float distance = MyUtils.SquaredDistance(activeDockingPort.transform.position, dockingPort.transform.position);
                    if (distance < maxSquaredDistance && distance<closestSquareDistance)
                    {
                        closestSquareDistance = distance;
                        foundPort = dockingPort;
                    }
                    
                }
            }

            return foundPort;
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

        void ServerEjectBeforeDestruction()
        {
            dockingData = new DockingData { parentShipNetId = 0, parentPortIndex = 0 };
            UnDock();
        }

        public override void OnStopServer()
        {
            if (parentDestructor != null)
            {
                parentDestructor.OnServerWillDestroyThisObject -= ServerEjectBeforeDestruction;
            }
            
            base.OnStopServer();
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
                parentDestructor.OnServerWillDestroyThisObject -= ServerEjectBeforeDestruction;
                lastDockedTime = Time.time;
                dockingData = new DockingData { parentShipNetId = 0, parentPortIndex = 0 };
                UnDock();
                return;

            }

            PullToDockingPort();
            RpcPull();

            //Debug.Log("trying to dock");
            if (activeDockingPort.TargetDockingPort != null && activeDockingPort.TargetDockingPort.IsAvailable)
            {

                dockingData = ServerGenerateDockingData(activeDockingPort, activeDockingPort.TargetDockingPort);
                Dock(dockingData);
                parentDestructor = parentShip.GetComponent<DelayedDestructor>();
                parentDestructor.OnServerWillDestroyThisObject += ServerEjectBeforeDestruction;
                lastDockedTime = Time.time;

            }


        }


        #endregion

        #region Commands

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




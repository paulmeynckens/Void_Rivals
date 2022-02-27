using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Mirror;
using Core.Interractables;
using System;
using Core;

namespace ShipsLogic
{
    [Serializable]
    public struct DockingState
    {
        public bool isActive;
        public NetworkIdentity femaleDockingPortIdentity;
    }
    public class MaleDockingPort : NetworkBehaviour,IResettable
    {
        public Transform MaleNonMovingBody
        {
            get => maleNonMovingBody;
        }        

        [SerializeField] Transform maleNonMovingBody = null;

        [SerializeField] List<FemaleDockingPort> ownShipFemaleDockingPorts = null;

        [SerializeField] GameObject doorCollider = null;

        [SerializeField] float pullForce = 50000;
        [SerializeField] float maxSquaredDistance = 20;
        [SerializeField] float leverArm = 50;


        const float DOCKING_ROTATION_SPEED = 60f;
        const float DOCKING_TRANSLATION_SPEED = 10f;
        const float DOCKING_TIMEOUT = 3f;

        #region Syncvars + hooks

        [SyncVar(hook = nameof(ClientProcessDockingState))] DockingState currentDockingState = new DockingState { isActive = false, femaleDockingPortIdentity = null };
        void ClientProcessDockingState(DockingState _old, DockingState _new)
        {
            if (_new.isActive == false)
            {
                Stow();
                return;
            }

            if (_new.femaleDockingPortIdentity == null)
            {
                UnDock();

            }
            
            else
            {

                Dock(_new.femaleDockingPortIdentity.GetComponent<FemaleDockingPort>());
            }
        }

        

        #endregion

        FemaleDockingPort targetFemaleDockingPort = null;

        FemaleDockingPort collidedFemale = null;

        Rigidbody externalBodyRB = null;


        public bool IsPulling
        {
            get => isPulling;
        }
        const float MIN_DOCKING_TIME = 5;

        bool isPulling = false;
        private Vector3 parkingPosition=Vector3.zero;
        private float lastDockedTime;

        private void Awake()
        {
            parkingPosition = maleNonMovingBody.position;
             //currentFemaleDockingPortIdentity = GetComponent<NetworkIdentity>();
        }

        private void FixedUpdate()
        {
            
            
            if (hasAuthority && isClient)
            {
                if (Input.GetKey(KeyBindings.Pairs[PlayerAction.dock]))
                {
                    CmdTryDockingOrUnDock();
                    targetFemaleDockingPort = ClosestFemaleDockingPort();
                    PullToDockingPort();
                    targetFemaleDockingPort = null;
                }

            }
        }

        #region Client
        

        

        #endregion

        #region BothSides

        public FemaleDockingPort ClosestFemaleDockingPort()
        {
            FemaleDockingPort foundFemale = null;

            float closestSquareDistance = float.MaxValue;

            foreach (FemaleDockingPort targetDockingPort in FemaleDockingPort.allFemaleDockingPorts)
            {
                if (targetDockingPort.gameObject.activeInHierarchy && targetDockingPort.IsAvailable && !ownShipFemaleDockingPorts.Contains(targetDockingPort))
                {
                    float distance = MyUtils.SquaredDistance(transform.position, targetDockingPort.transform.position);
                    if (distance < maxSquaredDistance && distance < closestSquareDistance)
                    {
                        if (transform.InverseTransformPoint(targetDockingPort.transform.position).z > 0 && targetDockingPort.transform.InverseTransformPoint(transform.position).z > 0)//means the two docking ports are facing each other
                        {
                            closestSquareDistance = distance;
                            foundFemale = targetDockingPort;
                        }
                    }

                }
            }
            return foundFemale;
        }

        void PullToDockingPort()
        {
            if (externalBodyRB == null)
            {
                return;
            }


            if (targetFemaleDockingPort != null)
            {
                Debug.DrawLine(targetFemaleDockingPort.transform.position, transform.position, Color.white, Time.fixedDeltaTime);
                Transform toMatch = targetFemaleDockingPort.transform;


                Vector3 upForce = toMatch.up * pullForce;
                Vector3 upForceApplicationPoint = transform.TransformPoint(0, leverArm, 0);
                externalBodyRB.AddForceAtPosition(upForce, upForceApplicationPoint);
                externalBodyRB.AddForceAtPosition(-upForce, transform.position);

                Vector3 rightForce = -toMatch.right * pullForce;
                Vector3 rightForceApplicationPoint = transform.TransformPoint(leverArm, 0, 0);
                externalBodyRB.AddForceAtPosition(rightForce, rightForceApplicationPoint);
                externalBodyRB.AddForceAtPosition(-rightForce, transform.position);


                Vector3 pullTowardForce = (toMatch.position - transform.position).normalized * pullForce;
                externalBodyRB.AddForceAtPosition(pullTowardForce, transform.position);

                isPulling = true;
            }
        }

        

        void Dock(FemaleDockingPort femaleDockingPort)
        {
            doorCollider.SetActive(false);
            femaleDockingPort.DoorCollider.SetActive(false);

            transform.parent.parent = femaleDockingPort.transform.parent;
            transform.parent.localScale = Vector3.one;
            transform.parent.localRotation = femaleDockingPort.transform.localRotation;            
            transform.parent.Translate(femaleDockingPort.transform.position - transform.position);

            maleNonMovingBody.transform.parent = femaleDockingPort.FemaleNonMovingBody;
            maleNonMovingBody.transform.localScale = Vector3.one;
            maleNonMovingBody.transform.localRotation = transform.parent.localRotation;
            maleNonMovingBody.transform.localPosition = transform.parent.localPosition;                   

            Destroy(externalBodyRB);
        }

        void UnDock()
        {
            doorCollider.SetActive(true);
            if (currentDockingState.femaleDockingPortIdentity != null)
            {
                currentDockingState.femaleDockingPortIdentity.GetComponent<FemaleDockingPort>().DoorCollider.SetActive(true);
            }

            transform.parent.parent = null;
            externalBodyRB = transform.parent.gameObject.AddComponent<Rigidbody>();

            ParkGeneralBody();
        }

        void Stow()
        {
            if (externalBodyRB != null)
            {
                Destroy(externalBodyRB);
            }
            ParkGeneralBody();
            StowOutside();

        }

        void ParkGeneralBody()
        {
            maleNonMovingBody.parent = null;
            maleNonMovingBody.transform.localScale = Vector3.one;
            maleNonMovingBody.transform.localRotation = Quaternion.identity;
            maleNonMovingBody.transform.localPosition = parkingPosition;
        }
        void StowOutside()
        {
            transform.parent.parent = maleNonMovingBody;
            transform.parent.localPosition = Vector3.one;
            transform.parent.localRotation = Quaternion.identity;
        }

        #endregion

        #region Server

        [ServerCallback]
        private void OnTriggerEnter(Collider other)
        {
            collidedFemale = other.gameObject.GetComponent<FemaleDockingPort>();
            
        }

        [ServerCallback]
        private void OnTriggerExit(Collider other)
        {
            collidedFemale = null;
        }

        //
        public void ServerEject()
        {

            lastDockedTime = Time.time;
            FemaleDockingPort femaleDockingPort = currentDockingState.femaleDockingPortIdentity.GetComponent<FemaleDockingPort>();
            femaleDockingPort.IsAvailable = true;// sets the currently used female docking port available for other male docking ports to dock
            currentDockingState = new DockingState { isActive = true, femaleDockingPortIdentity=null };
            UnDock();
        }

        public void ServerPrepare()
        {
            currentDockingState = new DockingState { isActive = true, femaleDockingPortIdentity = null };
        }

        void IResettable.ServerReset()
        {
            if (currentDockingState.femaleDockingPortIdentity != null)
            {
                UnDock();
            }


            currentDockingState = new DockingState { isActive = true, femaleDockingPortIdentity = null };

            targetFemaleDockingPort = null;

            collidedFemale = null;



        }


        #endregion

        #region Commands
        [Command(channel = Channels.Unreliable)]
        void CmdTryDockingOrUnDock()
        {

            if (Time.time - lastDockedTime < MIN_DOCKING_TIME)// the ship must have docked or undocked for at least "MIN_DOCKING_TIME"
            {
                return;
            }

            if (currentDockingState.femaleDockingPortIdentity != null)//means we are docked
            {

                ServerEject();
                return;
            }


            targetFemaleDockingPort = ClosestFemaleDockingPort();
            PullToDockingPort();

            if (collidedFemale == targetFemaleDockingPort)
            {
                targetFemaleDockingPort.IsAvailable = false;
                

                currentDockingState.femaleDockingPortIdentity = targetFemaleDockingPort.netIdentity;
                Dock(targetFemaleDockingPort);
                lastDockedTime = Time.time;
            }

            RpcPull();

        }


        #endregion

        #region Rpcs

        [ClientRpc(channel = Channels.Unreliable, includeOwner = false)]
        void RpcPull()
        {
            targetFemaleDockingPort = ClosestFemaleDockingPort();
            PullToDockingPort();
            targetFemaleDockingPort = null;
        }

        
        #endregion

    }
}

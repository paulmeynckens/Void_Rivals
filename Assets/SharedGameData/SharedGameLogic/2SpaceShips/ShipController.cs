using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Mirror;
using System;
using Core.ServerAuthoritativeActions;
using Core;

namespace ShipsLogic
{
    public class ShipController : ServerAuthoritativeMovement
    {

        public ShipData shipData = null;
        [SyncVar] [HideInInspector] public float gyroscopeAvailiability = 1;
        [SyncVar] [HideInInspector] public float propulsionAvailiability = 1;


        

        public static event Action<ShipController> OnClientTakeControl =delegate { };
        public static event Action OnClientExit = delegate { };

        [SerializeField] Transform externalCollider = null;
        Rigidbody rb=null;
        Rigidbody MasterRigidbody
        {
            get
            {
                if (rb == null)
                {
                    rb = externalCollider.GetComponent<Rigidbody>();
                }
               return rb;
            }
        }

        public readonly MousePullController pullController = new MousePullController();


        const float LEVER_ARM = 100;

        private ShipInput currentInputSnapshot=new ShipInput { tick = 0, yaw = 0, pitch = 0, roll = 0, thrust = 0 };
        public ShipInput CurrentInputSnapshot { get => currentInputSnapshot; }//will be used for feedback elements such as joysticks movement, engine sound, gyroscope sound, etc


        

        float currentThrust = 0;


   
        private void Start()
        {
            if (MasterRigidbody != null)
            {
                MasterRigidbody.transform.parent = null;
                SetMasterRigidbody();
            }
            
            
        }
        protected override void Update()
        {
            base.Update();
            if (hasAuthority && shipData.shipType == ShipType.strike_craft)
            {
                
                pullController.CalculateCurrentInput();

                
            }
            if (isServer)
            {
                if (connectionToClient == null)
                {
                    syncInterval = 0.1f;
                }
                else
                {
                    syncInterval = 2;
                }
            }
        }



        protected override void FixedUpdate()
        {
            SetMasterRigidbody();
            base.FixedUpdate();

        }



        #region Client
        public override void OnStartAuthority()
        {
            base.OnStartAuthority();

            if (shipData.shipType == ShipType.strike_craft)
            {
                
                OnClientTakeControl(this);
            }
        }



        protected override InputSnapshot ClientCollectInputs(ushort tick)
        {
            if (InputsBlocker.instance.BlockPlayerInputs())
            {
                return new ShipInput
                {
                    tick = tick,
                    yaw = 0,
                    pitch = 0,
                    thrust = 0,
                    roll = 0,

                };
            }


            float yawConsign = 0;

            float pitchConsign = 0;

            float thrustConsign = 0;

            if (Input.GetKey(KeyBindings.Pairs[PlayerAction.forward]) && !Input.GetKey(KeyBindings.Pairs[PlayerAction.backward]))
            {
                thrustConsign = shipData.engineMaxForwardThrust;

            }
            else if (Input.GetKey(KeyBindings.Pairs[PlayerAction.backward]) && !Input.GetKey(KeyBindings.Pairs[PlayerAction.forward]))
            {
                thrustConsign = -shipData.engineMaxBackwardThrust;
            }

            float rollConsign = 0;
            if (Input.GetKey(KeyBindings.Pairs[PlayerAction.rollLeft]) && !Input.GetKey(KeyBindings.Pairs[PlayerAction.rollRight]))
            {
                rollConsign = shipData.rollTorque;
            }
            if (!Input.GetKey(KeyBindings.Pairs[PlayerAction.rollLeft]) && Input.GetKey(KeyBindings.Pairs[PlayerAction.rollRight]))
            {
                rollConsign = -shipData.rollTorque;
            }

            switch (shipData.shipType)
            {
                case ShipType.space_ship:



                    if (Input.GetKey(KeyBindings.Pairs[PlayerAction.left]) && !Input.GetKey(KeyBindings.Pairs[PlayerAction.right]))
                    {
                        yawConsign = -shipData.yawTorque;
                    }
                    if (!Input.GetKey(KeyBindings.Pairs[PlayerAction.left]) && Input.GetKey(KeyBindings.Pairs[PlayerAction.right]))
                    {
                        yawConsign = shipData.yawTorque;
                    }


                    if (Input.GetKey(KeyBindings.Pairs[PlayerAction.jump]) && !Input.GetKey(KeyBindings.Pairs[PlayerAction.crouch]))
                    {
                        pitchConsign = -shipData.pitchTorque;
                    }
                    if (!Input.GetKey(KeyBindings.Pairs[PlayerAction.jump]) && Input.GetKey(KeyBindings.Pairs[PlayerAction.crouch]))
                    {
                        pitchConsign = shipData.pitchTorque;
                    }
                    break;


                case ShipType.strike_craft:

                    if (Input.GetKey(KeyBindings.Pairs[PlayerAction.aim]))
                    {
                        break;
                    }
                    
                    Vector2 currentInput=pullController.CurrentInput;
                    yawConsign = currentInput.x*shipData.yawTorque;
                    pitchConsign = -currentInput.y*shipData.pitchTorque;

                    break;
            }

            return new ShipInput
            {
                tick = tick,
                yaw = yawConsign,
                pitch = pitchConsign,
                thrust = thrustConsign,
                roll = rollConsign,

            };

        }

        protected override void ClientCorrectState(StateSnapshot bufferedState, StateSnapshot newState)
        {
            if (MasterRigidbody == null)
            {
                return;
            }
            if (bufferedState is ShipState buffered && newState is ShipState targetState)
            {
                Vector3 positionCorrection = targetState.position - buffered.position;
                Vector3 velocityCorrection = targetState.velocity - buffered.velocity;
                Quaternion rotationCorrection = targetState.rotation * Quaternion.Inverse(buffered.rotation);
                

                MasterRigidbody.position += positionCorrection;
                MasterRigidbody.velocity += velocityCorrection;
                MasterRigidbody.rotation = rotationCorrection * MasterRigidbody.rotation;
                


                if (showDebugMessages)
                {
                    float positionMagnitude = positionCorrection.magnitude;
                    float velocityMagnitude = velocityCorrection.magnitude;
                    float rotationAngle = rotationCorrection.eulerAngles.magnitude;
                    

                    Debug.Log("position delta : " + positionMagnitude + " velocity delta : " + velocityMagnitude + " rotation delta : " + rotationAngle);// + " angular velocity : " + angularVelocityMagnitude);
                }

            }
            else
            {
                if (showDebugMessages)
                {
                    Debug.LogError("State not deserialised properly");
                }
            }


        }

        protected override void ClientForceState(StateSnapshot newState)
        {
            if (MasterRigidbody == null)
            {
                return;
            }
            base.ClientForceState(newState);
            if(newState is ShipState shipState)
            {
                MasterRigidbody.position = shipState.position;
                MasterRigidbody.velocity = shipState.velocity;
                MasterRigidbody.rotation = shipState.rotation;
                //masterRigidbody.angularVelocity = shipState.angularVelocity;
            }
        }

        public override void OnStopAuthority()
        {
            base.OnStopAuthority();

            OnClientExit();

        }




        #endregion


        #region Both Sides

        protected void SetMasterRigidbody()
        {
            if (externalCollider.parent != null && rb!=null)
            {
                Destroy(rb);
                return;
            }

            if(rb==null)
            {
                rb = externalCollider.gameObject.AddComponent<Rigidbody>();
                rb.isKinematic = false;
                rb.useGravity = false;
                rb.mass = shipData.rigidbodyMass;
                rb.drag = shipData.rigidBodyDrag;
                rb.angularDrag = shipData.rigidbodyAngularDrag;
            }
            
            
        }
        protected override void ApplyExternalForces()
        {
            if (MasterRigidbody == null)
            {
                return;
            }

            
            Vector3 thrustVector = MasterRigidbody.transform.forward * currentThrust;
            MasterRigidbody.AddForce(thrustVector);

            if (shipData.shipType == ShipType.space_ship && MasterRigidbody!=null)
            {
                float counterForce = shipData.stabilisationTorque / LEVER_ARM;
                Vector3 offset;
                offset.x = 0;
                offset.y = -LEVER_ARM;
                offset.z = 0;

                Vector3 upwardForce = Vector3.up * counterForce;
                Vector3 downWardForce = Vector3.down * counterForce;


                MasterRigidbody.AddForceAtPosition(upwardForce, MasterRigidbody.position);

                MasterRigidbody.AddForceAtPosition(downWardForce, MasterRigidbody.transform.TransformPoint(offset));
            }
        }
        protected override void UseInput(InputSnapshot input)
        {
            if (MasterRigidbody == null)
            {
                return;
            }

            if (input is ShipInput shipInput)
            {

                Vector3 torque;
                torque.x = Mathf.Clamp(shipInput.pitch, -shipData.pitchTorque, shipData.pitchTorque);
                torque.y = Mathf.Clamp(shipInput.yaw, -shipData.yawTorque, shipData.yawTorque);
                torque.z = Mathf.Clamp(shipInput.roll, -shipData.rollTorque, shipData.rollTorque);
                MasterRigidbody.AddRelativeTorque(torque);

                currentThrust = Mathf.Clamp(shipInput.thrust, -shipData.engineMaxBackwardThrust, shipData.engineMaxForwardThrust);


                if (isClient)
                {
                    currentInputSnapshot = shipInput;// new ShipInput { tick = 0, yaw = torque.y, pitch = torque.x, roll = torque.z, thrust = currentThrust };
                }
            }

            else
            {
                if (showDebugMessages)
                {
                    Debug.Log("Empty input used");
                }
            }
        }



        protected override StateSnapshot GenerateState(ushort tick)
        {
            if (MasterRigidbody == null)
            {
                return new StateSnapshot { tick = tick };
            }
            
            return new ShipState
            {
                tick = tick,
                position = MasterRigidbody.position,
                velocity = MasterRigidbody.velocity,
                rotation = MasterRigidbody.rotation,
            };

        }





        #endregion

        #region Server

        
        protected override bool ShouldServerGenerateState()
        {
            if(MasterRigidbody == null)
            {

                return false;
            }
            return true;
        }
        

        #endregion


    }
}




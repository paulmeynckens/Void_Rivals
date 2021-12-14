using UnityEngine;
using System.Collections;
using Core.ServerAuthoritativeActions;
using Core;
using Mirror;

namespace ShipsLogic.Turrets
{
    public class TurretController : NetworkBehaviour,IResettable
    {
        [SerializeField] TwoAxisRotator rotator = null;


        [Header("Horizontal")]
        //[SerializeField] Transform horizontalPointer=null;
        [SerializeField] Transform[] horizontalBodies = null;
        [SerializeField] bool restrictedHorizontalAngle = false;
        [SerializeField] [Range(10, 85)] float horizontalHalfRotation = 30.0f;


        [Header("Vertical")]
        //[SerializeField] Transform verticalPointer=null;


        [SerializeField] Transform[] verticalBodies = null;
        [SerializeField] [Range(10, 85)] float upperVerticalAngle = 45f;
        [SerializeField] [Range(10, 85)] float lowerVerticalAngle = 45f;

        [Header("Parameter for Horizontal and Vertical")]
        [SerializeField] float rotationSpeed = 120f;






        #region Syncvars+hooks
        [SyncVar(hook = nameof(ClientUpdateRotations))] Vector2 rotations = Vector2.zero;
        void ClientUpdateRotations(Vector2 _old, Vector2 _new)
        {
            if (!hasAuthority)
            {
                rotator.horizontalRotator.localRotation = Quaternion.Euler(0, _new.y, 0);
                rotator.pointer.localRotation = Quaternion.Euler(_new.x, 0, 0);
            }
        }

        #endregion


        private void Update()
        {
            
            if (hasAuthority && !InputsBlocker.instance.BlockPlayerInputs())
            {
                if (!Input.GetKey(KeyBindings.Pairs[PlayerAction.release_cursor]))//sets the cursor visible and view locked
                {
                    rotator.RotateView();
                }

            }
            
            RotateHorizontalBodies();
            RotateVerticalBodies();

        }

        private void FixedUpdate()
        {
            if (hasAuthority)
            {
                CmdSendRotations(rotator.horizontalRotator.localEulerAngles.y, rotator.pointer.localEulerAngles.x);
            }
        }



        #region Client








        #endregion

        #region Both sides

        void RotateHorizontalBodies()
        {
            float appliedAngle = rotator.horizontalRotator.localEulerAngles.y;
            if (restrictedHorizontalAngle)
            {
                if(appliedAngle>0 && appliedAngle < 180)//right quadran
                {
                    if (appliedAngle > horizontalHalfRotation)
                    {
                        appliedAngle = horizontalHalfRotation;
                    }
                }
                else if(appliedAngle>180 && appliedAngle < 360) //left quadran
                {
                    if (appliedAngle < 360-horizontalHalfRotation)
                    {
                        appliedAngle = 360-horizontalHalfRotation;
                    }
                }
                
            }



            Quaternion appliedHorizontalRotation = Quaternion.Euler(0, appliedAngle, 0);

            rotator.horizontalRotator.localRotation= Quaternion.Euler(0, appliedAngle, 0);

            foreach (Transform horizontalBody in horizontalBodies)
            {
                horizontalBody.localRotation = appliedHorizontalRotation;
            }

        }


        void RotateVerticalBodies()
        {

            float appliedAngle = rotator.pointer.localEulerAngles.x;

            if (appliedAngle > 0 && appliedAngle < 180)//lower quadran
            {
                if (appliedAngle > lowerVerticalAngle)
                {
                    appliedAngle = lowerVerticalAngle;
                }
            }
            else if (appliedAngle > 180 && appliedAngle < 360)//upper quadran
            {
                if (appliedAngle < 360 - upperVerticalAngle)
                {
                    appliedAngle = 360 - upperVerticalAngle;
                }
            }

            Quaternion appliedVerticalRotation = Quaternion.Euler(appliedAngle, 0, 0);

            rotator.pointer.localRotation= Quaternion.Euler(appliedAngle, 0, 0);

            foreach (Transform verticalBody in verticalBodies)
            {
                verticalBody.localRotation = appliedVerticalRotation;
            }
        }



        #endregion

        #region commands

        [Command (channel = Channels.Unreliable)]
        void CmdSendRotations(float horizontal, float vertical)
        {

            rotator.horizontalRotator.localRotation = Quaternion.Euler(0, horizontal, 0);
            rotator.pointer.localRotation = Quaternion.Euler(vertical, 0, 0);

            rotations = new Vector2 { y = horizontal, x = vertical };

        }



        #endregion

        #region Server
        void IResettable.ServerReset()
        {
            rotations = Vector2.zero;
            rotator.horizontalRotator.localRotation = Quaternion.identity;
            rotator.pointer.localRotation = Quaternion.identity;
        }


        #endregion
    }
}
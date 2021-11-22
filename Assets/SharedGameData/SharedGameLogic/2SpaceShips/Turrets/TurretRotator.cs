using UnityEngine;
using System.Collections;
using Core.ServerAuthoritativeActions;
using Core;
using Mirror;

namespace ShipsLogic.Turrets
{
    public class TurretRotator : NetworkBehaviour
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




        float targetHorizontalAngle;

        float targetVerticalAngle;

        #region Syncvars+hooks
        [SyncVar(hook = nameof(ClientUpdateRotations))] Vector2 rotations = Vector2.zero;
        void ClientUpdateRotations(Vector2 _old, Vector2 _new)
        {
            if (!hasAuthority)
            {
                targetHorizontalAngle = _new.y;
                targetVerticalAngle = _new.x;
            }
        }

        #endregion


        private void Update()
        {
            
            if (hasAuthority && !UI_Manager.instance.aMenuIsActive)
            {
                if (!Input.GetKey(KeyBindings.Pairs[PlayerAction.release_cursor]))//sets the cursor visible and view locked
                {
                    rotator.RotateView();
                }

            }
            float maxRotationDelta = rotationSpeed * Time.deltaTime;
            RotateHorizontalBodies(maxRotationDelta);
            RotateVerticalBodies(maxRotationDelta);

        }

        private void FixedUpdate()
        {
            if (hasAuthority)
            {
                targetHorizontalAngle = rotator.horizontalRotator.localEulerAngles.y;
                targetVerticalAngle = rotator.pointer.localEulerAngles.x;
                CmdSendRotations(targetHorizontalAngle, targetVerticalAngle);
            }
        }



        #region Client








        #endregion

        #region Both sides

        void RotateHorizontalBodies(float maxRotationDelta)
        {
            float appliedAngle = targetHorizontalAngle;
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



            Quaternion appliedHorizontalRotation = Quaternion.RotateTowards(horizontalBodies[0].localRotation, Quaternion.Euler(0, appliedAngle, 0), maxRotationDelta);

            foreach (Transform horizontalBody in horizontalBodies)
            {
                horizontalBody.localRotation = appliedHorizontalRotation;
            }

        }


        void RotateVerticalBodies(float maxRotationDelta)
        {

            float appliedAngle = targetVerticalAngle;

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

            Quaternion appliedVerticalRotation = Quaternion.RotateTowards(verticalBodies[0].localRotation, Quaternion.Euler(appliedAngle, 0, 0), maxRotationDelta);

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
            targetHorizontalAngle = horizontal;
            targetVerticalAngle = vertical;

            rotations = new Vector2 { y = horizontal, x = vertical };

        }

        #endregion

        #region Rpcs
        


        #endregion
    }
}
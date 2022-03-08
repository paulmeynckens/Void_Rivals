using System.Collections;
using System.Collections.Generic;
using System;
using UnityEngine;
using Core;
using Core.ServerAuthoritativeActions;



namespace CharacterLogic
{
    public enum CharacterWalkingState
    {
        jogging,
        ducking,
        running,
        climbing,
    }
    public class CharacterWalk : CharacterMoveMode
    {
        CharacterWalkingState currentWalkingState = CharacterWalkingState.jogging;
        public CharacterWalkingState CurrentWalkingState
        {
            get => currentWalkingState;
        }

        CharacterController walker;


        const float JOG_SPEED = 4;
        const float JUMP_SPEED = 5f;
        const float CLIMB_SPEED = 2f;
        
        bool isClimbing = false;


        public bool IsClimbing
        {
            get => isClimbing;
        }

        float deltaUpDown=0;


        public event Action<Transform> OnSwitchShip = delegate { };

        private void Awake()
        {
            walker = GetComponent<CharacterController>();
        }

        public override void Deactivate()
        {
            base.Deactivate();
            walker.enabled = false;
            deltaUpDown = 0;
        }

        public override void Activate()
        {
            base.Activate();
            walker.enabled = true;
            deltaUpDown = 0;
            transform.localRotation = Quaternion.Euler(0, transform.localRotation.eulerAngles.y, 0); //resets the character vertical
        }

        public override void ModeApplyExternalForces()
        {

            if (!walker.isGrounded && !isClimbing)
            {
                deltaUpDown += Physics.gravity.y * Time.fixedDeltaTime; //applies gravity if not grounded and not flying
                
            }
            else
            {
                deltaUpDown = -0.05f;//stick the character controller to the ground
                
            }




        }


        public override void ModeUseInput(CharacterInput inputs)
        {
            walker.enabled = true;//solving bug #36

            Vector3 movement = Vector3.zero;

            if (walker.isGrounded && inputs.jump && !isClimbing)
            {
                
                deltaUpDown += JUMP_SPEED;
            }




            if (isClimbing)
            {
                movement = twoAxisRotator.pointer.forward * inputs.forwardBackward * CLIMB_SPEED * Time.fixedDeltaTime + twoAxisRotator.horizontalRotator.right * inputs.rightLeft * CLIMB_SPEED * Time.fixedDeltaTime;
            }
            else
            {
                movement = twoAxisRotator.horizontalRotator.forward * inputs.forwardBackward * JOG_SPEED * Time.fixedDeltaTime + twoAxisRotator.horizontalRotator.right * inputs.rightLeft  * JOG_SPEED*Time.fixedDeltaTime + Vector3.up * deltaUpDown * Time.fixedDeltaTime;
            }



            walker.Move(movement);

            walker.enabled = false;//solving bug #36
        }





        private void OnTriggerEnter(Collider other)
        {
            if (other.CompareTag("Climbable"))
            {
                isClimbing = true;
            }
        }

        private void OnTriggerExit(Collider other)
        {
            if (other.CompareTag("Climbable"))
            {
                isClimbing = false;
            }
        }


    }

}


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
        }

        public override void ModeApplyExternalForces()
        {

            

            


        }

        public override void ModeUseInput(CharacterInput inputs)
        {

            if (walker.isGrounded)
            {
                if (inputs.jump)
                {
                    deltaUpDown += JUMP_SPEED*Time.deltaTime;
                }
                else
                {
                    deltaUpDown = -0.05f;//stick the character controller to the ground
                }
            }
            else
            {
                deltaUpDown += Physics.gravity.y * Time.fixedDeltaTime; //applies gravity if not grounded and not flying
            }

            if (isClimbing)
            {
                deltaUpDown = 0;
            }

            Vector3 movement = Vector3.zero;


            if (isClimbing)
            {
                movement = (twoAxisRotator.pointer.forward * inputs.forwardBackward * CLIMB_SPEED + twoAxisRotator.horizontalRotator.right * inputs.rightLeft * CLIMB_SPEED)*Time.fixedDeltaTime;
            }
            else
            {
                movement = (twoAxisRotator.horizontalRotator.forward * inputs.forwardBackward * JOG_SPEED + twoAxisRotator.horizontalRotator.right * inputs.rightLeft  * JOG_SPEED)*Time.fixedDeltaTime;
            }

            movement += deltaUpDown * Vector3.up;

            walker.Move(movement);

        }





        private void OnTriggerEnter(Collider other)
        {

            switch (other.gameObject.tag)
            {
                case "Ship Interior":
                    EnterShip(other.transform);
                    break;


                case "Climbable":
                    isClimbing = true;
                    break;



                default:

                    break;
            }

        }

        private void OnTriggerExit(Collider other)
        {
            if (other.CompareTag("Climbable"))
            {
                isClimbing = false;
            }
        }

        void EnterShip(Transform ship)
        {
            transform.parent = ship;
            OnSwitchShip(ship);
        }

    }

}


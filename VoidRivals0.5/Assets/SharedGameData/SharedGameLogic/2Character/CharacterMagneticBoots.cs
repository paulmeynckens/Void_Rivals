using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Mirror;
using Core;
using Core.ServerAuthoritativeActions;

namespace CharacterLogic
{
    public class CharacterMagneticBoots : CharacterMoveMode
    {

        //CapsuleCollider capsuleCollider;


        [SerializeField] float moveSpeed = 1;

        [SerializeField] float rayHight = 2;

        [SerializeField] LayerMask rayLayerMask = 27;

        [SerializeField] Transform[] rayShooters = null;

        private void Awake()
        {
            //capsuleCollider = GetComponent<CapsuleCollider>();
        }
        public override void Deactivate()
        {
            base.Deactivate();
            //capsuleCollider.enabled = false;
        }

        public override void Activate()
        {
            base.Activate();
            //capsuleCollider.enabled = false;
        }

        public override void ModeUseInput(CharacterInput characterInput)
        {
            transform.position += (twoAxisRotator.horizontalRotator.forward * characterInput.forwardBackward + twoAxisRotator.horizontalRotator.right * characterInput.rightLeft) * Time.deltaTime;

            if(characterInput.forwardBackward==0 && characterInput.rightLeft == 0)//if the character has not moved, then don't try to align to hull to avoid jittering
            {
                return;
            }

            AlignToHull();
        }

        void AlignToHull()
        {
            Vector3 targetPosition = Vector3.zero;

            Vector3 targetUpwardDirection = Vector3.zero;

            int foundHitsCount = 0;

            foreach (Transform rayShooter in rayShooters)
            {
                Ray ray = new Ray { origin = rayShooter.position, direction = rayShooter.forward };
                RaycastHit raycastHit;
                if (Physics.Raycast(ray, out raycastHit, rayHight, rayLayerMask))
                {
                    foundHitsCount++;
                    targetPosition += raycastHit.point;
                    targetUpwardDirection += raycastHit.normal;
                }
            }


            targetPosition = targetPosition / foundHitsCount;

            transform.LookAt(transform.position + transform.forward, targetUpwardDirection);
            transform.position = targetPosition;
        }

    }
}

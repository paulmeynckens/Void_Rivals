using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Core;
using Core.ServerAuthoritativeActions;

namespace CharacterLogic
{
    public class CharacterFly : CharacterMoveMode
    {

        Rigidbody masterRigidbody;
        CapsuleCollider capsuleCollider;


        public readonly MousePullController pullController = new MousePullController();


        const float LEVER_ARM = 100;

        private ShipInput currentInputSnapshot;
        public ShipInput CurrentInputSnapshot { get => currentInputSnapshot; }//will be used for feedback elements such as joysticks movement, engine sound, gyroscope sound, etc




        
        [SerializeField] private float forwardThrust;
        [SerializeField] float lateralThrust;
        [SerializeField] float stabilisationTorque = 10;

        private void Awake()
        {
            masterRigidbody = GetComponent<Rigidbody>();
            capsuleCollider = GetComponent<CapsuleCollider>();
        }
        public override void Deactivate()
        {
            base.Deactivate();
            masterRigidbody.isKinematic = true;
            capsuleCollider.enabled = false;
        }
        public override void Activate()
        {
            base.Activate();
            masterRigidbody.isKinematic = false;
            capsuleCollider.enabled = true;
        }

        public override void ModeApplyExternalForces()
        {
            float counterForce = stabilisationTorque / LEVER_ARM;
            Vector3 offset;
            offset.x = 0;
            offset.y = -LEVER_ARM;
            offset.z = 0;

            Vector3 upwardForce = Vector3.up * counterForce;
            Vector3 downWardForce = Vector3.down * counterForce;


            masterRigidbody.AddForceAtPosition(upwardForce, masterRigidbody.position);

            masterRigidbody.AddForceAtPosition(downWardForce, masterRigidbody.transform.TransformPoint(offset));
        }

        public override void ModeUseInput(CharacterInput characterInput)
        {
            Vector3 thrustForce = twoAxisRotator.pointer.forward * characterInput.forwardBackward * forwardThrust + twoAxisRotator.horizontalRotator.right* characterInput.rightLeft * lateralThrust;
            masterRigidbody.AddForce(thrustForce);
        }

    }
}

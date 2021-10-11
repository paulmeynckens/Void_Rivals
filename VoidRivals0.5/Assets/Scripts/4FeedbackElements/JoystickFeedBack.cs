using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using ShipsLogic;

namespace FeedbackElements
{
    public class JoystickFeedBack : MonoBehaviour
    {
        enum JoystickType
        {
            direction,
            thrust
        }
        [SerializeField] JoystickType joystickType = JoystickType.direction;

        [SerializeField] ShipController shipController;
        [SerializeField] float maxYawAngle = 45;
        [SerializeField] float maxPicthAngle = 45;


        Quaternion targetRotation = Quaternion.identity;
        float rotationSpeed;

        private void Awake()
        {
            shipController = GetComponentInParent<ShipController>();
        }
        // Update is called once per frame
        private void Update()
        {
            transform.localRotation = Quaternion.RotateTowards(transform.localRotation, targetRotation, rotationSpeed * Time.deltaTime);
        }
        void FixedUpdate()
        {
            switch (joystickType)
            {
                case JoystickType.direction:
                    targetRotation = Quaternion.Euler(PitchAngle(), 0, YawAngle());
                    break;

                case JoystickType.thrust:
                    targetRotation = Quaternion.Euler(ThrustAngle(), 0, RollAngle());
                    break;

            }
            rotationSpeed = Quaternion.Angle(transform.localRotation, targetRotation) / Time.fixedDeltaTime;
        }

        float PitchAngle()
        {
            float angle = maxPicthAngle * shipController.CurrentInputSnapshot.pitch / shipController.shipData.pitchTorque;
            return angle;
        }
        float YawAngle()
        {
            float angle = -maxYawAngle * shipController.CurrentInputSnapshot.yaw / shipController.shipData.yawTorque;
            return angle;
        }
        float ThrustAngle()
        {
            float angle = maxPicthAngle * shipController.CurrentInputSnapshot.thrust / shipController.shipData.engineMaxForwardThrust;
            return angle;
        }
        float RollAngle()
        {
            float angle = maxYawAngle * shipController.CurrentInputSnapshot.roll / shipController.shipData.rollTorque;
            return angle;
        }
    }
}



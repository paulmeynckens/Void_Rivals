using System.Collections;
using System.Collections.Generic;
using ShipsLogic;
using UnityEngine;

namespace ShipsRenderer
{
    public class ProtoshipJoystick : MonoBehaviour
    {
        [SerializeField]ShipController shipController;

        [SerializeField] Transform baseTransform = null;
        [SerializeField] Transform poleTransform = null;
        [SerializeField] Transform gazTransform = null;

        [SerializeField] float maxYawAngle = 20;
        [SerializeField] float maxPicthAngle = 8;
        [SerializeField] float maxRollAngle = 10;
        [SerializeField] float maxThrustAngle = 30;

        Quaternion targetBaseRotation = Quaternion.identity;
        float baseRotationSpeed;
        Quaternion targetPoleRotation = Quaternion.identity;
        float poleRotationSpeed;
        Quaternion targetGazRotation = Quaternion.identity;
        float gazRotationSpeed;




        // Update is called once per frame
        void Update()
        {
            baseTransform.localRotation= Quaternion.RotateTowards(baseTransform.localRotation, targetBaseRotation, baseRotationSpeed * Time.deltaTime);

            poleTransform.localRotation = Quaternion.RotateTowards(poleTransform.localRotation, targetPoleRotation, poleRotationSpeed * Time.deltaTime);

            gazTransform.localRotation = Quaternion.RotateTowards(gazTransform.localRotation, targetGazRotation, gazRotationSpeed * Time.deltaTime);

        }

        void FixedUpdate()
        {
            targetBaseRotation = Quaternion.Euler(PitchAngle(), 0, RollAngle());
            baseRotationSpeed = Quaternion.Angle(baseTransform.localRotation, targetBaseRotation) / Time.fixedDeltaTime;

            targetPoleRotation = Quaternion.Euler(0, YawAngle(), 0);
            poleRotationSpeed = Quaternion.Angle(poleTransform.localRotation, targetPoleRotation) / Time.fixedDeltaTime;

            targetGazRotation = Quaternion.Euler(ThrustAngle(), 0, 0);
            gazRotationSpeed = Quaternion.Angle(gazTransform.localRotation, targetGazRotation) / Time.fixedDeltaTime;




        }

        float PitchAngle()
        {
            float angle = maxPicthAngle * shipController.CurrentInputSnapshot.pitch / shipController.shipData.pitchTorque;
            return angle;
        }
        float YawAngle()
        {
            float angle = maxYawAngle * shipController.CurrentInputSnapshot.yaw / shipController.shipData.yawTorque;
            return angle;
        }
        float ThrustAngle()
        {
            float angle = maxThrustAngle * shipController.CurrentInputSnapshot.thrust / shipController.shipData.engineMaxForwardThrust;
            return angle;
        }
        float RollAngle()
        {
            float angle = maxRollAngle * shipController.CurrentInputSnapshot.roll / shipController.shipData.rollTorque;
            return angle;
        }
    }
}

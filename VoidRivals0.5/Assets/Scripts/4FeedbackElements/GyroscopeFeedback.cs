using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using ShipsLogic;


namespace FeedbackElements
{
    public class GyroscopeFeedback : ContinuousFeedbackGenerator
    {
        // Start is called before the first frame update
        ShipController shipController;

        float maxTorqueMagnitude = 0;
        float targetPitch = 0;

        private void Awake()
        {

            shipController = GetComponentInParent<ShipController>();
            CalculateMaxTorqueMagnitude();
        }
        // Update is called once per frame
        private void Update()
        {
            ChangePower(targetPitch);
        }
        void FixedUpdate()
        {
#if UNITY_EDITOR
            CalculateMaxTorqueMagnitude();
#endif
            targetPitch = TorqueMagnitude() * m_maxPitch / maxTorqueMagnitude;
        }


        float TorqueMagnitude()
        {
            Vector3 totalTorque;
            totalTorque.x = shipController.CurrentInputSnapshot.pitch;
            totalTorque.y = shipController.CurrentInputSnapshot.yaw;
            totalTorque.z = shipController.CurrentInputSnapshot.roll;
            float torqueMagnitude = totalTorque.magnitude;
            return torqueMagnitude;
        }

        void CalculateMaxTorqueMagnitude()
        {
            Vector3 totalTorque;
            totalTorque.x = shipController.shipData.pitchTorque;
            totalTorque.y = shipController.shipData.yawTorque;
            totalTorque.z = shipController.shipData.rollTorque;
            maxTorqueMagnitude = totalTorque.magnitude;
        }
    }
}



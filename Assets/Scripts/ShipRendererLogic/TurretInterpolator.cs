using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using ShipsLogic.Turrets;

namespace ShipsRenderer
{
    [DefaultExecutionOrder(+10)]
    public class TurretInterpolator : MonoBehaviour
    {
        [SerializeField] TurretController turretController = null;

        [SerializeField] Transform horizontalRotator = null;
        [SerializeField] Transform[] horizontalFollowers=null;

        [SerializeField] Transform pointer = null;
        [SerializeField] Transform[] verticalFollowers = null;

        Quaternion nextRotatorLocalRotation = Quaternion.identity;
        Quaternion lastRotatorLocalRotation = Quaternion.identity;

        Quaternion nextPointerLocalRotation = Quaternion.identity;
        Quaternion lastPointerLocalRotation = Quaternion.identity;

        float lastInterpolationTime=0;
        void Update()
        {
            if (turretController.hasAuthority)
            {
                foreach (Transform horizontalFollower in horizontalFollowers)
                {
                    horizontalFollower.localRotation = horizontalRotator.localRotation;
                }
                foreach (Transform verticalFollower in verticalFollowers)
                {
                    verticalFollower.localRotation =pointer.localRotation;
                }
            }
            else
            {
                float interpolationIncrement = (Time.time - lastInterpolationTime) / Time.fixedDeltaTime;
                InterpolateRotations(interpolationIncrement);
            }

        }
        private void FixedUpdate()
        {
            if (!turretController.hasAuthority)
            {
                UpdateInterpolationData();
            }

        }



        void InterpolateRotations(float interpolationIncrement)
        {
            foreach(Transform horizontalFollower in horizontalFollowers)
            {
                horizontalFollower.localRotation = Quaternion.Lerp(lastRotatorLocalRotation, nextRotatorLocalRotation, interpolationIncrement);
            }
            foreach (Transform verticalFollower in verticalFollowers)
            {
                verticalFollower.localRotation = Quaternion.Lerp(lastPointerLocalRotation, nextPointerLocalRotation, interpolationIncrement);
            }            

        }

        void UpdateInterpolationData()
        {
            lastInterpolationTime = Time.time;

            lastRotatorLocalRotation = nextRotatorLocalRotation;
            nextRotatorLocalRotation = horizontalRotator.localRotation;

            lastPointerLocalRotation = nextPointerLocalRotation;
            nextPointerLocalRotation = pointer.localRotation;
        }



    }
}

using System.Collections;
using System.Collections.Generic;
using Mirror;
using UnityEngine;

namespace FeedbackElements
{
    public class TurretFeedback : ContinuousFeedbackGenerator
    {

        [SerializeField] Transform verticalBody = null;
        [SerializeField] float pitchMult = 1;

        Quaternion previousHorizontal;
        Quaternion previousVertical;



        // Update is called once per frame
        void Update()
        {
            previousHorizontal = transform.localRotation;
            previousVertical = verticalBody.localRotation;
        }
        private void LateUpdate()
        {
            float horizontalPitch = Quaternion.Angle(previousHorizontal, transform.localRotation);

            float verticalPitch = Quaternion.Angle(previousVertical, verticalBody.localRotation);

            ChangePower(Mathf.Max(horizontalPitch, verticalPitch) * Time.deltaTime * pitchMult);
        }
    }
}


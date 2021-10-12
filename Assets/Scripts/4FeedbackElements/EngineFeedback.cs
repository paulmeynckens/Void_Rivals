using System.Collections;
using System.Collections.Generic;
using System.Transactions;
using UnityEngine;
using ShipsLogic;

namespace FeedbackElements
{
    public class EngineFeedback : ContinuousFeedbackGenerator
    {

        //[SerializeField] Transform flame = null;
        [SerializeField] TrailRenderer trail = null;
        ShipController shipController;
        Engine engine;
        //Vector3 flameScale=Vector3.zero;

        private void Awake()
        {
            engine = GetComponent<Engine>();
            shipController = GetComponentInParent<ShipController>();
        }

        // Update is called once per frame
        void Update()
        {
            float currentThrustConsign = shipController.CurrentInputSnapshot.thrust;

            if (currentThrustConsign > 0)
            {
                ChangePower(m_maxPitch);
                //flameScale.y = 3;
            }
            if (currentThrustConsign < 0)
            {
                ChangePower(m_minPitch);
                //flameScale.y = -3;
            }
            else if (currentThrustConsign == 0)
            {
                ChangePower(0);
                //flameScale.y = 0;
            }


            if (currentThrustConsign != 0)
            {
                trail.emitting = true;
            }
            else
            {
                trail.emitting = false;
            }


            //flame.localScale = flameScale;
        }
    }
}


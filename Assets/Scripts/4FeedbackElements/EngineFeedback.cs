using System.Collections;
using System.Collections.Generic;
using System.Transactions;
using UnityEngine;
using ShipsLogic;

namespace FeedbackElements
{
    public class EngineFeedback : ContinuousSoundFeedbackGenerator
    {

        //[SerializeField] Transform flame = null;
        [SerializeField] TrailRenderer trail = null;
        ShipController shipController;
        [SerializeField] ParticleSystem m_particleSystem = null;

        //Vector3 flameScale=Vector3.zero;

        private void Awake()
        {

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
                
                m_particleSystem.emissionRate = 150;
            }
            if (currentThrustConsign < 0)
            {
                ChangePower(m_minPitch);
                //flameScale.y = -3;
                m_particleSystem.emissionRate = 0;
            }
            else if (currentThrustConsign == 0)
            {
                ChangePower(0);
                //flameScale.y = 0;
                m_particleSystem.emissionRate = 0;
            }

            if (trail != null)
            {
                if (currentThrustConsign != 0)
                {
                    trail.emitting = true;
                }
                else
                {
                    trail.emitting = false;
                }
            }

            


            //flame.localScale = flameScale;
        }
    }
}

